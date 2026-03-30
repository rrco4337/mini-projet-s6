<?php
/**
 * Classe de connexion a la base de donnees (Singleton PDO)
 */
class Database
{
    private static ?PDO $instance = null;

    private function __construct() {}

    public static function getInstance(): PDO
    {
        if (self::$instance === null) {
            try {
                $dsn = sprintf(
                    'pgsql:host=%s;port=%s;dbname=%s',
                    DB_HOST,
                    DB_PORT,
                    DB_NAME
                );

                self::$instance = new PDO($dsn, DB_USER, DB_PASS, [
                    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                    PDO::ATTR_EMULATE_PREPARES => false
                ]);
            } catch (PDOException $e) {
                if (DEBUG) {
                    die('Erreur de connexion: ' . $e->getMessage());
                }
                die('Erreur de connexion a la base de donnees.');
            }
        }

        return self::$instance;
    }
}
