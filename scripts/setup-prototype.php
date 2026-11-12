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

$theme_dir = get_theme_root() . '/genvira';
if (!is_file($theme_dir . '/style.css')) {
    WP_CLI::error('The genvira theme is missing from wp-content/themes.');
}

$pages = [
    'home' => ['Home', 'OUR LEAD PROGRAM', 'Genvira is advancing GVB-2030, an investigational viral-vector therapeutic program for bladder cancer.'],
    'gvb-2030' => ['GVB-2030', 'OUR LEAD THERAPEUTIC PROGRAM', 'A viral-vector therapeutic program being developed for bladder cancer.'],
    'pipeline' => ['Our pipeline', 'PROGRAMS IN DEVELOPMENT', 'A focused lead program, supported by a broader pipeline of viral-vector therapeutics.'],
    'platform' => ['Our platform', 'THE ENGINEERING BEHIND OUR PROGRAMS', 'Viral-vector design, characterization, and development capabilities that support our therapeutic pipeline.'],
    'research' => ['Research & updates', 'PUBLICATIONS & COMPANY NEWS', 'Explore the publications behind our work and the collaborations moving it forward.'],
    'about' => ['About Genvira', 'RESEARCH ROOTS. THERAPEUTIC PURPOSE.', 'An Ottawa-based team advancing viral-vector engineering for therapeutic development.'],
    'partnering' => ['Partnering', 'ADVANCING THROUGH COLLABORATION', 'Connect with Genvira about therapeutic programs, scientific collaboration, and strategic opportunities.'],
    'contact' => ['Contact us', 'LET’S TALK', 'Reach the Genvira team in Ottawa, Canada.'],
    'research-tools' => ['Research tools', 'TOOLS FOR RESEARCH', 'A separate research offering built on our viral-vector expertise.'],
    'careers' => ['Careers', 'BUILD WITH US', 'Help bring viral engineering and therapeutic research together.'],
    'privacy' => ['Prototype privacy information', 'LOCAL WEBSITE PROTOTYPE', 'How this prototype handles contact links and local WordPress access.'],
];

$administrators = get_users(['role' => 'administrator', 'number' => 1, 'fields' => 'ID']);
$author = $administrators ? (int) $administrators[0] : 1;
$page_ids = [];
kses_remove_filters();
foreach ($pages as $slug => [$title, $eyebrow, $summary]) {
    $content_file = $theme_dir . '/content/' . $slug . '.html';
    $content = is_file($content_file) ? file_get_contents($content_file) : '';
    $content = preg_replace_callback('/\{\{url:([a-z0-9-]*)\}\}/', fn($match) => esc_url(home_url('/' . ($match[1] ? $match[1] . '/' : ''))), $content);
    $content = preg_replace_callback('/\{\{asset:([a-z0-9.-]+)\}\}/', fn($match) => esc_url(content_url('/themes/genvira/assets/' . $match[1])), $content);
    $page_ids[$slug] = genvira_seed_record([
        'post_type' => 'page', 'post_name' => $slug, 'post_title' => $title,
        'post_content' => $content, 'post_author' => $author,
        'meta_input' => ['_genvira_eyebrow' => $eyebrow, '_genvira_summary' => $summary],
    ]);
}

$articles = [
    [
        'slug' => 'melanoma-research-collaboration', 'category' => 'news', 'label' => 'Company news',
        'title' => 'A UK–Canada collaboration to advance melanoma research', 'date' => '2025-08-01 12:00:00', 'date_label' => '1 Aug 2025',
        'excerpt' => 'Genvira, Labskin, and NRC announce a collaboration supported by up to £1.2 million ($2.0 million) in funding.',
        'content' => '<p>Genvira, Labskin Limited, and the National Research Council of Canada announced a collaborative project to develop immunotherapy approaches for malignant melanoma.</p><p>The project is supported by advisory services and up to £1.2 million ($2.0 million) through the Canada–UK Biomanufacturing of Biologics and Advanced Therapies program.</p><p>Support is provided through Innovate UK in the United Kingdom and NRC programs in Canada. The announcement describes a research collaboration, not clinical efficacy results.</p><p><a class="button" href="https://genvira.com/blogs/news/genvira-and-labskin-receive-1-2-million-2-0-million-uk-canada-collaboration-award-to-advance-immunotherapies-for-malignant-melanoma">Read the original announcement ↗</a></p>',
    ],
    [
        'slug' => 'ox40l-vaccinia-antitumor-immunity', 'category' => 'publication', 'label' => 'Publication',
        'title' => 'OX40L-expressing recombinant modified vaccinia virus Ankara induces potent antitumor immunity via reprogramming Tregs', 'date' => '2023-08-01 12:00:00', 'date_label' => '2023',
        'excerpt' => 'Journal of Experimental Medicine · Research on an engineered vaccinia virus and antitumor immunity.',
        'content' => '<p class="publication-meta">Yang N, Wang Y, Liu S, et al.<br>Journal of Experimental Medicine. 2023;220(8):e20221166.<br>DOI: 10.1084/jem.20221166</p><p>This paper is listed in Genvira’s public bibliography. It examines an OX40L-expressing modified vaccinia virus Ankara and antitumor immune responses.</p><p>This publication is not a clinical report on GVB-2030. Consult the original paper for its experimental methods, findings, and limitations.</p><p><a class="button" href="https://doi.org/10.1084/jem.20221166">Read the paper ↗</a></p><p><a href="https://pubmed.ncbi.nlm.nih.gov/37145142/">View on PubMed</a> · <a href="https://genvira.com/pages/key-publications">Genvira bibliography</a></p>',
    ],
    [
        'slug' => 'net1-unc5b-characterization', 'category' => 'publication', 'label' => 'Publication',
        'title' => 'Investigation of dynamic solution interactions between NET-1 and UNC-5B by multi-wavelength analytical ultracentrifugation', 'date' => '2023-07-01 12:00:00', 'date_label' => '2023',
        'excerpt' => 'European Biophysics Journal · Biophysical characterization of protein interactions.',
        'content' => '<p class="publication-meta">Gabir H, Gupta M, Meier M, et al.<br>European Biophysics Journal. 2023;52:473–481.<br>DOI: 10.1007/s00249-023-01644-1</p><p>This study examines the solution behavior and interactions of NET-1 and its receptor UNC-5B using analytical ultracentrifugation. Genvira appears among the author affiliations.</p><p>It is included as research from Genvira’s public bibliography, not evidence of clinical benefit for a therapeutic candidate.</p><p><a class="button" href="https://doi.org/10.1007/s00249-023-01644-1">Read the paper ↗</a></p><p><a href="https://pubmed.ncbi.nlm.nih.gov/36939874/">View on PubMed</a></p>',
    ],
    [
        'slug' => 'imaging-oncolytic-virus-distribution', 'category' => 'publication', 'label' => 'Publication',
        'title' => 'The importance of imaging strategies for pre-clinical and clinical in vivo distribution of oncolytic viruses', 'date' => '2018-01-01 12:00:00', 'date_label' => '2018',
        'excerpt' => 'Oncolytic Virotherapy · A review of imaging approaches for studying viral distribution.',
        'content' => '<p class="publication-meta">Pelin A, Wang J, Bell J, Le Boeuf F.<br>Oncolytic Virotherapy. 2018;7:25–35.<br>DOI: 10.2147/OV.S137159</p><p>This review discusses imaging strategies for understanding how oncolytic viruses distribute in preclinical and clinical settings.</p><p>The paper is included in Genvira’s public bibliography. It is a scientific review, not a clinical update for GVB-2030.</p><p><a class="button" href="https://doi.org/10.2147/OV.S137159">Read the paper ↗</a></p><p><a href="https://pubmed.ncbi.nlm.nih.gov/29637059/">View on PubMed</a></p>',
    ],
];

foreach ($articles as $article) {
    $category = term_exists($article['category'], 'category');
    if (!$category) {
        $category = wp_insert_term($article['label'], 'category', ['slug' => $article['category']]);
    }
    if (is_wp_error($category)) {
        WP_CLI::error($category->get_error_message());
    }
    genvira_seed_record([
        'post_type' => 'post', 'post_name' => $article['slug'], 'post_title' => $article['title'],
        'post_content' => $article['content'], 'post_excerpt' => $article['excerpt'],
        'post_author' => $author, 'post_date' => $article['date'],
        'post_category' => [(int) $category['term_id']],
        'meta_input' => ['_genvira_date_label' => $article['date_label']],
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
