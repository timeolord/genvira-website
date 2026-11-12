<?php get_header(); ?>
<?php while (have_posts()) : the_post(); the_content(); endwhile; ?>
<section class="section shell" aria-labelledby="latest-title">
    <div class="section-heading"><div><p class="eyebrow">RESEARCH & UPDATES</p><h2 id="latest-title">Science, with the evidence.</h2></div><a class="text-link" href="<?php echo esc_url(genvira_url('research')); ?>">All research & updates <span aria-hidden="true">↗</span></a></div>
    <div class="research-grid"><?php genvira_latest_research(); ?></div>
</section>
<?php get_footer(); ?>
