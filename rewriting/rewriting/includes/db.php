<?php
/**
 * Connexion PostgreSQL simple
 */

function getDB() {
    static $pdo = null;
    
    if ($pdo === null) {
        try {
            $dsn = sprintf(
                'pgsql:host=%s;port=%s;dbname=%s',
                DB_HOST,
                DB_PORT,
                DB_NAME
            );
            
            $pdo = new PDO($dsn, DB_USER, DB_PASS);
            $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            die('Erreur BD: ' . $e->getMessage());
        }
    }
    
    return $pdo;
}

// Fonction simple pour exécuter une requête
function query($sql, $params = []) {
    $pdo = getDB();
    $stmt = $pdo->prepare($sql);
    $stmt->execute($params);
    return $stmt;
}

// Lire une seule ligne
function fetchOne($sql, $params = []) {
    return query($sql, $params)->fetch();
}

// Lire plusieurs lignes
function fetchAll($sql, $params = []) {
    return query($sql, $params)->fetchAll();
}

// Lire une colonne
function fetchColumn($sql, $params = []) {
    return query($sql, $params)->fetchColumn();
}
?>