<?php
/**
 * Router pour le serveur PHP built-in (php -S)
 * Redirige toutes les requêtes vers index.php (sauf fichiers réels)
 * Permet le rewriting d'URL sans Apache
 */

$requested_file = __DIR__ . $_SERVER['REQUEST_URI'];

// Si c'est un fichier ou dossier réel qui existe, le servir directement
if (is_file($requested_file) || is_dir($requested_file)) {
    return false;
}

// Sinon, rediriger tout vers index.php (le routeur principal)
require __DIR__ . '/index.php';
