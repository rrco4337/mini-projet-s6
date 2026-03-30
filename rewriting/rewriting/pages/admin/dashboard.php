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
    <div class="flex justify-between items-center mb-8">
        <h1 class="text-3xl font-bold text-gray-900">Tableau de Bord</h1>
        <a href="/admin/article/new" class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition font-semibold">
            ✏️ Nouvel Article
        </a>
    </div>

    <!-- Statistiques -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
        <div class="bg-white p-6 rounded-lg border border-slate-200 shadow-sm">
            <p class="text-slate-600 text-sm font-semibold uppercase">Articles Publiés</p>
            <p class="text-4xl font-bold text-blue-600 mt-2"><?php echo $nbArticles; ?></p>
        </div>
        <div class="bg-white p-6 rounded-lg border border-slate-200 shadow-sm">
            <p class="text-slate-600 text-sm font-semibold uppercase">Brouillons</p>
            <p class="text-4xl font-bold text-amber-600 mt-2"><?php echo $nbDrafts; ?></p>
        </div>
        <div class="bg-white p-6 rounded-lg border border-slate-200 shadow-sm">
            <p class="text-slate-600 text-sm font-semibold uppercase">Catégories</p>
            <p class="text-4xl font-bold text-teal-600 mt-2"><?php echo $nbCategories; ?></p>
        </div>
    </div>

    <!-- Derniers articles -->
    <div class="bg-white rounded-lg border border-slate-200 shadow-sm">
        <div class="p-6 border-b border-slate-200">
            <h2 class="text-lg font-bold text-gray-900">Derniers Articles</h2>
        </div>
        <div class="overflow-x-auto">
            <table class="w-full">
                <thead>
                    <tr class="border-b border-slate-200 bg-slate-50">
                        <th class="px-6 py-3 text-left text-xs font-semibold text-slate-600 uppercase">Titre</th>
                        <th class="px-6 py-3 text-left text-xs font-semibold text-slate-600 uppercase">Catégorie</th>
                        <th class="px-6 py-3 text-left text-xs font-semibold text-slate-600 uppercase">Statut</th>
                        <th class="px-6 py-3 text-left text-xs font-semibold text-slate-600 uppercase">Date</th>
                        <th class="px-6 py-3 text-center text-xs font-semibold text-slate-600 uppercase">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach ($articles as $a): ?>
                    <tr class="border-b border-slate-200 hover:bg-slate-50">
                        <td class="px-6 py-4 font-semibold text-gray-900"><?php echo e($a['titre']); ?></td>
                        <td class="px-6 py-4 text-slate-600"><?php echo e($a['categorie_nom']); ?></td>
                        <td class="px-6 py-4">
                            <span class="px-3 py-1 rounded-full text-xs font-semibold <?php echo $a['statut'] == 'publie' ? 'bg-green-100 text-green-800' : 'bg-amber-100 text-amber-800'; ?>">
                                <?php echo ucfirst($a['statut']); ?>
                            </span>
                        </td>
                        <td class="px-6 py-4 text-slate-600"><?php echo formatDate($a['date_publication']); ?></td>
                        <td class="px-6 py-4 text-center">
                            <a href="/admin/article/<?php echo $a['id']; ?>/edit" class="text-blue-600 hover:text-blue-800 font-semibold">Éditer</a>
                        </td>
                    </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
        </div>
    </div>
</div>

<?php include BASE_PATH . '/includes/admin-footer.php'; ?>
