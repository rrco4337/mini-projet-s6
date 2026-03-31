<?php
/**
 * Page d'erreur 500
 */
$pageTitle = 'Erreur serveur';
$metaDescription = 'Erreur 500: une erreur serveur inattendue s\'est produite. Merci de reessayer plus tard.';
$metaKeywords = 'erreur 500, erreur serveur, iran war news';
$metaRobots = 'noindex, nofollow';
$navCategories = [];

try {
    $navCategories = Category::all();
} catch (Exception $e) {
}

require_once __DIR__ . '/../includes/header.php';
?>

<main class="error-page">
  <div class="container text-center animate-fadeIn">
    <div class="error-code">500</div>
    <h1 class="h2 mb-3">Erreur serveur</h1>
    <p class="error-message">
      Une erreur inattendue s'est produite. Veuillez reessayer plus tard.
    </p>
    <div class="d-flex justify-content-center gap-3">
      <a href="<?= url('/') ?>" class="btn btn-primary">
        <i class="bi bi-house me-2"></i>Retour a l'accueil
      </a>
      <a href="javascript:location.reload()" class="btn btn-outline-secondary">
        <i class="bi bi-arrow-clockwise me-2"></i>Reessayer
      </a>
    </div>
  </div>
</main>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>
