<?php
// Récupérer l'article par slug
$slug = $_GET['slug'] ?? '';
$article = fetchOne(
    'SELECT a.*, c.nom as categorie_nom, c.slug as categorie_slug,
            m.fichier as image_fichier, m.alt as image_alt
     FROM articles a
     LEFT JOIN categories c ON a.categorie_id = c.id
     LEFT JOIN medias m ON a.image_une = m.id
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

// Incremente les vues en front legacy
query('UPDATE articles SET vues = vues + 1 WHERE id = ?', [$article['id']]);
$article['vues'] = (int) $article['vues'] + 1;

$pageTitle = $article['titre'];

$galleryMedias = [];
$articleCategories = [];
try {
    $hasArticleMediasTable = (bool) fetchColumn("SELECT to_regclass('public.article_medias') IS NOT NULL");
    if ($hasArticleMediasTable) {
        $galleryMedias = fetchAll(
            'SELECT m.* FROM article_medias am
             JOIN medias m ON m.id = am.media_id
             WHERE am.article_id = ?
             ORDER BY am.ordre ASC, am.id ASC',
            [$article['id']]
        );
    }

        $articleCategories = fetchAll(
                'SELECT c.nom, c.slug
                 FROM article_categories ac
                 JOIN categories c ON c.id = ac.category_id
                 WHERE ac.article_id = ?
                 ORDER BY c.nom ASC',
                [$article['id']]
        );
} catch (Exception $e) {
    $galleryMedias = [];
        $articleCategories = [];
}
?>

<?php include BASE_PATH . '/includes/header.php'; ?>

<main class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-10 sm:py-12">
    <article class="bg-white rounded-2xl border border-stone shadow-editorial p-6 sm:p-10">
        <header class="mb-8 pb-6 border-b border-stone">
            <?php if (!empty($articleCategories)): ?>
                <div class="mb-4 flex flex-wrap gap-2">
                    <?php foreach ($articleCategories as $cat): ?>
                        <a href="/categorie/<?php echo e($cat['slug']); ?>" class="inline-flex items-center rounded-full border border-stone px-3 py-1 text-xs uppercase tracking-wider text-gray-600 hover:text-ink hover:border-gray-400 transition-colors">
                            <?php echo e($cat['nom']); ?>
                        </a>
                    <?php endforeach; ?>
                </div>
            <?php elseif (!empty($article['categorie_slug'])): ?>
                <a href="/categorie/<?php echo e($article['categorie_slug']); ?>" class="inline-flex items-center rounded-full border border-stone px-3 py-1 text-xs uppercase tracking-wider text-gray-600 hover:text-ink hover:border-gray-400 transition-colors mb-4">
                    <?php echo e($article['categorie_nom']); ?>
                </a>
            <?php endif; ?>

            <h1 class="font-serif text-4xl sm:text-5xl leading-tight font-bold tracking-tight"><?php echo e($article['titre']); ?></h1>

            <?php if (!empty($article['sous_titre'])): ?>
                <h2 class="mt-4 text-xl sm:text-2xl text-gray-600 leading-relaxed"><?php echo e($article['sous_titre']); ?></h2>
            <?php endif; ?>

            <div class="mt-6 flex flex-wrap items-center gap-4 text-sm text-gray-500">
                <?php if (!empty($article['date_publication'])): ?>
                    <span>
                        <time datetime="<?php echo e($article['date_publication']); ?>">
                            <?php echo formatDate($article['date_publication'], 'd F Y \a H:i'); ?>
                        </time>
                    </span>
                <?php endif; ?>
                <span><?php echo (int) $article['vues']; ?> vue(s)</span>
            </div>
        </header>

        <?php if (!empty($article['chapeau'])): ?>
            <div class="text-xl leading-relaxed text-gray-700 border-l-2 border-gray-300 pl-5 mb-8">
                <?php echo e($article['chapeau']); ?>
            </div>
        <?php endif; ?>

        <?php if (!empty($galleryMedias)): ?>
            <section class="mb-8">
                <h3 class="font-serif text-2xl font-semibold mb-4">Galerie</h3>
                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <?php foreach ($galleryMedias as $media): ?>
                        <div>
                            <figure>
                                <img src="/uploads/<?php echo e($media['fichier']); ?>" alt="<?php echo e($media['alt'] ?? 'Illustration de l article'); ?>" class="w-full h-64 object-cover rounded-xl border border-stone" />
                            </figure>
                        </div>
                    <?php endforeach; ?>
                </div>
            </section>
        <?php elseif (!empty($article['image_fichier'])): ?>
            <figure class="mb-8">
                <img src="/uploads/<?php echo e($article['image_fichier']); ?>" alt="<?php echo e($article['image_alt'] ?? 'Illustration de l article'); ?>" class="w-full h-auto rounded-xl border border-stone" />
            </figure>
        <?php endif; ?>

        <section class="article-content text-[1.05rem] leading-8 text-gray-800">
            <?php echo $article['contenu']; ?>
        </section>
    </article>

    <div class="mt-8 flex flex-wrap gap-3">
        <a href="/" class="inline-flex items-center rounded-lg border border-stone px-4 py-2 text-sm font-semibold text-gray-700 hover:bg-gray-50 transition-colors">Retour a l'accueil</a>
        <?php if (!empty($article['categorie_slug'])): ?>
            <a href="/categorie/<?php echo e($article['categorie_slug']); ?>" class="inline-flex items-center rounded-lg bg-ink px-4 py-2 text-sm font-semibold text-white hover:bg-black transition-colors">Voir la categorie</a>
        <?php endif; ?>
    </div>
</main>

<?php include BASE_PATH . '/includes/footer.php'; ?>
