TRUNCATE TABLE wp_users;
TRUNCATE TABLE wp_usermeta;
TRUNCATE TABLE wp_comments;
TRUNCATE TABLE wp_commentmeta;
TRUNCATE TABLE wp_links;
TRUNCATE TABLE wp_termmeta;

DELETE FROM wp_posts
WHERE post_type = 'revision'
   OR post_status IN ('auto-draft', 'trash', 'private')
   OR post_password <> '';

UPDATE wp_posts SET post_author = 1, post_password = '', post_content_filtered = '', comment_count = 0;

DELETE FROM wp_postmeta
WHERE post_id NOT IN (SELECT ID FROM wp_posts)
   OR meta_key NOT IN ('_wp_page_template', '_thumbnail_id', '_wp_attached_file', '_wp_attachment_metadata', '_wp_attachment_image_alt');

DELETE FROM wp_term_relationships WHERE object_id NOT IN (SELECT ID FROM wp_posts);

DELETE FROM wp_options
WHERE option_name NOT IN (
    'siteurl', 'home', 'blogname', 'blogdescription', 'admin_email',
    'blog_public', 'timezone_string', 'gmt_offset', 'date_format', 'time_format',
    'start_of_week', 'WPLANG', 'permalink_structure', 'category_base', 'tag_base',
    'show_on_front', 'page_on_front', 'page_for_posts', 'posts_per_page',
    'posts_per_rss', 'rss_use_excerpt', 'default_category', 'default_post_format',
    'default_comment_status', 'default_ping_status', 'thread_comments',
    'thread_comments_depth', 'page_comments', 'comments_per_page',
    'default_comments_page', 'comment_order', 'close_comments_for_old_posts',
    'close_comments_days_old', 'require_name_email', 'comment_registration',
    'comment_moderation', 'comment_previously_approved',
    'template', 'stylesheet', 'current_theme', 'active_plugins', 'sidebars_widgets',
    'wp_user_roles', 'db_version', 'initial_db_version',
    'wp_page_for_privacy_policy', 'thumbnail_size_w', 'thumbnail_size_h',
    'thumbnail_crop', 'medium_size_w', 'medium_size_h', 'large_size_w', 'large_size_h',
    'uploads_use_yearmonth_folders', 'image_default_align', 'image_default_link_type',
    'image_default_size', 'html_type', 'blog_charset'
)
AND option_name NOT LIKE 'theme\_mods\_%'
AND option_name NOT LIKE 'widget\_%';

UPDATE wp_options SET option_value = 'prototype@example.invalid' WHERE option_name = 'admin_email';
