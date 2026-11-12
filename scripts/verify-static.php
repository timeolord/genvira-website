<?php

$root = dirname(__DIR__) . '/dist/genvira';
$manifest = json_decode(file_get_contents($root . '/export-manifest.json'), true, flags: JSON_THROW_ON_ERROR);
$base = $manifest['base_path'];
$count = 0;
foreach (new RecursiveIteratorIterator(new RecursiveDirectoryIterator($root, FilesystemIterator::SKIP_DOTS)) as $file) {
    if (!$file->isFile()) {
        continue;
    }
    if (in_array(strtolower($file->getExtension()), ['php', 'sql', 'log'], true)) {
        throw new RuntimeException('A server file was included in the static export.');
    }
    if (!in_array($file->getExtension(), ['html', 'css', 'js', 'json', 'svg'], true)) {
        continue;
    }
    $text = file_get_contents($file->getPathname());
    if (preg_match('#https?://(?:localhost|127\.0\.0\.1)(?::\d+)?#', $text)) {
        throw new RuntimeException('A local server URL remains in the export.');
    }
    if ($file->getExtension() !== 'html') {
        continue;
    }
    $document = new DOMDocument();
    $previous = libxml_use_internal_errors(true);
    $document->loadHTML($text, LIBXML_NONET);
    libxml_clear_errors();
    libxml_use_internal_errors($previous);
    $xpath = new DOMXPath($document);
    foreach ($xpath->query('//*[@href or @src or @poster]') as $node) {
        foreach (['href', 'src', 'poster'] as $attribute) {
            $url = $node->getAttribute($attribute);
            if (!$url || $url[0] === '#' || preg_match('#^(?:[a-z][a-z0-9+.-]*:|//)#i', $url)) {
                continue;
            }
            $path = parse_url($url, PHP_URL_PATH);
            if (!str_starts_with($path, $base)) {
                throw new RuntimeException('A static link has the wrong deployment path: ' . $path);
            }
            $target = $root . '/' . rawurldecode(substr($path, strlen($base)));
            if (is_dir($target)) {
                $target .= '/index.html';
            }
            if (!is_file($target)) {
                throw new RuntimeException('A static link target is missing: ' . $path);
            }
        }
    }
    $count++;
}
foreach ($manifest['pages'] as $page) {
    if (!is_file($root . $page . 'index.html')) {
        throw new RuntimeException('An exported page is missing.');
    }
}
foreach ($manifest['assets'] as $asset) {
    if (!is_file($root . $asset)) {
        throw new RuntimeException('An exported asset is missing.');
    }
}
if (!is_file($root . '/licenses/OFL.txt') || !is_file($root . '/404.html') || !is_file($root . '/index.html')) {
    throw new RuntimeException('The export is missing required files.');
}
echo 'Verified ' . $count . ' HTML documents, all local links, assets, and deployment path ' . $base . PHP_EOL;
