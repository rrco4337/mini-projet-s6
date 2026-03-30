<?php
/**
 * Page d'erreur 404
 */
$pageTitle = 'Page non trouvee';
$metaDescription = 'Erreur 404: page non trouvee.';
$metaRobots = 'noindex, nofollow';
$navCategories = [];
try {
    $navCategories = Category::all();
} catch (Exception $e) {}

require_once __DIR__ . '/../includes/header.php';
?>

<main class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-20 text-center">
  <div class="bg-white rounded-2xl border border-stone shadow-editorial p-10">
    <div class="text-8xl font-serif font-bold text-gray-300 mb-6">404</div>
    <h1 class="text-3xl font-semibold text-gray-900 mb-4">Page non trouvee</h1>
    <p class="text-gray-600 mb-8">
      La page que vous recherchez n'existe pas ou a ete deplacee.
    </p>
    <div class="flex justify-center gap-4">
      <a href="<?= url('/') ?>" class="inline-flex items-center px-5 py-3 rounded-xl bg-ink text-white font-semibold hover:bg-black transition-colors">
        Retour a l'accueil
      </a>
      <a href="javascript:history.back()" class="inline-flex items-center px-5 py-3 rounded-xl border border-stone text-gray-700 font-semibold hover:bg-gray-50 transition-colors">
        Page precedente
      </a>
    </div>
  </div>
</main>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>
