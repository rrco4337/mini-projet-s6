package com.miniprojets6.article;

import com.miniprojets6.category.Category;
import com.miniprojets6.category.CategoryRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.OffsetDateTime;
import java.util.List;

@Service
public class ArticleService {

    private final ArticleRepository articleRepository;
    private final CategoryRepository categoryRepository;

    public ArticleService(ArticleRepository articleRepository, CategoryRepository categoryRepository) {
        this.articleRepository = articleRepository;
        this.categoryRepository = categoryRepository;
    }

    @Transactional(readOnly = true)
    public List<Article> findAll() {
        return articleRepository.findAll();
    }

    @Transactional(readOnly = true)
    public Article findById(Integer id) {
        return articleRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Article non trouve: " + id));
    }

    @Transactional(readOnly = true)
    public List<Article> findAllPublished() {
        return articleRepository.findByStatutOrderByDatePublicationDesc(ArticleStatut.publie);
    }

    @Transactional(readOnly = true)
    public List<Article> findFeatured() {
        return articleRepository.findFeaturedArticles(true, ArticleStatut.publie);
    }

    @Transactional(readOnly = true)
    public Article findPublishedBySlug(String slug) {
        return articleRepository.findBySlugAndStatut(slug, ArticleStatut.publie)
                .orElseThrow(() -> new IllegalArgumentException("Article non trouve: " + slug));
    }

    @Transactional
    public Article findPublishedBySlugAndIncrementVues(String slug) {
        Article article = findPublishedBySlug(slug);
        articleRepository.incrementVues(article.getId());
        article.setVues(article.getVues() + 1);
        return article;
    }

    @Transactional
    public Article create(ArticleForm form) {
        if (articleRepository.findBySlug(form.getSlug()).isPresent()) {
            throw new IllegalArgumentException("Un article avec ce slug existe deja");
        }

        Article article = new Article();
        mapFormToEntity(form, article);

        if (article.getStatut() == ArticleStatut.publie && article.getDatePublication() == null) {
            article.setDatePublication(OffsetDateTime.now());
        }

        return articleRepository.save(article);
    }

    @Transactional
    public Article update(Integer id, ArticleForm form) {
        Article article = findById(id);

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

        return articleRepository.save(article);
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

        if (form.getCategorieId() != null) {
            Category category = categoryRepository.findById(form.getCategorieId())
                    .orElseThrow(() -> new IllegalArgumentException("Categorie non trouvee"));
            article.setCategorie(category);
        } else {
            article.setCategorie(null);
        }
    }
}
