package com.miniprojets6.plain.article;

import java.time.OffsetDateTime;

public class PlainArticleRow {
    private final int id;
    private final String titre;
    private final String slug;
    private final String categoryNames;
    private final String statut;
    private final boolean aLaUne;
    private final String chapeau;
    private final int vues;
    private final OffsetDateTime createdAt;
    private final OffsetDateTime updatedAt;

    public PlainArticleRow(
        int id,
        String titre,
        String slug,
        String categoryNames,
        String statut,
        boolean aLaUne,
        String chapeau,
        int vues,
        OffsetDateTime createdAt,
        OffsetDateTime updatedAt
    ) {
        this.id = id;
        this.titre = titre;
        this.slug = slug;
        this.categoryNames = categoryNames;
        this.statut = statut;
        this.aLaUne = aLaUne;
        this.chapeau = chapeau;
        this.vues = vues;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
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

    public String getCategoryNames() {
        return categoryNames;
    }

    public String getStatut() {
        return statut;
    }

    public boolean isaLaUne() {
        return aLaUne;
    }

    public String getChapeau() {
        return chapeau;
    }

    public int getVues() {
        return vues;
    }

    public OffsetDateTime getCreatedAt() {
        return createdAt;
    }

    public OffsetDateTime getUpdatedAt() {
        return updatedAt;
    }
}
