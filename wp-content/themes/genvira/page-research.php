<?php get_header(); ?>
<section class="page-hero"><div class="shell"><p class="eyebrow">PUBLICATIONS & COMPANY NEWS</p><h1>Research & updates</h1><p class="page-intro">Explore the publications behind our work and the collaborations moving it forward.</p></div></section>
<section class="section shell" aria-label="Research archive">
    <div class="research-tools" data-research-controls hidden><div class="filter-group" role="group" aria-label="Filter by type"><button type="button" data-filter="all" aria-pressed="true">All updates</button><button type="button" data-filter="publication" aria-pressed="false">Publications</button><button type="button" data-filter="news" aria-pressed="false">Company news</button></div><label class="search-label">Search research<input type="search" id="research-search" placeholder="Search by title or topic"></label></div>
    <p class="filter-status small" aria-live="polite" data-filter-status></p>
    <div class="research-grid research-archive"><?php genvira_latest_research(30); ?></div>
    <p class="empty-results" hidden>No matching updates. Try another search or choose All updates.</p>
    <p class="source-note">These publications are listed in Genvira’s public research archive. They are not clinical results for GVB-2030. <a href="https://genvira.com/pages/key-publications">View the original bibliography</a>.</p>
</section>
<?php get_footer(); ?>
