<?php

define('DB_NAME', 'wordpress');
define('DB_USER', 'wordpress');
define('DB_PASSWORD', 'wordpress');
define('DB_HOST', 'localhost:' . getenv('WP_DEV_SOCKET'));
define('DB_CHARSET', 'utf8mb4');
define('DB_COLLATE', '');
define('WP_CONTENT_DIR', getenv('WP_DEV_ROOT') . '/wp-content');
define('WP_CONTENT_URL', 'http://localhost:8080/wp-content');
define('WP_DEBUG', true);
define('WP_DEBUG_LOG', true);
define('WP_DEBUG_DISPLAY', false);
define('WP_ENVIRONMENT_TYPE', 'local');
define('WP_AUTO_UPDATE_CORE', false);
define('AUTOMATIC_UPDATER_DISABLED', true);

$salt_file = __DIR__ . '/local-salts.php';
if (!file_exists($salt_file)) {
    $salt_keys = ['AUTH_KEY', 'SECURE_AUTH_KEY', 'LOGGED_IN_KEY', 'NONCE_KEY', 'AUTH_SALT', 'SECURE_AUTH_SALT', 'LOGGED_IN_SALT', 'NONCE_SALT'];
    $salt_config = "<?php\n";
    foreach ($salt_keys as $salt_key) {
        $salt_config .= "define('$salt_key', '" . bin2hex(random_bytes(32)) . "');\n";
    }
    file_put_contents($salt_file, $salt_config, LOCK_EX);
    chmod($salt_file, 0600);
}
require $salt_file;

$table_prefix = 'wp_';
define('ABSPATH', __DIR__ . '/');
require_once ABSPATH . 'wp-settings.php';
