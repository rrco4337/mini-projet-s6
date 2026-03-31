<?php
/**
 * Page d'erreur 404
 */
$pageTitle = 'Page non trouvee';
$metaDescription = 'Erreur 404: page non trouvee.';
$metaKeywords = 'erreur 404, page non trouvee, iran war news';
$metaRobots = 'noindex, nofollow';
$navCategories = [];
try {
    $navCategories = Category::all();
} catch (Exception $e) {}

require_once __DIR__ . '/../includes/header.php';
?>

<main class="error-page">
  <div class="container text-center animate-fadeIn">
    <div class="error-code">404</div>
    <h1 class="h2 mb-3">Page non trouvee</h1>
    <p class="error-message">
      La page que vous recherchez n'existe pas ou a ete deplacee.
    </p>
    <div class="d-flex justify-content-center gap-3">
      <a href="<?= url('/') ?>" class="btn btn-primary">
        <i class="bi bi-house me-2"></i>Retour a l'accueil
      </a>
      <a href="javascript:history.back()" class="btn btn-outline-secondary">
        <i class="bi bi-arrow-left me-2"></i>Page precedente
      </a>
    </div>
  </div>
</main>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>
