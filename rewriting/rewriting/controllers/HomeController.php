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
            'metaDescription' => 'Iran War News - Informations et analyses sur le conflit en Iran, dans une mise en perspective éditoriale sobre et exigeante.',
            'canonicalUrl' => 'http://localhost:8000/',
            'ogImage' => 'http://localhost:8000/default-og-image.png',
            'pageType' => 'website',
            'currentUrl' => 'http://localhost:8000/',
            'articles' => $articles,
            'featuredArticles' => $featuredArticles,
            'selectedCategorySlugs' => $categorySlugs,
            'selectedPublicationDate' => $publicationDate
        ]);
    }
}
