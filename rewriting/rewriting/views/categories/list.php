<?php
/**
 * Liste des categories
 */
?>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Categories - BackOffice</title>
  <meta name="description" content="Page backoffice de gestion des categories Iran War News." />
  <meta name="keywords" content="categories, administration, iran war news" />
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
  <?php include __DIR__ . '/../includes/admin_sidebar.php'; ?>

  <div class="w-full xl:ml-72">
    <?php
    $adminHeaderMode = 'simple';
    $adminSearchPlaceholder = 'Rechercher une categorie...';
    $adminHeaderButtons = [
      ['href' => url('logout'), 'label' => 'Deconnexion', 'class' => 'rounded-xl border border-slate-200 bg-white px-4 py-2 text-sm font-medium text-slate-700 transition hover:bg-slate-50'],
    ];
    include __DIR__ . '/../includes/admin_header.php';
    ?>

    <main class="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8">
      <section class="mb-6 flex flex-wrap items-center justify-between gap-4">
        <div>
          <h1 class="text-3xl font-bold tracking-tight text-slate-900">Gestion des categories</h1>
          <p class="mt-2 text-sm text-slate-600">Organisez vos contenus en thematiques editoriales claires.</p>
        </div>
        <a href="<?= url('categories/new') ?>" class="rounded-xl bg-slate-900 px-5 py-3 text-sm font-semibold text-white transition hover:bg-slate-700">Nouvelle categorie</a>
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
            <thead class="bg-slate-100 text-left text-xs font-semibold uppercase tracking-wide text-slate-600">
              <tr>
                <th class="px-5 py-4">ID</th>
                <th class="px-5 py-4">Nom</th>
                <th class="px-5 py-4">Slug</th>
                <th class="px-5 py-4">Description</th>
                <th class="px-5 py-4 text-right">Actions</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-slate-200">
              <?php foreach ($categories as $index => $cat): ?>
                <tr class="<?= $index % 2 == 0 ? 'bg-white' : 'bg-slate-50' ?> transition hover:bg-blue-50/60">
                  <td class="px-5 py-4 font-semibold text-slate-700"><?= $cat['id'] ?></td>
                  <td class="px-5 py-4 font-semibold text-slate-900"><?= e($cat['nom']) ?></td>
                  <td class="px-5 py-4 text-slate-600"><?= e($cat['slug']) ?></td>
                  <td class="px-5 py-4 text-slate-600"><?= e($cat['description'] ?? '') ?></td>
                  <td class="px-5 py-4 text-right">
                    <div class="inline-flex items-center gap-2">
                      <a href="<?= url('categories/' . $cat['id'] . '/edit') ?>" class="rounded-lg border border-blue-200 bg-blue-50 px-3 py-1.5 text-xs font-semibold text-blue-700 transition hover:bg-blue-100">Modifier</a>
                      <form action="<?= url('categories/' . $cat['id'] . '/delete') ?>" method="post" class="inline" onsubmit="return confirm('Supprimer cette categorie ?');">
                        <button type="submit" class="rounded-lg border border-rose-200 bg-rose-50 px-3 py-1.5 text-xs font-semibold text-rose-700 transition hover:bg-rose-100">Supprimer</button>
                      </form>
                    </div>
                  </td>
                </tr>
              <?php endforeach; ?>
              <?php if (empty($categories)): ?>
                <tr>
                  <td colspan="5" class="px-6 py-14 text-center text-sm text-slate-500">Aucune categorie disponible.</td>
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
