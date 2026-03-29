package com.miniprojets6.article;

import com.miniprojets6.category.Category;
import jakarta.persistence.*;
import org.hibernate.annotations.JdbcType;
import org.hibernate.dialect.PostgreSQLEnumJdbcType;

import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "articles")
public class Article {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, length = 255)
    private String titre;

    @Column(nullable = false, unique = true, length = 270)
    private String slug;

    @Column(name = "sous_titre", length = 255)
    private String sousTitre;

    @Column(columnDefinition = "TEXT")
    private String chapeau;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String contenu;

    @Column(name = "meta_title", length = 70)
    private String metaTitle;

    @Column(name = "meta_description", length = 165)
    private String metaDescription;

    @Column(name = "meta_keywords", length = 255)
    private String metaKeywords;

    @Column(name = "image_une")
    private Integer imageUne;

    @Transient
    private String imageUrl;

    @Transient
    private String imageAlt;

    @Transient
    private List<ArticleImageView> galleryImages = new ArrayList<>();

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "categorie_id")
    private Category categorie;

        @ManyToMany(fetch = FetchType.EAGER)
        @JoinTable(
            name = "article_categories",
            joinColumns = @JoinColumn(name = "article_id"),
            inverseJoinColumns = @JoinColumn(name = "category_id")
        )
        private List<Category> categories = new ArrayList<>();

    @Column(name = "auteur_id")
    private Integer auteurId;

    @Enumerated(EnumType.STRING)
    @JdbcType(PostgreSQLEnumJdbcType.class)
    @Column(nullable = false, columnDefinition = "article_statut")
    private ArticleStatut statut = ArticleStatut.brouillon;

    @Column(name = "a_la_une", nullable = false)
    private Boolean aLaUne = false;

    @Column(nullable = false)
    private Integer vues = 0;

    @Column(name = "date_publication")
    private OffsetDateTime datePublication;

    @Column(name = "created_at", nullable = false)
    private OffsetDateTime createdAt;

    @Column(name = "updated_at", nullable = false)
    private OffsetDateTime updatedAt;

    @PrePersist
    public void onCreate() {
        OffsetDateTime now = OffsetDateTime.now();
        createdAt = now;
        updatedAt = now;
    }

    @PreUpdate
    public void onUpdate() {
        updatedAt = OffsetDateTime.now();
    }

    // Getters and Setters
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getTitre() {
        return titre;
    }

    public void setTitre(String titre) {
        this.titre = titre;
    }

    public String getSlug() {
        return slug;
    }

    public void setSlug(String slug) {
        this.slug = slug;
    }

    public String getSousTitre() {
        return sousTitre;
    }

    public void setSousTitre(String sousTitre) {
        this.sousTitre = sousTitre;
    }

    public String getChapeau() {
        return chapeau;
    }

    public void setChapeau(String chapeau) {
        this.chapeau = chapeau;
    }

    public String getContenu() {
        return contenu;
    }

    public void setContenu(String contenu) {
        this.contenu = contenu;
    }

    public String getMetaTitle() {
        return metaTitle;
    }

    public void setMetaTitle(String metaTitle) {
        this.metaTitle = metaTitle;
    }

    public String getMetaDescription() {
        return metaDescription;
    }

    public void setMetaDescription(String metaDescription) {
        this.metaDescription = metaDescription;
    }

    public String getMetaKeywords() {
        return metaKeywords;
    }

    public void setMetaKeywords(String metaKeywords) {
        this.metaKeywords = metaKeywords;
    }

    public Integer getImageUne() {
        return imageUne;
    }

    public void setImageUne(Integer imageUne) {
        this.imageUne = imageUne;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getImageAlt() {
        return imageAlt;
    }

    public void setImageAlt(String imageAlt) {
        this.imageAlt = imageAlt;
    }

    public List<ArticleImageView> getGalleryImages() {
        return galleryImages;
    }

    public void setGalleryImages(List<ArticleImageView> galleryImages) {
        this.galleryImages = galleryImages;
    }

    public Category getCategorie() {
        if (categories != null && !categories.isEmpty()) {
            return categories.get(0);
        }
        return categorie;
    }

    public void setCategorie(Category categorie) {
        this.categorie = categorie;
        if (categorie != null && (categories == null || categories.isEmpty())) {
            categories = new ArrayList<>();
            categories.add(categorie);
        }
    }

    public List<Category> getCategories() {
        return categories;
    }

    public void setCategories(List<Category> categories) {
        this.categories = categories;
        if (categories != null && !categories.isEmpty()) {
            this.categorie = categories.get(0);
        }
    }

    public Integer getAuteurId() {
        return auteurId;
    }

    public void setAuteurId(Integer auteurId) {
        this.auteurId = auteurId;
    }

    public ArticleStatut getStatut() {
        return statut;
    }

    public void setStatut(ArticleStatut statut) {
        this.statut = statut;
    }

    public Boolean getALaUne() {
        return aLaUne;
    }

    public void setALaUne(Boolean aLaUne) {
        this.aLaUne = aLaUne;
    }

    public Integer getVues() {
        return vues;
    }

    public void setVues(Integer vues) {
        this.vues = vues;
    }

    public OffsetDateTime getDatePublication() {
        return datePublication;
    }

    public void setDatePublication(OffsetDateTime datePublication) {
        this.datePublication = datePublication;
    }

    public OffsetDateTime getCreatedAt() {
        return createdAt;
    }

    public OffsetDateTime getUpdatedAt() {
        return updatedAt;
    }
}
