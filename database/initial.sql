
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;
DROP TABLE IF EXISTS `wp_commentmeta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_commentmeta` (
  `meta_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `comment_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  `meta_key` varchar(255) DEFAULT NULL,
  `meta_value` longtext DEFAULT NULL,
  PRIMARY KEY (`meta_id`),
  KEY `comment_id` (`comment_id`),
  KEY `meta_key` (`meta_key`(191))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `wp_commentmeta` DISABLE KEYS */;
/*!40000 ALTER TABLE `wp_commentmeta` ENABLE KEYS */;
DROP TABLE IF EXISTS `wp_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_comments` (
  `comment_ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `comment_post_ID` bigint(20) unsigned NOT NULL DEFAULT 0,
  `comment_author` tinytext NOT NULL,
  `comment_author_email` varchar(100) NOT NULL DEFAULT '',
  `comment_author_url` varchar(200) NOT NULL DEFAULT '',
  `comment_author_IP` varchar(100) NOT NULL DEFAULT '',
  `comment_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `comment_date_gmt` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `comment_content` text NOT NULL,
  `comment_karma` int(11) NOT NULL DEFAULT 0,
  `comment_approved` varchar(20) NOT NULL DEFAULT '1',
  `comment_agent` varchar(255) NOT NULL DEFAULT '',
  `comment_type` varchar(20) NOT NULL DEFAULT 'comment',
  `comment_parent` bigint(20) unsigned NOT NULL DEFAULT 0,
  `user_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`comment_ID`),
  KEY `comment_post_ID` (`comment_post_ID`),
  KEY `comment_approved_date_gmt` (`comment_approved`,`comment_date_gmt`),
  KEY `comment_date_gmt` (`comment_date_gmt`),
  KEY `comment_parent` (`comment_parent`),
  KEY `comment_author_email` (`comment_author_email`(10))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `wp_comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `wp_comments` ENABLE KEYS */;
DROP TABLE IF EXISTS `wp_links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_links` (
  `link_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `link_url` varchar(255) NOT NULL DEFAULT '',
  `link_name` varchar(255) NOT NULL DEFAULT '',
  `link_image` varchar(255) NOT NULL DEFAULT '',
  `link_target` varchar(25) NOT NULL DEFAULT '',
  `link_description` varchar(255) NOT NULL DEFAULT '',
  `link_visible` varchar(20) NOT NULL DEFAULT 'Y',
  `link_owner` bigint(20) unsigned NOT NULL DEFAULT 1,
  `link_rating` int(11) NOT NULL DEFAULT 0,
  `link_updated` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `link_rel` varchar(255) NOT NULL DEFAULT '',
  `link_notes` mediumtext NOT NULL,
  `link_rss` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`link_id`),
  KEY `link_visible` (`link_visible`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `wp_links` DISABLE KEYS */;
/*!40000 ALTER TABLE `wp_links` ENABLE KEYS */;
DROP TABLE IF EXISTS `wp_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_options` (
  `option_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `option_name` varchar(191) NOT NULL DEFAULT '',
  `option_value` longtext NOT NULL,
  `autoload` varchar(20) NOT NULL DEFAULT 'yes',
  PRIMARY KEY (`option_id`),
  UNIQUE KEY `option_name` (`option_name`),
  KEY `autoload` (`autoload`)
) ENGINE=InnoDB AUTO_INCREMENT=175 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `wp_options` DISABLE KEYS */;
INSERT INTO `wp_options` VALUES (2,'siteurl','http://localhost:8080','on');
INSERT INTO `wp_options` VALUES (3,'home','http://localhost:8080','on');
INSERT INTO `wp_options` VALUES (4,'blogname','Genvira Biosciences','on');
INSERT INTO `wp_options` VALUES (5,'blogdescription','Viral engineering. Therapeutic purpose.','on');
INSERT INTO `wp_options` VALUES (7,'admin_email','prototype@example.invalid','on');
INSERT INTO `wp_options` VALUES (8,'start_of_week','1','on');
INSERT INTO `wp_options` VALUES (11,'require_name_email','1','on');
INSERT INTO `wp_options` VALUES (13,'posts_per_rss','10','on');
INSERT INTO `wp_options` VALUES (14,'rss_use_excerpt','0','on');
INSERT INTO `wp_options` VALUES (19,'default_category','1','on');
INSERT INTO `wp_options` VALUES (20,'default_comment_status','open','on');
INSERT INTO `wp_options` VALUES (21,'default_ping_status','open','on');
INSERT INTO `wp_options` VALUES (23,'posts_per_page','10','on');
INSERT INTO `wp_options` VALUES (24,'date_format','F j, Y','on');
INSERT INTO `wp_options` VALUES (25,'time_format','g:i a','on');
INSERT INTO `wp_options` VALUES (27,'comment_moderation','0','on');
INSERT INTO `wp_options` VALUES (29,'permalink_structure','/%postname%/','on');
INSERT INTO `wp_options` VALUES (32,'blog_charset','UTF-8','on');
INSERT INTO `wp_options` VALUES (34,'active_plugins','a:0:{}','on');
INSERT INTO `wp_options` VALUES (35,'category_base','','on');
INSERT INTO `wp_options` VALUES (38,'gmt_offset','0','on');
INSERT INTO `wp_options` VALUES (41,'template','genvira','on');
INSERT INTO `wp_options` VALUES (42,'stylesheet','genvira','on');
INSERT INTO `wp_options` VALUES (43,'comment_registration','0','on');
INSERT INTO `wp_options` VALUES (44,'html_type','text/html','on');
INSERT INTO `wp_options` VALUES (47,'db_version','61833','on');
INSERT INTO `wp_options` VALUES (48,'uploads_use_yearmonth_folders','1','on');
INSERT INTO `wp_options` VALUES (50,'blog_public','1','on');
INSERT INTO `wp_options` VALUES (52,'show_on_front','page','on');
INSERT INTO `wp_options` VALUES (53,'tag_base','','on');
INSERT INTO `wp_options` VALUES (57,'thumbnail_size_w','150','on');
INSERT INTO `wp_options` VALUES (58,'thumbnail_size_h','150','on');
INSERT INTO `wp_options` VALUES (59,'thumbnail_crop','1','on');
INSERT INTO `wp_options` VALUES (60,'medium_size_w','300','on');
INSERT INTO `wp_options` VALUES (61,'medium_size_h','300','on');
INSERT INTO `wp_options` VALUES (63,'large_size_w','1024','on');
INSERT INTO `wp_options` VALUES (64,'large_size_h','1024','on');
INSERT INTO `wp_options` VALUES (65,'image_default_link_type','none','on');
INSERT INTO `wp_options` VALUES (66,'image_default_size','','on');
INSERT INTO `wp_options` VALUES (67,'image_default_align','','on');
INSERT INTO `wp_options` VALUES (68,'close_comments_for_old_posts','0','on');
INSERT INTO `wp_options` VALUES (69,'close_comments_days_old','14','on');
INSERT INTO `wp_options` VALUES (70,'thread_comments','1','on');
INSERT INTO `wp_options` VALUES (71,'thread_comments_depth','5','on');
INSERT INTO `wp_options` VALUES (72,'page_comments','0','on');
INSERT INTO `wp_options` VALUES (73,'comments_per_page','50','on');
INSERT INTO `wp_options` VALUES (74,'default_comments_page','newest','on');
INSERT INTO `wp_options` VALUES (75,'comment_order','asc','on');
INSERT INTO `wp_options` VALUES (77,'widget_categories','a:0:{}','on');
INSERT INTO `wp_options` VALUES (78,'widget_text','a:0:{}','on');
INSERT INTO `wp_options` VALUES (79,'widget_rss','a:0:{}','on');
INSERT INTO `wp_options` VALUES (81,'timezone_string','','on');
INSERT INTO `wp_options` VALUES (82,'page_for_posts','0','on');
INSERT INTO `wp_options` VALUES (83,'page_on_front','6','on');
INSERT INTO `wp_options` VALUES (84,'default_post_format','0','on');
INSERT INTO `wp_options` VALUES (90,'wp_page_for_privacy_policy','3','on');
INSERT INTO `wp_options` VALUES (94,'comment_previously_approved','1','on');
INSERT INTO `wp_options` VALUES (102,'initial_db_version','61833','on');
INSERT INTO `wp_options` VALUES (103,'wp_user_roles','a:5:{s:13:\"administrator\";a:2:{s:4:\"name\";s:13:\"Administrator\";s:12:\"capabilities\";a:61:{s:13:\"switch_themes\";b:1;s:11:\"edit_themes\";b:1;s:16:\"activate_plugins\";b:1;s:12:\"edit_plugins\";b:1;s:10:\"edit_users\";b:1;s:10:\"edit_files\";b:1;s:14:\"manage_options\";b:1;s:17:\"moderate_comments\";b:1;s:17:\"manage_categories\";b:1;s:12:\"manage_links\";b:1;s:12:\"upload_files\";b:1;s:6:\"import\";b:1;s:15:\"unfiltered_html\";b:1;s:10:\"edit_posts\";b:1;s:17:\"edit_others_posts\";b:1;s:20:\"edit_published_posts\";b:1;s:13:\"publish_posts\";b:1;s:10:\"edit_pages\";b:1;s:4:\"read\";b:1;s:8:\"level_10\";b:1;s:7:\"level_9\";b:1;s:7:\"level_8\";b:1;s:7:\"level_7\";b:1;s:7:\"level_6\";b:1;s:7:\"level_5\";b:1;s:7:\"level_4\";b:1;s:7:\"level_3\";b:1;s:7:\"level_2\";b:1;s:7:\"level_1\";b:1;s:7:\"level_0\";b:1;s:17:\"edit_others_pages\";b:1;s:20:\"edit_published_pages\";b:1;s:13:\"publish_pages\";b:1;s:12:\"delete_pages\";b:1;s:19:\"delete_others_pages\";b:1;s:22:\"delete_published_pages\";b:1;s:12:\"delete_posts\";b:1;s:19:\"delete_others_posts\";b:1;s:22:\"delete_published_posts\";b:1;s:20:\"delete_private_posts\";b:1;s:18:\"edit_private_posts\";b:1;s:18:\"read_private_posts\";b:1;s:20:\"delete_private_pages\";b:1;s:18:\"edit_private_pages\";b:1;s:18:\"read_private_pages\";b:1;s:12:\"delete_users\";b:1;s:12:\"create_users\";b:1;s:17:\"unfiltered_upload\";b:1;s:14:\"edit_dashboard\";b:1;s:14:\"update_plugins\";b:1;s:14:\"delete_plugins\";b:1;s:15:\"install_plugins\";b:1;s:13:\"update_themes\";b:1;s:14:\"install_themes\";b:1;s:11:\"update_core\";b:1;s:10:\"list_users\";b:1;s:12:\"remove_users\";b:1;s:13:\"promote_users\";b:1;s:18:\"edit_theme_options\";b:1;s:13:\"delete_themes\";b:1;s:6:\"export\";b:1;}}s:6:\"editor\";a:2:{s:4:\"name\";s:6:\"Editor\";s:12:\"capabilities\";a:34:{s:17:\"moderate_comments\";b:1;s:17:\"manage_categories\";b:1;s:12:\"manage_links\";b:1;s:12:\"upload_files\";b:1;s:15:\"unfiltered_html\";b:1;s:10:\"edit_posts\";b:1;s:17:\"edit_others_posts\";b:1;s:20:\"edit_published_posts\";b:1;s:13:\"publish_posts\";b:1;s:10:\"edit_pages\";b:1;s:4:\"read\";b:1;s:7:\"level_7\";b:1;s:7:\"level_6\";b:1;s:7:\"level_5\";b:1;s:7:\"level_4\";b:1;s:7:\"level_3\";b:1;s:7:\"level_2\";b:1;s:7:\"level_1\";b:1;s:7:\"level_0\";b:1;s:17:\"edit_others_pages\";b:1;s:20:\"edit_published_pages\";b:1;s:13:\"publish_pages\";b:1;s:12:\"delete_pages\";b:1;s:19:\"delete_others_pages\";b:1;s:22:\"delete_published_pages\";b:1;s:12:\"delete_posts\";b:1;s:19:\"delete_others_posts\";b:1;s:22:\"delete_published_posts\";b:1;s:20:\"delete_private_posts\";b:1;s:18:\"edit_private_posts\";b:1;s:18:\"read_private_posts\";b:1;s:20:\"delete_private_pages\";b:1;s:18:\"edit_private_pages\";b:1;s:18:\"read_private_pages\";b:1;}}s:6:\"author\";a:2:{s:4:\"name\";s:6:\"Author\";s:12:\"capabilities\";a:10:{s:12:\"upload_files\";b:1;s:10:\"edit_posts\";b:1;s:20:\"edit_published_posts\";b:1;s:13:\"publish_posts\";b:1;s:4:\"read\";b:1;s:7:\"level_2\";b:1;s:7:\"level_1\";b:1;s:7:\"level_0\";b:1;s:12:\"delete_posts\";b:1;s:22:\"delete_published_posts\";b:1;}}s:11:\"contributor\";a:2:{s:4:\"name\";s:11:\"Contributor\";s:12:\"capabilities\";a:5:{s:10:\"edit_posts\";b:1;s:4:\"read\";b:1;s:7:\"level_1\";b:1;s:7:\"level_0\";b:1;s:12:\"delete_posts\";b:1;}}s:10:\"subscriber\";a:2:{s:4:\"name\";s:10:\"Subscriber\";s:12:\"capabilities\";a:2:{s:4:\"read\";b:1;s:7:\"level_0\";b:1;}}}','on');
INSERT INTO `wp_options` VALUES (106,'widget_block','a:6:{i:2;a:1:{s:7:\"content\";s:19:\"<!-- wp:search /-->\";}i:3;a:1:{s:7:\"content\";s:154:\"<!-- wp:group --><div class=\"wp-block-group\"><!-- wp:heading --><h2>Recent Posts</h2><!-- /wp:heading --><!-- wp:latest-posts /--></div><!-- /wp:group -->\";}i:4;a:1:{s:7:\"content\";s:227:\"<!-- wp:group --><div class=\"wp-block-group\"><!-- wp:heading --><h2>Recent Comments</h2><!-- /wp:heading --><!-- wp:latest-comments {\"displayAvatar\":false,\"displayDate\":false,\"displayExcerpt\":false} /--></div><!-- /wp:group -->\";}i:5;a:1:{s:7:\"content\";s:146:\"<!-- wp:group --><div class=\"wp-block-group\"><!-- wp:heading --><h2>Archives</h2><!-- /wp:heading --><!-- wp:archives /--></div><!-- /wp:group -->\";}i:6;a:1:{s:7:\"content\";s:150:\"<!-- wp:group --><div class=\"wp-block-group\"><!-- wp:heading --><h2>Categories</h2><!-- /wp:heading --><!-- wp:categories /--></div><!-- /wp:group -->\";}s:12:\"_multiwidget\";i:1;}','auto');
INSERT INTO `wp_options` VALUES (107,'sidebars_widgets','a:2:{s:19:\"wp_inactive_widgets\";a:5:{i:0;s:7:\"block-2\";i:1;s:7:\"block-3\";i:2;s:7:\"block-4\";i:3;s:7:\"block-5\";i:4;s:7:\"block-6\";}s:13:\"array_version\";i:3;}','auto');
INSERT INTO `wp_options` VALUES (108,'widget_pages','a:1:{s:12:\"_multiwidget\";i:1;}','auto');
INSERT INTO `wp_options` VALUES (109,'widget_calendar','a:1:{s:12:\"_multiwidget\";i:1;}','auto');
INSERT INTO `wp_options` VALUES (110,'widget_archives','a:1:{s:12:\"_multiwidget\";i:1;}','auto');
INSERT INTO `wp_options` VALUES (111,'widget_media_audio','a:1:{s:12:\"_multiwidget\";i:1;}','auto');
INSERT INTO `wp_options` VALUES (112,'widget_media_image','a:1:{s:12:\"_multiwidget\";i:1;}','auto');
INSERT INTO `wp_options` VALUES (113,'widget_media_gallery','a:1:{s:12:\"_multiwidget\";i:1;}','auto');
INSERT INTO `wp_options` VALUES (114,'widget_media_video','a:1:{s:12:\"_multiwidget\";i:1;}','auto');
INSERT INTO `wp_options` VALUES (115,'widget_meta','a:1:{s:12:\"_multiwidget\";i:1;}','auto');
INSERT INTO `wp_options` VALUES (116,'widget_search','a:1:{s:12:\"_multiwidget\";i:1;}','auto');
INSERT INTO `wp_options` VALUES (117,'widget_recent-posts','a:1:{s:12:\"_multiwidget\";i:1;}','auto');
INSERT INTO `wp_options` VALUES (118,'widget_recent-comments','a:1:{s:12:\"_multiwidget\";i:1;}','auto');
INSERT INTO `wp_options` VALUES (119,'widget_tag_cloud','a:1:{s:12:\"_multiwidget\";i:1;}','auto');
INSERT INTO `wp_options` VALUES (120,'widget_nav_menu','a:1:{s:12:\"_multiwidget\";i:1;}','auto');
INSERT INTO `wp_options` VALUES (121,'widget_custom_html','a:1:{s:12:\"_multiwidget\";i:1;}','auto');
INSERT INTO `wp_options` VALUES (150,'theme_mods_twentytwentyfive','a:2:{s:18:\"custom_css_post_id\";i:-1;s:16:\"sidebars_widgets\";a:2:{s:4:\"time\";i:1794501971;s:4:\"data\";a:3:{s:19:\"wp_inactive_widgets\";a:0:{}s:9:\"sidebar-1\";a:3:{i:0;s:7:\"block-2\";i:1;s:7:\"block-3\";i:2;s:7:\"block-4\";}s:9:\"sidebar-2\";a:2:{i:0;s:7:\"block-5\";i:1;s:7:\"block-6\";}}}}','off');
INSERT INTO `wp_options` VALUES (155,'current_theme','genvira','auto');
INSERT INTO `wp_options` VALUES (160,'theme_mods_genvira','a:2:{s:18:\"nav_menu_locations\";a:0:{}s:18:\"custom_css_post_id\";i:-1;}','auto');
/*!40000 ALTER TABLE `wp_options` ENABLE KEYS */;
DROP TABLE IF EXISTS `wp_postmeta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_postmeta` (
  `meta_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `post_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  `meta_key` varchar(255) DEFAULT NULL,
  `meta_value` longtext DEFAULT NULL,
  PRIMARY KEY (`meta_id`),
  KEY `post_id` (`post_id`),
  KEY `meta_key` (`meta_key`(191))
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `wp_postmeta` DISABLE KEYS */;
INSERT INTO `wp_postmeta` VALUES (1,2,'_wp_page_template','default');
INSERT INTO `wp_postmeta` VALUES (2,3,'_wp_page_template','default');
INSERT INTO `wp_postmeta` VALUES (3,6,'_genvira_eyebrow','OUR LEAD PROGRAM');
INSERT INTO `wp_postmeta` VALUES (4,6,'_genvira_summary','Genvira is advancing GVB-2030, an investigational viral-vector therapeutic program for bladder cancer.');
INSERT INTO `wp_postmeta` VALUES (5,6,'_genvira_prototype','1');
INSERT INTO `wp_postmeta` VALUES (6,7,'_genvira_eyebrow','OUR LEAD THERAPEUTIC PROGRAM');
INSERT INTO `wp_postmeta` VALUES (7,7,'_genvira_summary','A viral-vector therapeutic program being developed for bladder cancer.');
INSERT INTO `wp_postmeta` VALUES (8,7,'_genvira_prototype','1');
INSERT INTO `wp_postmeta` VALUES (9,8,'_genvira_eyebrow','PROGRAMS IN DEVELOPMENT');
INSERT INTO `wp_postmeta` VALUES (10,8,'_genvira_summary','A focused lead program, supported by a broader pipeline of viral-vector therapeutics.');
INSERT INTO `wp_postmeta` VALUES (11,8,'_genvira_prototype','1');
INSERT INTO `wp_postmeta` VALUES (12,9,'_genvira_eyebrow','THE ENGINEERING BEHIND OUR PROGRAMS');
INSERT INTO `wp_postmeta` VALUES (13,9,'_genvira_summary','Viral-vector design, characterization, and development capabilities that support our therapeutic pipeline.');
INSERT INTO `wp_postmeta` VALUES (14,9,'_genvira_prototype','1');
INSERT INTO `wp_postmeta` VALUES (15,10,'_genvira_eyebrow','PUBLICATIONS & COMPANY NEWS');
INSERT INTO `wp_postmeta` VALUES (16,10,'_genvira_summary','Explore the publications behind our work and the collaborations moving it forward.');
INSERT INTO `wp_postmeta` VALUES (17,10,'_genvira_prototype','1');
INSERT INTO `wp_postmeta` VALUES (18,11,'_genvira_eyebrow','RESEARCH ROOTS. THERAPEUTIC PURPOSE.');
INSERT INTO `wp_postmeta` VALUES (19,11,'_genvira_summary','An Ottawa-based team advancing viral-vector engineering for therapeutic development.');
INSERT INTO `wp_postmeta` VALUES (20,11,'_genvira_prototype','1');
INSERT INTO `wp_postmeta` VALUES (21,12,'_genvira_eyebrow','ADVANCING THROUGH COLLABORATION');
INSERT INTO `wp_postmeta` VALUES (22,12,'_genvira_summary','Connect with Genvira about therapeutic programs, scientific collaboration, and strategic opportunities.');
INSERT INTO `wp_postmeta` VALUES (23,12,'_genvira_prototype','1');
INSERT INTO `wp_postmeta` VALUES (24,13,'_genvira_eyebrow','LET’S TALK');
INSERT INTO `wp_postmeta` VALUES (25,13,'_genvira_summary','Reach the Genvira team in Ottawa, Canada.');
INSERT INTO `wp_postmeta` VALUES (26,13,'_genvira_prototype','1');
INSERT INTO `wp_postmeta` VALUES (30,15,'_genvira_eyebrow','BUILD WITH US');
INSERT INTO `wp_postmeta` VALUES (31,15,'_genvira_summary','Help bring viral engineering and therapeutic research together.');
INSERT INTO `wp_postmeta` VALUES (32,15,'_genvira_prototype','1');
INSERT INTO `wp_postmeta` VALUES (33,16,'_genvira_eyebrow','WEBSITE PRIVACY');
INSERT INTO `wp_postmeta` VALUES (34,16,'_genvira_summary','Information about email contact and links to external websites.');
INSERT INTO `wp_postmeta` VALUES (35,16,'_genvira_prototype','1');
INSERT INTO `wp_postmeta` VALUES (36,17,'_genvira_date_label','August 1, 2025');
INSERT INTO `wp_postmeta` VALUES (37,17,'_genvira_prototype','1');
INSERT INTO `wp_postmeta` VALUES (40,18,'_genvira_date_label','2023');
INSERT INTO `wp_postmeta` VALUES (41,18,'_genvira_prototype','1');
INSERT INTO `wp_postmeta` VALUES (44,19,'_genvira_date_label','2023');
INSERT INTO `wp_postmeta` VALUES (45,19,'_genvira_prototype','1');
INSERT INTO `wp_postmeta` VALUES (48,20,'_genvira_date_label','2018');
INSERT INTO `wp_postmeta` VALUES (49,20,'_genvira_prototype','1');
INSERT INTO `wp_postmeta` VALUES (52,23,'_genvira_prototype','1');
INSERT INTO `wp_postmeta` VALUES (53,23,'_genvira_eyebrow','THE PEOPLE BEHIND GENVIRA');
INSERT INTO `wp_postmeta` VALUES (54,23,'_genvira_summary','Meet our leadership, board of directors, and scientific and strategic advisors.');
/*!40000 ALTER TABLE `wp_postmeta` ENABLE KEYS */;
DROP TABLE IF EXISTS `wp_posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_posts` (
  `ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `post_author` bigint(20) unsigned NOT NULL DEFAULT 0,
  `post_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `post_date_gmt` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `post_content` longtext NOT NULL,
  `post_title` text NOT NULL,
  `post_excerpt` text NOT NULL,
  `post_status` varchar(20) NOT NULL DEFAULT 'publish',
  `comment_status` varchar(20) NOT NULL DEFAULT 'open',
  `ping_status` varchar(20) NOT NULL DEFAULT 'open',
  `post_password` varchar(255) NOT NULL DEFAULT '',
  `post_name` varchar(200) NOT NULL DEFAULT '',
  `to_ping` text NOT NULL,
  `pinged` text NOT NULL,
  `post_modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `post_modified_gmt` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `post_content_filtered` longtext NOT NULL,
  `post_parent` bigint(20) unsigned NOT NULL DEFAULT 0,
  `guid` varchar(255) NOT NULL DEFAULT '',
  `menu_order` int(11) NOT NULL DEFAULT 0,
  `post_type` varchar(20) NOT NULL DEFAULT 'post',
  `post_mime_type` varchar(100) NOT NULL DEFAULT '',
  `comment_count` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`ID`),
  KEY `post_name` (`post_name`(191)),
  KEY `type_status_date` (`post_type`,`post_status`,`post_date`,`ID`),
  KEY `post_parent` (`post_parent`),
  KEY `post_author` (`post_author`),
  KEY `type_status_author` (`post_type`,`post_status`,`post_author`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `wp_posts` DISABLE KEYS */;
INSERT INTO `wp_posts` VALUES (1,1,'2026-11-12 16:04:14','2026-11-12 16:04:14','<!-- wp:paragraph -->\n<p>Welcome to WordPress. This is your first post. Edit or delete it, then start writing!</p>\n<!-- /wp:paragraph -->','Hello world!','','publish','open','open','','hello-world','','','2026-11-12 16:04:14','2026-11-12 16:04:14','',0,'http://localhost:8080/?p=1',0,'post','',0);
INSERT INTO `wp_posts` VALUES (2,1,'2026-11-12 16:04:14','2026-11-12 16:04:14','<!-- wp:paragraph -->\n<p>This is an example page. It\'s different from a blog post because it will stay in one place and will show up in your site navigation (in most themes). Most people start with an About page that introduces them to potential site visitors. It might say something like this:</p>\n<!-- /wp:paragraph -->\n\n<!-- wp:quote -->\n<blockquote class=\"wp-block-quote\">\n<!-- wp:paragraph -->\n<p>Hi there! I\'m a bike messenger by day, aspiring actor by night, and this is my website. I live in Los Angeles, have a great dog named Jack, and I like pi&#241;a coladas. (And gettin\' caught in the rain.)</p>\n<!-- /wp:paragraph -->\n</blockquote>\n<!-- /wp:quote -->\n\n<!-- wp:paragraph -->\n<p>...or something like this:</p>\n<!-- /wp:paragraph -->\n\n<!-- wp:quote -->\n<blockquote class=\"wp-block-quote\">\n<!-- wp:paragraph -->\n<p>The XYZ Doohickey Company was founded in 1971, and has been providing quality doohickeys to the public ever since. Located in Gotham City, XYZ employs over 2,000 people and does all kinds of awesome things for the Gotham community.</p>\n<!-- /wp:paragraph -->\n</blockquote>\n<!-- /wp:quote -->\n\n<!-- wp:paragraph -->\n<p>As a new WordPress user, you should go to <a href=\"http://localhost:8080/wp-admin/\">your dashboard</a> to delete this page and create new pages for your content. Have fun!</p>\n<!-- /wp:paragraph -->','Sample Page','','publish','closed','open','','sample-page','','','2026-11-12 16:04:14','2026-11-12 16:04:14','',0,'http://localhost:8080/?page_id=2',0,'page','',0);
INSERT INTO `wp_posts` VALUES (3,1,'2026-11-12 16:04:14','2026-11-12 16:04:14','<!-- wp:heading -->\n<h2 class=\"wp-block-heading\">Who we are</h2>\n<!-- /wp:heading -->\n<!-- wp:paragraph -->\n<p><strong class=\"privacy-policy-tutorial\">Suggested text: </strong>Our website address is: http://localhost:8080.</p>\n<!-- /wp:paragraph -->\n<!-- wp:heading -->\n<h2 class=\"wp-block-heading\">Comments</h2>\n<!-- /wp:heading -->\n<!-- wp:paragraph -->\n<p><strong class=\"privacy-policy-tutorial\">Suggested text: </strong>When visitors leave comments on the site we collect the data shown in the comments form, and also the visitor&#8217;s IP address and browser user agent string to help spam detection.</p>\n<!-- /wp:paragraph -->\n<!-- wp:paragraph -->\n<p>An anonymized string created from your email address (also called a hash) may be provided to the Gravatar service to see if you are using it. The Gravatar service privacy policy is available here: https://automattic.com/privacy/. After approval of your comment, your profile picture is visible to the public in the context of your comment.</p>\n<!-- /wp:paragraph -->\n<!-- wp:heading -->\n<h2 class=\"wp-block-heading\">Media</h2>\n<!-- /wp:heading -->\n<!-- wp:paragraph -->\n<p><strong class=\"privacy-policy-tutorial\">Suggested text: </strong>If you upload images to the website, you should avoid uploading images with embedded location data (EXIF GPS) included. Visitors to the website can download and extract any location data from images on the website.</p>\n<!-- /wp:paragraph -->\n<!-- wp:heading -->\n<h2 class=\"wp-block-heading\">Cookies</h2>\n<!-- /wp:heading -->\n<!-- wp:paragraph -->\n<p><strong class=\"privacy-policy-tutorial\">Suggested text: </strong>If you leave a comment on our site you may opt-in to saving your name, email address and website in cookies. These are for your convenience so that you do not have to fill in your details again when you leave another comment. These cookies will last for one year.</p>\n<!-- /wp:paragraph -->\n<!-- wp:paragraph -->\n<p>If you visit our login page, we will set a temporary cookie to determine if your browser accepts cookies. This cookie contains no personal data and is discarded when you close your browser.</p>\n<!-- /wp:paragraph -->\n<!-- wp:paragraph -->\n<p>When you log in, we will also set up several cookies to save your login information and your screen display choices. Login cookies last for two days, and screen options cookies last for a year. If you select &quot;Remember Me&quot;, your login will persist for two weeks. If you log out of your account, the login cookies will be removed.</p>\n<!-- /wp:paragraph -->\n<!-- wp:paragraph -->\n<p>If you edit or publish an article, an additional cookie will be saved in your browser. This cookie includes no personal data and simply indicates the post ID of the article you just edited. It expires after 1 day.</p>\n<!-- /wp:paragraph -->\n<!-- wp:heading -->\n<h2 class=\"wp-block-heading\">Embedded content from other websites</h2>\n<!-- /wp:heading -->\n<!-- wp:paragraph -->\n<p><strong class=\"privacy-policy-tutorial\">Suggested text: </strong>Articles on this site may include embedded content (e.g. videos, images, articles, etc.). Embedded content from other websites behaves in the exact same way as if the visitor has visited the other website.</p>\n<!-- /wp:paragraph -->\n<!-- wp:paragraph -->\n<p>These websites may collect data about you, use cookies, embed additional third-party tracking, and monitor your interaction with that embedded content, including tracking your interaction with the embedded content if you have an account and are logged in to that website.</p>\n<!-- /wp:paragraph -->\n<!-- wp:heading -->\n<h2 class=\"wp-block-heading\">Who we share your data with</h2>\n<!-- /wp:heading -->\n<!-- wp:paragraph -->\n<p><strong class=\"privacy-policy-tutorial\">Suggested text: </strong>If you request a password reset, your IP address will be included in the reset email.</p>\n<!-- /wp:paragraph -->\n<!-- wp:heading -->\n<h2 class=\"wp-block-heading\">How long we retain your data</h2>\n<!-- /wp:heading -->\n<!-- wp:paragraph -->\n<p><strong class=\"privacy-policy-tutorial\">Suggested text: </strong>If you leave a comment, the comment and its metadata are retained indefinitely. This is so we can recognize and approve any follow-up comments automatically instead of holding them in a moderation queue.</p>\n<!-- /wp:paragraph -->\n<!-- wp:paragraph -->\n<p>For users that register on our website (if any), we also store the personal information they provide in their user profile. All users can see, edit, or delete their personal information at any time (except they cannot change their username). Website administrators can also see and edit that information.</p>\n<!-- /wp:paragraph -->\n<!-- wp:heading -->\n<h2 class=\"wp-block-heading\">What rights you have over your data</h2>\n<!-- /wp:heading -->\n<!-- wp:paragraph -->\n<p><strong class=\"privacy-policy-tutorial\">Suggested text: </strong>If you have an account on this site, or have left comments, you can request to receive an exported file of the personal data we hold about you, including any data you have provided to us. You can also request that we erase any personal data we hold about you. This does not include any data we are obliged to keep for administrative, legal, or security purposes.</p>\n<!-- /wp:paragraph -->\n<!-- wp:heading -->\n<h2 class=\"wp-block-heading\">Where your data is sent</h2>\n<!-- /wp:heading -->\n<!-- wp:paragraph -->\n<p><strong class=\"privacy-policy-tutorial\">Suggested text: </strong>Visitor comments may be checked through an automated spam detection service.</p>\n<!-- /wp:paragraph -->\n','Privacy Policy','','draft','closed','open','','privacy-policy','','','2026-11-12 16:04:14','2026-11-12 16:04:14','',0,'http://localhost:8080/?page_id=3',0,'page','',0);
INSERT INTO `wp_posts` VALUES (4,1,'2026-11-12 16:04:25','2026-11-12 16:04:25','<!-- wp:page-list /-->','Navigation','','publish','closed','closed','','navigation','','','2026-11-12 16:04:25','2026-11-12 16:04:25','',0,'http://localhost:8080/?p=4',0,'wp_navigation','',0);
INSERT INTO `wp_posts` VALUES (6,1,'2026-11-12 16:46:11','2026-11-12 16:46:11','<section class=\"home-hero\"><div class=\"shell hero-grid\"><div class=\"hero-copy\"><p class=\"eyebrow\"><span class=\"status-dot\"></span> OUR LEAD PROGRAM · GVB-2030</p><h1>Engineering a new approach to <span>bladder cancer.</span></h1><p>We’re advancing viral-vector therapeutics with a clear purpose: to bring new approaches to cancer treatment.</p><div class=\"button-row\"><a class=\"button button-cyan\" href=\"http://localhost:8080/gvb-2030/\">Explore GVB-2030 <span aria-hidden=\"true\">↗</span></a><a class=\"hero-text-link\" href=\"http://localhost:8080/pipeline/\">View our pipeline <span aria-hidden=\"true\">→</span></a></div></div><figure class=\"hero-visual\"><div class=\"visual-topline\"><span>BLADDER CANCER / IMMUNE ENVIRONMENT</span><span>01</span></div><img src=\"http://localhost:8080/wp-content/themes/genvira/assets/tumor-environment.svg\" alt=\"Conceptual bladder-wall section showing a tumor invading the muscle layer, nearby tertiary lymphoid structures (TLS), and viral vectors\" width=\"680\" height=\"560\"><figcaption>Muscle-invasive tumor · TLS · Viral vectors<br><span>Conceptual illustration, not experimental data.</span></figcaption></figure></div><div class=\"shell hero-facts\"><div><span>LEAD CANDIDATE</span><strong>GVB-2030</strong></div><div><span>THERAPEUTIC FOCUS</span><strong>Bladder cancer</strong></div><div><span>DEVELOPMENT STAGE</span><strong>IND-enabling studies</strong></div><a href=\"http://localhost:8080/gvb-2030/#development\">Program overview <span aria-hidden=\"true\">↗</span></a></div></section>\n<section class=\"section shell introduction\"><div><p class=\"eyebrow\">THERAPEUTICS FIRST</p><h2>One lead program.<br>A platform built<br>to go further.</h2></div><div><p class=\"large-copy\">GVB-2030 brings our viral engineering expertise into focus.</p><p>Our lead program is an engineered vaccinia virus being developed for bladder cancer. It is designed to deliver an immune-activating payload to the tumor environment.</p><p>Behind it is a broader development platform that brings vector design, characterization, and manufacturing considerations together.</p><a class=\"text-link\" href=\"http://localhost:8080/gvb-2030/\">Meet our lead program <span aria-hidden=\"true\">↗</span></a></div></section>\n<section class=\"platform-feature\"><div class=\"shell feature-grid\"><div class=\"feature-heading\"><p class=\"eyebrow\">OUR ENGINEERING PLATFORM</p><h2>From vector design<br>to therapeutic potential.</h2><p>We engineer the vector and evaluate how it performs, with translation in mind from the start.</p><a class=\"button button-outline\" href=\"http://localhost:8080/platform/\">Explore our platform <span aria-hidden=\"true\">↗</span></a></div><div class=\"capability-list\"><div><span class=\"step-number\">01</span><div><h3>Design & engineer</h3><p>Vector architecture, genetic stability, and payload design.</p></div><span class=\"capability-symbol cyan\" aria-hidden=\"true\">◎</span></div><div><span class=\"step-number\">02</span><div><h3>Measure & characterize</h3><p>Potency, durability, and immune activity assays.</p></div><span class=\"capability-symbol green\" aria-hidden=\"true\">⌁</span></div><div><span class=\"step-number\">03</span><div><h3>Develop for translation</h3><p>Process development and scalable manufacturing considerations.</p></div><span class=\"capability-symbol violet\" aria-hidden=\"true\">⤴</span></div></div></div></section>\n<section class=\"section shell company-note\"><p class=\"eyebrow\">BUILT IN OTTAWA. WORKING THROUGH COLLABORATION.</p><div><h2>Research roots.<br>A therapeutic focus.</h2><p>Genvira grew out of the Ottawa Hospital Research Institute. Today, our team brings viral engineering and translational research together to advance our own programs and work with partners.</p><a class=\"text-link\" href=\"http://localhost:8080/about/\">Get to know Genvira <span aria-hidden=\"true\">↗</span></a></div></section>\n<section aria-label=\"Supported by\"><ul class=\"shell supporter-list\" role=\"list\"><li><img src=\"http://localhost:8080/wp-content/themes/genvira/assets/supporter-feddev.png\" alt=\"FedDev Ontario\"></li><li><img src=\"http://localhost:8080/wp-content/themes/genvira/assets/supporter-ontario.svg\" alt=\"Government of Ontario\"></li><li><img src=\"http://localhost:8080/wp-content/themes/genvira/assets/supporter-mitacs.svg\" alt=\"Mitacs\"></li><li><img src=\"http://localhost:8080/wp-content/themes/genvira/assets/supporter-invest-ottawa.svg\" alt=\"Invest Ottawa\"></li><li><img src=\"http://localhost:8080/wp-content/themes/genvira/assets/supporter-obio.svg\" alt=\"OBIO\"></li></ul></section>\n','Home','','publish','closed','closed','','home','','','2026-11-16 14:48:57','2026-11-16 14:48:57','',0,'http://localhost:8080/?page_id=6',0,'page','',0);
INSERT INTO `wp_posts` VALUES (7,1,'2026-11-12 16:46:11','2026-11-12 16:46:11','<section class=\"section shell\"><div class=\"program-overview\"><div><span class=\"tag\">LEAD PROGRAM</span><h2>Engineering a vector<br>with a therapeutic purpose.</h2><p class=\"large-copy\">GVB-2030 is an investigational, engineered vaccinia virus program for bladder cancer.</p><p>The program is designed to carry cytokine payloads and engage the tumor environment. Our development work focuses on the vector, its biological activity, and the evidence needed to support further clinical development.</p></div><dl class=\"fact-panel\"><div><dt>Program</dt><dd>GVB-2030</dd></div><div><dt>Indication</dt><dd>Bladder cancer</dd></div><div><dt>Vector</dt><dd>Engineered vaccinia virus</dd></div><div><dt>Payload class</dt><dd>Cytokines</dd></div><div><dt>Published stage</dt><dd>IND-enabling studies</dd></div></dl></div></section>\n<section class=\"tinted-section\" id=\"tumor-environment\"><div class=\"section shell\"><p class=\"eyebrow\">THE TUMOR & ITS IMMUNE ENVIRONMENT</p><div class=\"section-heading\"><h2>Showing disease beyond<br>the bladder lining.</h2><p>A closer look at muscle-invasive disease<br>and the surrounding immune environment.</p></div><div class=\"tumor-context-grid\"><figure class=\"tumor-context-figure\"><img src=\"http://localhost:8080/wp-content/themes/genvira/assets/tumor-environment.svg\" alt=\"A bladder tumor extends through the lining and connective tissue into the muscle. Nearby, a tertiary lymphoid structure contains B-cell and T-cell zones, with viral-vector symbols shown separately.\" width=\"680\" height=\"560\" loading=\"lazy\"></figure><div class=\"tumor-context-copy\"><h3>Beyond stages 0 and I</h3><p>Stage 0 disease is confined to the lining. In stage I, the tumor has entered connective tissue but has not reached the muscle. Stage II disease involves the muscle layer; the illustration shows that deeper invasion.</p><dl class=\"tumor-context-definitions\"><div><dt>Tertiary lymphoid structures (TLS)</dt><dd>Organized groups of immune cells, including B cells and T cells, that can form in tumor-associated tissue.</dd></div><div><dt>Viral vectors</dt><dd>Shown alongside the tumor and immune environment to illustrate the components of viral-vector research.</dd></div></dl></div></div></div></section>\n<section class=\"tinted-section\" id=\"development\"><div class=\"shell section\"><p class=\"eyebrow\">DEVELOPMENT</p><div class=\"section-heading\"><h2>A clear next step.</h2><p>Building the evidence needed<br>for first-in-human evaluation.</p></div><ol class=\"development-steps\"><li><span>01</span><h3>Vector development</h3><p>Engineering and characterization of the candidate.</p></li><li class=\"current\"><span>02 · CURRENT PUBLIC STAGE</span><h3>IND-enabling studies</h3><p>Studies to support preparation for clinical development.</p></li><li><span>03 · NEXT DEVELOPMENT GOAL</span><h3>First-in-human studies</h3><p>Subject to completion of development work and applicable authorizations.</p></li></ol></div></section>\n<section class=\"section shell\"><div class=\"section-heading\"><div><p class=\"eyebrow\">THE DEVELOPMENT RATIONALE</p><h2>The vector is part of the therapy.</h2></div></div><div class=\"three-columns\"><div><span class=\"number-label\">01 / ENGINEER</span><h3>A modified viral vector</h3><p>GVB-2030 uses a highly modified vaccinia virus as its delivery vehicle.</p></div><div><span class=\"number-label\">02 / DELIVER</span><h3>An immune-activating payload</h3><p>Cytokine payloads are part of the publicly described program design.</p></div><div><span class=\"number-label\">03 / EVALUATE</span><h3>Evidence for the next stage</h3><p>Assays and development studies characterize how the candidate performs before clinical evaluation.</p></div></div><div class=\"button-row\"><a class=\"button\" href=\"http://localhost:8080/partnering/\">Discuss the program <span aria-hidden=\"true\">↗</span></a><a class=\"text-link\" href=\"http://localhost:8080/pipeline/\">See the full pipeline <span aria-hidden=\"true\">→</span></a></div></section>\n','GVB-2030','','publish','closed','closed','','gvb-2030','','','2026-11-16 14:48:57','2026-11-16 14:48:57','',0,'http://localhost:8080/?page_id=7',0,'page','',0);
INSERT INTO `wp_posts` VALUES (8,1,'2026-11-12 16:46:11','2026-11-12 16:46:11','<section class=\"section shell\"><div class=\"section-heading\"><div><p class=\"eyebrow\">THERAPEUTIC PROGRAMS</p><h2>Our programs, at a glance.</h2></div><p>Our candidates and their publicly<br>described development stages.</p></div><div class=\"pipeline-table-wrap\" tabindex=\"0\" role=\"region\" aria-label=\"Therapeutic pipeline table\"><table class=\"pipeline-table\" role=\"table\"><thead><tr><th scope=\"col\">Program</th><th scope=\"col\">Approach</th><th scope=\"col\">Focus</th><th scope=\"col\">Development status</th></tr></thead><tbody><tr class=\"lead-row\"><th scope=\"row\"><span class=\"tag\">LEAD PROGRAM</span><a href=\"http://localhost:8080/gvb-2030/\">GVB-2030 <span aria-hidden=\"true\">↗</span></a></th><td data-label=\"Approach\">Engineered vaccinia virus<br><span class=\"small\">Cytokine payloads</span></td><td data-label=\"Focus\">Bladder cancer</td><td data-label=\"Development status\"><span class=\"stage-label stage-current\">IND-enabling studies</span><p class=\"small\">Preparing for further clinical development</p></td></tr><tr><th scope=\"row\">GVB-2040</th><td data-label=\"Approach\">Personalized cancer vaccine</td><td data-label=\"Focus\">Oncology</td><td data-label=\"Development status\"><span class=\"stage-label\">Preclinical</span><p class=\"small\">Cell-line data</p></td></tr><tr><th scope=\"row\">GVB-2020</th><td data-label=\"Approach\">In vivo CAR-T / TCR-T approach</td><td data-label=\"Focus\">Oncology & immunology</td><td data-label=\"Development status\"><span class=\"stage-label\">Preclinical</span><p class=\"small\">Validated in cells; further details not disclosed</p></td></tr><tr><th scope=\"row\">GVB-2010</th><td data-label=\"Approach\">Additional therapeutic program</td><td data-label=\"Focus\">Colorectal cancer</td><td data-label=\"Development status\"><span class=\"stage-label\">Preclinical</span><p class=\"small\">Mouse-model studies complete</p></td></tr></tbody></table></div><div class=\"prose article-width\"><h2>Clinical development progress</h2><p>A partnered Phase 1 study evaluated a Genvira-engineered vector in a separate development program. We reported encouraging preliminary safety and efficacy signals from that study.</p><p><a href=\"http://localhost:8080/gvb-2030/\">GVB-2030</a>, our lead program for bladder cancer, is in IND-enabling studies. Our next goal is first-in-human evaluation. We are also developing the preclinical programs listed above.</p></div></section>\n<section class=\"tinted-section\"><div class=\"shell section split-section\"><div><p class=\"eyebrow\">THE PLATFORM BEHIND THE PIPELINE</p><h2>Products and capabilities.<br>Clearly connected.</h2></div><div><p>Our pipeline describes what we are developing. Our platform describes how we design vectors, measure their performance, and consider manufacturing.</p><a class=\"button button-outline\" href=\"http://localhost:8080/platform/\">Explore the engineering platform <span aria-hidden=\"true\">↗</span></a></div></div></section>\n','Our pipeline','','publish','closed','closed','','pipeline','','','2026-11-12 16:46:11','2026-11-12 16:46:11','',0,'http://localhost:8080/?page_id=8',0,'page','',0);
INSERT INTO `wp_posts` VALUES (9,1,'2026-11-12 16:46:11','2026-11-12 16:46:11','<section class=\"section shell\"><div class=\"split-section\"><div><p class=\"eyebrow\">VIRAL VECTOR ENGINEERING</p><h2>Designed together.<br>Evaluated together.</h2></div><div><p class=\"large-copy\">Vector architecture, payload design, biological performance, and manufacturing all inform therapeutic development.</p><p>Genvira designs, constructs, and characterizes RNA and DNA viral vectors. Our public platform description emphasizes genetic stability, immune activity, payload capacity, and scalable processes.</p></div></div></section>\n<section class=\"tinted-section\"><div class=\"section shell\" data-platform><div class=\"section-heading\"><div><p class=\"eyebrow\">EXPLORE THE WORKFLOW</p><h2>Three connected capabilities.</h2></div><p>Choose a step to explore the work<br>behind our therapeutic programs.</p></div><div class=\"platform-tabs\" role=\"group\" aria-label=\"Platform steps\"><button type=\"button\" data-step=\"design\" aria-pressed=\"true\">01 <span>Design & engineer</span></button><button type=\"button\" data-step=\"measure\" aria-pressed=\"false\">02 <span>Measure & characterize</span></button><button type=\"button\" data-step=\"translate\" aria-pressed=\"false\">03 <span>Develop for translation</span></button></div><div class=\"platform-panel\" data-panel=\"design\"><figure class=\"payload-diagram\" role=\"img\" aria-label=\"A viral vector carrying a therapeutic payload\"><div class=\"payload-vector\"><div class=\"payload-vector-label\">Viral vector</div><div class=\"payload-core\">Therapeutic<br>payload</div></div></figure><div><p class=\"eyebrow\">01 / DESIGN & ENGINEER</p><h3>Begin with the vector.</h3><p>We use vector engineering, in-house libraries, and AI/ML-guided design to explore genetic stability, payload design, and immune activity.</p><p>These choices create candidates that can be evaluated in the laboratory. Proprietary sequences and engineering methods remain outside this public overview.</p></div></div><div class=\"platform-panel\" data-panel=\"measure\"><figure class=\"assay-graphic\" role=\"img\" aria-label=\"Illustrative bars for potency, durability, and immune activity. Bar lengths do not represent assay values.\"><div class=\"assay-row\"><div>Potency</div></div><div class=\"assay-row\"><div>Durability</div></div><div class=\"assay-row\"><div>Immune activity</div></div></figure><div><p class=\"eyebrow\">02 / MEASURE & CHARACTERIZE</p><h3>Understand performance.</h3><p>Potency, durability, and immunogenicity assays help compare candidates and guide further development.</p><p>The goal is to connect vector design with measurable biological characteristics.</p></div></div><div class=\"platform-panel\" data-panel=\"translate\"><figure class=\"translation-graphic\" role=\"img\" aria-label=\"Development progresses from design through process development to scale-up\"><div class=\"translation-stage\"><span class=\"translation-icon translation-design\"></span><div>Design</div></div><div class=\"translation-stage\"><span class=\"translation-icon translation-process\"><i></i><i></i><i></i></span><div>Process</div></div><div class=\"translation-stage\"><span class=\"translation-icon translation-scale\"><i></i><i></i><i></i></span><div>Scale</div></div></figure><div><p class=\"eyebrow\">03 / DEVELOP FOR TRANSLATION</p><h3>Consider the path beyond discovery.</h3><p>Process development and manufacturing considerations inform how candidates move toward preclinical and partnered development.</p><p>We consider production yield and scale-up early in vector design, with the goal of developing processes suitable for future manufacturing under Good Manufacturing Practice (GMP).</p></div></div></div></section>\n<section class=\"section shell split-section\"><div><p class=\"eyebrow\">PUTTING THE PLATFORM TO WORK</p><h2>A foundation for<br>our therapeutic pipeline.</h2></div><div><p>GVB-2030 is our lead program, with additional preclinical candidates in development. Our team also collaborates with research and industry partners on viral-vector programs.</p><div class=\"button-row\"><a class=\"button\" href=\"http://localhost:8080/pipeline/\">View our pipeline <span aria-hidden=\"true\">↗</span></a><a class=\"text-link\" href=\"http://localhost:8080/partnering/\">Explore partnering <span aria-hidden=\"true\">→</span></a></div></div></section>\n','Our platform','','publish','closed','closed','','platform','','','2026-11-12 16:46:11','2026-11-12 16:46:11','',0,'http://localhost:8080/?page_id=9',0,'page','',0);
INSERT INTO `wp_posts` VALUES (10,1,'2026-11-12 16:46:11','2026-11-12 16:46:11','','Research & updates','','publish','closed','closed','','research','','','2026-11-12 16:46:11','2026-11-12 16:46:11','',0,'http://localhost:8080/?page_id=10',0,'page','',0);
INSERT INTO `wp_posts` VALUES (11,1,'2026-11-12 16:46:11','2026-11-12 16:46:11','<section class=\"section shell split-section\"><div><p class=\"eyebrow\">OUR COMPANY</p><h2>From research roots<br>to therapeutic development.</h2></div><div><p class=\"large-copy\">Genvira is an Ottawa-based biotechnology company focused on viral-vector engineering.</p><p>Dr. Jiahu Wang founded Genvira in 2019 as a spinout from the Ottawa Hospital Research Institute. The company grew out of research into three practical limits of viral vectors: genetic instability, low production yields, and limited room for therapeutic payloads.</p><p>Today, our <a href=\"http://localhost:8080/platform/\">engineering platform</a> supports work in cancer immunotherapy, genetic medicines, and vaccines.</p></div></section>\n<section class=\"tinted-section\"><div class=\"shell section split-section\"><div><p class=\"eyebrow\">PEOPLE BEHIND THE WORK</p><h2>Meet the team<br>moving our work forward.</h2></div><div><p class=\"large-copy\">Our leadership, board, and advisors bring experience across viral-vector research, therapeutic development, manufacturing, and business strategy.</p><a class=\"button\" href=\"http://localhost:8080/team/\">Meet our team <span aria-hidden=\"true\">↗</span></a></div></div></section>\n','About Genvira','','publish','closed','closed','','about','','','2026-11-16 15:24:24','2026-11-16 15:24:24','',0,'http://localhost:8080/?page_id=11',0,'page','',0);
INSERT INTO `wp_posts` VALUES (12,1,'2026-11-12 16:46:11','2026-11-12 16:46:11','<section class=\"section shell split-section\"><div><p class=\"eyebrow\">WORK WITH GENVIRA</p><h2>A focused conversation.<br>A shared scientific goal.</h2></div><div><p class=\"large-copy\">We welcome conversations with biotechnology companies, research groups, and potential investment partners.</p><p>Start with the program or capability that interests you. Our team can discuss the public development overview and explore whether there is a basis for further collaboration.</p><a class=\"button\" href=\"http://localhost:8080/contact/\">Contact our team <span aria-hidden=\"true\">↗</span></a></div></section>\n<section class=\"tinted-section\"><div class=\"section shell\"><p class=\"eyebrow\">AREAS FOR DISCUSSION</p><div class=\"three-columns\"><div><span class=\"number-label\">01 / THERAPEUTIC PROGRAMS</span><h3>GVB-2030 & the pipeline</h3><p>Discuss the lead bladder cancer program and Genvira’s broader research direction.</p><a class=\"text-link\" href=\"http://localhost:8080/gvb-2030/\">Explore GVB-2030 <span aria-hidden=\"true\">↗</span></a></div><div><span class=\"number-label\">02 / SCIENTIFIC COLLABORATION</span><h3>Viral-vector engineering</h3><p>Explore potential collaboration in vector design, characterization, and translational development.</p><a class=\"text-link\" href=\"http://localhost:8080/platform/\">Explore the platform <span aria-hidden=\"true\">↗</span></a></div><div><span class=\"number-label\">03 / STRATEGIC CONVERSATIONS</span><h3>Partners & investors</h3><p>Connect with the team about Genvira’s therapeutic focus and development priorities.</p><a class=\"text-link\" href=\"mailto:info@genvira.com?subject=Strategic%20inquiry\">Start a conversation <span aria-hidden=\"true\">↗</span></a></div></div></div></section>\n<section class=\"section shell\"><p class=\"eyebrow\">RECENT COLLABORATION</p><h2>Working together on melanoma research.</h2><p class=\"large-copy narrow\">Genvira, Labskin, and the National Research Council of Canada announced a UK–Canada collaboration supported by up to £1.2 million ($2.0 million) in funding in August 2025.</p><a class=\"text-link\" href=\"http://localhost:8080/research/\">Read the company update <span aria-hidden=\"true\">↗</span></a><p class=\"source-note\"><a href=\"http://localhost:8080/melanoma-research-collaboration/\">Read the collaboration announcement</a></p></section>\n','Partnering','','publish','closed','closed','','partnering','','','2026-11-12 16:46:11','2026-11-12 16:46:11','',0,'http://localhost:8080/?page_id=12',0,'page','',0);
INSERT INTO `wp_posts` VALUES (13,1,'2026-11-12 16:46:11','2026-11-12 16:46:11','<section class=\"section shell contact-layout\"><div><p class=\"eyebrow\">START A CONVERSATION</p><h2>Connect with our team.</h2><p>For program, partnership, investment, or research inquiries, contact Genvira directly.</p><div class=\"contact-details\"><p class=\"eyebrow\">GENVIRA BIOSCIENCES INC.</p><h3>Ottawa, Canada</h3><address>310 Hunt Club Rd, Suite 304<br>Ottawa, Ontario K1V 1C1<br>Canada</address><span class=\"email-address\">info@genvira.com</span><a href=\"tel:+16136954718\">+1 (613) 695-4718</a><a class=\"text-link\" href=\"https://www.google.com/maps/search/?api=1&amp;query=Genvira%20Biosciences%20Inc%2C%20310%20Hunt%20Club%20Road%2C%20Ottawa%2C%20ON%20K1V%201C1&amp;query_place_id=ChIJq6pq-XgIzkwRuff3ORYzMLQ\">Open in Google Maps <span aria-hidden=\"true\">↗</span></a><a class=\"text-link\" href=\"https://www.linkedin.com/company/genvira/\">Find us on LinkedIn <span aria-hidden=\"true\">↗</span></a></div></div><div class=\"contact-map\" data-latitude=\"45.337208\" data-longitude=\"-75.685013\" role=\"region\" aria-label=\"Map of Genvira’s Ottawa office\" hidden></div></section>\n','Contact us','','publish','closed','closed','','contact','','','2026-11-12 16:46:11','2026-11-12 16:46:11','',0,'http://localhost:8080/?page_id=13',0,'page','',0);
INSERT INTO `wp_posts` VALUES (15,1,'2026-11-12 16:46:11','2026-11-12 16:46:11','<section class=\"section shell split-section\"><div><p class=\"eyebrow\">WORK AT GENVIRA</p><h2>Bring your expertise<br>to viral engineering.</h2></div><div><p class=\"large-copy\">We welcome interest from people working in bioengineering, cancer biology, immunology, molecular biology, and quality.</p><p>We invite inquiries from research scientists, laboratory technicians, and co-op students. Please include your cover letter and résumé with your inquiry.</p><a class=\"button\" href=\"mailto:info@genvira.com?subject=Career%20inquiry\">Send a career inquiry <span aria-hidden=\"true\">↗</span></a></div></section>\n','Careers','','publish','closed','closed','','careers','','','2026-11-12 16:46:11','2026-11-12 16:46:11','',0,'http://localhost:8080/?page_id=15',0,'page','',0);
INSERT INTO `wp_posts` VALUES (16,1,'2026-11-12 16:46:11','2026-11-12 16:46:11','<section class=\"section shell article-width prose\"><h2>Contacting Genvira</h2><p>Contact links open your email application. Please leave patient information and confidential research data out of general inquiries.</p><h2>External links</h2><p>Research links may take you to other websites. Consult those websites for their privacy practices.</p><h2>Privacy questions</h2><p>Email <span class=\"email-address\">info@genvira.com</span> with questions about privacy.</p></section>\n','Privacy','','publish','closed','closed','','privacy','','','2026-11-12 16:46:11','2026-11-12 16:46:11','',0,'http://localhost:8080/?page_id=16',0,'page','',0);
INSERT INTO `wp_posts` VALUES (17,1,'2025-08-01 12:00:00','2025-08-01 12:00:00','<p>Genvira Biosciences Inc. (“Genvira”), a Canadian innovator in next-generation viral vectors, Labskin Limited (“Labskin”), a leader in 3D in vitro human skin models, and the National Research Council of Canada (NRC) are pleased to announce the launch of a collaborative project to develop novel immunotherapies for malignant melanoma. The collaboration is receiving advisory services and up to £1.2 million ($2.0 million) in funding through the Canada–UK Biomanufacturing of Biologics and Advanced Therapies program. UK participants are supported by Innovate UK, part of UK Research and Innovation (UKRI), while in Canada, support for the project is offered through the NRC Industrial Research Assistance Program (NRC IRAP) and the NRC Collaborative Science and Technology Innovation Program (NRC CSTIP).</p>\n<p>Malignant melanoma continues to be a serious global health concern, with an estimated 330,000 new cases and 60,000 deaths each year. This international partnership aims to address the unmet need by developing cutting-edge cancer vaccines and optimizing targeted antigen delivery systems.</p>\n<p>As part of the collaboration, Labskin will utilize its expertise in advanced disease modeling to develop a novel 3D human skin model of melanoma, enabling in vitro testing of vaccine candidates. Genvira will contribute its proprietary viral vector and gene delivery platforms, while the NRC will support the integration of mRNA technologies to engineer innovative, targeted immunotherapies tailored to melanoma.</p>\n<p>Dr. Nicola Kingswell, Scientific Director at Labskin Limited, stated:</p>\n<blockquote><p>“We’re extremely grateful to Innovate UK for supporting this exciting project. It represents a step-change in the treatment of malignant melanoma, which will benefit many patients worldwide. This partnership will not only produce and validate new immunotherapies, but also establish a framework for developing future cancer therapeutics.”</p></blockquote>\n<p>Dr. Jiahu Wang, President of Genvira Biosciences, added:</p>\n<blockquote><p>“We’d like to thank NRC IRAP for their support, and the NRC for their collaborative role. This partnership enables us to rapidly translate our viral vector technologies into clinical applications for melanoma and lays the groundwork for broader advances in cancer immunotherapy.”</p></blockquote>\n<p>The project brings together unique and complementary strengths in 3D tissue engineering, gene and viral therapy, mRNA technology, and advanced biomanufacturing. In addition to therapeutic development, the consortium will focus on scalable production processes, quality control assays, and robust technologies to enable rapid response to future healthcare challenges.</p>\n<p>This initiative highlights the importance of international collaboration in driving innovation and accelerating the development of advanced biologics and therapies.</p>\n<h2>About Labskin Limited</h2>\n<p>Labskin Limited is a UK-based biotechnology company specializing in full-thickness human skin models for pharmaceutical, cosmetic, and clinical research. Its advanced 3D platforms offer realistic testing environments for evaluating treatments in vitro.</p>\n<p>To learn more: <a href=\"https://www.labskin.co.uk\">www.labskin.co.uk</a></p>\n<h2>About Genvira Biosciences Inc.</h2>\n<p>Genvira Bioscience is a Canadian biotechnology company focused on designing and developing viral vector platforms for use in gene therapies, cancer vaccines, and regenerative medicine.</p>\n<p>To learn more: <a href=\"https://www.genvira.com\">www.genvira.com</a></p>','Genvira and Labskin Receive £1.2 Million ($2.0 Million) UK–Canada Collaboration Award to Advance Immunotherapies for Malignant Melanoma','Genvira, Labskin, and NRC announce a collaboration supported by up to £1.2 million ($2.0 million) in funding.','publish','open','open','','melanoma-research-collaboration','','','2025-08-01 12:00:00','2025-08-01 12:00:00','',0,'http://localhost:8080/?p=17',0,'post','',0);
INSERT INTO `wp_posts` VALUES (18,1,'2023-08-01 12:00:00','2023-08-01 12:00:00','<p class=\"publication-meta\">Yang N, Wang Y, Liu S, et al.<br>Journal of Experimental Medicine. 2023;220(8):e20221166.<br>DOI: 10.1084/jem.20221166</p><p>It examines an OX40L-expressing modified vaccinia virus Ankara and antitumor immune responses.</p><p>This publication is not a clinical report on GVB-2030. Consult the original paper for its experimental methods, findings, and limitations.</p><p><a class=\"button\" href=\"https://doi.org/10.1084/jem.20221166\">Read the paper ↗</a></p><p><a href=\"https://pubmed.ncbi.nlm.nih.gov/37145142/\">View on PubMed</a></p>','OX40L-expressing recombinant modified vaccinia virus Ankara induces potent antitumor immunity via reprogramming Tregs','Journal of Experimental Medicine · Research on an engineered vaccinia virus and antitumor immunity.','publish','open','open','','ox40l-vaccinia-antitumor-immunity','','','2023-08-01 12:00:00','2023-08-01 12:00:00','',0,'http://localhost:8080/?p=18',0,'post','',0);
INSERT INTO `wp_posts` VALUES (19,1,'2023-07-01 12:00:00','2023-07-01 12:00:00','<p class=\"publication-meta\">Gabir H, Gupta M, Meier M, et al.<br>European Biophysics Journal. 2023;52:473–481.<br>DOI: 10.1007/s00249-023-01644-1</p><p>This study examines the solution behavior and interactions of NET-1 and its receptor UNC-5B using analytical ultracentrifugation. Genvira appears among the author affiliations.</p><p>It is included as research from Genvira’s public bibliography, not evidence of clinical benefit for a therapeutic candidate.</p><p><a class=\"button\" href=\"https://doi.org/10.1007/s00249-023-01644-1\">Read the paper ↗</a></p><p><a href=\"https://pubmed.ncbi.nlm.nih.gov/36939874/\">View on PubMed</a></p>','Investigation of dynamic solution interactions between NET-1 and UNC-5B by multi-wavelength analytical ultracentrifugation','European Biophysics Journal · Biophysical characterization of protein interactions.','publish','open','open','','net1-unc5b-characterization','','','2023-07-01 12:00:00','2023-07-01 12:00:00','',0,'http://localhost:8080/?p=19',0,'post','',0);
INSERT INTO `wp_posts` VALUES (20,1,'2018-01-01 12:00:00','2018-01-01 12:00:00','<p class=\"publication-meta\">Pelin A, Wang J, Bell J, Le Boeuf F.<br>Oncolytic Virotherapy. 2018;7:25–35.<br>DOI: 10.2147/OV.S137159</p><p>This review discusses imaging strategies for understanding how oncolytic viruses distribute in preclinical and clinical settings.</p><p>The paper is included in Genvira’s public bibliography. It is a scientific review, not a clinical update for GVB-2030.</p><p><a class=\"button\" href=\"https://doi.org/10.2147/OV.S137159\">Read the paper ↗</a></p><p><a href=\"https://pubmed.ncbi.nlm.nih.gov/29637059/\">View on PubMed</a></p>','The importance of imaging strategies for pre-clinical and clinical in vivo distribution of oncolytic viruses','Oncolytic Virotherapy · A review of imaging approaches for studying viral distribution.','publish','open','open','','imaging-oncolytic-virus-distribution','','','2018-01-01 12:00:00','2018-01-01 12:00:00','',0,'http://localhost:8080/?p=20',0,'post','',0);
INSERT INTO `wp_posts` VALUES (23,1,'2026-11-16 15:24:23','2026-11-16 15:24:23','<nav class=\"team-jump shell\" aria-label=\"Team sections\"><a href=\"#leadership\">Leadership</a><a href=\"#board\">Board of directors</a><a href=\"#advisors\">Advisors</a></nav>\n<section id=\"leadership\" class=\"team-section\"><div class=\"shell section\"><p class=\"eyebrow\">OUR PEOPLE</p><h2>Leadership</h2><div class=\"team-profiles\">\n<article class=\"team-profile\"><img src=\"http://localhost:8080/wp-content/themes/genvira/assets/team-jiahu-wang.jpg\" alt=\"Dr. Jiahu Wang\" width=\"240\" height=\"240\"><div><h3>Dr. Jiahu Wang</h3><p class=\"team-profile-role\">Founder, President</p><div class=\"team-profile-bio\"><p>Dr. Jiahu Wang is the Founder and President of Genvira Biosciences Inc. He has spent two decades building viral vectors with a successful track record of bringing programs into the clinic.</p><p>Previously he was a cancer researcher at the Ottawa Hospital Research Institute where he led a team which designed, constructed and produced customized viral products for academic collaborators and industrial partners. Prior to that he spent 7 years working as Director, Novel Biotherapeutics at Jennerex Biotherapeutics in the U.S.</p><p>Dr. Wang completed his Postdoc in Cell Biology at the University of Virginia. He received a PhD in Chemistry from Queens University.</p></div></div></article>\n<article class=\"team-profile\"><img src=\"http://localhost:8080/wp-content/themes/genvira/assets/team-pamod-hemakumara.png\" alt=\"Pamod Hemakumara\" width=\"240\" height=\"240\"><div><h3>Pamod Hemakumara</h3><p class=\"team-profile-role\">Corporate &amp; business development consultant</p><div class=\"team-profile-bio\"><p>Pamod Hemakumara is a corporate and business development consultant at Genvira Biosciences Inc. He brings over a decade of experience in corporate strategy and BD across biotech, pharma, and life science sectors, having executed over $175M in transactions spanning licensing, M&amp;A, fundraising, VC investments, and strategic partnerships. Previously, Pamod was Director of Corporate Development at Quibim, where he supported the company’s Series A and led pharma and medtech partnerships. Before that, he worked with the Samsung Group on global strategy initiatives, including Samsung Biologics’ expansion into next-gen modalities such as cell and gene therapy.</p><p>He holds an MBA from IMD, a Master’s in Biomedical Technology from the University of Calgary, and a BSc in Biochemistry &amp; Molecular Biology from UNBC.</p></div></div></article>\n</div></div></section>\n<section id=\"board\" class=\"team-section tinted-section\"><div class=\"shell section\"><p class=\"eyebrow\">OUR PEOPLE</p><h2>Board of directors</h2><div class=\"team-profiles\">\n<article class=\"team-profile\"><img src=\"http://localhost:8080/wp-content/themes/genvira/assets/team-jiahu-wang.jpg\" alt=\"Dr. Jiahu Wang\" width=\"240\" height=\"240\"><div><h3>Dr. Jiahu Wang</h3><p class=\"team-profile-role\">Founder, President</p><div class=\"team-profile-bio\"><p>Dr. Jiahu Wang is the founder and President of Genvira Biosciences Inc.</p><p>He has spent two decades building viral vectors with a successful track record of bringing programs into the clinic.</p></div></div></article>\n<article class=\"team-profile\"><img src=\"http://localhost:8080/wp-content/themes/genvira/assets/team-john-lin.jpg\" alt=\"Dr. John Lin\" width=\"240\" height=\"240\"><div><h3>Dr. John Lin</h3><p class=\"team-profile-role\">Board director</p><div class=\"team-profile-bio\"><p>Dr. John Lin is the Co-CEO of Frontage Laboratories, Inc. Before this, he served as the Executive Vice President, Bioanalytical and Biologics Services, where he led operations for the company’s global bioanalytical labs. Before joining Frontage, he served as a business leader in AstraZeneca’s global drug metabolism and pharmacokinetics (DMPK) division. Prior to AstraZeneca, Dr. Lin was Laboratory Director for Avantix Laboratories. Dr. Lin completed post-doctoral research in pharmacokinetics and metabolism at the College of Pharmacy and the Comprehensive Cancer Center of the Ohio State University. He earned a PhD in analytical chemistry from Dalhousie University in Canada.</p></div></div></article>\n<article class=\"team-profile\"><img src=\"http://localhost:8080/wp-content/themes/genvira/assets/team-jim-de-wilde.jpg\" alt=\"Dr. Jim de Wilde\" width=\"240\" height=\"240\"><div><h3>Dr. Jim de Wilde</h3><p class=\"team-profile-role\">Board director</p><div class=\"team-profile-bio\"><p>Dr. Jim de Wilde is a career educator and venture capitalist, Dr. de Wilde has focused on global competitiveness and the commercialization of knowledge in both the private and public sectors. Dr. de Wilde was a member of the RBC Capital Markets Technology Fund Advisory Board and currently serves on the Investment Committee of iNovia Capital in Montreal and the Advisory Board of Enertech Capital in Toronto. He has a PhD from McGill with a dissertation focusing on technology competitiveness.</p></div></div></article>\n</div></div></section>\n<section id=\"advisors\" class=\"team-section\"><div class=\"shell section\"><p class=\"eyebrow\">OUR PEOPLE</p><h2>Scientific & strategic advisors</h2><div class=\"team-profiles\">\n<article class=\"team-profile\"><img src=\"http://localhost:8080/wp-content/themes/genvira/assets/team-john-bell.jpg\" alt=\"Dr. John Bell\" width=\"240\" height=\"240\"><div><h3>Dr. John Bell</h3><p class=\"team-profile-role\">Advisor</p><div class=\"team-profile-bio\"><p>John Bell is a world-renowned thought leader in cancer-fighting (oncolytic) virus research and development. He is a Senior Scientist at the Ottawa Hospital Research Institute and Professor in the Departments of Medicine and Biochemistry, Microbiology &amp; Immunology at the University of Ottawa. For more than twenty years, John and his team have been developing oncolytic viruses. He is a Co-founder of Turnstone Biologics, a San Diego company developing novel biotherapeutics to treat and cure patients with solid tumors. John is the Scientific Director of BioCanRx - Canada’s Immunotherapy Network - a not-for-profit organization working to accelerate the development of innovative immunotherapeutics, designed to save lives and enable a better quality of life for Canadian cancer patients. John was elected as a fellow of the Royal Society of Canada in 2013 and the Canadian Academy of Health Sciences in 2022. He serves on the Boards of Directors the Terry Fox Research Institute and the Biologics Manufacturing Centre. John holds Bachelor’s and Ph.D. degrees from McMaster University.</p></div></div></article>\n<article class=\"team-profile\"><img src=\"http://localhost:8080/wp-content/themes/genvira/assets/team-evan-steeg.jpg\" alt=\"Dr. Evan Steeg\" width=\"240\" height=\"240\"><div><h3>Dr. Evan Steeg</h3><p class=\"team-profile-role\">Advisor</p><div class=\"team-profile-bio\"><p>Dr. Evan Steeg has over 20 years of experience and deep expertise in Artificial Intelligence/Machine Learning. Evan has successfully developed and commercialized AI-driven solutions for biopharma and other industries. He was a co-founder, President and CEO of Molecular Mining Co., a firm specializing in utilizing AI to streamline pharmaceutical processes. Evan has patented inventions in data mining, AI/ML and bioinformatics. He is well versed in technology commercialization and strategic foresight. Evan Steeg holds a Ph.D. in Computer Science from the University of Toronto under the supervision of “Deep Learning” AI pioneer Prof. Geoffrey Hinton</p></div></div></article>\n<article class=\"team-profile\"><img src=\"http://localhost:8080/wp-content/themes/genvira/assets/team-georg-roth.jpg\" alt=\"Dr. Georg Roth\" width=\"240\" height=\"240\"><div><h3>Dr. Georg Roth</h3><p class=\"team-profile-role\">Advisor</p><div class=\"team-profile-bio\"><p>Dr. Georg Roth has over 30 years of experience in the biopharma industry. Until recently, Dr. Roth was the CTO of CG Oncology and held senior management positions at OncoMyx and KaliVir, in charge of product manufacturing. Prior to that he was the COO and SVP Technical Operations of Sillajen Biotherapeutics. Previously, he was VP at Jennerex Biotherapeutics. He also held positions at Dynavax, Berlex and Schering AG. He holds a Ph.D. in Chemical Engineering from Technical University Berlin, Germany</p></div></div></article>\n<article class=\"team-profile\"><img src=\"http://localhost:8080/wp-content/themes/genvira/assets/team-lance-wong.jpg\" alt=\"Dr. Lance Wong\" width=\"240\" height=\"240\"><div><h3>Dr. Lance Wong</h3><p class=\"team-profile-role\">Advisor</p><div class=\"team-profile-bio\"><p>Dr. Lance Wong has extensive experience in the biotechnology and pharmaceutical industry. Since 2019, Lance is the VP, Manufacturing at IMVAQ. Prior to this, he was the Managing Director at Strand Bio, where he acted as senior advisor or in executive roles for start-ups. Lance has worked at Bavarian Nordic, Inc. as the Director for CMC strategy, operational support for pre-BLA/-MAA. Lance also contributed to partnership deals with major pharmaceutical companies. Lance also worked at MedImmune/AstraZeneca, successfully managed regulatory filings and site inspections. Lance Wong holds a Ph.D. degree in Chemical Engineering from UCLA</p></div></div></article>\n</div></div></section>\n<div class=\"shell team-source\"><a class=\"text-link\" href=\"http://localhost:8080/partnering/\">Connect with our team <span aria-hidden=\"true\">↗</span></a></div>\n','Our team','','publish','closed','closed','','team','','','2026-11-16 15:24:23','2026-11-16 15:24:23','',0,'http://localhost:8080/team/',0,'page','',0);
/*!40000 ALTER TABLE `wp_posts` ENABLE KEYS */;
DROP TABLE IF EXISTS `wp_term_relationships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_term_relationships` (
  `object_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  `term_taxonomy_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  `term_order` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`object_id`,`term_taxonomy_id`),
  KEY `term_taxonomy_id` (`term_taxonomy_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `wp_term_relationships` DISABLE KEYS */;
INSERT INTO `wp_term_relationships` VALUES (1,1,0);
INSERT INTO `wp_term_relationships` VALUES (17,2,0);
INSERT INTO `wp_term_relationships` VALUES (18,3,0);
INSERT INTO `wp_term_relationships` VALUES (19,3,0);
INSERT INTO `wp_term_relationships` VALUES (20,3,0);
/*!40000 ALTER TABLE `wp_term_relationships` ENABLE KEYS */;
DROP TABLE IF EXISTS `wp_term_taxonomy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_term_taxonomy` (
  `term_taxonomy_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `term_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  `taxonomy` varchar(32) NOT NULL DEFAULT '',
  `description` longtext NOT NULL,
  `parent` bigint(20) unsigned NOT NULL DEFAULT 0,
  `count` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`term_taxonomy_id`),
  UNIQUE KEY `term_id_taxonomy` (`term_id`,`taxonomy`),
  KEY `taxonomy` (`taxonomy`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `wp_term_taxonomy` DISABLE KEYS */;
INSERT INTO `wp_term_taxonomy` VALUES (1,1,'category','',0,1);
INSERT INTO `wp_term_taxonomy` VALUES (2,2,'category','',0,1);
INSERT INTO `wp_term_taxonomy` VALUES (3,3,'category','',0,3);
/*!40000 ALTER TABLE `wp_term_taxonomy` ENABLE KEYS */;
DROP TABLE IF EXISTS `wp_termmeta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_termmeta` (
  `meta_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `term_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  `meta_key` varchar(255) DEFAULT NULL,
  `meta_value` longtext DEFAULT NULL,
  PRIMARY KEY (`meta_id`),
  KEY `term_id` (`term_id`),
  KEY `meta_key` (`meta_key`(191))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `wp_termmeta` DISABLE KEYS */;
/*!40000 ALTER TABLE `wp_termmeta` ENABLE KEYS */;
DROP TABLE IF EXISTS `wp_terms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_terms` (
  `term_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL DEFAULT '',
  `slug` varchar(200) NOT NULL DEFAULT '',
  `term_group` bigint(10) NOT NULL DEFAULT 0,
  PRIMARY KEY (`term_id`),
  KEY `slug` (`slug`(191)),
  KEY `name` (`name`(191))
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `wp_terms` DISABLE KEYS */;
INSERT INTO `wp_terms` VALUES (1,'Uncategorized','uncategorized',0);
INSERT INTO `wp_terms` VALUES (2,'Company news','news',0);
INSERT INTO `wp_terms` VALUES (3,'Publication','publication',0);
/*!40000 ALTER TABLE `wp_terms` ENABLE KEYS */;
DROP TABLE IF EXISTS `wp_usermeta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_usermeta` (
  `umeta_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  `meta_key` varchar(255) DEFAULT NULL,
  `meta_value` longtext DEFAULT NULL,
  PRIMARY KEY (`umeta_id`),
  KEY `user_id` (`user_id`),
  KEY `meta_key` (`meta_key`(191))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `wp_usermeta` DISABLE KEYS */;
/*!40000 ALTER TABLE `wp_usermeta` ENABLE KEYS */;
DROP TABLE IF EXISTS `wp_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `wp_users` (
  `ID` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_login` varchar(60) NOT NULL DEFAULT '',
  `user_pass` varchar(255) NOT NULL DEFAULT '',
  `user_nicename` varchar(50) NOT NULL DEFAULT '',
  `user_email` varchar(100) NOT NULL DEFAULT '',
  `user_url` varchar(100) NOT NULL DEFAULT '',
  `user_registered` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `user_activation_key` varchar(255) NOT NULL DEFAULT '',
  `user_status` int(11) NOT NULL DEFAULT 0,
  `display_name` varchar(250) NOT NULL DEFAULT '',
  PRIMARY KEY (`ID`),
  KEY `user_login_key` (`user_login`),
  KEY `user_nicename` (`user_nicename`),
  KEY `user_email` (`user_email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40000 ALTER TABLE `wp_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `wp_users` ENABLE KEYS */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

