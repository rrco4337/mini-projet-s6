package com.miniprojets6.article;

import com.miniprojets6.category.Category;
import com.miniprojets6.category.CategoryRepository;
import com.miniprojets6.media.Media;
import com.miniprojets6.media.MediaService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class ArticleService {

    private final ArticleRepository articleRepository;
    private final CategoryRepository categoryRepository;
    private final MediaService mediaService;

    public ArticleService(ArticleRepository articleRepository,
                          CategoryRepository categoryRepository,
                          MediaService mediaService) {
        this.articleRepository = articleRepository;
        this.categoryRepository = categoryRepository;
        this.mediaService = mediaService;
    }

    @Transactional(readOnly = true)
    public List<Article> findAll() {
        List<Article> articles = articleRepository.findAll();
        articles.forEach(this::enrichPrimaryImage);
        return articles;
    }

    @Transactional(readOnly = true)
    public Article findById(Integer id) {
        Article article = articleRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Article non trouve: " + id));
        enrichPrimaryImage(article);
        return article;
    }

    @Transactional(readOnly = true)
    public List<Article> findAllPublished() {
        List<Article> articles = articleRepository.findByStatutOrderByDatePublicationDesc(ArticleStatut.publie);
        articles.forEach(this::enrichPrimaryImage);
        return articles;
    }

    @Transactional(readOnly = true)
    public List<Article> findPublishedByFilters(List<String> categorySlugs, LocalDate publicationDate) {
        List<String> normalizedCategories = (categorySlugs == null)
                ? List.of()
                : categorySlugs.stream()
                .filter(slug -> slug != null && !slug.isBlank())
                .distinct()
                .collect(Collectors.toList());
        OffsetDateTime startDate = null;
        OffsetDateTime endDate = null;
        if (publicationDate != null) {
            startDate = publicationDate.atStartOfDay().atOffset(ZoneOffset.UTC);
            endDate = publicationDate.plusDays(1).atStartOfDay().atOffset(ZoneOffset.UTC);
        }

        List<Article> articles;
        if (!normalizedCategories.isEmpty() && publicationDate != null) {
            articles = articleRepository.findPublishedByCategoriesAndDateRange(
                    ArticleStatut.publie,
                    normalizedCategories,
                    startDate,
                    endDate
            );
        } else if (!normalizedCategories.isEmpty()) {
            articles = articleRepository.findPublishedByCategories(
                    ArticleStatut.publie,
                    normalizedCategories
            );
        } else if (publicationDate != null) {
            articles = articleRepository.findPublishedByDateRange(
                    ArticleStatut.publie,
                    startDate,
                    endDate
            );
        } else {
            articles = articleRepository.findByStatutOrderByDatePublicationDesc(ArticleStatut.publie);
        }

        articles.forEach(this::enrichPrimaryImage);
        return articles;
    }

    @Transactional(readOnly = true)
    public List<Article> findFeatured() {
        List<Article> articles = articleRepository.findFeaturedArticles(true, ArticleStatut.publie);
        articles.forEach(this::enrichPrimaryImage);
        return articles;
    }

    @Transactional(readOnly = true)
    public Article findPublishedBySlug(String slug) {
        Article article = articleRepository.findBySlugAndStatut(slug, ArticleStatut.publie)
                .orElseThrow(() -> new IllegalArgumentException("Article non trouve: " + slug));
        enrichPrimaryImage(article);
        return article;
    }

    @Transactional
    public Article findPublishedBySlugAndIncrementVues(String slug) {
        Article article = findPublishedBySlug(slug);
        articleRepository.incrementVues(article.getId());
        article.setVues(article.getVues() + 1);
        return article;
    }

    @Transactional
    public Article create(ArticleForm form, MultipartFile[] images, String imageAlts) {
        if (articleRepository.findBySlug(form.getSlug()).isPresent()) {
            throw new IllegalArgumentException("Un article avec ce slug existe deja");
        }

        Article article = new Article();
        mapFormToEntity(form, article);

        if (article.getStatut() == ArticleStatut.publie && article.getDatePublication() == null) {
            article.setDatePublication(OffsetDateTime.now());
        }

        List<Media> uploaded = mediaService.storeFiles(images, imageAlts, form.getSlug());
        if (!uploaded.isEmpty()) {
            Media first = uploaded.get(0);
            article.setImageUne(first.getId());
        }

        Article saved = articleRepository.save(article);
        enrichPrimaryImage(saved);
        return saved;
    }

    @Transactional
    public Article update(Integer id, ArticleForm form, MultipartFile[] images, String imageAlts) {
        Article article = findById(id);
        String oldSlug = article.getSlug();

        articleRepository.findBySlug(form.getSlug())
                .filter(existing -> !existing.getId().equals(id))
                .ifPresent(existing -> {
                    throw new IllegalArgumentException("Un article avec ce slug existe deja");
                });

        ArticleStatut oldStatut = article.getStatut();
        mapFormToEntity(form, article);

        if (oldStatut != ArticleStatut.publie && article.getStatut() == ArticleStatut.publie) {
            article.setDatePublication(OffsetDateTime.now());
        }

        mediaService.retagArticleMedia(oldSlug, form.getSlug());

        List<Media> uploaded = mediaService.storeFiles(images, imageAlts, form.getSlug());
        if (!uploaded.isEmpty()) {
            Media first = uploaded.get(0);
            article.setImageUne(first.getId());
        }

        Article saved = articleRepository.save(article);
        enrichPrimaryImage(saved);
        return saved;
    }

    @Transactional
    public void delete(Integer id) {
        Article article = findById(id);
        articleRepository.delete(article);
    }

    private void mapFormToEntity(ArticleForm form, Article article) {
        article.setTitre(form.getTitre());
        article.setSlug(form.getSlug());
        article.setSousTitre(form.getSousTitre());
        article.setChapeau(form.getChapeau());
        article.setContenu(form.getContenu());
        article.setMetaTitle(form.getMetaTitle());
        article.setMetaDescription(form.getMetaDescription());
        article.setMetaKeywords(form.getMetaKeywords());
        article.setStatut(form.getStatut());
        article.setALaUne(form.getALaUne() != null ? form.getALaUne() : false);

        List<Integer> selectedCategoryIds = new ArrayList<>();
        if (form.getCategorieIds() != null) {
            selectedCategoryIds.addAll(form.getCategorieIds());
        }
        if (selectedCategoryIds.isEmpty() && form.getCategorieId() != null) {
            selectedCategoryIds.add(form.getCategorieId());
        }

        LinkedHashSet<Integer> deduplicated = new LinkedHashSet<>(selectedCategoryIds);
        if (!deduplicated.isEmpty()) {
            List<Category> selectedCategories = categoryRepository.findAllById(deduplicated);
            if (selectedCategories.size() != deduplicated.size()) {
                throw new IllegalArgumentException("Categorie non trouvee");
            }

            article.setCategories(selectedCategories);
            article.setCategorie(selectedCategories.get(0));
        } else {
            article.setCategories(new ArrayList<>());
            article.setCategorie(null);
        }
    }

    private void enrichPrimaryImage(Article article) {
        List<Media> gallery = mediaService.findByArticleSlug(article.getSlug());
        article.setGalleryImages(gallery.stream()
                .map(media -> new ArticleImageView(media.getFichier(), media.getAlt()))
                .toList());

        if (article.getImageUne() == null) {
            if (!gallery.isEmpty()) {
                Media first = gallery.get(0);
                article.setImageUrl(first.getFichier());
                article.setImageAlt(first.getAlt());
            }
            return;
        }

        mediaService.findById(article.getImageUne()).ifPresent(media -> {
            article.setImageUrl(media.getFichier());
            article.setImageAlt(media.getAlt());
        });
    }
}
