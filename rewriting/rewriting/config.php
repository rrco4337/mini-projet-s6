<?php
/**
 * Configuration - Iran War News
 */

// Base de données
define('DB_HOST', 'localhost');
define('DB_PORT', '5432');
define('DB_NAME', 'iran');
define('DB_USER', 'postgres');
define('DB_PASS', 'admin');

// URL
define('BASE_URL', 'http://localhost:8000');
define('UPLOAD_DIR', __DIR__ . '/uploads/');

// Session
session_name('iran_session');
session_start();

// Timezone
date_default_timezone_set('Europe/Paris');

// Debug
define('DEBUG', true);
if (DEBUG) {
    error_reporting(E_ALL);
    ini_set('display_errors', '1');
}
?>