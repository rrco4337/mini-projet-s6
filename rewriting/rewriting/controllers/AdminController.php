<?php
/**
 * Controleur pour le tableau de bord admin
 */
class AdminController extends Controller
{
    public function dashboard(): void
    {
        $totalArticles = Article::count();
        $publishedCount = Article::countByStatut('publie');
        $draftCount = Article::countByStatut('brouillon');
        $archivedCount = Article::countByStatut('archive');
        $featuredCount = Article::countFeatured();
        $totalViews = Article::sumViews();
        $totalCategories = Category::count();

        $recentArticles = Article::getRecent(5);
        $mostViewedArticle = Article::getMostViewed();

        // Donnees pour le graphique
        $statusData = json_encode([$publishedCount, $draftCount, $archivedCount]);

        $this->view('admin/dashboard', [
            'totalArticles' => $totalArticles,
            'publishedCount' => $publishedCount,
            'draftCount' => $draftCount,
            'archivedCount' => $archivedCount,
            'featuredCount' => $featuredCount,
            'totalViews' => $totalViews,
            'totalCategories' => $totalCategories,
            'recentArticles' => $recentArticles,
            'mostViewedArticle' => $mostViewedArticle,
            'statusData' => $statusData
        ]);
    }
}
