<?php
/**
 * Liste des articles (admin)
 */
?>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Gestion des articles - BackOffice</title>
  <meta name="robots" content="noindex, nofollow" />
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
  <script src="https://cdn.tailwindcss.com"></script>
  <script>
    tailwind.config = {
      theme: { extend: { fontFamily: { sans: ['Plus Jakarta Sans', 'sans-serif'] }, boxShadow: { soft: '0 10px 30px rgba(15, 23, 42, 0.08)' } } }
    };
  </script>
  <style>body { background: radial-gradient(circle at 8% 12%, rgba(37, 99, 235, 0.08), transparent 30%), #f6f8fb; }</style>
</head>
<body class="min-h-screen font-sans text-slate-800">
<div class="flex min-h-screen">
  <?php include __DIR__ . '/../../includes/admin_sidebar.php'; ?>

  <div class="w-full xl:ml-72">
    <?php include __DIR__ . '/../../includes/admin_header.php'; ?>

    <main class="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8">
      <section class="mb-6 flex flex-wrap items-center justify-between gap-4">
        <div>
          <h1 class="text-3xl font-bold tracking-tight text-slate-900">Gestion des articles</h1>
          <p class="mt-2 text-sm text-slate-600">Consultez, editez et supprimez les contenus publies ou en brouillon.</p>
        </div>
        <div class="flex flex-wrap items-center gap-2">
          <a href="<?= url('admin/articles/drafts') ?>" class="inline-flex items-center gap-2 rounded-xl border border-slate-200 bg-white px-4 py-3 text-sm font-semibold text-slate-700 transition hover:bg-slate-50">Voir les brouillons</a>
          <a href="<?= url('admin/articles/archives') ?>" class="inline-flex items-center gap-2 rounded-xl border border-slate-200 bg-white px-4 py-3 text-sm font-semibold text-slate-700 transition hover:bg-slate-50">Voir les archives</a>
          <a href="<?= url('admin/articles/new') ?>" class="inline-flex items-center gap-2 rounded-xl bg-slate-900 px-5 py-3 text-sm font-semibold text-white transition hover:bg-slate-700">Ajouter un article</a>
        </div>
      </section>

      <?php if (!empty($successMessage)): ?>
        <div class="mb-4 rounded-xl border border-emerald-200 bg-emerald-50 px-4 py-3 text-sm text-emerald-800"><?= e($successMessage) ?></div>
      <?php endif; ?>
      <?php if (!empty($errorMessage)): ?>
        <div class="mb-4 rounded-xl border border-rose-200 bg-rose-50 px-4 py-3 text-sm text-rose-800"><?= e($errorMessage) ?></div>
      <?php endif; ?>

      <section class="overflow-hidden rounded-2xl border border-slate-200 bg-white shadow-soft">
        <div class="overflow-x-auto">
          <table class="min-w-full text-sm">
            <thead class="bg-slate-100/90 text-left text-xs font-semibold uppercase tracking-wide text-slate-600">
              <tr>
                <th class="px-5 py-4">ID</th>
                <th class="px-5 py-4">Titre</th>
                <th class="px-5 py-4">Categorie</th>
                <th class="px-5 py-4">Statut</th>
                <th class="px-5 py-4">A la une</th>
                <th class="px-5 py-4">Vues</th>
                <th class="px-5 py-4 text-right">Actions</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-slate-200">
              <?php foreach ($articles as $index => $article): ?>
                <tr class="<?= $index % 2 == 0 ? 'bg-white' : 'bg-slate-50' ?> transition hover:bg-blue-50/60">
                  <td class="px-5 py-4 font-semibold text-slate-700"><?= $article['id'] ?></td>
                  <td class="px-5 py-4">
                    <p class="font-semibold text-slate-900"><?= e($article['titre']) ?></p>
                    <p class="mt-1 text-xs text-slate-500">/<?= e($article['slug']) ?></p>
                  </td>
                  <td class="px-5 py-4">
                    <div class="flex flex-wrap gap-1.5">
                      <?php if (!empty($article['categories'])): ?>
                        <?php foreach ($article['categories'] as $cat): ?>
                          <span class="rounded-full border border-slate-200 bg-white px-2 py-1 text-xs font-medium text-slate-600"><?= e($cat['nom']) ?></span>
                        <?php endforeach; ?>
                      <?php elseif (!empty($article['categorie_nom'])): ?>
                        <span class="rounded-full border border-slate-200 bg-white px-2 py-1 text-xs font-medium text-slate-600"><?= e($article['categorie_nom']) ?></span>
                      <?php else: ?>
                        <span class="text-slate-400">-</span>
                      <?php endif; ?>
                    </div>
                  </td>
                  <td class="px-5 py-4">
                    <?php if ($article['statut'] === 'publie'): ?>
                      <span class="rounded-full bg-emerald-100 px-3 py-1 text-xs font-semibold text-emerald-700">Publie</span>
                    <?php elseif ($article['statut'] === 'brouillon'): ?>
                      <span class="rounded-full bg-amber-100 px-3 py-1 text-xs font-semibold text-amber-800">Brouillon</span>
                    <?php else: ?>
                      <span class="rounded-full bg-slate-200 px-3 py-1 text-xs font-semibold text-slate-700">Archive</span>
                    <?php endif; ?>
                  </td>
                  <td class="px-5 py-4 text-lg">
                    <?= $article['a_la_une'] ? '★' : '<span class="text-slate-300">☆</span>' ?>
                  </td>
                  <td class="px-5 py-4 font-semibold text-slate-700"><?= $article['vues'] ?></td>
                  <td class="px-5 py-4 text-right">
                    <div class="inline-flex items-center gap-2">
                      <a href="<?= url('article/' . e($article['slug'])) ?>" target="_blank" class="rounded-lg border border-slate-300 px-3 py-1.5 text-xs font-semibold text-slate-700 transition hover:bg-slate-100">Voir</a>
                      <a href="<?= url('admin/articles/' . $article['id'] . '/edit') ?>" class="rounded-lg border border-blue-200 bg-blue-50 px-3 py-1.5 text-xs font-semibold text-blue-700 transition hover:bg-blue-100">Modifier</a>
                      <form action="<?= url('admin/articles/' . $article['id'] . '/archive') ?>" method="post" class="inline" onsubmit="return confirm('Archiver cet article ?');">
                        <button type="submit" class="rounded-lg border border-amber-200 bg-amber-50 px-3 py-1.5 text-xs font-semibold text-amber-700 transition hover:bg-amber-100">Archiver</button>
                      </form>
                      <form action="<?= url('admin/articles/' . $article['id'] . '/delete') ?>" method="post" class="inline" onsubmit="return confirm('Supprimer cet article ?');">
                        <button type="submit" class="rounded-lg border border-rose-200 bg-rose-50 px-3 py-1.5 text-xs font-semibold text-rose-700 transition hover:bg-rose-100">Supprimer</button>
                      </form>
                    </div>
                  </td>
                </tr>
              <?php endforeach; ?>
              <?php if (empty($articles)): ?>
                <tr>
                  <td colspan="7" class="px-6 py-14 text-center text-sm text-slate-500">Aucun article disponible.</td>
                </tr>
              <?php endif; ?>
            </tbody>
          </table>
        </div>
      </section>

      <div class="mt-6">
        <a href="<?= url('admin') ?>" class="inline-flex items-center rounded-xl border border-slate-200 bg-white px-4 py-2 text-sm font-medium text-slate-700 transition hover:bg-slate-50">Retour au tableau de bord</a>
      </div>
    </main>
  </div>
</div>
</body>
</html>
