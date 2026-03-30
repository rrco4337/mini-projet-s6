<?php
require '../config.php';
require '../includes/db.php';
require '../includes/functions.php';

// Vérifier que l'utilisateur est admin
if (!isAdmin()) {
    redirect('/login.php');
}

$pageTitle = 'Admin - Article';
$article = null;
$categories = fetchAll('SELECT id, nom FROM categories ORDER BY nom');

// Récupérer l'article si en édition
if (isset($_GET['id'])) {
    $article = fetchOne('SELECT * FROM articles WHERE id = ?', [$_GET['id']]);
    if (!$article) {
        setFlash('error', 'Article non trouvé');
        redirect('/admin/articles.php');
    }
}

// Traiter le formulaire
if ($_POST && isset($_POST['titre'])) {
    $titre = $_POST['titre'];
    $chapeau = $_POST['chapeau'];
    $contenu = $_POST['contenu'];
    $categorie_id = $_POST['categorie_id'] ?: null;
    $statut = $_POST['statut'] ?? 'brouillon';
    $slug = slugify($titre);
    
    // Vérifier l'unicité du slug
    if ($article) {
        // Édition
        query(
            'UPDATE articles SET titre = ?, slug = ?, chapeau = ?, contenu = ?, categorie_id = ?, statut = ?, updated_at = NOW() WHERE id = ?',
            [$titre, $slug, $chapeau, $contenu, $categorie_id, $statut, $article['id']]
        );
        setFlash('success', 'Article mis à jour');
    } else {
        // Création
        query(
            'INSERT INTO articles (titre, slug, chapeau, contenu, categorie_id, statut, date_publication) VALUES (?, ?, ?, ?, ?, ?, NOW())',
            [$titre, $slug, $chapeau, $contenu, $categorie_id, $statut]
        );
        setFlash('success', 'Article créé');
    }
    
    redirect('/admin/articles.php');
}
?>

<?php include '../includes/admin-header.php'; ?>

<div class="max-w-4xl">
    <h1 class="text-3xl font-bold text-gray-900 mb-8"><?php echo $article ? 'Éditer l\'article' : 'Créer un article'; ?></h1>

    <form method="POST" class="bg-white p-8 rounded-lg border border-slate-200 space-y-6">
        <div>
            <label class="block text-sm font-semibold text-gray-900 mb-2">Titre</label>
            <input 
                type="text" 
                name="titre" 
                placeholder="Titre de l'article" 
                value="<?php echo e($article['titre'] ?? ''); ?>" 
                class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                required
            >
        </div>
        
        <div>
            <label class="block text-sm font-semibold text-gray-900 mb-2">Résumé (Chapeau)</label>
            <input 
                type="text" 
                name="chapeau" 
                placeholder="Résumé court de l'article" 
                value="<?php echo e($article['chapeau'] ?? ''); ?>"
                class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
            >
        </div>
        
        <div>
            <label class="block text-sm font-semibold text-gray-900 mb-2">Catégorie</label>
            <select name="categorie_id" class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                <option value="">-- Sélectionner une catégorie --</option>
                <?php foreach ($categories as $cat): ?>
                <option value="<?php echo $cat['id']; ?>" <?php echo ($article['categorie_id'] ?? null) == $cat['id'] ? 'selected' : ''; ?>>
                    <?php echo e($cat['nom']); ?>
                </option>
                <?php endforeach; ?>
            </select>
        </div>
        
        <div>
            <label class="block text-sm font-semibold text-gray-900 mb-2">Contenu (HTML accepté)</label>
            <textarea 
                name="contenu" 
                placeholder="Contenu de l'article..." 
                rows="15"
                class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 font-mono text-sm"
                required
            ><?php echo e($article['contenu'] ?? ''); ?></textarea>
        </div>
        
        <div>
            <label class="block text-sm font-semibold text-gray-900 mb-2">Statut</label>
            <select name="statut" class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                <option value="brouillon" <?php echo ($article['statut'] ?? 'brouillon') == 'brouillon' ? 'selected' : ''; ?>>Brouillon</option>
                <option value="publie" <?php echo ($article['statut'] ?? '') == 'publie' ? 'selected' : ''; ?>>Publié</option>
                <option value="archive" <?php echo ($article['statut'] ?? '') == 'archive' ? 'selected' : ''; ?>>Archivé</option>
            </select>
        </div>
        
        <div class="flex gap-4 pt-4">
            <button type="submit" class="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition font-semibold">
                💾 Enregistrer
            </button>
            <a href="/admin/articles.php" class="px-6 py-2 bg-slate-200 text-slate-700 rounded-lg hover:bg-slate-300 transition font-semibold">
                Annuler
            </a>
        </div>
    </form>
</div>

<?php include '../includes/admin-footer.php'; ?>
