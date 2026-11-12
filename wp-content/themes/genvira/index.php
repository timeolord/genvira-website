<?php get_header(); ?>
<section class="section shell"><h1><?php echo is_search() ? 'Search results' : 'Updates'; ?></h1><?php if (have_posts()) : while (have_posts()) : the_post(); ?><article class="research-entry"><h2><a href="<?php the_permalink(); ?>"><?php the_title(); ?></a></h2><?php the_excerpt(); ?></article><?php endwhile; the_posts_pagination(); else : ?><p>No results found.</p><?php endif; ?></section>
<?php get_footer(); ?>
