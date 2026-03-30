<?php
require '../../config.php';
require '../../includes/db.php';
require '../../includes/functions.php';

if (!isAdmin()) redirect('/login');

$pageTitle = 'Gérer les Articles';

if ($_POST && isset($_POST['action'])) {
    $action = $_POST['action'];
    $articleId = $_POST['article_id'] ?? null;
    
    if ($action === 'delete' && $articleId) {
        query('DELETE FROM articles WHERE id = ?', [$articleId]);
        setFlash('success', 'Article supprimé');
        redirect('/admin/articles');
    }
}

$filter = $_GET['filter'] ?? 'publie';
if ($filter === 'all') {
    $articles = fetchAll('SELECT a.*, c.nom as categorie_nom FROM articles a LEFT JOIN categories c ON a.categorie_id = c.id ORDER BY a.date_publication DESC');
} else {
    $articles = fetchAll('SELECT a.*, c.nom as categorie_nom FROM articles a LEFT JOIN categories c ON a.categorie_id = c.id WHERE a.statut = ? ORDER BY a.date_publication DESC', [$filter]);
}
?>

<?php include BASE_PATH . '/includes/admin-header.php'; ?>

<div class="max-w-7xl">
    <div class="flex justify-between items-center mb-8">
        <h1 class="text-3xl font-bold text-gray-900">Gérer les Articles</h1>
        <a href="/admin/article/new" class="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition font-semibold">
            + Nouvel Article
        </a>
    </div>

    <!-- Filtres -->
    <div class="flex gap-4 mb-6">
        <a href="/admin/articles?filter=publie" class="px-4 py-2 rounded-lg font-semibold <?php echo $filter === 'publie' ? 'bg-blue-600 text-white' : 'bg-white text-slate-700 border border-slate-200'; ?>">Publiés</a>
        <a href="/admin/articles?filter=brouillon" class="px-4 py-2 rounded-lg font-semibold <?php echo $filter === 'brouillon' ? 'bg-blue-600 text-white' : 'bg-white text-slate-700 border border-slate-200'; ?>">Brouillons</a>
        <a href="/admin/articles?filter=all" class="px-4 py-2 rounded-lg font-semibold <?php echo $filter === 'all' ? 'bg-blue-600 text-white' : 'bg-white text-slate-700 border border-slate-200'; ?>">Tous</a>
    </div>

    <!-- Tableau -->
    <div class="bg-white rounded-lg border border-slate-200 shadow-sm overflow-x-auto">
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
                        <a href="/admin/article/<?php echo $a['id']; ?>/edit" class="text-blue-600 hover:text-blue-800 font-semibold mr-4">✏️</a>
                        <form method="POST" class="inline-block">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="article_id" value="<?php echo $a['id']; ?>">
                            <button type="submit" class="text-red-600 hover:text-red-800 font-semibold" onclick="return confirm('Confirmer la suppression?')">🗑️</button>
                        </form>
                    </td>
                </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
        <?php if (empty($articles)): ?>
        <div class="p-8 text-center text-slate-500">Aucun article.</div>
        <?php endif; ?>
    </div>
</div>

<?php include BASE_PATH . '/includes/admin-footer.php'; ?>
