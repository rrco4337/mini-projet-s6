<?php
require_once __DIR__ . '/../../config.php';
require_once __DIR__ . '/../../includes/db.php';
require_once __DIR__ . '/../../includes/functions.php';

if (!isAdmin()) redirect('/login');

$pageTitle = 'Gérer les Catégories';

if ($_POST && isset($_POST['action'])) {
    if ($_POST['action'] === 'create' && isset($_POST['nom'])) {
        $nom = $_POST['nom'];
        $slug = slugify($nom);
        query('INSERT INTO categories (nom, slug) VALUES (?, ?)', [$nom, $slug]);
        setFlash('success', 'Catégorie créée');
        redirect('/admin/categories');
    } elseif ($_POST['action'] === 'delete' && isset($_POST['id'])) {
        query('DELETE FROM categories WHERE id = ?', [$_POST['id']]);
        setFlash('success', 'Catégorie supprimée');
        redirect('/admin/categories');
    }
}

$categories = fetchAll('SELECT * FROM categories ORDER BY nom');
?>

<?php include BASE_PATH . '/includes/admin-header.php'; ?>

<div class="max-w-4xl">
    <div class="mb-8">
        <h1 class="text-3xl font-bold tracking-tight text-slate-900">Gestion des categories</h1>
        <p class="mt-2 text-sm text-slate-600">Structurez votre ligne editoriale avec des categories claires.</p>
    </div>

    <div class="mb-8 rounded-2xl border border-slate-200 bg-white p-8 shadow-[0_10px_25px_rgba(15,23,42,0.05)]">
        <h2 class="mb-6 text-xl font-semibold text-slate-900">Creer une nouvelle categorie</h2>
        
        <form method="POST" class="flex flex-col gap-4 sm:flex-row">
            <input type="text" name="nom" placeholder="Nom de la categorie" class="h-11 flex-1 rounded-xl border border-slate-300 px-4 text-sm outline-none transition focus:border-blue-300 focus:ring-2 focus:ring-blue-100" required>
            <input type="hidden" name="action" value="create">
            <button type="submit" class="inline-flex items-center justify-center rounded-xl bg-slate-900 px-6 py-3 text-sm font-semibold text-white transition hover:bg-slate-700">Ajouter</button>
        </form>
    </div>

    <div class="overflow-x-auto rounded-2xl border border-slate-200 bg-white shadow-[0_10px_25px_rgba(15,23,42,0.05)]">
        <div class="border-b border-slate-200 px-6 py-5">
            <h2 class="text-lg font-semibold text-slate-900">Categories existantes</h2>
        </div>
        
        <table class="w-full">
            <thead>
                <tr class="bg-slate-50 text-left text-xs font-semibold uppercase tracking-wide text-slate-600">
                    <th class="px-6 py-4">Nom</th>
                    <th class="px-6 py-4">Slug</th>
                    <th class="px-6 py-4 text-center">Articles</th>
                    <th class="px-6 py-4 text-center">Actions</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($categories as $idx => $cat): 
                    $nbArticles = fetchColumn('SELECT COUNT(*) FROM articles WHERE categorie_id = ?', [$cat['id']]);
                ?>
                <tr class="border-t border-slate-200 <?php echo $idx % 2 === 0 ? 'bg-white' : 'bg-slate-50/50'; ?> hover:bg-blue-50/40">
                    <td class="px-6 py-4 font-semibold text-gray-900"><?php echo e($cat['nom']); ?></td>
                    <td class="px-6 py-4 text-slate-600 font-mono text-sm"><?php echo e($cat['slug']); ?></td>
                    <td class="px-6 py-4 text-center text-slate-600"><?php echo $nbArticles; ?></td>
                    <td class="px-6 py-4 text-center">
                        <form method="POST" class="inline-block">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id" value="<?php echo $cat['id']; ?>">
                            <button type="submit" class="inline-flex rounded-lg border border-red-200 bg-red-50 px-3 py-1.5 text-xs font-semibold text-red-700 hover:bg-red-100" onclick="return confirm('Confirmer la suppression ?')">Supprimer</button>
                        </form>
                    </td>
                </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
        
        <?php if (empty($categories)): ?>
        <div class="p-10 text-center text-sm text-slate-500">Aucune categorie.</div>
        <?php endif; ?>
    </div>
</div>

<?php include BASE_PATH . '/includes/admin-footer.php'; ?>
