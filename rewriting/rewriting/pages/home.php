<?php
$pageTitle = 'Iran War News - Actualités';

// Récupérer tous les articles publiés
$articles = fetchAll(
    'SELECT a.id, a.titre, a.slug, a.chapeau, a.date_publication, c.nom as categorie_nom, c.slug as categorie_slug
     FROM articles a
     LEFT JOIN categories c ON a.categorie_id = c.id
     WHERE a.statut = ? AND a.date_publication <= NOW()
     ORDER BY a.date_publication DESC
     LIMIT 20',
    ['publie']
);
?>

<?php include BASE_PATH . '/includes/header.php'; ?>

<h1 class="text-4xl font-serif font-bold text-gray-900 mb-12">Dernières Actualités</h1>

<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-12">
    <?php foreach ($articles as $article): ?>
    <article class="bg-white rounded-lg border border-gray-200 shadow-sm hover:shadow-md transition overflow-hidden">
        <div class="p-6">
            <span class="text-xs uppercase tracking-widest font-semibold text-blue-600">
                <?php echo e($article['categorie_nom']); ?>
            </span>
            <h2 class="text-xl font-bold text-gray-900 mt-3 mb-2">
                <?php echo e($article['titre']); ?>
            </h2>
            <p class="text-gray-600 text-sm mb-4">
                <?php echo e(substr($article['chapeau'], 0, 150)) . (strlen($article['chapeau']) > 150 ? '...' : ''); ?>
            </p>
            <p class="text-xs text-gray-500 mb-4">
                <?php echo formatDate($article['date_publication']); ?>
            </p>
            <a href="/article/<?php echo urlencode($article['slug']); ?>" class="inline-block px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition font-semibold text-sm">
                Lire l'article →
            </a>
        </div>
    </article>
    <?php endforeach; ?>
</div>

<?php if (empty($articles)): ?>
<div class="text-center py-20">
    <p class="text-gray-500 text-lg">Aucun article pour le moment.</p>
</div>
<?php endif; ?>

<?php include BASE_PATH . '/includes/footer.php'; ?>
