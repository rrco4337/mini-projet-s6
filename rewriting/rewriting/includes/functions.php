<?php
/**
 * Fonctions utiles
 */

// Echapper HTML
function e($text) {
    return htmlspecialchars($text ?? '', ENT_QUOTES, 'UTF-8');
}

// Vérifier si connecté
function isLogged() {
    return isset($_SESSION['user_id']);
}

// Vérifier si admin
function isAdmin() {
    return isLogged() && $_SESSION['user_role'] === 'admin';
}

// Redirection
function redirect($path) {
    header('Location: ' . BASE_URL . $path);
    exit;
}

// Message flash
function setFlash($type, $message) {
    $_SESSION['flash'] = ['type' => $type, 'message' => $message];
}

function getFlash() {
    if (isset($_SESSION['flash'])) {
        $flash = $_SESSION['flash'];
        unset($_SESSION['flash']);
        return $flash;
    }
    return null;
}

// Slug simple
function slugify($text) {
    $text = strtolower($text);
    $text = preg_replace('/[^a-z0-9]+/', '-', $text);
    return trim($text, '-');
}

// Formater date en français
function formatDate($date) {
    $dateTime = new DateTime($date);
    $months = [
        1 => 'janvier', 2 => 'février', 3 => 'mars', 4 => 'avril', 5 => 'mai', 6 => 'juin',
        7 => 'juillet', 8 => 'août', 9 => 'septembre', 10 => 'octobre', 11 => 'novembre', 12 => 'décembre'
    ];
    $day = $dateTime->format('d');
    $month = $months[(int)$dateTime->format('m')];
    $year = $dateTime->format('Y');
    return "$day $month $year";
}

// URL article
function articleUrl($slug) {
    return BASE_URL . '/article.php?slug=' . urlencode($slug);
}

// Récupérer l'utilisateur actuel
function getCurrentUser() {
    if (isLogged()) {
        return fetchOne('SELECT id, username, email, role FROM users WHERE id = ?', [$_SESSION['user_id']]);
    }
    return null;
}
?>