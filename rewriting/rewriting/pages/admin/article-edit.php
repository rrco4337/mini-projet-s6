<?php
require_once __DIR__ . '/../../config.php';
require_once __DIR__ . '/../../includes/db.php';
require_once __DIR__ . '/../../includes/functions.php';

if (!isAdmin()) redirect('/login');

function legacyTableExists(string $tableName): bool {
    try {
        return (bool) fetchColumn("SELECT to_regclass('public." . $tableName . "') IS NOT NULL");
    } catch (Exception $e) {
        return false;
    }
}

function ensureArticleMediasTable(): bool {
    try {
        query('CREATE TABLE IF NOT EXISTS article_medias (
            id SERIAL PRIMARY KEY,
            article_id INTEGER NOT NULL REFERENCES articles(id) ON DELETE CASCADE,
            media_id INTEGER NOT NULL REFERENCES medias(id) ON DELETE CASCADE,
            ordre INTEGER NOT NULL DEFAULT 0,
            created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
            UNIQUE(article_id, media_id)
        )');
        query('CREATE INDEX IF NOT EXISTS idx_article_medias_article ON article_medias(article_id)');
        query('CREATE INDEX IF NOT EXISTS idx_article_medias_ordre ON article_medias(article_id, ordre)');
        return true;
    } catch (Exception $e) {
        return false;
    }
}

function uploadArticleImages(array $files, string $altsRaw = ''): array {
    $uploadedIds = [];
    if (empty($files['name']) || !is_array($files['name'])) {
        return $uploadedIds;
    }

    $alts = preg_split('/\r\n|\r|\n/', trim($altsRaw));
    $maxSize = 5 * 1024 * 1024;
    $allowedTypes = ['image/jpeg' => 'jpg', 'image/png' => 'png', 'image/gif' => 'gif', 'image/webp' => 'webp'];

    if (!is_dir(UPLOAD_DIR)) {
        mkdir(UPLOAD_DIR, 0755, true);
    }

    foreach ($files['name'] as $index => $name) {
        if (empty($name) || ($files['error'][$index] ?? UPLOAD_ERR_NO_FILE) === UPLOAD_ERR_NO_FILE) {
            continue;
        }

        if (($files['error'][$index] ?? UPLOAD_ERR_OK) !== UPLOAD_ERR_OK) {
            continue;
        }

        $tmpName = $files['tmp_name'][$index] ?? '';
        $size = (int) ($files['size'][$index] ?? 0);
        if ($size <= 0 || $size > $maxSize || !is_uploaded_file($tmpName)) {
            continue;
        }

        $finfo = new finfo(FILEINFO_MIME_TYPE);
        $mimeType = $finfo->file($tmpName);
        if (!isset($allowedTypes[$mimeType])) {
            continue;
        }

        $filename = uniqid('img_', true) . '.' . $allowedTypes[$mimeType];
        $destination = UPLOAD_DIR . $filename;
        if (!move_uploaded_file($tmpName, $destination)) {
            continue;
        }

        $alt = trim($alts[$index] ?? '');
        if ($alt === '') {
            $alt = pathinfo($name, PATHINFO_FILENAME);
        }

        $stmt = query(
            'INSERT INTO medias (fichier, alt, mime_type, taille, created_at) VALUES (?, ?, ?, ?, NOW()) RETURNING id',
            [$filename, $alt, $mimeType, $size]
        );
        $mediaId = (int) $stmt->fetchColumn();
        if ($mediaId > 0) {
            $uploadedIds[] = $mediaId;
        }
    }

    return $uploadedIds;
}

$pageTitle = 'Admin - Article';
$article = null;
$articleMedias = [];
$hasArticleMediasTable = ensureArticleMediasTable() || legacyTableExists('article_medias');
$categories = fetchAll('SELECT id, nom FROM categories ORDER BY nom');

if (isset($_GET['id'])) {
    $article = fetchOne('SELECT * FROM articles WHERE id = ?', [$_GET['id']]);
    if (!$article) {
        setFlash('error', 'Article non trouvé');
        redirect('/admin/articles');
    }

    if (!empty($article['image_une'])) {
        $imageUne = fetchOne('SELECT * FROM medias WHERE id = ?', [$article['image_une']]);
        if ($imageUne) {
            $articleMedias[] = $imageUne;
        }
    }

    if ($hasArticleMediasTable) {
        $extraMedias = fetchAll(
            'SELECT m.* FROM article_medias am
             JOIN medias m ON m.id = am.media_id
             WHERE am.article_id = ?
             ORDER BY am.ordre ASC, am.id ASC',
            [$article['id']]
        );
        foreach ($extraMedias as $media) {
            $alreadyInList = false;
            foreach ($articleMedias as $existingMedia) {
                if ((int) $existingMedia['id'] === (int) $media['id']) {
                    $alreadyInList = true;
                    break;
                }
            }
            if (!$alreadyInList) {
                $articleMedias[] = $media;
            }
        }
    }
}

if ($_POST && isset($_POST['titre'])) {
    $titre = trim($_POST['titre']);
    $chapeau = trim($_POST['chapeau'] ?? '');
    $contenu = $_POST['contenu'] ?? '';
    $categorie_id = !empty($_POST['categorie_id']) ? (int) $_POST['categorie_id'] : null;
    $statut = $_POST['statut'] ?? 'brouillon';
    $slug = slugify($titre);
    $uploadedMediaIds = uploadArticleImages($_FILES['images'] ?? [], $_POST['image_alts'] ?? '');
    $imageUne = !empty($uploadedMediaIds) ? (int) $uploadedMediaIds[0] : null;
    
    if ($article) {
        if ($imageUne === null) {
            $imageUne = !empty($article['image_une']) ? (int) $article['image_une'] : null;
        }

        query('UPDATE articles SET titre = ?, slug = ?, chapeau = ?, contenu = ?, categorie_id = ?, statut = ?, image_une = ?, updated_at = NOW() WHERE id = ?',
            [$titre, $slug, $chapeau, $contenu, $categorie_id, $statut, $imageUne, $article['id']]);

        if ($hasArticleMediasTable && !empty($uploadedMediaIds)) {
            $nextOrder = (int) fetchColumn('SELECT COALESCE(MAX(ordre), -1) + 1 FROM article_medias WHERE article_id = ?', [$article['id']]);
            foreach ($uploadedMediaIds as $uploadedId) {
                query('INSERT INTO article_medias (article_id, media_id, ordre, created_at) VALUES (?, ?, ?, NOW()) ON CONFLICT DO NOTHING',
                    [$article['id'], $uploadedId, $nextOrder]);
                $nextOrder++;
            }
        }

        setFlash('success', 'Article mis à jour');
    } else {
        $datePublication = $statut === 'publie' ? date('Y-m-d H:i:s') : null;
        $stmt = query('INSERT INTO articles (titre, slug, chapeau, contenu, categorie_id, statut, image_une, date_publication, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW()) RETURNING id',
            [$titre, $slug, $chapeau, $contenu, $categorie_id, $statut, $imageUne, $datePublication]);
        $newArticleId = (int) $stmt->fetchColumn();

        if ($hasArticleMediasTable && $newArticleId > 0 && !empty($uploadedMediaIds)) {
            foreach ($uploadedMediaIds as $index => $uploadedId) {
                query('INSERT INTO article_medias (article_id, media_id, ordre, created_at) VALUES (?, ?, ?, NOW()) ON CONFLICT DO NOTHING',
                    [$newArticleId, $uploadedId, $index]);
            }
        }

        setFlash('success', 'Article créé');
    }
    
    redirect('/admin/articles');
}
?>

<?php include BASE_PATH . '/includes/admin-header.php'; ?>

<div class="max-w-4xl">
    <h1 class="text-3xl font-bold text-gray-900 mb-8"><?php echo $article ? 'Éditer l\'article' : 'Créer un article'; ?></h1>

    <form method="POST" enctype="multipart/form-data" class="bg-white p-8 rounded-lg border border-slate-200 space-y-6">
        <div>
            <label class="block text-sm font-semibold text-gray-900 mb-2">Titre</label>
            <input type="text" name="titre" placeholder="Titre" value="<?php echo e($article['titre'] ?? ''); ?>" class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500" required>
        </div>
        
        <div>
            <label class="block text-sm font-semibold text-gray-900 mb-2">Résumé</label>
            <input type="text" name="chapeau" placeholder="Résumé" value="<?php echo e($article['chapeau'] ?? ''); ?>" class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
        </div>
        
        <div>
            <label class="block text-sm font-semibold text-gray-900 mb-2">Catégorie</label>
            <select name="categorie_id" class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                <option value="">-- Sélectionner --</option>
                <?php foreach ($categories as $cat): ?>
                <option value="<?php echo $cat['id']; ?>" <?php echo ($article['categorie_id'] ?? null) == $cat['id'] ? 'selected' : ''; ?>>
                    <?php echo e($cat['nom']); ?>
                </option>
                <?php endforeach; ?>
            </select>
        </div>
        
        <div>
            <label class="block text-sm font-semibold text-gray-900 mb-2">Contenu</label>
            <textarea name="contenu" rows="15" class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 font-mono text-sm" required><?php echo e($article['contenu'] ?? ''); ?></textarea>
        </div>
        
        <div>
            <label class="block text-sm font-semibold text-gray-900 mb-2">Statut</label>
            <select name="statut" class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                <option value="brouillon" <?php echo ($article['statut'] ?? 'brouillon') == 'brouillon' ? 'selected' : ''; ?>>Brouillon</option>
                <option value="publie" <?php echo ($article['statut'] ?? '') == 'publie' ? 'selected' : ''; ?>>Publié</option>
            </select>
        </div>

        <div>
            <label class="block text-sm font-semibold text-gray-900 mb-2">Photos (une ou plusieurs)</label>
            <input type="file" name="images[]" accept="image/jpeg,image/png,image/gif,image/webp" multiple class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
            <p class="text-xs text-gray-500 mt-1">Formats autorisés: JPG, PNG, GIF, WEBP. Max 5 Mo par image.</p>
        </div>

        <div>
            <label class="block text-sm font-semibold text-gray-900 mb-2">Textes alternatifs (optionnel)</label>
            <textarea name="image_alts" rows="3" placeholder="Un texte alternatif par ligne, dans l'ordre des photos" class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"></textarea>
        </div>

        <?php if (!empty($articleMedias)): ?>
        <div>
            <label class="block text-sm font-semibold text-gray-900 mb-3">Photos actuelles</label>
            <div class="grid grid-cols-2 md:grid-cols-4 gap-3">
                <?php foreach ($articleMedias as $media): ?>
                <div class="rounded-lg overflow-hidden border border-slate-200 bg-slate-50">
                    <img src="/uploads/<?php echo e($media['fichier']); ?>" alt="<?php echo e($media['alt'] ?? ''); ?>" class="w-full h-28 object-cover">
                    <div class="p-2 text-xs text-slate-600 truncate"><?php echo e($media['alt'] ?? ''); ?></div>
                </div>
                <?php endforeach; ?>
            </div>
        </div>
        <?php endif; ?>
        
        <div class="flex gap-4 pt-4">
            <button type="submit" class="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition font-semibold">💾 Enregistrer</button>
            <a href="/admin/articles" class="px-6 py-2 bg-slate-200 text-slate-700 rounded-lg hover:bg-slate-300 transition font-semibold">Annuler</a>
        </div>
    </form>
</div>

<?php include BASE_PATH . '/includes/admin-footer.php'; ?>
