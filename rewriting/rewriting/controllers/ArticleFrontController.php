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

        // Variables SEO et Open Graph
        $metaDescription = substr($article['meta_description'] ?? $article['chapeau'] ?? '', 0, 155);
        $canonicalUrl = 'http://localhost:8000/article/' . $article['slug'];
        $ogImage = $article['imageUrl'] ?? 'http://localhost:8000/default-og-image.png';
        $pageType = 'article';
        $currentUrl = $canonicalUrl;

        $this->view('front/article/detail', [
            'pageTitle' => $article['titre'],
            'metaDescription' => $metaDescription,
            'metaKeywords' => $article['meta_keywords'] ?? '',
            'canonicalUrl' => $canonicalUrl,
            'ogImage' => $ogImage,
            'pageType' => $pageType,
            'currentUrl' => $currentUrl,
            'article' => $article
        ]);
    }
}
