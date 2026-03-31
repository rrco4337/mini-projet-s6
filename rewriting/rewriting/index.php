<?php
/**
 * Routeur Principal - Iran War News
 * Dispatche toutes les requêtes selon l'URL
 * Utilise .htaccess pour rediriger tout vers ici
 */

// Avec le serveur PHP integre, laisser passer les fichiers statiques existants.
if (PHP_SAPI === 'cli-server') {
    $requestPath = parse_url($_SERVER['REQUEST_URI'] ?? '/', PHP_URL_PATH) ?: '/';
    $fullPath = __DIR__ . $requestPath;
    if (is_file($fullPath)) {
        return false;
    }
}

require_once __DIR__ . '/config.php';
require_once __DIR__ . '/includes/db.php';
require_once __DIR__ . '/includes/functions.php';

// Parser l'URL demandée
$path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$path = trim($path, '/');

// Dispatcher selon le chemin
if ($path === '' || $path === 'index.php') {
    // Page d'accueil
    include __DIR__ . '/pages/home.php';
    
} elseif (strpos($path, 'article/') === 0 || strpos($path, 'article?') === 0) {
    // Page article
    if (strpos($path, 'article/') === 0) {
        $_GET['slug'] = substr($path, 8); // Extraire le slug
    }
    include __DIR__ . '/pages/article.php';
    
} elseif ($path === 'login' || $path === 'login.php') {
    // Page login
    include __DIR__ . '/pages/login.php';
    
} elseif ($path === 'logout' || $path === 'logout.php') {
    // Logout
    include __DIR__ . '/pages/logout.php';
    
} elseif ($path === 'admin' || $path === 'admin/') {
    // Dashboard admin
    include __DIR__ . '/pages/admin/dashboard.php';
    
} elseif (strpos($path, 'admin/articles') === 0) {
    // Gestion articles
    include __DIR__ . '/pages/admin/articles.php';
    
} elseif (strpos($path, 'admin/article') === 0) {
    // Edition/création article
    if (strpos($path, 'article/') !== false) {
        preg_match('/article\/(\d+)/', $path, $m);
        $_GET['id'] = $m[1] ?? null;
    }
    include __DIR__ . '/pages/admin/article-edit.php';
    
} elseif (strpos($path, 'admin/categor') === 0) {
    // Gestion catégories
    include __DIR__ . '/pages/admin/categories.php';
    
} else {
    // 404
    header('HTTP/1.0 404 Not Found');
    $pageTitle = '404 - Page non trouvée';
    include 'includes/header.php';
    echo '<div class="text-center py-20"><h1 class="text-3xl font-bold">404 - Page non trouvée</h1><p class="text-gray-600 mt-4">La page que vous recherchez n\'existe pas.</p></div>';
    include 'includes/footer.php';
}

