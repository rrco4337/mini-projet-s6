<?php
/**
 * Tableau de bord admin
 */
?>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Tableau de bord - Iran War News</title>
  <meta name="description" content="Tableau de bord backoffice pour la gestion editoriale Iran War News." />
  <meta name="keywords" content="backoffice, dashboard admin, iran war news" />
  <meta name="robots" content="noindex, nofollow" />
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet" />
  <script src="https://cdn.tailwindcss.com"></script>
  <script>
    tailwind.config = {
      theme: {
        extend: {
          fontFamily: { sans: ['Plus Jakarta Sans', 'sans-serif'] },
          colors: { ink: '#111827', paper: '#f6f8fb', accent: '#2563eb' },
          boxShadow: { soft: '0 10px 30px rgba(15, 23, 42, 0.08)' }
        }
      }
    };
  </script>
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { display: flex; min-height: 100vh; background: radial-gradient(circle at 15% 20%, rgba(37, 99, 235, 0.08), transparent 38%), radial-gradient(circle at 85% 0%, rgba(30, 64, 175, 0.08), transparent 30%), #f6f8fb; }
    aside { position: fixed !important; top: 0 !important; left: 0 !important; width: 288px !important; height: 100vh !important; z-index: 50 !important; overflow-y: auto !important; border-right: 1px solid #e2e8f0 !important; background-color: rgba(255, 255, 255, 0.95) !important; padding: 28px 24px; }
    .main-wrapper { margin-left: 288px !important; width: calc(100% - 288px) !important; min-height: 100vh !important; display: flex; flex-direction: column; }
    .metric-fill { transition: width 1.2s ease; }
  </style>
</head>
<body class="min-h-screen font-sans text-slate-800">
<?php include __DIR__ . '/../includes/admin_sidebar.php'; ?>

<div class="main-wrapper">


    <main class="mx-auto w-full max-w-7xl flex-1 px-4 py-8 sm:px-6 lg:px-8">
      <section class="rounded-3xl border border-slate-200 bg-white p-6 shadow-soft">
        <p class="text-xs font-semibold uppercase tracking-[0.18em] text-blue-600">Tableau de bord editorial</p>
        <div class="mt-3 flex flex-wrap items-center justify-between gap-4">
          <div>
            <h1 class="text-3xl font-bold tracking-tight text-slate-900">Pilotez votre redaction</h1>
            <p class="mt-2 text-sm text-slate-600">Vision claire sur la publication, les performances et les actions rapides.</p>
          </div>
          <a href="<?= url('admin/articles/new') ?>" class="inline-flex items-center gap-2 rounded-xl bg-slate-900 px-5 py-3 text-sm font-semibold text-white transition hover:bg-slate-700">
            <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/></svg>
            Ajouter un article
          </a>
        </div>
      </section>

      <section class="mt-6 grid gap-5 sm:grid-cols-2 xl:grid-cols-4">
        <article class="rounded-2xl border border-slate-200 bg-white p-5 shadow-soft">
          <p class="text-xs font-semibold uppercase tracking-wide text-slate-500">Articles total</p>
          <p class="mt-3 text-3xl font-bold text-slate-900"><?= $totalArticles ?></p>
        </article>
        <article class="rounded-2xl border border-blue-100 bg-blue-50 p-5 shadow-soft">
          <p class="text-xs font-semibold uppercase tracking-wide text-blue-600">Publies</p>
          <p class="mt-3 text-3xl font-bold text-blue-900"><?= $publishedCount ?></p>
        </article>
        <article class="rounded-2xl border border-slate-200 bg-white p-5 shadow-soft">
          <p class="text-xs font-semibold uppercase tracking-wide text-slate-500">A la une</p>
          <p class="mt-3 text-3xl font-bold text-slate-900"><?= $featuredCount ?></p>
        </article>
        <article class="rounded-2xl border border-slate-200 bg-white p-5 shadow-soft">
          <p class="text-xs font-semibold uppercase tracking-wide text-slate-500">Vues</p>
          <p class="mt-3 text-3xl font-bold text-slate-900">
            <?php if ($totalViews >= 1000): ?>
              <?= number_format($totalViews / 1000, 1) ?>k
            <?php else: ?>
              <?= $totalViews ?>
            <?php endif; ?>
          </p>
        </article>
      </section>

      <section class="mt-6 grid gap-6 xl:grid-cols-3">
        <article class="rounded-2xl border border-slate-200 bg-white p-6 shadow-soft xl:col-span-2">
          <div class="flex items-center justify-between">
            <h2 class="text-lg font-semibold text-slate-900">Repartition des statuts</h2>
            <span class="rounded-full bg-slate-100 px-3 py-1 text-xs font-semibold text-slate-600">Live</span>
          </div>
          <div class="mt-6 h-72">
            <canvas id="statusChart"></canvas>
          </div>
          <div class="mt-6 space-y-4">
            <div>
              <div class="mb-2 flex items-center justify-between text-sm font-medium text-slate-600"><span>Publies</span><span><?= $publishedCount ?>/<?= $totalArticles ?></span></div>
              <div class="h-2 rounded-full bg-slate-200"><div class="metric-fill h-2 rounded-full bg-blue-600" data-width="<?= $totalArticles > 0 ? round($publishedCount * 100 / $totalArticles) : 0 ?>%"></div></div>
            </div>
            <div>
              <div class="mb-2 flex items-center justify-between text-sm font-medium text-slate-600"><span>Brouillons</span><span><?= $draftCount ?>/<?= $totalArticles ?></span></div>
              <div class="h-2 rounded-full bg-slate-200"><div class="metric-fill h-2 rounded-full bg-slate-500" data-width="<?= $totalArticles > 0 ? round($draftCount * 100 / $totalArticles) : 0 ?>%"></div></div>
            </div>
            <div>
              <div class="mb-2 flex items-center justify-between text-sm font-medium text-slate-600"><span>Archives</span><span><?= $archivedCount ?>/<?= $totalArticles ?></span></div>
              <div class="h-2 rounded-full bg-slate-200"><div class="metric-fill h-2 rounded-full bg-slate-300" data-width="<?= $totalArticles > 0 ? round($archivedCount * 100 / $totalArticles) : 0 ?>%"></div></div>
            </div>
          </div>
        </article>

        <article class="rounded-2xl border border-slate-200 bg-white p-6 shadow-soft">
          <h2 class="text-lg font-semibold text-slate-900">Activite recente</h2>
          <div class="mt-4 space-y-3">
            <?php if (!empty($recentArticles)): ?>
              <?php foreach ($recentArticles as $article): ?>
                <div class="rounded-xl border border-slate-200 bg-slate-50 p-3 transition hover:-translate-y-0.5 hover:border-blue-200 hover:bg-blue-50">
                  <div class="flex items-start justify-between gap-3">
                    <div>
                      <p class="line-clamp-2 text-sm font-semibold text-slate-800"><?= e($article['titre']) ?></p>
                      <p class="mt-1 text-xs text-slate-500"><?= e($article['created_at']) ?></p>
                    </div>
                    <span class="rounded-full px-2 py-1 text-[11px] font-semibold <?= $article['statut'] === 'publie' ? 'bg-emerald-100 text-emerald-700' : ($article['statut'] === 'brouillon' ? 'bg-amber-100 text-amber-800' : 'bg-slate-200 text-slate-700') ?>"><?= e($article['statut']) ?></span>
                  </div>
                </div>
              <?php endforeach; ?>
            <?php else: ?>
              <p class="rounded-xl border border-dashed border-slate-300 bg-slate-50 px-4 py-6 text-center text-sm text-slate-500">Aucun article recent.</p>
            <?php endif; ?>
          </div>
        </article>
      </section>

      <?php if (!empty($mostViewedArticle) && $mostViewedArticle['vues'] > 0): ?>
        <section class="mt-6 rounded-2xl border border-slate-200 bg-white p-6 shadow-soft">
          <div class="flex flex-wrap items-center justify-between gap-4">
            <div>
              <p class="text-xs font-semibold uppercase tracking-[0.16em] text-slate-500">Article le plus populaire</p>
              <a href="<?= url('article/' . e($mostViewedArticle['slug'])) ?>" target="_blank" class="mt-2 block text-xl font-semibold text-slate-900 transition hover:text-blue-700">
                <?= e($mostViewedArticle['titre']) ?>
              </a>
              <p class="mt-2 max-w-3xl text-sm text-slate-600"><?= e($mostViewedArticle['chapeau'] ?? '') ?></p>
            </div>
            <div class="rounded-2xl bg-blue-50 px-6 py-4 text-center">
              <p class="text-xs font-semibold uppercase tracking-wide text-blue-600">Vues</p>
              <p class="mt-1 text-3xl font-bold text-blue-900"><?= $mostViewedArticle['vues'] ?></p>
            </div>
          </div>
        </section>
      <?php endif; ?>

      <section class="mt-6 grid gap-4 md:grid-cols-2 xl:grid-cols-4">
        <a href="<?= url('admin/articles/new') ?>" class="rounded-2xl border border-slate-200 bg-white p-5 shadow-soft transition hover:-translate-y-1 hover:border-blue-200 hover:bg-blue-50">
          <p class="text-sm font-semibold text-slate-900">Nouvel article</p>
          <p class="mt-1 text-sm text-slate-600">Demarrer une publication</p>
        </a>
        <a href="<?= url('admin/articles') ?>" class="rounded-2xl border border-slate-200 bg-white p-5 shadow-soft transition hover:-translate-y-1 hover:border-blue-200 hover:bg-blue-50">
          <p class="text-sm font-semibold text-slate-900">Gerer les articles</p>
          <p class="mt-1 text-sm text-slate-600">Modifier ou supprimer</p>
        </a>
        <a href="<?= url('categories/new') ?>" class="rounded-2xl border border-slate-200 bg-white p-5 shadow-soft transition hover:-translate-y-1 hover:border-blue-200 hover:bg-blue-50">
          <p class="text-sm font-semibold text-slate-900">Nouvelle categorie</p>
          <p class="mt-1 text-sm text-slate-600">Structurer la ligne editoriale</p>
        </a>
        <a href="<?= url('categories') ?>" class="rounded-2xl border border-slate-200 bg-white p-5 shadow-soft transition hover:-translate-y-1 hover:border-blue-200 hover:bg-blue-50">
          <p class="text-sm font-semibold text-slate-900">Categories (<?= $totalCategories ?>)</p>
          <p class="mt-1 text-sm text-slate-600">Organiser les thematiques</p>
        </a>
      </section>
    </main>
  </div>

<script>
  const ctx = document.getElementById('statusChart').getContext('2d');
  const chartStatusData = <?= $statusData ?>;

  new Chart(ctx, {
    type: 'doughnut',
    data: {
      labels: ['Publies', 'Brouillons', 'Archives'],
      datasets: [{
        data: chartStatusData,
        backgroundColor: ['#2563eb', '#64748b', '#cbd5e1'],
        borderColor: '#ffffff',
        borderWidth: 4
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      cutout: '68%',
      plugins: {
        legend: {
          position: 'bottom',
          labels: { usePointStyle: true, padding: 18, color: '#334155', font: { family: 'Plus Jakarta Sans', size: 12, weight: '600' } }
        }
      }
    }
  });

  setTimeout(() => {
    document.querySelectorAll('.metric-fill').forEach((item) => {
      const finalWidth = item.getAttribute('data-width') || '0%';
      item.style.width = '0%';
      requestAnimationFrame(() => { item.style.width = finalWidth; });
    });
  }, 350);
</script>
</body>
</html>
