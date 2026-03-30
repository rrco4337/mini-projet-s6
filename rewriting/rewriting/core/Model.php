<?php
/**
 * Classe de base pour les modeles
 */
abstract class Model
{
    protected static string $table;
    protected static string $primaryKey = 'id';

    protected static function db(): PDO
    {
        return Database::getInstance();
    }

    public static function all(): array
    {
        $stmt = static::db()->query('SELECT * FROM ' . static::$table . ' ORDER BY id DESC');
        return $stmt->fetchAll();
    }

    public static function find(int $id): ?array
    {
        $stmt = static::db()->prepare('SELECT * FROM ' . static::$table . ' WHERE id = ?');
        $stmt->execute([$id]);
        $result = $stmt->fetch();
        return $result ?: null;
    }

    public static function create(array $data): int
    {
        $columns = implode(', ', array_keys($data));
        $placeholders = implode(', ', array_fill(0, count($data), '?'));

        $sql = sprintf(
            'INSERT INTO %s (%s) VALUES (%s)',
            static::$table,
            $columns,
            $placeholders
        );

        $stmt = static::db()->prepare($sql);
        $stmt->execute(array_values($data));

        return (int) static::db()->lastInsertId();
    }

    public static function update(int $id, array $data): bool
    {
        $set = implode(' = ?, ', array_keys($data)) . ' = ?';

        $sql = sprintf(
            'UPDATE %s SET %s WHERE id = ?',
            static::$table,
            $set
        );

        $stmt = static::db()->prepare($sql);
        $values = array_values($data);
        $values[] = $id;

        return $stmt->execute($values);
    }

    public static function delete(int $id): bool
    {
        $stmt = static::db()->prepare('DELETE FROM ' . static::$table . ' WHERE id = ?');
        return $stmt->execute([$id]);
    }

    // Alias pour delete (utilise par Media)
    protected static function _delete(int $id): bool
    {
        return static::delete($id);
    }

    public static function count(): int
    {
        $stmt = static::db()->query('SELECT COUNT(*) FROM ' . static::$table);
        return (int) $stmt->fetchColumn();
    }
}
