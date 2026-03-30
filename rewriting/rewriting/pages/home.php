<?php
$pageTitle = 'Accueil';

$selectedCategorySlugs = [];
if (isset($_GET['categorySlugs'])) {
        $selectedCategorySlugs = is_array($_GET['categorySlugs']) ? $_GET['categorySlugs'] : [$_GET['categorySlugs']];
}
$selectedCategorySlugs = array_values(array_filter(array_map('trim', $selectedCategorySlugs)));

$selectedPublicationDate = trim($_GET['publicationDate'] ?? '');
if ($selectedPublicationDate === '') {
        $selectedPublicationDate = null;
}

$navCategories = fetchAll('SELECT id, nom, slug FROM categories ORDER BY nom');

$sql = "
        SELECT DISTINCT a.*, c.nom AS categorie_nom, c.slug AS categorie_slug,
                     m.fichier AS image_fichier, m.alt AS image_alt
        FROM articles a
        LEFT JOIN categories c ON a.categorie_id = c.id
        LEFT JOIN article_categories ac ON a.id = ac.article_id
        LEFT JOIN categories c2 ON ac.category_id = c2.id
        LEFT JOIN medias m ON a.image_une = m.id
        WHERE a.statut = 'publie' AND (a.date_publication IS NULL OR a.date_publication <= NOW())
";
$params = [];

if (!empty($selectedCategorySlugs)) {
        $placeholders = implode(',', array_fill(0, count($selectedCategorySlugs), '?'));
        $sql .= " AND (c.slug IN ($placeholders) OR c2.slug IN ($placeholders))";
        $params = array_merge($params, $selectedCategorySlugs, $selectedCategorySlugs);
}

if (!empty($selectedPublicationDate)) {
        $sql .= " AND DATE(a.date_publication) = ?";
        $params[] = $selectedPublicationDate;
}

$sql .= ' ORDER BY a.date_publication DESC NULLS LAST, a.created_at DESC LIMIT 30';
$articles = fetchAll($sql, $params);

$featuredArticles = fetchAll(
        "SELECT a.*, c.nom AS categorie_nom, c.slug AS categorie_slug,
                        m.fichier AS image_fichier, m.alt AS image_alt
         FROM articles a
         LEFT JOIN categories c ON a.categorie_id = c.id
         LEFT JOIN medias m ON a.image_une = m.id
         WHERE a.statut = 'publie' AND a.a_la_une = true AND (a.date_publication IS NULL OR a.date_publication <= NOW())
         ORDER BY a.date_publication DESC NULLS LAST, a.created_at DESC
         LIMIT 3"
);

$categoryByArticle = [];
if (!empty($articles) || !empty($featuredArticles)) {
        $allIds = array_unique(array_map(static function ($a) {
                return (int) $a['id'];
        }, array_merge($articles, $featuredArticles)));
        if (!empty($allIds)) {
                $in = implode(',', array_fill(0, count($allIds), '?'));
                $rows = fetchAll(
                        "SELECT ac.article_id, c.nom, c.slug
                         FROM article_categories ac
                         JOIN categories c ON c.id = ac.category_id
                         WHERE ac.article_id IN ($in)",
                        $allIds
                );
                foreach ($rows as $row) {
                        $aid = (int) $row['article_id'];
                        if (!isset($categoryByArticle[$aid])) {
                                $categoryByArticle[$aid] = [];
                        }
                        $categoryByArticle[$aid][] = ['nom' => $row['nom'], 'slug' => $row['slug']];
                }
        }
}

$enrichArticle = static function (array $article) use ($categoryByArticle): array {
        $articleId = (int) $article['id'];
        $article['categories'] = $categoryByArticle[$articleId] ?? [];
        $article['imageUrl'] = !empty($article['image_fichier']) ? '/uploads/' . $article['image_fichier'] : null;
        $article['imageAlt'] = $article['image_alt'] ?? '';
        return $article;
};

$articles = array_map($enrichArticle, $articles);
$featuredArticles = array_map($enrichArticle, $featuredArticles);
?>

<?php include BASE_PATH . '/includes/header.php'; ?>

<main class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-8 sm:py-10">

    <section class="mb-6">
        <div class="rounded-2xl border border-stone bg-white shadow-editorial">
            <div class="p-5 sm:p-6">
                <form method="get" action="/">
                    <div class="grid grid-cols-1 md:grid-cols-12 gap-5 items-end">
                        <div class="md:col-span-8">
                            <p class="block text-xs uppercase tracking-[0.2em] font-semibold text-gray-500 mb-2">Categories</p>
                            <div class="flex flex-wrap gap-2">
                                <?php foreach ($navCategories as $cat): ?>
                                    <?php $isSelected = in_array($cat['slug'], $selectedCategorySlugs, true); ?>
                                    <label class="cursor-pointer">
                                        <input type="checkbox" name="categorySlugs[]" value="<?= e($cat['slug']) ?>" class="peer sr-only" <?= $isSelected ? 'checked' : '' ?> />
                                        <span class="inline-flex items-center gap-2 rounded-full border border-stone px-3 py-1.5 text-xs uppercase tracking-wider text-gray-600 transition-colors hover:text-ink hover:border-gray-400 peer-checked:border-ink peer-checked:bg-ink peer-checked:text-white">
                                            <?= e($cat['nom']) ?>
                                        </span>
                                    </label>
                                <?php endforeach; ?>
                            </div>
                        </div>

                        <div class="md:col-span-4">
                            <label for="publicationDate" class="block text-xs uppercase tracking-[0.2em] font-semibold text-gray-500 mb-2">Date de publication</label>
                            <input id="publicationDate" name="publicationDate" type="date" class="w-full rounded-lg border-stone focus:border-ink focus:ring-ink text-sm"
                                         value="<?= e($selectedPublicationDate ?? '') ?>" />
                        </div>

                        <div class="md:col-span-12 flex gap-2 justify-end">
                            <button type="submit" class="px-5 py-2.5 rounded-lg bg-ink text-white text-sm font-semibold hover:bg-black transition-colors">
                                Rechercher
                            </button>
                            <a href="/" class="px-4 py-2.5 rounded-lg border border-stone text-sm text-gray-700 hover:bg-gray-50 transition-colors">Reset</a>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </section>

    <?php if (!empty($featuredArticles)): ?>
        <section class="mb-10">
            <div class="flex items-center justify-between mb-5">
                <h2 class="font-serif text-3xl font-semibold tracking-tight">A la une</h2>
                <span class="h-px bg-stone flex-1 ml-5"></span>
            </div>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <?php foreach ($featuredArticles as $article): ?>
                    <article class="group rounded-2xl border border-stone bg-white shadow-editorial overflow-hidden hover:-translate-y-1 transition-all duration-300">
                            <?php if (!empty($article['imageUrl'])): ?>
                                <img src="<?= e($article['imageUrl']) ?>" alt="<?= e($article['imageAlt'] ?: 'Illustration de l article') ?>" class="h-48 w-full object-cover" />
                            <?php endif; ?>
                            <div class="p-5">
                                <?php if (!empty($article['categories'])): ?>
                                    <div class="mb-3 flex flex-wrap gap-2">
                                        <?php foreach ($article['categories'] as $cat): ?>
                                            <a href="/?categorySlugs[]=<?= e($cat['slug']) ?>" class="inline-flex items-center rounded-full border border-stone px-3 py-1 text-xs uppercase tracking-wider text-gray-600 hover:text-ink hover:border-gray-400 transition-colors">
                                                <?= e($cat['nom']) ?>
                                            </a>
                                        <?php endforeach; ?>
                                    </div>
                                <?php elseif (!empty($article['categorie_nom'])): ?>
                                    <a href="/?categorySlugs[]=<?= e($article['categorie_slug']) ?>" class="inline-flex items-center rounded-full border border-stone px-3 py-1 text-xs uppercase tracking-wider text-gray-600 hover:text-ink hover:border-gray-400 transition-colors mb-3">
                                        <?= e($article['categorie_nom']) ?>
                                    </a>
                                <?php endif; ?>
                                <h3 class="font-serif text-2xl leading-snug font-semibold group-hover:text-accent transition-colors">
                                    <a href="/article/<?= e($article['slug']) ?>">
                                        <?= e($article['titre']) ?>
                                    </a>
                                </h3>
                                <?php if (!empty($article['chapeau'])): ?>
                                    <p class="mt-3 text-gray-600 leading-relaxed">
                                        <?= e($article['chapeau']) ?>
                                    </p>
                                <?php endif; ?>
                            </div>
                            <div class="px-5 py-4 border-t border-stone text-sm text-gray-500">
                                <?= (int) $article['vues'] ?> vues
                            </div>
                    </article>
                <?php endforeach; ?>
            </div>
        </section>
    <?php endif; ?>

    <section>
        <div class="flex items-center justify-between mb-5">
            <h2 class="font-serif text-3xl font-semibold tracking-tight">Derniers articles</h2>
            <span class="h-px bg-stone flex-1 ml-5"></span>
        </div>

        <?php if (empty($articles)): ?>
            <div class="rounded-xl border border-stone bg-white p-5 text-gray-600">
                Aucun article disponible pour le moment.
            </div>
        <?php endif; ?>

        <div class="grid grid-cols-1 gap-6">
            <?php foreach ($articles as $article): ?>
                <article class="rounded-2xl border border-stone bg-white shadow-editorial overflow-hidden hover:shadow-xl transition-shadow duration-300">
                    <div class="p-5 sm:p-6">
                        <div class="grid grid-cols-1 md:grid-cols-12 gap-5 items-start">
                                <?php if (!empty($article['imageUrl'])): ?>
                                    <div class="md:col-span-4">
                                        <img src="<?= e($article['imageUrl']) ?>" alt="<?= e($article['imageAlt'] ?: 'Illustration de l article') ?>" class="w-full h-52 object-cover rounded-xl" />
                                    </div>
                                <?php endif; ?>

                                <div class="<?= !empty($article['imageUrl']) ? 'md:col-span-8' : 'md:col-span-12' ?>">
                                    <?php if (!empty($article['categories'])): ?>
                                        <div class="mb-3 flex flex-wrap gap-2">
                                            <?php foreach ($article['categories'] as $cat): ?>
                                                <a href="/?categorySlugs[]=<?= e($cat['slug']) ?>" class="inline-flex items-center rounded-full border border-stone px-3 py-1 text-xs uppercase tracking-wider text-gray-600 hover:text-ink hover:border-gray-400 transition-colors">
                                                    <?= e($cat['nom']) ?>
                                                </a>
                                            <?php endforeach; ?>
                                        </div>
                                    <?php elseif (!empty($article['categorie_nom'])): ?>
                                        <a href="/?categorySlugs[]=<?= e($article['categorie_slug']) ?>" class="inline-flex items-center rounded-full border border-stone px-3 py-1 text-xs uppercase tracking-wider text-gray-600 hover:text-ink hover:border-gray-400 transition-colors mb-3">
                                            <?= e($article['categorie_nom']) ?>
                                        </a>
                                    <?php endif; ?>
                                    <h3 class="font-serif text-3xl leading-tight font-semibold mb-2 hover:text-accent transition-colors">
                                        <a href="/article/<?= e($article['slug']) ?>">
                                            <?= e($article['titre']) ?>
                                        </a>
                                    </h3>
                                    <?php if (!empty($article['sous_titre'])): ?>
                                        <p class="text-gray-500 text-lg mb-2"><?= e($article['sous_titre']) ?></p>
                                    <?php endif; ?>
                                    <?php if (!empty($article['chapeau'])): ?>
                                        <p class="text-gray-700 leading-relaxed"><?= e($article['chapeau']) ?></p>
                                    <?php endif; ?>
                                    <div class="mt-4 flex flex-wrap items-center gap-4 text-sm text-gray-500">
                                        <?php if (!empty($article['date_publication'])): ?>
                                            <span><?= formatDate($article['date_publication'], 'd M Y') ?></span>
                                        <?php endif; ?>
                                        <span><?= (int) $article['vues'] ?> vues</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </article>
            <?php endforeach; ?>
        </div>
    </section>

</main>

<?php include BASE_PATH . '/includes/footer.php'; ?>
