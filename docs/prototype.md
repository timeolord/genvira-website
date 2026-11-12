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

The browser checks cover eleven pages at 1440 px desktop and 390 px mobile widths, four research detail pages, responsive overflow, image loading, heading structure, menu open and Escape behavior, platform steps, research type filters, search with no results, contact topic links, a JavaScript-disabled fallback, and a real 404 response. The script and its Nix QA environment are documented in the root README.

The sanitized SQL was imported into a temporary database. Checks confirmed all eleven page summaries, fifteen prototype content markers, the selected theme, four queryable research posts, and creation of a fresh administrator with ID 1. Checksums confirmed that the restore test did not change the working database.

Browser captures of the actual WordPress theme: [desktop homepage](../wp-content/themes/genvira/screenshot.png), [mobile homepage](prototype-mobile.png), and [mobile pipeline](pipeline-mobile.png).
