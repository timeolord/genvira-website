<!doctype html>
<html <?php language_attributes(); ?>>
<head>
    <meta charset="<?php bloginfo('charset'); ?>">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <?php wp_head(); ?>
</head>
<body <?php body_class(); ?>>
<?php wp_body_open(); ?>
<a class="skip-link" href="#main">Skip to content</a>
<div class="prototype-strip">Website prototype <span aria-hidden="true">/</span> Public research and company information <a href="<?php echo esc_url(genvira_url('research')); ?>">Explore the research <span aria-hidden="true">↗</span></a></div>
<header class="site-header">
    <div class="shell header-inner">
        <a class="brand" href="<?php echo esc_url(genvira_url()); ?>" aria-label="Genvira Biosciences home"><img src="<?php echo esc_url(get_template_directory_uri() . '/assets/logo.svg'); ?>" width="216" height="60" alt="Genvira Biosciences"></a>
        <button class="menu-toggle" type="button" aria-expanded="false" aria-controls="site-navigation">Menu <span aria-hidden="true">☰</span></button>
        <nav id="site-navigation" class="site-nav" aria-label="Main navigation">
            <?php wp_nav_menu(['theme_location' => 'primary', 'container' => false, 'menu_class' => 'nav-links', 'fallback_cb' => 'genvira_navigation']); ?>
            <a class="button button-small button-outline" href="<?php echo esc_url(genvira_url('partnering')); ?>">Partner with us <span aria-hidden="true">↗</span></a>
        </nav>
    </div>
</header>
<main id="main">
