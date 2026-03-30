<?php
/**
 * Modele Category
 */
class Category extends Model
{
    protected static string $table = 'categories';

    public static function findBySlug(string $slug): ?array
    {
        $stmt = static::db()->prepare('SELECT * FROM categories WHERE slug = ?');
        $stmt->execute([$slug]);
        $result = $stmt->fetch();
        return $result ?: null;
    }

    public static function existsBySlug(string $slug, ?int $excludeId = null): bool
    {
        if ($excludeId) {
            $stmt = static::db()->prepare('SELECT COUNT(*) FROM categories WHERE slug = ? AND id != ?');
            $stmt->execute([$slug, $excludeId]);
        } else {
            $stmt = static::db()->prepare('SELECT COUNT(*) FROM categories WHERE slug = ?');
            $stmt->execute([$slug]);
        }
        return (int) $stmt->fetchColumn() > 0;
    }

    public static function all(): array
    {
        $stmt = static::db()->query('SELECT * FROM categories ORDER BY nom ASC');
        return $stmt->fetchAll();
    }

    public static function validate(array $data, ?int $excludeId = null): array
    {
        $errors = [];

        if (empty(trim($data['nom'] ?? ''))) {
            $errors['nom'] = 'Le nom est obligatoire.';
        } elseif (strlen($data['nom']) > 100) {
            $errors['nom'] = 'Le nom ne doit pas depasser 100 caracteres.';
        }

        if (empty(trim($data['slug'] ?? ''))) {
            $errors['slug'] = 'Le slug est obligatoire.';
        } elseif (strlen($data['slug']) > 110) {
            $errors['slug'] = 'Le slug ne doit pas depasser 110 caracteres.';
        } elseif (!preg_match('/^[a-z0-9-]+$/', $data['slug'])) {
            $errors['slug'] = 'Le slug ne peut contenir que des lettres minuscules, chiffres et tirets.';
        } elseif (self::existsBySlug($data['slug'], $excludeId)) {
            $errors['slug'] = 'Ce slug existe deja.';
        }

        return $errors;
    }
}
