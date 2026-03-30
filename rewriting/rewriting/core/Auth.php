<?php
/**
 * Gestion de l'authentification
 */
class Auth
{
    public static function attempt(string $username, string $password): bool
    {
        $user = User::findByUsername($username);

        if (!$user || !$user['actif']) {
            return false;
        }

        if (!password_verify($password, $user['password_hash'])) {
            return false;
        }

        // Connexion reussie
        $_SESSION['user_id'] = $user['id'];
        $_SESSION['username'] = $user['username'];
        $_SESSION['role'] = $user['role'];

        return true;
    }

    public static function check(): bool
    {
        return isset($_SESSION['user_id']);
    }

    public static function user(): ?array
    {
        if (!self::check()) {
            return null;
        }

        return [
            'id' => $_SESSION['user_id'],
            'username' => $_SESSION['username'],
            'role' => $_SESSION['role']
        ];
    }

    public static function logout(): void
    {
        unset($_SESSION['user_id'], $_SESSION['username'], $_SESSION['role']);
        session_destroy();
    }

    public static function isAdmin(): bool
    {
        return self::check() && $_SESSION['role'] === 'admin';
    }

    public static function isEditor(): bool
    {
        return self::check() && in_array($_SESSION['role'], ['admin', 'editeur']);
    }
}
