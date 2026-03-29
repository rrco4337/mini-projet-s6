package com.miniprojets6.article;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@Controller
public class ArticleFrontController {

    private final ArticleService articleService;

    public ArticleFrontController(ArticleService articleService) {
        this.articleService = articleService;
    }

    @GetMapping("/article/{slug}")
    public String detail(@PathVariable String slug, Model model) {
        Article article = articleService.findPublishedBySlugAndIncrementVues(slug);
        model.addAttribute("article", article);
        model.addAttribute("pageTitle", article.getMetaTitle() != null ? article.getMetaTitle() : article.getTitre());
        model.addAttribute("metaDescription", article.getMetaDescription());
        model.addAttribute("metaKeywords", article.getMetaKeywords());
        return "front/article/detail";
    }
}
