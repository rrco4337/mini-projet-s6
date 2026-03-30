<?php
/**
 * Router pour le serveur PHP integre
 * Usage: php -S localhost:8000 router.php
 */

// Si c'est un fichier statique existant, le servir directement
$uri = $_SERVER['REQUEST_URI'];
$path = parse_url($uri, PHP_URL_PATH);
$file = __DIR__ . $path;

// Servir les fichiers statiques (CSS, JS, images)
if (is_file($file)) {
    return false; // Laisser PHP servir le fichier
}

// Sinon, router vers index.php
require_once __DIR__ . '/index.php';
