package com.miniprojets6.plain.front;

import java.time.OffsetDateTime;

public class PlainFrontArticleRow {
    private final int id;
    private final String titre;
    private final String slug;
    private final String sousTitre;
    private final String chapeau;
    private final String contenu;
    private final int vues;
    private final String categoryNames;
    private final String primaryCategorySlug;
    private final String primaryCategoryName;
    private final String imageUrl;
    private final String imageAlt;
    private final OffsetDateTime datePublication;

    public PlainFrontArticleRow(
        int id,
        String titre,
        String slug,
        String sousTitre,
        String chapeau,
        String contenu,
        int vues,
        String categoryNames,
        String primaryCategorySlug,
        String primaryCategoryName,
        String imageUrl,
        String imageAlt,
        OffsetDateTime datePublication
    ) {
        this.id = id;
        this.titre = titre;
        this.slug = slug;
        this.sousTitre = sousTitre;
        this.chapeau = chapeau;
        this.contenu = contenu;
        this.vues = vues;
        this.categoryNames = categoryNames;
        this.primaryCategorySlug = primaryCategorySlug;
        this.primaryCategoryName = primaryCategoryName;
        this.imageUrl = imageUrl;
        this.imageAlt = imageAlt;
        this.datePublication = datePublication;
    }

    public int getId() {
        return id;
    }

    public String getTitre() {
        return titre;
    }

    public String getSlug() {
        return slug;
    }

    public String getSousTitre() {
        return sousTitre;
    }

    public String getChapeau() {
        return chapeau;
    }

    public String getContenu() {
        return contenu;
    }

    public int getVues() {
        return vues;
    }

    public String getCategoryNames() {
        return categoryNames;
    }

    public String getPrimaryCategorySlug() {
        return primaryCategorySlug;
    }

    public String getPrimaryCategoryName() {
        return primaryCategoryName;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public String getImageAlt() {
        return imageAlt;
    }

    public OffsetDateTime getDatePublication() {
        return datePublication;
    }
}
