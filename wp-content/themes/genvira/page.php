<?php get_header(); ?>
<?php while (have_posts()) : the_post(); ?>
<section class="page-hero"><div class="shell"><a class="breadcrumb" href="<?php echo esc_url(genvira_url()); ?>">Home</a><span class="breadcrumb-separator" aria-hidden="true">/</span><span class="breadcrumb"><?php the_title(); ?></span><p class="eyebrow"><?php echo esc_html(get_post_meta(get_the_ID(), '_genvira_eyebrow', true) ?: 'GENVIRA BIOSCIENCES'); ?></p><h1><?php the_title(); ?></h1><p class="page-intro"><?php echo esc_html(get_post_meta(get_the_ID(), '_genvira_summary', true)); ?></p></div></section>
<div class="page-content"><?php the_content(); ?></div>
<?php endwhile; ?>
<?php get_footer(); ?>
