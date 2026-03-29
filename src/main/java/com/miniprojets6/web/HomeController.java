package com.miniprojets6.web;

import com.miniprojets6.article.ArticleService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    private final ArticleService articleService;

    public HomeController(ArticleService articleService) {
        this.articleService = articleService;
    }

    @GetMapping("/")
    public String home(Model model) {
        model.addAttribute("featuredArticles", articleService.findFeatured());
        model.addAttribute("articles", articleService.findAllPublished());
        model.addAttribute("pageTitle", "Accueil");
        model.addAttribute("metaDescription", "Actualites et analyses sur le conflit en Iran. Informations en temps reel.");
        return "front/home";
    }
}
