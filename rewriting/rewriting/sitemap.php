<?php
/**
 * Sitemap XML généré dynamiquement
 */

header('Content-Type: application/xml; charset=utf-8');
header('Cache-Control: max-age=86400'); // Cache 24h

// Récupération de la DB
require_once __DIR__ . '/config/config.php';

$db = new Database();

echo '<?xml version="1.0" encoding="UTF-8"?>' . "\n";
echo '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">' . "\n";

// Home page
echo '<url>' . "\n";
echo '  <loc>https://yoursite.com/</loc>' . "\n";
echo '  <lastmod>' . date('Y-m-d') . '</lastmod>' . "\n";
echo '  <priority>1.0</priority>' . "\n";
echo '</url>' . "\n";

// Articles publiés
try {
  $articles = $db->fetchAll(
    "SELECT slug, date_modification FROM articles WHERE published_at IS NOT NULL ORDER BY date_modification DESC LIMIT 10000"
  );
  
  foreach ($articles as $article) {
    echo '<url>' . "\n";
    echo '  <loc>https://yoursite.com/article/' . htmlspecialchars($article['slug']) . '</loc>' . "\n";
    echo '  <lastmod>' . substr($article['date_modification'] ?? date('Y-m-d'), 0, 10) . '</lastmod>' . "\n";
    echo '  <priority>0.8</priority>' . "\n";
    echo '</url>' . "\n";
  }
} catch (Exception $e) {
  // DB non disponible, au moins home présente
}

echo '</urlset>' . "\n";
