<?php
/**
 * Controleur pour les articles (front)
 */
class ArticleFrontController extends Controller
{
    public function show(string $slug): void
    {
        $article = Article::findBySlug($slug);

        if (!$article || $article['statut'] !== 'publie') {
            http_response_code(404);
            require_once __DIR__ . '/../views/errors/404.php';
            exit;
        }

        // Incrementer les vues
        Article::incrementViews($article['id']);
        $article['vues']++;

        // Enrichir avec l'image et les categories
        $article = Article::getWithImage($article);

        // Recuperer la galerie d'images
        $article['galleryImages'] = Article::getGalleryImages($article['id']);

        $this->view('front/article/detail', [
            'pageTitle' => $article['titre'],
            'metaDescription' => $article['meta_description'] ?? '',
            'metaKeywords' => $article['meta_keywords'] ?? '',
            'article' => $article
        ]);
    }
}
