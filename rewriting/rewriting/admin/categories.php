<?php
require '../config.php';
require '../includes/db.php';
require '../includes/functions.php';

// Vérifier que l'utilisateur est admin
if (!isAdmin()) {
    redirect('/login.php');
}

$pageTitle = 'Gérer les Catégories';

// Traiter le formulaire
if ($_POST && isset($_POST['action'])) {
    $action = $_POST['action'];
    
    if ($action === 'create' && isset($_POST['nom'])) {
        $nom = $_POST['nom'];
        $slug = slugify($nom);
        
        query(
            'INSERT INTO categories (nom, slug) VALUES (?, ?)',
            [$nom, $slug]
        );
        setFlash('success', 'Catégorie créée');
        redirect('/admin/categories.php');
        
    } elseif ($action === 'delete' && isset($_POST['id'])) {
        query('DELETE FROM categories WHERE id = ?', [$_POST['id']]);
        setFlash('success', 'Catégorie supprimée');
        redirect('/admin/categories.php');
    }
}

// Récupérer les catégories
$categories = fetchAll('SELECT * FROM categories ORDER BY nom');
?>

<?php include '../includes/admin-header.php'; ?>

<div class="max-w-4xl">
    <h1 class="text-3xl font-bold text-gray-900 mb-8">Gérer les Catégories</h1>

    <!-- Formulaire de création -->
    <div class="bg-white p-8 rounded-lg border border-slate-200 mb-8">
        <h2 class="text-xl font-bold text-gray-900 mb-6">Créer une nouvelle catégorie</h2>
        
        <form method="POST" class="flex gap-4">
            <input 
                type="text" 
                name="nom" 
                placeholder="Nom de la catégorie" 
                class="flex-1 px-4 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                required
            >
            <input type="hidden" name="action" value="create">
            <button type="submit" class="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition font-semibold">
                + Créer
            </button>
        </form>
    </div>

    <!-- Liste des catégories -->
    <div class="bg-white rounded-lg border border-slate-200 overflow-x-auto">
        <div class="p-6 border-b border-slate-200">
            <h2 class="text-lg font-bold text-gray-900">Catégories existantes</h2>
        </div>
        
        <table class="w-full">
            <thead>
                <tr class="border-b border-slate-200 bg-slate-50">
                    <th class="px-6 py-3 text-left text-xs font-semibold text-slate-600 uppercase">Nom</th>
                    <th class="px-6 py-3 text-left text-xs font-semibold text-slate-600 uppercase">Slug</th>
                    <th class="px-6 py-3 text-center text-xs font-semibold text-slate-600 uppercase">Articles</th>
                    <th class="px-6 py-3 text-center text-xs font-semibold text-slate-600 uppercase">Actions</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($categories as $cat): 
                    $nbArticles = fetchColumn('SELECT COUNT(*) FROM articles WHERE categorie_id = ?', [$cat['id']]);
                ?>
                <tr class="border-b border-slate-200 hover:bg-slate-50">
                    <td class="px-6 py-4 font-semibold text-gray-900"><?php echo e($cat['nom']); ?></td>
                    <td class="px-6 py-4 text-slate-600 font-mono text-sm"><?php echo e($cat['slug']); ?></td>
                    <td class="px-6 py-4 text-center text-slate-600"><?php echo $nbArticles; ?></td>
                    <td class="px-6 py-4 text-center">
                        <form method="POST" class="inline-block">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id" value="<?php echo $cat['id']; ?>">
                            <button 
                                type="submit" 
                                class="text-red-600 hover:text-red-800 font-semibold"
                                onclick="return confirm('Confirmer la suppression? (' + <?php echo $nbArticles; ?> + ' articles associés)')">
                                🗑️ Supprimer
                            </button>
                        </form>
                    </td>
                </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
        
        <?php if (empty($categories)): ?>
        <div class="p-8 text-center text-slate-500">Aucune catégorie.</div>
        <?php endif; ?>
    </div>
</div>

<?php include '../includes/admin-footer.php'; ?>
