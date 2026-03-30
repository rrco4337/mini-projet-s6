<?php
/**
 * Detail d'un article
 */
require_once __DIR__ . '/../../includes/header.php';
?>

<main class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-10 sm:py-12">
  <article class="bg-white rounded-2xl border border-stone shadow-editorial p-6 sm:p-10">
    <header class="mb-8 pb-6 border-b border-stone">
      <?php if (!empty($article['categories'])): ?>
        <div class="mb-4 flex flex-wrap gap-2">
          <?php foreach ($article['categories'] as $cat): ?>
            <a href="<?= url('/?categorySlugs=' . e($cat['slug'])) ?>" class="inline-flex items-center rounded-full border border-stone px-3 py-1 text-xs uppercase tracking-wider text-gray-600 hover:text-ink hover:border-gray-400 transition-colors">
              <?= e($cat['nom']) ?>
            </a>
          <?php endforeach; ?>
        </div>
      <?php elseif (!empty($article['categorie_nom'])): ?>
        <a href="<?= url('/?categorySlugs=' . e($article['categorie_slug'])) ?>" class="inline-flex items-center rounded-full border border-stone px-3 py-1 text-xs uppercase tracking-wider text-gray-600 hover:text-ink hover:border-gray-400 transition-colors mb-4">
          <?= e($article['categorie_nom']) ?>
        </a>
      <?php endif; ?>

      <h1 class="font-serif text-4xl sm:text-5xl leading-tight font-bold tracking-tight"><?= e($article['titre']) ?></h1>

      <?php if (!empty($article['sous_titre'])): ?>
        <h2 class="mt-4 text-xl sm:text-2xl text-gray-600 leading-relaxed"><?= e($article['sous_titre']) ?></h2>
      <?php endif; ?>

      <div class="mt-6 flex flex-wrap items-center gap-4 text-sm text-gray-500">
        <?php if (!empty($article['date_publication'])): ?>
          <span>
            <time datetime="<?= e($article['date_publication']) ?>">
              <?= formatDate($article['date_publication'], 'd F Y \a H:i') ?>
            </time>
          </span>
        <?php endif; ?>
        <span><?= (int) $article['vues'] ?> vue(s)</span>
      </div>
    </header>

    <?php if (!empty($article['chapeau'])): ?>
      <div class="text-xl leading-relaxed text-gray-700 border-l-2 border-gray-300 pl-5 mb-8">
        <?= e($article['chapeau']) ?>
      </div>
    <?php endif; ?>

    <?php if (!empty($article['galleryImages'])): ?>
      <section class="mb-8">
        <h3 class="font-serif text-2xl font-semibold mb-4">Galerie</h3>
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <?php foreach ($article['galleryImages'] as $img): ?>
            <div>
              <figure>
                <img src="<?= e($img['url']) ?>" alt="<?= e($img['alt'] ?? 'Illustration de l article') ?>" class="w-full h-64 object-cover rounded-xl border border-stone" />
              </figure>
            </div>
          <?php endforeach; ?>
        </div>
      </section>
    <?php elseif (!empty($article['imageUrl'])): ?>
      <figure class="mb-8">
        <img src="<?= e($article['imageUrl']) ?>" alt="<?= e($article['imageAlt'] ?? 'Illustration de l article') ?>" class="w-full h-auto rounded-xl border border-stone" />
      </figure>
    <?php endif; ?>

    <section class="article-content text-[1.05rem] leading-8 text-gray-800">
      <?= $article['contenu'] ?>
    </section>
  </article>

  <div class="mt-8 flex flex-wrap gap-3">
    <a href="<?= url('/') ?>" class="inline-flex items-center rounded-lg border border-stone px-4 py-2 text-sm font-semibold text-gray-700 hover:bg-gray-50 transition-colors">Retour a l'accueil</a>
    <?php if (!empty($article['categorie_slug'])): ?>
      <a href="<?= url('/?categorySlugs=' . e($article['categorie_slug'])) ?>" class="inline-flex items-center rounded-lg bg-ink px-4 py-2 text-sm font-semibold text-white hover:bg-black transition-colors">Voir la categorie</a>
    <?php endif; ?>
  </div>
</main>

<?php require_once __DIR__ . '/../../includes/footer.php'; ?>
