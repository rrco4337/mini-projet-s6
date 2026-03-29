package com.miniprojets6.article;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public class ArticleForm {

    @NotBlank(message = "Le titre est obligatoire")
    @Size(max = 255, message = "Le titre ne doit pas depasser 255 caracteres")
    private String titre;

    @NotBlank(message = "Le slug est obligatoire")
    @Size(max = 270, message = "Le slug ne doit pas depasser 270 caracteres")
    private String slug;

    @Size(max = 255, message = "Le sous-titre ne doit pas depasser 255 caracteres")
    private String sousTitre;

    private String chapeau;

    @NotBlank(message = "Le contenu est obligatoire")
    private String contenu;

    @Size(max = 70, message = "Le meta title ne doit pas depasser 70 caracteres")
    private String metaTitle;

    @Size(max = 165, message = "La meta description ne doit pas depasser 165 caracteres")
    private String metaDescription;

    @Size(max = 255, message = "Les meta keywords ne doivent pas depasser 255 caracteres")
    private String metaKeywords;

    private Integer categorieId;

    private ArticleStatut statut = ArticleStatut.brouillon;

    private Boolean aLaUne = false;

    // Getters and Setters
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

    public Integer getCategorieId() {
        return categorieId;
    }

    public void setCategorieId(Integer categorieId) {
        this.categorieId = categorieId;
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
}
