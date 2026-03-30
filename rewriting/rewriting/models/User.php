<?php
/**
 * Modele User
 */
class User extends Model
{
    protected static string $table = 'users';

    // Roles
    const ROLE_ADMIN = 'admin';
    const ROLE_EDITEUR = 'editeur';
    const ROLE_LECTEUR = 'lecteur';

    public static function findByUsername(string $username): ?array
    {
        $stmt = static::db()->prepare('SELECT * FROM users WHERE username = ?');
        $stmt->execute([$username]);
        $result = $stmt->fetch();
        return $result ?: null;
    }

    public static function findByEmail(string $email): ?array
    {
        $stmt = static::db()->prepare('SELECT * FROM users WHERE email = ?');
        $stmt->execute([$email]);
        $result = $stmt->fetch();
        return $result ?: null;
    }

    public static function hashPassword(string $password): string
    {
        return password_hash($password, PASSWORD_BCRYPT);
    }
}
