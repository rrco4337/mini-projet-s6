<?php
require_once __DIR__ . '/../../config.php';
require_once __DIR__ . '/../../includes/db.php';
require_once __DIR__ . '/../../includes/functions.php';

// Vérifier que l'utilisateur est admin
if (!isAdmin()) {
    redirect('/login');
}

$pageTitle = 'Dashboard - Iran War News';

// Récupérer les statistiques
$nbArticles = fetchColumn('SELECT COUNT(*) FROM articles WHERE statut = ?', ['publie']);
$nbDrafts = fetchColumn('SELECT COUNT(*) FROM articles WHERE statut = ?', ['brouillon']);
$nbCategories = fetchColumn('SELECT COUNT(*) FROM categories');

// Récupérer les derniers articles
$articles = fetchAll(
    'SELECT a.id, a.titre, a.slug, a.statut, a.date_publication, c.nom as categorie_nom
     FROM articles a
     LEFT JOIN categories c ON a.categorie_id = c.id
     ORDER BY a.date_publication DESC
     LIMIT 10'
);
?>

<?php include BASE_PATH . '/includes/admin-header.php'; ?>

<div class="max-w-7xl">
    <div class="mb-8 flex flex-wrap items-center justify-between gap-4">
        <div>
            <h1 class="text-3xl font-bold tracking-tight text-slate-900">Tableau de bord editorial</h1>
            <p class="mt-2 text-sm text-slate-600">Suivez les performances et pilotez vos contenus en un coup d'oeil.</p>
        </div>
        <a href="/admin/article/new" class="inline-flex items-center gap-2 rounded-xl bg-slate-900 px-5 py-3 text-sm font-semibold text-white transition hover:bg-slate-700">
            <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/></svg>
            Nouvel article
        </a>
    </div>

    <div class="mb-8 grid grid-cols-1 gap-5 md:grid-cols-3">
        <div class="rounded-2xl border border-slate-200 bg-white p-6 shadow-[0_10px_25px_rgba(15,23,42,0.05)]">
            <p class="text-xs font-semibold uppercase tracking-wide text-slate-500">Articles publies</p>
            <p class="mt-2 text-4xl font-bold text-slate-900"><?php echo $nbArticles; ?></p>
        </div>
        <div class="rounded-2xl border border-slate-200 bg-white p-6 shadow-[0_10px_25px_rgba(15,23,42,0.05)]">
            <p class="text-xs font-semibold uppercase tracking-wide text-slate-500">Brouillons</p>
            <p class="mt-2 text-4xl font-bold text-amber-600"><?php echo $nbDrafts; ?></p>
        </div>
        <div class="rounded-2xl border border-slate-200 bg-white p-6 shadow-[0_10px_25px_rgba(15,23,42,0.05)]">
            <p class="text-xs font-semibold uppercase tracking-wide text-slate-500">Categories</p>
            <p class="mt-2 text-4xl font-bold text-blue-600"><?php echo $nbCategories; ?></p>
        </div>
    </div>

    <div class="overflow-hidden rounded-2xl border border-slate-200 bg-white shadow-[0_10px_25px_rgba(15,23,42,0.05)]">
        <div class="flex items-center justify-between border-b border-slate-200 px-6 py-5">
            <h2 class="text-lg font-semibold text-slate-900">Derniers articles</h2>
            <a href="/admin/articles" class="text-sm font-semibold text-blue-600 hover:text-blue-700">Voir tout</a>
        </div>
        <div class="overflow-x-auto">
            <table class="w-full">
                <thead>
                    <tr class="bg-slate-50 text-left text-xs font-semibold uppercase tracking-wide text-slate-600">
                        <th class="px-6 py-3 text-left text-xs font-semibold text-slate-600 uppercase">Titre</th>
                        <th class="px-6 py-3 text-left text-xs font-semibold text-slate-600 uppercase">Catégorie</th>
                        <th class="px-6 py-3 text-left text-xs font-semibold text-slate-600 uppercase">Statut</th>
                        <th class="px-6 py-3 text-left text-xs font-semibold text-slate-600 uppercase">Date</th>
                        <th class="px-6 py-3 text-center text-xs font-semibold text-slate-600 uppercase">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach ($articles as $idx => $a): ?>
                    <tr class="border-t border-slate-200 <?php echo $idx % 2 === 0 ? 'bg-white' : 'bg-slate-50/50'; ?> hover:bg-blue-50/40">
                        <td class="px-6 py-4 font-semibold text-gray-900"><?php echo e($a['titre']); ?></td>
                        <td class="px-6 py-4 text-slate-600"><?php echo e($a['categorie_nom'] ?? '-'); ?></td>
                        <td class="px-6 py-4">
                            <span class="px-3 py-1 rounded-full text-xs font-semibold <?php echo $a['statut'] == 'publie' ? 'bg-green-100 text-green-800' : 'bg-amber-100 text-amber-800'; ?>">
                                <?php echo ucfirst($a['statut']); ?>
                            </span>
                        </td>
                        <td class="px-6 py-4 text-slate-600"><?php echo formatDate($a['date_publication']); ?></td>
                        <td class="px-6 py-4 text-center">
                            <a href="/admin/article/<?php echo $a['id']; ?>/edit" class="inline-flex rounded-lg border border-blue-200 bg-blue-50 px-3 py-1.5 text-xs font-semibold text-blue-700 hover:bg-blue-100">Modifier</a>
                        </td>
                    </tr>
                    <?php endforeach; ?>
                    <?php if (empty($articles)): ?>
                    <tr>
                        <td colspan="5" class="px-6 py-12 text-center text-sm text-slate-500">Aucun article recent.</td>
                    </tr>
                    <?php endif; ?>
                </tbody>
            </table>
        </div>
    </div>
</div>

<?php include BASE_PATH . '/includes/admin-footer.php'; ?>
