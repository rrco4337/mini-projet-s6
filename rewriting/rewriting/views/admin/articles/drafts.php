<?php
/**
 * Liste des brouillons (admin)
 */
?>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Brouillons - BackOffice</title>
  <meta name="description" content="Page backoffice de gestion des brouillons Iran War News." />
  <meta name="robots" content="noindex, nofollow" />
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
  <script src="https://cdn.tailwindcss.com"></script>
  <script>
    tailwind.config = { theme: { extend: { fontFamily: { sans: ['Plus Jakarta Sans', 'sans-serif'] }, boxShadow: { soft: '0 10px 30px rgba(15, 23, 42, 0.08)' } } } };
  </script>
</head>
<body class="min-h-screen bg-slate-50 font-sans text-slate-800">
<div class="flex min-h-screen">
  <?php include __DIR__ . '/../../includes/admin_sidebar.php'; ?>

  <div class="w-full xl:ml-72">
    <?php
    $adminHeaderMode = 'simple';
    $adminSearchPlaceholder = 'Rechercher dans les brouillons...';
    $adminHeaderButtons = [
      ['href' => url('admin/articles/archives'), 'label' => 'Archives', 'class' => 'rounded-xl border border-slate-200 bg-white px-4 py-2 text-sm font-medium text-slate-700 transition hover:bg-slate-50'],
      ['href' => url('admin/articles'), 'label' => 'Tous les articles', 'class' => 'rounded-xl border border-slate-200 bg-white px-4 py-2 text-sm font-medium text-slate-700 transition hover:bg-slate-50'],
      ['href' => url('logout'), 'label' => 'Deconnexion', 'class' => 'rounded-xl border border-slate-200 bg-white px-4 py-2 text-sm font-medium text-slate-700 transition hover:bg-slate-50'],
    ];
    include __DIR__ . '/../../includes/admin_header.php';
    ?>

    <main class="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8">
      <section class="mb-6 flex flex-wrap items-center justify-between gap-4">
        <div>
          <h1 class="text-3xl font-bold tracking-tight text-slate-900">Tous les brouillons</h1>
          <p class="mt-2 text-sm text-slate-600">Retrouvez uniquement les articles en cours de redaction.</p>
        </div>
        <a href="<?= url('admin/articles/new') ?>" class="inline-flex items-center gap-2 rounded-xl bg-slate-900 px-5 py-3 text-sm font-semibold text-white transition hover:bg-slate-700">Ajouter un article</a>
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
                  <td class="px-5 py-4 font-semibold text-slate-700"><?= $article['vues'] ?></td>
                  <td class="px-5 py-4 text-right">
                    <div class="inline-flex items-center gap-2">
                      <a href="<?= url('admin/articles/' . $article['id'] . '/edit') ?>" class="rounded-lg border border-blue-200 bg-blue-50 px-3 py-1.5 text-xs font-semibold text-blue-700 transition hover:bg-blue-100">Modifier</a>
                      <form action="<?= url('admin/articles/' . $article['id'] . '/archive') ?>" method="post" class="inline" onsubmit="return confirm('Archiver ce brouillon ?');">
                        <button type="submit" class="rounded-lg border border-amber-200 bg-amber-50 px-3 py-1.5 text-xs font-semibold text-amber-700 transition hover:bg-amber-100">Archiver</button>
                      </form>
                      <form action="<?= url('admin/articles/' . $article['id'] . '/delete') ?>" method="post" class="inline" onsubmit="return confirm('Supprimer ce brouillon ?');">
                        <button type="submit" class="rounded-lg border border-rose-200 bg-rose-50 px-3 py-1.5 text-xs font-semibold text-rose-700 transition hover:bg-rose-100">Supprimer</button>
                      </form>
                    </div>
                  </td>
                </tr>
              <?php endforeach; ?>
              <?php if (empty($articles)): ?>
                <tr>
                  <td colspan="5" class="px-6 py-14 text-center text-sm text-slate-500">Aucun brouillon disponible.</td>
                </tr>
              <?php endif; ?>
            </tbody>
          </table>
        </div>
      </section>
    </main>
  </div>
</div>
</body>
</html>
