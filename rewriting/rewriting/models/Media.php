<?php
/**
 * Modele Media
 */
class Media extends Model
{
    protected static string $table = 'medias';

    public static function upload(array $file, string $alt = '', string $titre = ''): ?int
    {
        // Verifier le fichier
        if ($file['error'] !== UPLOAD_ERR_OK) {
            return null;
        }

        // Verifier la taille
        if ($file['size'] > UPLOAD_MAX_SIZE) {
            return null;
        }

        // Verifier le type MIME
        $allowedTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
        $finfo = new finfo(FILEINFO_MIME_TYPE);
        $mimeType = $finfo->file($file['tmp_name']);

        if (!in_array($mimeType, $allowedTypes)) {
            return null;
        }

        // Generer un nom unique
        $extension = pathinfo($file['name'], PATHINFO_EXTENSION);
        $filename = uniqid('img_') . '.' . $extension;

        // Creer le dossier si necessaire
        if (!is_dir(UPLOAD_DIR)) {
            mkdir(UPLOAD_DIR, 0755, true);
        }

        // Deplacer le fichier
        $destination = UPLOAD_DIR . $filename;
        if (!move_uploaded_file($file['tmp_name'], $destination)) {
            return null;
        }

        // Creer l'entree en base
        return self::create([
            'fichier' => $filename,
            'alt' => $alt ?: $file['name'],
            'titre' => $titre,
            'mime_type' => $mimeType,
            'taille' => $file['size'],
            'created_at' => date('Y-m-d H:i:s')
        ]);
    }

    public static function getByArticle(int $articleId): array
    {
        // Recuperer les medias lies a l'article
        $stmt = static::db()->prepare("
            SELECT m.* FROM medias m
            JOIN article_medias am ON m.id = am.media_id
            WHERE am.article_id = ?
        ");
        $stmt->execute([$articleId]);
        return $stmt->fetchAll();
    }
}
