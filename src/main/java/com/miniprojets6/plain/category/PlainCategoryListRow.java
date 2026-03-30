package com.miniprojets6.plain.category;

import java.time.OffsetDateTime;

public class PlainCategoryListRow {
    private final int id;
    private final String nom;
    private final String slug;
    private final String description;
    private final OffsetDateTime updatedAt;

    public PlainCategoryListRow(int id, String nom, String slug, String description, OffsetDateTime updatedAt) {
        this.id = id;
        this.nom = nom;
        this.slug = slug;
        this.description = description;
        this.updatedAt = updatedAt;
    }

    public int getId() {
        return id;
    }

    public String getNom() {
        return nom;
    }

    public String getSlug() {
        return slug;
    }

    public String getDescription() {
        return description;
    }

    public OffsetDateTime getUpdatedAt() {
        return updatedAt;
    }
}
