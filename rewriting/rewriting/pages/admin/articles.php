<?php
require_once __DIR__ . '/../../config.php';
require_once __DIR__ . '/../../includes/db.php';
require_once __DIR__ . '/../../includes/functions.php';

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
    <div class="mb-8 flex flex-wrap items-center justify-between gap-4">
        <div>
            <h1 class="text-3xl font-bold tracking-tight text-slate-900">Gestion des articles</h1>
            <p class="mt-2 text-sm text-slate-600">Consultez, filtrez et mettez a jour vos contenus editoriaux.</p>
        </div>
        <a href="/admin/article/new" class="inline-flex items-center gap-2 rounded-xl bg-slate-900 px-5 py-3 text-sm font-semibold text-white transition hover:bg-slate-700">
            <svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/></svg>
            Nouvel article
        </a>
    </div>

    <div class="mb-6 flex flex-wrap gap-2">
        <a href="/admin/articles?filter=publie" class="rounded-xl px-4 py-2 text-sm font-semibold <?php echo $filter === 'publie' ? 'bg-blue-600 text-white' : 'border border-slate-200 bg-white text-slate-700 hover:bg-slate-50'; ?>">Publies</a>
        <a href="/admin/articles?filter=brouillon" class="rounded-xl px-4 py-2 text-sm font-semibold <?php echo $filter === 'brouillon' ? 'bg-blue-600 text-white' : 'border border-slate-200 bg-white text-slate-700 hover:bg-slate-50'; ?>">Brouillons</a>
        <a href="/admin/articles?filter=all" class="rounded-xl px-4 py-2 text-sm font-semibold <?php echo $filter === 'all' ? 'bg-blue-600 text-white' : 'border border-slate-200 bg-white text-slate-700 hover:bg-slate-50'; ?>">Tous</a>
    </div>

    <div class="overflow-x-auto rounded-2xl border border-slate-200 bg-white shadow-[0_10px_25px_rgba(15,23,42,0.05)]">
        <table class="w-full">
            <thead>
                <tr class="bg-slate-50 text-left text-xs font-semibold uppercase tracking-wide text-slate-600">
                    <th class="px-6 py-4">Titre</th>
                    <th class="px-6 py-4">Categorie</th>
                    <th class="px-6 py-4">Statut</th>
                    <th class="px-6 py-4">Date</th>
                    <th class="px-6 py-4 text-center">Actions</th>
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
                        <a href="/admin/article/<?php echo $a['id']; ?>/edit" class="mr-2 inline-flex rounded-lg border border-blue-200 bg-blue-50 px-3 py-1.5 text-xs font-semibold text-blue-700 hover:bg-blue-100">Modifier</a>
                        <form method="POST" class="inline-block">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="article_id" value="<?php echo $a['id']; ?>">
                            <button type="submit" class="inline-flex rounded-lg border border-red-200 bg-red-50 px-3 py-1.5 text-xs font-semibold text-red-700 hover:bg-red-100" onclick="return confirm('Confirmer la suppression ?')">Supprimer</button>
                        </form>
                    </td>
                </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
        <?php if (empty($articles)): ?>
        <div class="p-10 text-center text-sm text-slate-500">Aucun article.</div>
        <?php endif; ?>
    </div>
</div>

<?php include BASE_PATH . '/includes/admin-footer.php'; ?>
