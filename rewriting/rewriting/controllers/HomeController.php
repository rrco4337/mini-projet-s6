<?php
/**
 * Controleur pour la page d'accueil
 */
class HomeController extends Controller
{
    public function index(): void
    {
        // Recuperer les filtres
        $categorySlugs = isset($_GET['categorySlugs']) ? (array) $_GET['categorySlugs'] : [];
        $publicationDate = $_GET['publicationDate'] ?? null;

        // Recuperer les articles
        if (!empty($categorySlugs) || $publicationDate) {
            $articles = Article::getFiltered($categorySlugs, $publicationDate);
        } else {
            $articles = Article::getPublished();
        }

        // Enrichir avec les images et categories
        $articles = array_map(function($article) {
            return Article::getWithImage($article);
        }, $articles);

        // Articles a la une
        $featuredArticles = Article::getFeatured();
        $featuredArticles = array_map(function($article) {
            return Article::getWithImage($article);
        }, $featuredArticles);

        $this->view('front/home', [
            'pageTitle' => 'Accueil',
            'articles' => $articles,
            'featuredArticles' => $featuredArticles,
            'selectedCategorySlugs' => $categorySlugs,
            'selectedPublicationDate' => $publicationDate
        ]);
    }
}
