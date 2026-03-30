package com.miniprojets6.plain.article;

public class PlainCategoryRow {
    private final int id;
    private final String nom;

    public PlainCategoryRow(int id, String nom) {
        this.id = id;
        this.nom = nom;
    }

    public int getId() {
        return id;
    }

    public String getNom() {
        return nom;
    }
}
