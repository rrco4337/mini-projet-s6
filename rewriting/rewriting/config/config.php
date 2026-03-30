<?php
/**
 * Configuration de l'application
 */

// Mode debug
define('DEBUG', true);

// Configuration de la base de donnees
define('DB_HOST', 'localhost');
define('DB_PORT', '5432');
define('DB_NAME', 'iran');
define('DB_USER', 'cindy');
define('DB_PASS', 'cindy2301');

// URL de base (modifier selon votre environnement)
// Pour serveur PHP integre: ''
// Pour Apache: '/rewriting/rewriting'
define('BASE_URL', '');

// Dossier uploads
define('UPLOAD_DIR', __DIR__ . '/../uploads/');
define('UPLOAD_MAX_SIZE', 5 * 1024 * 1024); // 5 Mo

// Configuration de session
define('SESSION_NAME', 'iran_war_news_session');
define('SESSION_LIFETIME', 3600); // 1 heure

// Timezone
date_default_timezone_set('Europe/Paris');

// Gestion des erreurs
if (DEBUG) {
    error_reporting(E_ALL);
    ini_set('display_errors', '1');
} else {
    error_reporting(0);
    ini_set('display_errors', '0');
}

// Fonction helper pour les URLs
function url(string $path = ''): string
{
    return BASE_URL . '/' . ltrim($path, '/');
}

// Fonction helper pour echapper les sorties HTML
function e(?string $string): string
{
    return htmlspecialchars($string ?? '', ENT_QUOTES, 'UTF-8');
}

// Fonction helper pour les messages flash
function flash(string $type, string $message): void
{
    $_SESSION['flash'][$type] = $message;
}

function getFlash(string $type): ?string
{
    $message = $_SESSION['flash'][$type] ?? null;
    unset($_SESSION['flash'][$type]);
    return $message;
}

// Fonction helper pour formater les dates
function formatDate(?string $date, string $format = 'd M Y'): string
{
    if (!$date) return '';
    $dt = new DateTime($date);
    return $dt->format($format);
}
