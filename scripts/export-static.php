<?php

if (!defined('WP_CLI') || !WP_CLI) {
    exit;
}

function genvira_export_write($file, $content) {
    if (!is_dir(dirname($file)) && !mkdir(dirname($file), 0755, true)) {
        throw new RuntimeException('Could not create the export directory.');
    }
    if (file_put_contents($file, $content) === false) {
        throw new RuntimeException('Could not write ' . basename($file));
    }
}

function genvira_export_remove($path) {
    if (is_dir($path) && !is_link($path)) {
        foreach (new FilesystemIterator($path) as $entry) {
            genvira_export_remove($entry->getPathname());
        }
        rmdir($path);
    } elseif (file_exists($path) || is_link($path)) {
        unlink($path);
    }
}

function genvira_export_fetch($url, $expected_status = 200) {
    $response = wp_remote_get($url, ['timeout' => 30, 'redirection' => 0]);
    if (is_wp_error($response)) {
        throw new RuntimeException('Cannot fetch the running WordPress site: ' . $response->get_error_message());
    }
    if (wp_remote_retrieve_response_code($response) !== $expected_status) {
        throw new RuntimeException('Unexpected HTTP status for ' . wp_parse_url($url, PHP_URL_PATH));
    }
    return wp_remote_retrieve_body($response);
}

function genvira_export_resolve($value, $context) {
    if (str_starts_with($value, '//')) {
        $value = wp_parse_url($context, PHP_URL_SCHEME) . ':' . $value;
    } elseif (!preg_match('#^[a-z][a-z0-9+.-]*:#i', $value)) {
        $parts = wp_parse_url($context);
        $origin = $parts['scheme'] . '://' . $parts['host'] . (isset($parts['port']) ? ':' . $parts['port'] : '');
        $value = $origin . (str_starts_with($value, '/') ? $value : dirname($parts['path'] ?: '/') . '/' . $value);
    }
    $parts = wp_parse_url($value);
    if (!$parts) {
        throw new RuntimeException('An invalid URL was found in the prototype.');
    }
    $segments = [];
    foreach (explode('/', $parts['path'] ?? '/') as $segment) {
        if ($segment === '..') {
            array_pop($segments);
        } elseif ($segment !== '' && $segment !== '.') {
            $decoded = rawurldecode($segment);
            if (str_contains($decoded, '/') || str_contains($decoded, '\\') || str_contains($decoded, "\0") || in_array($decoded, ['.', '..'], true)) {
                throw new RuntimeException('Unsafe path in export.');
            }
            $segments[] = $segment;
        }
    }
    $parts['path'] = '/' . implode('/', $segments);
    return $parts;
}

function genvira_export_url($value, $context, &$state) {
    if ($value === '' || preg_match('/^(#|mailto:|tel:|data:)/i', $value)) {
        return $value;
    }
    $parts = genvira_export_resolve(html_entity_decode($value, ENT_QUOTES | ENT_HTML5, 'UTF-8'), $context);
    $origin = ($parts['scheme'] ?? '') . '://' . ($parts['host'] ?? '') . (isset($parts['port']) ? ':' . $parts['port'] : '');
    if ($origin !== $state['origin']) {
        return $value;
    }
    $path = $parts['path'];
    $page_path = rtrim($path, '/') . '/';
    $suffix = isset($parts['fragment']) ? '#' . $parts['fragment'] : '';
    if (isset($state['pages'][$page_path])) {
        if (!empty($parts['query'])) {
            throw new RuntimeException('Dynamic page queries cannot be exported: ' . $path);
        }
        return $state['base'] . ltrim($page_path, '/') . $suffix;
    }
    $extension = strtolower(pathinfo($path, PATHINFO_EXTENSION));
    if (!in_array($extension, ['css', 'js', 'svg', 'png', 'jpg', 'jpeg', 'webp', 'gif', 'avif', 'ico', 'woff', 'woff2', 'ttf', 'otf', 'pdf'], true)) {
        throw new RuntimeException('A local link is outside the public prototype export: ' . $path);
    }
    if (!isset($state['assets'][$path])) {
        $state['assets'][$path] = true;
        $source = $state['origin'] . $path . (isset($parts['query']) ? '?' . $parts['query'] : '');
        $body = genvira_export_fetch($source);
        if ($extension === 'css') {
            $body = genvira_export_css($body, $source, $state);
        }
        genvira_export_write($state['work'] . $path, $body);
    }
    return $state['base'] . ltrim($path, '/') . $suffix;
}

function genvira_export_css($css, $context, &$state) {
    $css = preg_replace_callback('/url\(\s*([\'"]?)(.*?)\1\s*\)/i', function ($match) use ($context, &$state) {
        return 'url("' . genvira_export_url($match[2], $context, $state) . '")';
    }, $css);
    return preg_replace_callback('/@import\s+([\'"])([^\'"]+)\1/i', function ($match) use ($context, &$state) {
        return '@import "' . genvira_export_url($match[2], $context, $state) . '"';
    }, $css);
}

function genvira_export_html($html, $context, &$state) {
    $document = new DOMDocument('1.0', 'UTF-8');
    $previous_errors = libxml_use_internal_errors(true);
    $document->loadHTML('<?xml encoding="UTF-8">' . $html, LIBXML_NONET);
    libxml_clear_errors();
    libxml_use_internal_errors($previous_errors);
    $xpath = new DOMXPath($document);
    foreach (iterator_to_array($xpath->query('//processing-instruction()')) as $node) {
        $node->parentNode->removeChild($node);
    }
    foreach (iterator_to_array($xpath->query('//link | //meta | //script')) as $node) {
        $rel = strtolower($node->getAttribute('rel'));
        $type = strtolower($node->getAttribute('type'));
        $id = $node->getAttribute('id');
        $remove = $node->nodeName === 'link' && (in_array($rel, ['canonical', 'shortlink', 'edituri', 'pingback', 'https://api.w.org/'], true) || ($rel === 'alternate' && in_array($type, ['application/json', 'application/rss+xml', 'application/atom+xml', 'application/json+oembed', 'text/xml+oembed'], true)));
        $remove = $remove || ($node->nodeName === 'meta' && in_array(strtolower($node->getAttribute('name')), ['generator', 'robots'], true));
        $remove = $remove || ($node->nodeName === 'script' && (str_starts_with($id, 'wp-emoji') || str_contains($node->textContent, 'wp-emoji-settings') || $type === 'speculationrules'));
        if ($remove) {
            $node->parentNode->removeChild($node);
        }
    }
    foreach ($xpath->query('//*[@href or @src or @poster or @srcset or @style]') as $node) {
        foreach (['href', 'src', 'poster'] as $attribute) {
            if ($node->hasAttribute($attribute)) {
                $node->setAttribute($attribute, genvira_export_url($node->getAttribute($attribute), $context, $state));
            }
        }
        if ($node->hasAttribute('srcset')) {
            $candidates = array_map(function ($candidate) use ($context, &$state) {
                $parts = preg_split('/\s+/', trim($candidate), 2);
                return genvira_export_url($parts[0], $context, $state) . (isset($parts[1]) ? ' ' . $parts[1] : '');
            }, explode(',', $node->getAttribute('srcset')));
            $node->setAttribute('srcset', implode(', ', $candidates));
        }
        if ($node->hasAttribute('style')) {
            $node->setAttribute('style', genvira_export_css($node->getAttribute('style'), $context, $state));
        }
    }
    foreach ($xpath->query('//style') as $node) {
        $node->nodeValue = genvira_export_css($node->textContent, $context, $state);
    }
    $robots = $document->createElement('meta');
    $robots->setAttribute('name', 'robots');
    $robots->setAttribute('content', 'noindex, nofollow');
    $document->getElementsByTagName('head')->item(0)->appendChild($robots);
    $output = $document->saveHTML();
    if (str_contains($output, $state['origin']) || str_contains($output, str_replace('/', '\\/', $state['origin']))) {
        throw new RuntimeException('An unresolved WordPress server URL remains in the exported HTML.');
    }
    return $output;
}

$root = getenv('WP_DEV_ROOT') ?: getcwd();
$base = $args[0] ?? '/genvira/';
if (!preg_match('#^/(?:[A-Za-z0-9_-]+/)*$#', $base)) {
    WP_CLI::error('Use a directory path with leading and trailing slashes, such as /genvira/ or /.');
}
if (get_stylesheet() !== 'genvira') {
    WP_CLI::error('Activate the genvira prototype theme before exporting.');
}
if (!class_exists('ZipArchive') || !class_exists('DOMDocument')) {
    WP_CLI::error('The exporter needs the PHP zip and DOM extensions, included in the Nix environment.');
}
$destination = $root . '/dist/genvira';
if (file_exists($destination) && (!is_dir($destination) || is_link($destination) || !is_file($destination . '/export-manifest.json') || (json_decode(file_get_contents($destination . '/export-manifest.json'), true)['format'] ?? '') !== 'genvira-static-v1')) {
    WP_CLI::error('dist/genvira already exists and is not a recognized generated export.');
}
$work = $root . '/.local/static-build-' . bin2hex(random_bytes(6));
$archive = $work . '.zip';
$home_parts = wp_parse_url(home_url('/'));
$origin = $home_parts['scheme'] . '://' . $home_parts['host'] . (isset($home_parts['port']) ? ':' . $home_parts['port'] : '');
if (!empty($home_parts['path']) && $home_parts['path'] !== '/') {
    WP_CLI::error('The WordPress source site must be installed at its domain root. The static destination may use any subdirectory.');
}
$state = ['origin' => $origin, 'base' => $base, 'work' => $work, 'pages' => ['/' => home_url('/')], 'assets' => []];
$pages = get_posts(['post_type' => 'page', 'post_status' => 'publish', 'numberposts' => -1, 'meta_key' => '_genvira_prototype', 'meta_value' => '1', 'has_password' => false]);
$articles = get_posts(['post_type' => 'post', 'post_status' => 'publish', 'numberposts' => -1, 'has_password' => false, 'tax_query' => [['taxonomy' => 'category', 'field' => 'slug', 'terms' => ['news', 'publication']]]]);
foreach (array_merge($pages, $articles) as $post) {
    $url = get_permalink($post);
    $state['pages'][rtrim(wp_parse_url($url, PHP_URL_PATH), '/') . '/'] = $url;
}
try {
    foreach ($state['pages'] as $path => $url) {
        $html = genvira_export_html(genvira_export_fetch($url), $url, $state);
        genvira_export_write($work . $path . 'index.html', $html);
    }
    $missing_url = $origin . '/genvira-export-missing-' . bin2hex(random_bytes(4)) . '/';
    genvira_export_write($work . '/404.html', genvira_export_html(genvira_export_fetch($missing_url, 404), $missing_url, $state));
    foreach (['OFL.txt', 'FONT-LICENSE.md'] as $license) {
        genvira_export_write($work . '/licenses/' . $license, file_get_contents(get_theme_root() . '/genvira/assets/' . $license));
    }
    $manifest = ['format' => 'genvira-static-v1', 'base_path' => $base, 'pages' => array_keys($state['pages']), 'assets' => array_keys($state['assets'])];
    genvira_export_write($work . '/export-manifest.json', wp_json_encode($manifest, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES) . "\n");
    $zip = new ZipArchive();
    if ($zip->open($archive, ZipArchive::CREATE | ZipArchive::OVERWRITE) !== true) {
        throw new RuntimeException('Could not create the static ZIP archive.');
    }
    foreach (new RecursiveIteratorIterator(new RecursiveDirectoryIterator($work, FilesystemIterator::SKIP_DOTS)) as $file) {
        $zip->addFile($file->getPathname(), 'genvira/' . substr($file->getPathname(), strlen($work) + 1));
    }
    $zip->close();
    if (!is_dir($root . '/dist')) {
        mkdir($root . '/dist', 0755, true);
    }
    genvira_export_remove($destination);
    rename($work, $destination);
    rename($archive, $root . '/dist/genvira-static.zip');
    WP_CLI::success('Exported ' . count($state['pages']) . ' pages and ' . count($state['assets']) . ' assets to dist/genvira with base path ' . $base);
    WP_CLI::log('Upload dist/genvira, or extract dist/genvira-static.zip.');
} catch (Throwable $error) {
    genvira_export_remove($work);
    genvira_export_remove($archive);
    WP_CLI::error($error->getMessage());
}
