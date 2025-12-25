<?php
define( 'DB_NAME',     getenv('WORDPRESS_DB_NAME') ?: 'wordpress' );
define( 'DB_USER',     getenv('WORDPRESS_DB_USER') ?: 'admin' );
define( 'DB_PASSWORD', getenv('WORDPRESS_DB_PASSWORD') ?: 'password' );
define( 'DB_HOST',     getenv('WORDPRESS_DB_HOST') ?: 'localhost' );
define( 'DB_CHARSET',  'utf8' );
define( 'DB_COLLATE',  '' );

// ... 其他 WordPress 預設設定 ...

$table_prefix = 'wp_';
define( 'WP_DEBUG', false );

if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}
require_once ABSPATH . 'wp-settings.php';
