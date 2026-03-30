<?php
/**
 * Point d'entree de l'application PHP
 * Iran War News - CMS simple
 */

// Demarrer la session
session_name('iran_war_news_session');
session_start();

// Charger la configuration
require_once __DIR__ . '/config/config.php';

// Charger le core
require_once __DIR__ . '/core/Database.php';
require_once __DIR__ . '/core/Model.php';
require_once __DIR__ . '/core/Router.php';
require_once __DIR__ . '/core/Controller.php';
require_once __DIR__ . '/core/Auth.php';

// Charger les modeles
require_once __DIR__ . '/models/User.php';
require_once __DIR__ . '/models/Category.php';
require_once __DIR__ . '/models/Article.php';
require_once __DIR__ . '/models/Media.php';

// Charger les controleurs
require_once __DIR__ . '/controllers/HomeController.php';
require_once __DIR__ . '/controllers/ArticleFrontController.php';
require_once __DIR__ . '/controllers/AuthController.php';
require_once __DIR__ . '/controllers/AdminController.php';
require_once __DIR__ . '/controllers/ArticleAdminController.php';
require_once __DIR__ . '/controllers/CategoryController.php';

// Creer le routeur
$router = new Router();

// ===========================
// ROUTES PUBLIQUES (FRONT)
// ===========================

// Page d'accueil
$router->get('/', [HomeController::class, 'index']);

// Detail d'un article
$router->get('/article/{slug}', [ArticleFrontController::class, 'show']);

// ===========================
// ROUTES AUTHENTIFICATION
// ===========================

// Page de connexion
$router->get('/login', [AuthController::class, 'showLogin'], ['guest']);

// Traitement du formulaire de connexion
$router->post('/login', [AuthController::class, 'login'], ['guest']);

// Deconnexion
$router->get('/logout', [AuthController::class, 'logout']);

// ===========================
// ROUTES ADMIN (PROTEGEES)
// ===========================

// Tableau de bord
$router->get('/admin', [AdminController::class, 'dashboard'], ['auth']);

// ===========================
// GESTION DES ARTICLES
// ===========================

// Liste des articles publies
$router->get('/admin/articles', [ArticleAdminController::class, 'index'], ['auth']);

// Liste des brouillons
$router->get('/admin/articles/drafts', [ArticleAdminController::class, 'drafts'], ['auth']);

// Liste des archives
$router->get('/admin/articles/archives', [ArticleAdminController::class, 'archives'], ['auth']);

// Formulaire de creation
$router->get('/admin/articles/new', [ArticleAdminController::class, 'create'], ['auth']);

// Enregistrement d'un nouvel article
$router->post('/admin/articles', [ArticleAdminController::class, 'store'], ['auth']);

// Formulaire de modification
$router->get('/admin/articles/{id}/edit', [ArticleAdminController::class, 'edit'], ['auth']);

// Mise a jour d'un article
$router->post('/admin/articles/{id}', [ArticleAdminController::class, 'update'], ['auth']);

// Suppression d'un article
$router->post('/admin/articles/{id}/delete', [ArticleAdminController::class, 'delete'], ['auth']);

// Archiver un article
$router->post('/admin/articles/{id}/archive', [ArticleAdminController::class, 'archive'], ['auth']);

// Restaurer un article
$router->post('/admin/articles/{id}/restore', [ArticleAdminController::class, 'restore'], ['auth']);

// ===========================
// GESTION DES CATEGORIES
// ===========================

// Liste des categories
$router->get('/categories', [CategoryController::class, 'index'], ['auth']);

// Formulaire de creation
$router->get('/categories/new', [CategoryController::class, 'create'], ['auth']);

// Enregistrement d'une nouvelle categorie
$router->post('/categories', [CategoryController::class, 'store'], ['auth']);

// Formulaire de modification
$router->get('/categories/{id}/edit', [CategoryController::class, 'edit'], ['auth']);

// Mise a jour d'une categorie
$router->post('/categories/{id}', [CategoryController::class, 'update'], ['auth']);

// Suppression d'une categorie
$router->post('/categories/{id}/delete', [CategoryController::class, 'delete'], ['auth']);

// ===========================
// DEMARRER LE ROUTAGE
// ===========================

try {
    $router->dispatch();
} catch (Exception $e) {
    if (DEBUG) {
        echo '<h1>Erreur</h1>';
        echo '<pre>' . e($e->getMessage()) . '</pre>';
        echo '<pre>' . e($e->getTraceAsString()) . '</pre>';
    } else {
        http_response_code(500);
        echo '<h1>Erreur serveur</h1>';
        echo '<p>Une erreur est survenue. Veuillez reessayer plus tard.</p>';
    }
}
