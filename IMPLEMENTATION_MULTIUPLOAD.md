# Guide d'Implémentation: Upload Multi-Photos pour Articles

## 📋 Résumé
Cette implémentation ajoute la capacité d'uploader **plusieurs photos** lors de la création/modification d'articles, avec prévisualisation live et gestion avancée des médias.

---

## 🔧 Modifications Requises

### 1. **Base de Données** - Créer la table `article_medias`

Exécutez le fichier SQL de migration:
```bash
psql -U user -d iran_war_db -f /Users/apple/Documents/GitHub/Untitled/mini-projet-s6/bd/migration_article_medias.sql
```

Ou directement via phpPgAdmin / pgAdmin:
```sql
CREATE TABLE IF NOT EXISTS article_medias (
  id          SERIAL       PRIMARY KEY,
  article_id  INTEGER      NOT NULL REFERENCES articles(id) ON DELETE CASCADE,
  media_id    INTEGER      NOT NULL REFERENCES medias(id) ON DELETE CASCADE,
  ordre       INTEGER      NOT NULL DEFAULT 0,
  description TEXT,
  created_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
  UNIQUE(article_id, media_id)
);

CREATE INDEX idx_article_medias_article ON article_medias(article_id);
CREATE INDEX idx_article_medias_media ON article_medias(media_id);
```

### 2. **Classe Media** - Ajouter `uploadMultiple()`

Ouvrez: `/rewriting/rewriting/models/Media.php`

**REMPLACEZ** la méthode `upload()` et `getByArticle()` par:

```php
/**
 * Upload un fichier unique et retourner son ID
 */
public static function upload(array $file, string $alt = '', string $titre = ''): ?int
{
    if (!is_array($file) || !isset($file['size'])) {
        return null;
    }

    if ($file['error'] !== UPLOAD_ERR_OK) {
        return null;
    }

    if ($file['size'] > UPLOAD_MAX_SIZE) {
        return null;
    }

    $allowedTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
    $finfo = new finfo(FILEINFO_MIME_TYPE);
    $mimeType = $finfo->file($file['tmp_name']);

    if (!in_array($mimeType, $allowedTypes)) {
        return null;
    }

    $extension = pathinfo($file['name'], PATHINFO_EXTENSION);
    $filename = uniqid('img_') . '.' . $extension;

    if (!is_dir(UPLOAD_DIR)) {
        mkdir(UPLOAD_DIR, 0755, true);
    }

    $destination = UPLOAD_DIR . $filename;
    if (!move_uploaded_file($file['tmp_name'], $destination)) {
        return null;
    }

    return self::create([
        'fichier' => $filename,
        'alt' => $alt ?: $file['name'],
        'titre' => $titre,
        'mime_type' => $mimeType,
        'taille' => $file['size'],
        'created_at' => date('Y-m-d H:i:s')
    ]);
}

/**
 * Upload plusieurs fichiers et retourner les IDs
 */
public static function uploadMultiple(array $files, array $alts = [], array $titres = []): array
{
    $mediaIds = [];

    if (!isset($files['name']) || !is_array($files['name'])) {
        return [];
    }

    $count = count($files['name']);
    for ($i = 0; $i < $count; $i++) {
        if (empty($files['name'][$i]) || $files['error'][$i] === UPLOAD_ERR_NO_FILE) {
            continue;
        }

        $singleFile = [
            'name'     => $files['name'][$i],
            'type'     => $files['type'][$i] ?? '',
            'tmp_name' => $files['tmp_name'][$i],
            'error'    => $files['error'][$i],
            'size'     => $files['size'][$i]
        ];

        $alt = trim($alts[$i] ?? '');
        $titre = trim($titres[$i] ?? '');

        $mediaId = self::upload($singleFile, $alt, $titre);
        if ($mediaId) {
            $mediaIds[] = $mediaId;
        }
    }

    return $mediaIds;
}

/**
 * Récupérer les medias liés à un article
 */
public static function getByArticle(int $articleId): array
{
    $stmt = static::db()->prepare("
        SELECT m.*, am.ordre 
        FROM medias m
        LEFT JOIN article_medias am ON m.id = am.media_id
        WHERE am.article_id = ?
        ORDER BY am.ordre ASC, m.created_at DESC
    ");
    $stmt->execute([$articleId]);
    return $stmt->fetchAll() ?: [];
}

/**
 * Récupérer un media par ID
 */
public static function findById(int $id): ?array
{
    $stmt = static::db()->prepare("SELECT * FROM medias WHERE id = ?");
    $stmt->execute([$id]);
    return $stmt->fetch() ?: null;
}

/**
 * Supprimer un media et son fichier
 */
public static function deleteMedia(int $id): bool
{
    $media = self::findById($id);
    if (!$media) {
        return false;
    }

    $filePath = UPLOAD_DIR . $media['fichier'];
    if (file_exists($filePath)) {
        @unlink($filePath);
    }

    return self::delete($id);
}
```

### 3. **Service ArticleMediaService** ✅
Créé: `/rewriting/rewriting/services/ArticleMediaService.php`

Ce fichier est déjà créé avec tous les utilitaires nécessaires.

### 4. **Contrôleur ArticleAdminController** - Update `store()` et `update()`

Ouvrez: `/rewriting/rewriting/controllers/ArticleAdminController.php`

**Dans la méthode `store()`, REMPLACEZ:**

```php
// Ancienne version (avant):
// $imageUne = null;
// if (!empty($_FILES['images']['name'][0])) {
//     $alts = array_filter(explode("\n", $data['imageAlts'] ?? ''));
//     $alt = trim($alts[0] ?? '');
//     $imageUne = Media::upload($_FILES['images'], $alt);
// }

// NOUVELLE VERSION:
require_once __DIR__ . '/../services/ArticleMediaService.php';

$imageUne = null;
$uploadedMediaIds = [];

if (!empty($_FILES['images']['name'][0])) {
    $alts = array_filter(explode("\n", $data['imageAlts'] ?? ''));
    $uploadedMediaIds = ArticleMediaService::processUploads($_FILES['images'], $alts);
    
    if (!empty($uploadedMediaIds)) {
        $imageUne = $uploadedMediaIds[0]; // La première image devient image_une
    }
}
```

**Puis APRÈS la création de l'article, AJOUTER:**

```php
$articleId = Article::create($articleData);

// 🆕 Synchroniser tous les medias uploadés
if (!empty($uploadedMediaIds)) {
    ArticleMediaService::syncMedia($articleId, $uploadedMediaIds);
}

// Synchroniser les categories
if (!empty($data['categorieIds'])) {
    Article::syncCategories($articleId, $data['categorieIds']);
}
```

**Dans la méthode `update()`, REMPLACEZ:**

```php
// Ancienne version (avant):
// $imageUne = $article['image_une'];
// if (!empty($_FILES['images']['name'][0])) {
//     $alts = array_filter(explode("\n", $data['imageAlts'] ?? ''));
//     $alt = trim($alts[0] ?? '');
//     $newImage = Media::upload($_FILES['images'], $alt);
//     if ($newImage) {
//         $imageUne = $newImage;
//     }
// }

// NOUVELLE VERSION:
require_once __DIR__ . '/../services/ArticleMediaService.php';

$imageUne = $article['image_une'];
$uploadedMediaIds = [];

if (!empty($_FILES['images']['name'][0])) {
    $alts = array_filter(explode("\n", $data['imageAlts'] ?? ''));
    $uploadedMediaIds = ArticleMediaService::processUploads($_FILES['images'], $alts);
    
    if (!empty($uploadedMediaIds)) {
        $imageUne = $uploadedMediaIds[0];
    }
}
```

**Puis APRÈS l'update de l'article, AJOUTER:**

```php
Article::update((int) $id, $articleData);

// 🆕 Synchroniser tous les medias uploadés (ajoute aux existants)
if (!empty($uploadedMediaIds)) {
    $existingMedias = Media::getByArticle((int) $id);
    $existingIds = array_column($existingMedias, 'id');
    $allMediaIds = array_merge($existingIds, $uploadedMediaIds);
    ArticleMediaService::syncMedia((int) $id, $allMediaIds);
}

// Synchroniser les categories
Article::syncCategories((int) $id, $data['categorieIds'] ?? []);
```

### 5. **Vue du Formulaire** - Intégrer le composant d'upload

Ouvrez: `/rewriting/rewriting/views/admin/articles/form.php`

**REMPLACEZ le champ "Images" par:**

```php
<?php include __DIR__ . '/media-upload.php'; ?>
```

**OU remplacez la section complète:**

```php
<div>
  <label for="images" class="mb-2 block text-sm font-semibold text-slate-700">Images</label>
  <input type="file" id="images" name="images" accept="image/*" multiple class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm file:mr-4 file:rounded-lg file:border-0 file:bg-slate-900 file:px-3 file:py-2 file:text-xs file:font-semibold file:text-white" />
  <p class="mt-1 text-xs text-slate-500">Formats image uniquement, 5 Mo maximum par fichier.</p>
</div>

<div>
  <label for="imageAlts" class="mb-2 block text-sm font-semibold text-slate-700">Texte alternatif (alt)</label>
  <textarea id="imageAlts" name="imageAlts" rows="3" placeholder="Un texte alt par ligne, dans le meme ordre que les images" class="w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm outline-none transition focus:border-blue-300 focus:bg-white"></textarea>
  <p class="mt-1 text-xs text-slate-500">Ligne 1 = alt image 1, ligne 2 = alt image 2.</p>
</div>
```

Par:

```php
<?php include __DIR__ . '/media-upload.php'; ?>
```

---

## ✅ Fichiers Créés/Modifiés

| Fichier | Statut | Action |
|---------|--------|--------|
| `bd/migration_article_medias.sql` | ✅ Créé | Exécuter via psql |
| `rewriting/services/ArticleMediaService.php` | ✅ Créé | Utilitaires pour les medias |
| `rewriting/views/admin/articles/media-upload.php` | ✅ Créé | Composant d'upload |
| `rewriting/models/Media.php` | ⚠️ À modifier | Ajouter `uploadMultiple()` |
| `rewriting/controllers/ArticleAdminController.php` | ⚠️ À modifier | Utiliser le service |
| `rewriting/views/admin/articles/form.php` | ⚠️ À modifier | Intégrer le composant |

---

## 🧪 Test

1. **Créer un article** avec 3 images
2. **Vérifier** que les images s'affichent en prévisualisation avant upload
3. **Modifier** l'article et voir les images existantes
4. **Upload** des images supplémentaires
5. **Vérifier** dans la BD que les relations `article_medias` sont créées

---

## 📝 Notes
- Les uploads sont stockés dans le dossier `/uploads/`
- La première image uploadée devient `image_une` pour la couverture
- L'ordre des images est préservé via la colonne `ordre`
- Les textes alt sont essentiels pour l'accessibilité et le SEO

