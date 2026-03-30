<?php
/**
 * Modele Article
 */
class Article extends Model
{
    protected static string $table = 'articles';

    // Statuts possibles
    const STATUT_BROUILLON = 'brouillon';
    const STATUT_PUBLIE = 'publie';
    const STATUT_ARCHIVE = 'archive';

    public static function findBySlug(string $slug): ?array
    {
        $stmt = static::db()->prepare('SELECT * FROM articles WHERE slug = ?');
        $stmt->execute([$slug]);
        $result = $stmt->fetch();
        return $result ?: null;
    }

    public static function getPublished(): array
    {
        $stmt = static::db()->query("
            SELECT a.*, c.nom as categorie_nom, c.slug as categorie_slug
            FROM articles a
            LEFT JOIN categories c ON a.categorie_id = c.id
            WHERE a.statut = 'publie'
            ORDER BY a.date_publication DESC, a.created_at DESC
        ");
        return $stmt->fetchAll();
    }

    public static function getByStatut(string $statut): array
    {
        $stmt = static::db()->prepare("
            SELECT a.*, c.nom as categorie_nom, c.slug as categorie_slug
            FROM articles a
            LEFT JOIN categories c ON a.categorie_id = c.id
            WHERE a.statut = ?
            ORDER BY a.updated_at DESC
        ");
        $stmt->execute([$statut]);
        return $stmt->fetchAll();
    }

    public static function getFeatured(int $limit = 3): array
    {
        $stmt = static::db()->prepare("
            SELECT a.*, c.nom as categorie_nom, c.slug as categorie_slug
            FROM articles a
            LEFT JOIN categories c ON a.categorie_id = c.id
            WHERE a.statut = 'publie' AND a.a_la_une = true
            ORDER BY a.date_publication DESC
            LIMIT ?
        ");
        $stmt->execute([$limit]);
        return $stmt->fetchAll();
    }

    public static function getFiltered(array $categorySlugs = [], ?string $publicationDate = null): array
    {
        $sql = "
            SELECT DISTINCT a.*, c.nom as categorie_nom, c.slug as categorie_slug
            FROM articles a
            LEFT JOIN categories c ON a.categorie_id = c.id
            LEFT JOIN article_categories ac ON a.id = ac.article_id
            LEFT JOIN categories c2 ON ac.category_id = c2.id
            WHERE a.statut = 'publie'
        ";

        $params = [];

        if (!empty($categorySlugs)) {
            $placeholders = implode(',', array_fill(0, count($categorySlugs), '?'));
            $sql .= " AND (c.slug IN ($placeholders) OR c2.slug IN ($placeholders))";
            $params = array_merge($params, $categorySlugs, $categorySlugs);
        }

        if ($publicationDate) {
            $sql .= " AND DATE(a.date_publication) = ?";
            $params[] = $publicationDate;
        }

        $sql .= " ORDER BY a.date_publication DESC, a.created_at DESC";

        $stmt = static::db()->prepare($sql);
        $stmt->execute($params);
        return $stmt->fetchAll();
    }

    public static function getMostViewed(): ?array
    {
        $stmt = static::db()->query("
            SELECT * FROM articles
            WHERE statut = 'publie'
            ORDER BY vues DESC
            LIMIT 1
        ");
        $result = $stmt->fetch();
        return $result ?: null;
    }

    public static function getRecent(int $limit = 5): array
    {
        $stmt = static::db()->prepare("
            SELECT * FROM articles
            ORDER BY created_at DESC
            LIMIT ?
        ");
        $stmt->execute([$limit]);
        return $stmt->fetchAll();
    }

    public static function incrementViews(int $id): void
    {
        $stmt = static::db()->prepare('UPDATE articles SET vues = vues + 1 WHERE id = ?');
        $stmt->execute([$id]);
    }

    public static function archive(int $id): bool
    {
        return static::update($id, ['statut' => self::STATUT_ARCHIVE, 'updated_at' => date('Y-m-d H:i:s')]);
    }

    public static function restore(int $id): bool
    {
        return static::update($id, ['statut' => self::STATUT_BROUILLON, 'updated_at' => date('Y-m-d H:i:s')]);
    }

    public static function countByStatut(string $statut): int
    {
        $stmt = static::db()->prepare('SELECT COUNT(*) FROM articles WHERE statut = ?');
        $stmt->execute([$statut]);
        return (int) $stmt->fetchColumn();
    }

    public static function countFeatured(): int
    {
        $stmt = static::db()->query("SELECT COUNT(*) FROM articles WHERE a_la_une = true AND statut = 'publie'");
        return (int) $stmt->fetchColumn();
    }

    public static function sumViews(): int
    {
        $stmt = static::db()->query('SELECT COALESCE(SUM(vues), 0) FROM articles');
        return (int) $stmt->fetchColumn();
    }

    public static function getCategories(int $articleId): array
    {
        $stmt = static::db()->prepare("
            SELECT c.* FROM categories c
            JOIN article_categories ac ON c.id = ac.category_id
            WHERE ac.article_id = ?
        ");
        $stmt->execute([$articleId]);
        return $stmt->fetchAll();
    }

    public static function syncCategories(int $articleId, array $categoryIds): void
    {
        // Supprimer les anciennes associations
        $stmt = static::db()->prepare('DELETE FROM article_categories WHERE article_id = ?');
        $stmt->execute([$articleId]);

        // Ajouter les nouvelles
        if (!empty($categoryIds)) {
            $stmt = static::db()->prepare('INSERT INTO article_categories (article_id, category_id) VALUES (?, ?)');
            foreach ($categoryIds as $catId) {
                $stmt->execute([$articleId, $catId]);
            }
        }
    }

    public static function getWithImage(array $article): array
    {
        if (!empty($article['image_une'])) {
            $media = Media::find($article['image_une']);
            if ($media) {
                $article['imageUrl'] = url('uploads/' . $media['fichier']);
                $article['imageAlt'] = $media['alt'] ?? '';
            }
        }

        // Charger les categories
        $article['categories'] = self::getCategories($article['id']);

        return $article;
    }

    public static function getGalleryImages(int $articleId): array
    {
        // Recuperer uniquement l'image_une car pas de table article_medias
        $stmt = static::db()->prepare("
            SELECT m.* FROM medias m
            JOIN articles a ON a.image_une = m.id
            WHERE a.id = ?
        ");
        $stmt->execute([$articleId]);
        $images = $stmt->fetchAll();

        return array_map(function($img) {
            $img['url'] = url('uploads/' . $img['fichier']);
            return $img;
        }, $images);
    }
}
