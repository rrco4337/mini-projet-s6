package com.miniprojets6.web;

import com.miniprojets6.article.Article;
import com.miniprojets6.article.ArticleService;
import com.miniprojets6.article.ArticleStatut;
import com.miniprojets6.category.CategoryService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin")
public class AdminController {

    private final ArticleService articleService;
    private final CategoryService categoryService;

    public AdminController(ArticleService articleService, CategoryService categoryService) {
        this.articleService = articleService;
        this.categoryService = categoryService;
    }

    @GetMapping
    public String dashboard(Model model) {
        List<Article> allArticles = articleService.findAll();

        // Statistiques générales
        model.addAttribute("totalArticles", allArticles.size());
        model.addAttribute("totalCategories", categoryService.findAll().size());

        // Articles par statut (filtrer les statuts null)
        Map<ArticleStatut, Long> articlesByStatus = allArticles.stream()
                .filter(article -> article.getStatut() != null)
                .collect(Collectors.groupingBy(Article::getStatut, Collectors.counting()));

        model.addAttribute("publishedCount", articlesByStatus.getOrDefault(ArticleStatut.publie, 0L));
        model.addAttribute("draftCount", articlesByStatus.getOrDefault(ArticleStatut.brouillon, 0L));
        model.addAttribute("archivedCount", articlesByStatus.getOrDefault(ArticleStatut.archive, 0L));

        // Articles à la une (filtrer les valeurs null)
        long featuredCount = allArticles.stream()
                .filter(article -> article.getALaUne() != null && article.getALaUne())
                .count();
        model.addAttribute("featuredCount", featuredCount);

        // Statistiques des vues (filtrer les valeurs null)
        int totalViews = allArticles.stream()
                .filter(article -> article.getVues() != null)
                .mapToInt(Article::getVues)
                .sum();
        model.addAttribute("totalViews", totalViews);

        // Article le plus vu (filtrer les valeurs null)
        Article mostViewedArticle = allArticles.stream()
                .filter(article -> article.getVues() != null)
                .max((a1, a2) -> Integer.compare(a1.getVues(), a2.getVues()))
                .orElse(null);
        model.addAttribute("mostViewedArticle", mostViewedArticle);

        // 5 derniers articles (filtrer les dates null)
        List<Article> recentArticles = allArticles.stream()
                .filter(article -> article.getCreatedAt() != null)
                .sorted((a1, a2) -> a2.getCreatedAt().compareTo(a1.getCreatedAt()))
                .limit(5)
                .collect(Collectors.toList());
        model.addAttribute("recentArticles", recentArticles);

        // Formatter pour les dates
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

        // Créer une Map pour les dates formatées
        Map<Integer, String> formattedDates = recentArticles.stream()
                .filter(article -> article.getCreatedAt() != null)
                .collect(Collectors.toMap(
                    Article::getId,
                    article -> article.getCreatedAt().format(formatter)
                ));
        model.addAttribute("formattedDates", formattedDates);

        // Données pour les graphiques (JSON)
        model.addAttribute("statusData",
            "[" + articlesByStatus.getOrDefault(ArticleStatut.publie, 0L) + "," +
                  articlesByStatus.getOrDefault(ArticleStatut.brouillon, 0L) + "," +
                  articlesByStatus.getOrDefault(ArticleStatut.archive, 0L) + "]");

        return "admin/dashboard";
    }
}
