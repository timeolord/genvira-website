<?php

function genvira_setup() {
    add_theme_support('title-tag');
    add_theme_support('post-thumbnails');
    add_theme_support('responsive-embeds');
    add_theme_support('html5', ['search-form', 'gallery', 'caption', 'style', 'script']);
    register_nav_menus(['primary' => 'Primary navigation']);
}
add_action('after_setup_theme', 'genvira_setup');

function genvira_assets() {
    wp_enqueue_style('genvira', get_stylesheet_uri(), [], filemtime(get_template_directory() . '/style.css'));
    wp_enqueue_script('genvira', get_template_directory_uri() . '/assets/site.js', [], filemtime(get_template_directory() . '/assets/site.js'), ['in_footer' => true, 'strategy' => 'defer']);
}
add_action('wp_enqueue_scripts', 'genvira_assets');

function genvira_url($slug = '') {
    return home_url('/' . ($slug ? trim($slug, '/') . '/' : ''));
}

function genvira_navigation() {
    $links = ['gvb-2030' => 'GVB-2030', 'pipeline' => 'Pipeline', 'platform' => 'Platform', 'research' => 'Research & updates', 'about' => 'About'];
    echo '<ul class="nav-links">';
    foreach ($links as $slug => $label) {
        $current = is_page($slug) ? ' aria-current="page"' : '';
        echo '<li><a href="' . esc_url(genvira_url($slug)) . '"' . $current . '>' . esc_html($label) . '</a></li>';
    }
    echo '</ul>';
}

function genvira_meta_description() {
    $description = is_singular() ? get_post_meta(get_queried_object_id(), '_genvira_summary', true) : '';
    $description = $description ?: 'Genvira Biosciences is advancing GVB-2030 for bladder cancer through viral vector engineering in Ottawa, Canada.';
    echo '<meta name="description" content="' . esc_attr($description) . '">' . "\n";
}
add_action('wp_head', 'genvira_meta_description');

function genvira_latest_research($limit = 3) {
    $articles = new WP_Query(['post_type' => 'post', 'posts_per_page' => $limit, 'tax_query' => [['taxonomy' => 'category', 'field' => 'slug', 'terms' => ['news', 'publication']]], 'ignore_sticky_posts' => true]);
    while ($articles->have_posts()) {
        $articles->the_post();
        $categories = array_values(array_filter(get_the_category(), fn($category) => in_array($category->slug, ['news', 'publication'], true)));
        $kind = $categories ? $categories[0]->slug : 'publication';
        ?>
        <article class="research-entry" data-kind="<?php echo esc_attr($kind); ?>" data-year="<?php echo esc_attr(get_the_date('Y')); ?>">
            <div class="entry-meta"><span class="tag"><?php echo esc_html($categories[0]->name ?? 'Publication'); ?></span><time datetime="<?php echo esc_attr(get_the_date('c')); ?>"><?php echo esc_html(get_post_meta(get_the_ID(), '_genvira_date_label', true) ?: get_the_date('j M Y')); ?></time></div>
            <h3><a href="<?php the_permalink(); ?>"><?php the_title(); ?></a></h3>
            <p><?php echo esc_html(get_the_excerpt()); ?></p>
            <a class="text-link" href="<?php the_permalink(); ?>">Read <?php echo $kind === 'news' ? 'update' : 'publication'; ?> <span aria-hidden="true">↗</span></a>
        </article>
        <?php
    }
    wp_reset_postdata();
}
