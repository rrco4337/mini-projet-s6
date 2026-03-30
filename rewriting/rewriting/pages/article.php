<?php
// Récupérer l'article par slug
$slug = $_GET['slug'] ?? '';
$article = fetchOne(
    'SELECT a.*, c.nom as categorie_nom, c.slug as categorie_slug
     FROM articles a
     LEFT JOIN categories c ON a.categorie_id = c.id
     WHERE a.slug = ? AND a.statut = ?',
    [$slug, 'publie']
);

if (!$article) {
    header('HTTP/1.0 404 Not Found');
    $pageTitle = '404 - Article non trouvé';
    include BASE_PATH . '/includes/header.php';
    echo '<div class="text-center py-20"><h1 class="text-3xl font-bold">404 - Article non trouvé</h1></div>';
    include BASE_PATH . '/includes/footer.php';
    exit;
}

$pageTitle = $article['titre'];
?>

<?php include BASE_PATH . '/includes/header.php'; ?>

<article class="max-w-3xl mx-auto">
    <div class="mb-8">
        <span class="text-xs uppercase tracking-widest font-semibold text-blue-600">
            <?php echo e($article['categorie_nom']); ?>
        </span>
        <h1 class="text-4xl font-serif font-bold text-gray-900 mt-4 mb-4">
            <?php echo e($article['titre']); ?>
        </h1>
        <p class="text-gray-600">
            <?php echo formatDate($article['date_publication']); ?>
        </p>
    </div>
    
    <div class="prose prose-lg max-w-none mb-12">
        <p class="text-xl text-gray-700 font-semibold mb-6 italic border-l-4 border-blue-600 pl-6">
            <?php echo e($article['chapeau']); ?>
        </p>
        
        <div class="article-content bg-white p-8 rounded-lg border border-gray-200">
            <?php echo $article['contenu']; ?>
        </div>
    </div>
    
    <div class="flex gap-4">
        <a href="/" class="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition font-semibold">
            ← Retour aux actualités
        </a>
    </div>
</article>

<?php include BASE_PATH . '/includes/footer.php'; ?>
