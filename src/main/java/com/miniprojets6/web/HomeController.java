package com.miniprojets6.web;

import com.miniprojets6.article.ArticleService;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDate;
import java.util.List;

@Controller
public class HomeController {

    private final ArticleService articleService;

    public HomeController(ArticleService articleService) {
        this.articleService = articleService;
    }

    @GetMapping("/")
    public String home(@RequestParam(value = "categorySlugs", required = false) List<String> categorySlugs,
                       @RequestParam(value = "publicationDate", required = false)
                       @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate publicationDate,
                       Model model) {
        model.addAttribute("featuredArticles", articleService.findFeatured());
        model.addAttribute("articles", articleService.findPublishedByFilters(categorySlugs, publicationDate));
        model.addAttribute("selectedCategorySlugs", categorySlugs == null ? List.of() : categorySlugs);
        model.addAttribute("selectedPublicationDate", publicationDate);
        model.addAttribute("pageTitle", "Accueil");
        model.addAttribute("metaDescription", "Actualites et analyses sur le conflit en Iran. Informations en temps reel.");
        return "front/home";
    }
}
