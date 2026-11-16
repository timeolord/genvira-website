# Genvira website prototype

## Direction

The prototype follows the supplied email: GVB-2030 first, distinct program and platform pages, a readable pipeline, source-linked publications and news, and a secondary research-tools page. Competitor page inventories and retrieval limits are in the two reference review documents beside this file.

CG Oncology informed the direct disease and lead-program hierarchy, restrained navigation, separated scientific illustrations, and dated research. Transgene informed the product-first ordering. Nouscom informed the distinction between technology and candidates. Arrakis's toolkit distinction was useful; its brand narrative and animated transitions were not carried over. No competitor imagery, layouts, or copy were copied.

## Brand

The original logo is `wp-content/themes/genvira/assets/logo.svg`, retrieved from https://genvira.com/cdn/shop/files/genvira.svg?v=1734045026 on 12 November 2026.

| Role | Colour |
| --- | --- |
| Logo cyan and main accent | `#00afef` |
| Logo green | `#00a859` |
| Logo violet | `#3e4095` |
| Logo magenta | `#eb288f` |
| Logo orange | `#f69734` |
| Logo red | `#ec3438` |
| Supporting dark ink | `#102f43` |
| Hero background | `#062b40` |
| Supporting pale background | `#f0f6f7` |

Dark ink and pale backgrounds are supporting colours, not extracted logo colours. Bright cyan is used for emphasis on dark backgrounds and surfaces; small links use a darker cyan for legibility. The original multicolour logo is preserved. Manrope is self-hosted; its license is bundled with the theme.

## Content sources

Reviewed 12 November 2026. Facts are paraphrased, and source links are present alongside the relevant website sections.

| Content | Primary source |
| --- | --- |
| GVB-2030 focus and next development goal | https://genvira.com/pages/about |
| Program names, modalities, published stages | https://genvira.com/pages/pipeline and its linked pipeline graphic |
| Vector engineering and assays | https://genvira.com/ |
| Company origin | https://genvira.com/pages/company-history-1 |
| Leadership, board, advisors | https://genvira.com/pages/team |
| Research bibliography | https://genvira.com/pages/key-publications |
| OX40L publication | https://doi.org/10.1084/jem.20221166 |
| NET-1 and UNC-5B publication | https://doi.org/10.1007/s00249-023-01644-1 |
| Viral distribution review | https://doi.org/10.2147/OV.S137159 |
| Melanoma collaboration | https://genvira.com/blogs/news/genvira-and-labskin-receive-1-2-million-2-0-million-uk-canada-collaboration-award-to-advance-immunotherapies-for-malignant-melanoma |
| Research-tools offering | https://genvira.com/pages/sars-cov-2-spike-vsv-based-pseudovirus |
| Contact and careers | https://genvira.com/pages/contact and https://genvira.com/pages/careers |

GVB-2030 remains labelled IND-enabling, as in the public pipeline. First-in-human development is described as a goal, with no trial-enrollment claim. The partnered Phase 1 statement on the current company page is not presented as GVB-2030 clinical evidence. No unpublished results, efficacy statistics, clinical milestones, or new intellectual-property details were invented.

Publication cards show only the verified year when an exact publication day was not established. Internal WordPress ordering dates are not presented as exact bibliographic dates. Company news uses the actual announcement date. Publications are not described as clinical results for GVB-2030.

## Implementation

This is a classic WordPress theme. Pages and research articles are stored in WordPress and remain editable there. `wp_dev prototype` seeds the authored HTML from the theme and activates it. It is explicit and repeatable, preserves unrelated content, and refuses unmarked slug collisions. Re-running it replaces the seeded pages and articles, so preserve editorial work first.

The pipeline is a semantic table that becomes a stacked layout on small screens. The platform uses ordinary buttons with keyboard controls. Research filters and search are local and do not require a service. Without JavaScript, navigation, all research entries, and all platform descriptions remain visible. No video, stock photographs, analytics, external font requests, or scroll-triggered content reveals are included.

The local privacy page describes only the prototype. Final public privacy and medical/regulatory copy depend on the eventual hosting and approved scientific content.

## Verification

The browser checks cover twelve pages at 1440 px desktop and 390 px mobile widths, four research detail pages, responsive overflow, image loading, heading structure, menu open and Escape behavior, platform steps, research type filters, search with no results, contact topic links, a JavaScript-disabled fallback, and a real 404 response. The script and its Nix QA environment are documented in the root README.

The sanitized SQL was imported into a temporary database. Checks confirmed all eleven page summaries, fifteen prototype content markers, the selected theme, four queryable research posts, and creation of a fresh administrator with ID 1. Checksums confirmed that the restore test did not change the working database.

Browser captures of the actual WordPress theme: [desktop homepage](../wp-content/themes/genvira/screenshot.png), [mobile homepage](prototype-mobile.png), and [mobile pipeline](pipeline-mobile.png).

## CEO illustration update, 16 November 2026

The homepage now shows a bladder-wall section with a tumor extending through the lining and connective tissue into muscle, rather than only an isolated viral vector. The illustration includes an anatomical bladder inset, cyan viral-vector symbols, and a tertiary lymphoid structure (TLS) with B-cell and T-cell groups. TLS was interpreted as tertiary lymphoid structures in this oncology context.

The GVB-2030 page repeats the schematic and explains its disease context in readable text. Stage II is used as the concrete example of muscle invasion beyond stages 0 and I, following the [National Cancer Institute staging description](https://www.cancer.gov/types/bladder/stages). This does not relabel every stage beyond I as metastatic or establish a clinical eligibility criterion for GVB-2030. The program's public indication and IND-enabling development status remain as previously sourced.

TLS are presented as organized immune-cell groups that can occur in tumor-associated tissue, with [primary bladder cancer research](https://doi.org/10.1038/s41416-024-02598-7) linked for background. Their presence in the schematic does not assert that GVB-2030 induces TLS or has shown a TLS-related clinical outcome. The illustration is original SVG artwork, not a reproduction of the supplied screenshot, a histology image, or experimental data.

The updated [program-page preview](tumor-context-desktop.png) shows the staging explanation and diagram together. Desktop and mobile browser checks and the static-export link checks passed for this update.

The follow-up TLS reference informed the revised cell arrangement: a central green B-cell follicle with a surrounding cyan T-cell region. The SVG description and legend use those same labels. The TLS shows the cells without shaded backgrounds or dotted boundaries, and viral-vector symbols are circular. This remains a simplified two-zone schematic rather than a complete inventory of the cell types in a mature TLS.

The dedicated Team page restores the full biographies and portraits from Genvira’s existing team page, grouped into leadership, directors, and advisors. Team is a primary navigation item, with an introduction from About and a footer link. All biographies remain visible without JavaScript.
