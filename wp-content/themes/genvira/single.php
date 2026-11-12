<?php get_header(); ?>
<?php while (have_posts()) : the_post(); ?>
<article><header class="page-hero"><div class="shell article-width"><a class="text-link" href="<?php echo esc_url(genvira_url('research')); ?>">← Research & updates</a><p class="eyebrow"><?php echo esc_html(get_the_category()[0]->name ?? 'Research'); ?> <span aria-hidden="true">/</span> <time datetime="<?php echo esc_attr(get_the_date('c')); ?>"><?php echo esc_html(get_post_meta(get_the_ID(), '_genvira_date_label', true) ?: get_the_date('j F Y')); ?></time></p><h1><?php the_title(); ?></h1></div></header><div class="section shell article-width prose"><?php the_content(); ?></div></article>
<?php endwhile; ?>
<?php get_footer(); ?>
