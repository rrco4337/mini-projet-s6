package com.miniprojets6.plain.article;

import java.util.ArrayList;
import java.util.List;

public class PlainArticleCreateRequest {
    private String titre;
    private String slug;
    private String sousTitre;
    private String chapeau;
    private String contenu;
    private String statut;
    private boolean aLaUne;
    private String metaTitle;
    private String metaDescription;
    private String metaKeywords;
    private final List<Integer> categoryIds = new ArrayList<>();

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

    public String getContenu() {
        return contenu;
    }

    public void setContenu(String contenu) {
        this.contenu = contenu;
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

    public String getStatut() {
        return statut;
    }

    public void setStatut(String statut) {
        this.statut = statut;
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

    public boolean isaLaUne() {
        return aLaUne;
    }

    public void setaLaUne(boolean aLaUne) {
        this.aLaUne = aLaUne;
    }

    public List<Integer> getCategoryIds() {
        return categoryIds;
    }
}
