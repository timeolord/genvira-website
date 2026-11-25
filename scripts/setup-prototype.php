<?php

if (!defined('WP_CLI') || !WP_CLI) {
    exit;
}

function genvira_seed_record($record) {
    $existing = get_page_by_path($record['post_name'], OBJECT, $record['post_type']);
    if ($existing && get_post_meta($existing->ID, '_genvira_prototype', true) !== '1') {
        WP_CLI::error('An existing page or post uses ' . $record['post_name'] . '. Rename it before importing the prototype.');
    }
    if ($existing) {
        $record['ID'] = $existing->ID;
    }
    $record['post_status'] = 'publish';
    $record['meta_input']['_genvira_prototype'] = '1';
    $id = wp_insert_post(wp_slash($record), true);
    if (is_wp_error($id)) {
        WP_CLI::error($id->get_error_message());
    }
    return $id;
}

function genvira_seed_links($content) {
    $content = preg_replace_callback('/\{\{url:([a-z0-9-]*)\}\}/', fn($match) => esc_url(home_url('/' . ($match[1] ? $match[1] . '/' : ''))), $content);
    return preg_replace_callback('/\{\{asset:([a-z0-9.-]+)\}\}/', fn($match) => esc_url(content_url('/themes/genvira/assets/' . $match[1])), $content);
}

function genvira_seed_articles($directory, $categories) {
    $index = $directory . '/index.json';
    $json = is_readable($index) ? file_get_contents($index) : false;
    if ($json === false) {
        WP_CLI::error('Could not read the research updates index.');
    }
    try {
        $articles = json_decode($json, true, 512, JSON_THROW_ON_ERROR);
    } catch (JsonException $error) {
        WP_CLI::error('Invalid research updates index: ' . $error->getMessage());
    }
    if (!is_array($articles)) {
        WP_CLI::error('The research updates index must be keyed by post slug.');
    }
    foreach ($articles as $slug => $article) {
        if (!is_string($slug) || !preg_match('/^[a-z0-9]+(?:-[a-z0-9]+)*$/D', $slug) || !is_array($article)) {
            WP_CLI::error('Invalid research update slug or metadata: ' . $slug);
        }
        foreach (['title', 'category', 'date', 'excerpt'] as $field) {
            if (!is_string($article[$field] ?? null) || trim($article[$field]) === '') {
                WP_CLI::error('Missing or invalid ' . $field . ' for research update ' . $slug);
            }
        }
        if (!isset($categories[$article['category']])) {
            WP_CLI::error('Invalid category for research update ' . $slug);
        }
        $date = DateTimeImmutable::createFromFormat('Y-m-d H:i:s', $article['date']);
        if (!$date || $date->format('Y-m-d H:i:s') !== $article['date'] || !is_string($article['date_label'] ?? '')) {
            WP_CLI::error('Invalid date or date label for research update ' . $slug);
        }
        $file = $directory . '/' . $slug . '.html';
        $content = is_readable($file) ? file_get_contents($file) : false;
        if ($content === false || trim($content) === '') {
            WP_CLI::error('Missing or empty article body: ' . $file);
        }
        $articles[$slug]['content'] = genvira_seed_links(trim($content));
    }
    return $articles;
}

$theme_dir = get_theme_root() . '/genvira';
if (!is_file($theme_dir . '/style.css')) {
    WP_CLI::error('The genvira theme is missing from wp-content/themes.');
}

$categories = ['news' => 'Company news', 'publication' => 'Publication'];
$articles = genvira_seed_articles($theme_dir . '/content/updates', $categories);

$pages = [
    'home' => ['Home', 'OUR LEAD PROGRAM', 'Genvira is advancing GVB-2030, an investigational viral-vector therapeutic program for bladder cancer.'],
    'gvb-2030' => ['GVB-2030', 'OUR LEAD THERAPEUTIC PROGRAM', 'A viral-vector therapeutic program being developed for bladder cancer.'],
    'pipeline' => ['Our pipeline', 'PROGRAMS IN DEVELOPMENT', 'A focused lead program, supported by a broader pipeline of viral-vector therapeutics.'],
    'platform' => ['Our platform', 'THE ENGINEERING BEHIND OUR PROGRAMS', 'Viral-vector design, characterization, and development capabilities that support our therapeutic pipeline.'],
    'research' => ['Research & updates', 'PUBLICATIONS & COMPANY NEWS', 'Explore the publications behind our work and the collaborations moving it forward.'],
    'about' => ['About Genvira', 'RESEARCH ROOTS. THERAPEUTIC PURPOSE.', 'An Ottawa-based team advancing viral-vector engineering for therapeutic development.'],
    'team' => ['Our team', 'THE PEOPLE BEHIND GENVIRA', 'Meet our leadership, board of directors, and scientific and strategic advisors.'],
    'partnering' => ['Partnering', 'ADVANCING THROUGH COLLABORATION', 'Connect with Genvira about therapeutic programs, scientific collaboration, and strategic opportunities.'],
    'contact' => ['Contact us', 'LET’S TALK', 'Reach the Genvira team in Ottawa, Canada.'],
    'careers' => ['Careers', 'BUILD WITH US', 'Help bring viral engineering and therapeutic research together.'],
    'privacy' => ['Privacy', 'GENVIRA BIOSCIENCES', 'How we handle information when you visit our website or contact us.'],
];

$administrators = get_users(['role' => 'administrator', 'number' => 1, 'fields' => 'ID']);
$author = $administrators ? (int) $administrators[0] : 1;
$page_ids = [];
kses_remove_filters();
foreach ($pages as $slug => [$title, $eyebrow, $summary]) {
    $content_file = $theme_dir . '/content/' . $slug . '.html';
    $content = is_file($content_file) ? file_get_contents($content_file) : '';
    $content = genvira_seed_links($content);
    $page_ids[$slug] = genvira_seed_record([
        'post_type' => 'page', 'post_name' => $slug, 'post_title' => $title,
        'post_content' => $content, 'post_author' => $author,
        'meta_input' => ['_genvira_eyebrow' => $eyebrow, '_genvira_summary' => $summary],
    ]);
}

foreach ($articles as $slug => $article) {
    $category = term_exists($article['category'], 'category');
    if (!$category) {
        $category = wp_insert_term($categories[$article['category']], 'category', ['slug' => $article['category']]);
    }
    if (is_wp_error($category)) {
        WP_CLI::error($category->get_error_message());
    }
    genvira_seed_record([
        'post_type' => 'post', 'post_name' => $slug, 'post_title' => $article['title'],
        'post_content' => $article['content'], 'post_excerpt' => $article['excerpt'],
        'post_author' => $author, 'post_date' => $article['date'],
        'post_category' => [(int) $category['term_id']],
        'meta_input' => ['_genvira_date_label' => $article['date_label'] ?? ''],
    ]);
}
kses_init_filters();
switch_theme('genvira');
update_option('show_on_front', 'page');
update_option('page_on_front', $page_ids['home']);
update_option('blogname', 'Genvira Biosciences');
update_option('blogdescription', 'Viral engineering. Therapeutic purpose.');
update_option('permalink_structure', '/%postname%/');
flush_rewrite_rules(false);
WP_CLI::success('Genvira prototype ready: ' . count($page_ids) . ' pages and ' . count($articles) . ' research updates. Existing unrelated content was preserved.');
