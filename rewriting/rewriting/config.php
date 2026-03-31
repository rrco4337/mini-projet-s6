<?php
/**
 * Configuration - Iran War News
 */

function envOrDefault(string $name, string $default): string {
    $value = getenv($name);
    return ($value === false || $value === '') ? $default : $value;
}

// Base de données
define('DB_HOST', envOrDefault('DB_HOST', 'localhost'));
define('DB_PORT', envOrDefault('DB_PORT', '5432'));
define('DB_NAME', envOrDefault('DB_NAME', 'iran'));
define('DB_USER', envOrDefault('DB_USER', 'cindy'));
define('DB_PASS', envOrDefault('DB_PASS', 'cindy2301'));

// URLs et chemins
define('BASE_PATH', __DIR__);
define('BASE_URL', envOrDefault('BASE_URL', 'http://localhost:8000'));
define('UPLOAD_DIR', __DIR__ . '/uploads/');

// Session
session_name(envOrDefault('SESSION_NAME', 'iran_session'));
session_start();

// Timezone
date_default_timezone_set(envOrDefault('APP_TIMEZONE', 'Europe/Paris'));

// Debug
define('DEBUG', filter_var(envOrDefault('APP_DEBUG', '1'), FILTER_VALIDATE_BOOLEAN));
if (DEBUG) {
    error_reporting(E_ALL);
    ini_set('display_errors', '1');
}
?>