package com.miniprojets6.plain.front;

public class PlainFrontCategory {
    private final int id;
    private final String nom;
    private final String slug;

    public PlainFrontCategory(int id, String nom, String slug) {
        this.id = id;
        this.nom = nom;
        this.slug = slug;
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
}
