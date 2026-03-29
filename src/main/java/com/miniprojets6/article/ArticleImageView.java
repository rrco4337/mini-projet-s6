package com.miniprojets6.article;

public class ArticleImageView {

    private final String url;
    private final String alt;

    public ArticleImageView(String url, String alt) {
        this.url = url;
        this.alt = alt;
    }

    public String getUrl() {
        return url;
    }

    public String getAlt() {
        return alt;
    }
}
