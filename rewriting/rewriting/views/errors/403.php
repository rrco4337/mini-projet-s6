<?php
/**
 * Page d'erreur 403
 */
$pageTitle = 'Acces refuse';
$metaDescription = 'Erreur 403: acces refuse. Vous n\'avez pas les droits necessaires pour consulter cette page.';
$metaKeywords = 'erreur 403, acces refuse, iran war news';
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
    <div class="error-code">403</div>
    <h1 class="h2 mb-3">Acces refuse</h1>
    <p class="error-message">
      Vous n'avez pas les droits necessaires pour acceder a cette page.
    </p>
    <div class="d-flex justify-content-center gap-3">
      <a href="<?= url('/') ?>" class="btn btn-primary">
        <i class="bi bi-house me-2"></i>Retour a l'accueil
      </a>
      <a href="<?= url('login') ?>" class="btn btn-outline-secondary">
        <i class="bi bi-box-arrow-in-right me-2"></i>Se connecter
      </a>
    </div>
  </div>
</main>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>
