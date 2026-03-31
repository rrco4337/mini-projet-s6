<?php
/**
 * Service pour gérer les photos d'un article
 */
class ArticleMediaService
{
    /**
     * Traiter les uploads de fichiers pour un article
     * @param array $files Les fichiers uploadés ($_FILES['images'])
     * @param array $alts Les textes alternatifs
     * @param array $titres Les titres des images
     * @return array Liste des IDs media uploadés
     */
    public static function processUploads(array $files, array $alts = [], array $titres = []): array
    {
        if (empty($files['name'][0] ?? null)) {
            return [];
        }

        return Media::uploadMultiple($files, $alts, $titres);
    }

    /**
     * Synchroniser les medias d'un article
     */
    public static function syncMedia(int $articleId, array $mediaIds): bool
    {
        try {
            // Supprimer les relations existantes
            $db = Database::getInstance();
            $stmt = $db->prepare("DELETE FROM article_medias WHERE article_id = ?");
            $stmt->execute([$articleId]);

            // Créer les nouvelles relations
            $stmt = $db->prepare("
                INSERT INTO article_medias (article_id, media_id, ordre)
                VALUES (?, ?, ?)
            ");

            foreach ($mediaIds as $index => $mediaId) {
                $stmt->execute([$articleId, $mediaId, $index]);
            }

            return true;
        } catch (Exception $e) {
            error_log("Erreur ArticleMediaService::syncMedia: " . $e->getMessage());
            return false;
        }
    }

    /**
     * Récupérer les medias d'un article avec le chemin d'accès
     */
    public static function getArticleMedias(int $articleId): array
    {
        $medias = Media::getByArticle($articleId);
        
        return array_map(function($media) {
            return [
                'id' => $media['id'],
                'fichier' => $media['fichier'],
                'alt' => $media['alt'],
                'titre' => $media['titre'] ?? '',
                'url' => url('/uploads/' . $media['fichier']),
                'taille' => self::formatFileSize($media['taille'] ?? 0),
                'mime_type' => $media['mime_type'] ?? ''
            ];
        }, $medias);
    }

    /**
     * Formater la taille d'un fichier
     */
    private static function formatFileSize(int $bytes): string
    {
        if ($bytes === 0) return '0 B';
        
        $units = ['B', 'KB', 'MB', 'GB'];
        $bytes = max($bytes, 0);
        $pow = floor(($bytes ? log($bytes) : 0) / log(1024));
        $pow = min($pow, count($units) - 1);
        $bytes /= (1 << (10 * $pow));

        return round($bytes, 2) . ' ' . $units[$pow];
    }

    /**
     * Supprimer une image d'un article
     */
    public static function deleteMediaFromArticle(int $articleId, int $mediaId): bool
    {
        try {
            $db = Database::getInstance();
            
            // Supprimer la relation
            $stmt = $db->prepare("DELETE FROM article_medias WHERE article_id = ? AND media_id = ?");
            $stmt->execute([$articleId, $mediaId]);

            // Supprimer le fichier physique et l'entrée média
            Media::deleteMedia($mediaId);

            return true;
        } catch (Exception $e) {
            error_log("Erreur ArticleMediaService::deleteMediaFromArticle: " . $e->getMessage());
            return false;
        }
    }

    /**
     * Valider les uploads
     */
    public static function validateUploads(array $files): array
    {
        $errors = [];

        if (empty($files['name'])) {
            return $errors;
        }

        $allowedTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
        $maxSize = UPLOAD_MAX_SIZE ?? (5 * 1024 * 1024); // 5 MB par défaut

        $count = count($files['name']);
        for ($i = 0; $i < $count; $i++) {
            if (empty($files['name'][$i])) {
                continue;
            }

            if ($files['error'][$i] !== UPLOAD_ERR_OK) {
                $errors[] = "Erreur lors du téléchargement de {$files['name'][$i]}: code {$files['error'][$i]}";
                continue;
            }

            if ($files['size'][$i] > $maxSize) {
                $errors[] = "{$files['name'][$i]} dépasse la taille maximale de " . ($maxSize / 1024 / 1024) . " MB";
                continue;
            }

            $finfo = new finfo(FILEINFO_MIME_TYPE);
            $mimeType = $finfo->file($files['tmp_name'][$i]);

            if (!in_array($mimeType, $allowedTypes)) {
                $errors[] = "{$files['name'][$i]}: type de fichier non autorisé ($mimeType)";
            }
        }

        return $errors;
    }
}
