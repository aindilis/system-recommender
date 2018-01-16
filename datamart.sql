-- MySQL dump 10.11
--
-- Host: localhost    Database: datamart_dec2008
-- ------------------------------------------------------
-- Server version	5.0.51a-8

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `FM_TROVE_DEFS`
--

DROP TABLE IF EXISTS `FM_TROVE_DEFS`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `FM_TROVE_DEFS` (
  `trove_id` int(11) NOT NULL,
  `root` int(11) NOT NULL,
  `parent` int(11) NOT NULL,
  `name` varchar(200) NOT NULL,
  `datasource_id` int(5) NOT NULL,
  PRIMARY KEY  (`trove_id`,`datasource_id`),
  KEY `datasource_id_index2` (`datasource_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `datasources`
--

DROP TABLE IF EXISTS `datasources`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `datasources` (
  `datasource_id` int(11) NOT NULL default '0',
  `forge_id` int(5) NOT NULL,
  `friendly_name` varchar(100) NOT NULL default '',
  `date_donated` datetime NOT NULL default '0000-00-00 00:00:00',
  `contact_person` varchar(100) NOT NULL default '',
  `comments` varchar(250) default '',
  `start_date` date default NULL,
  `end_date` date default NULL,
  PRIMARY KEY  (`datasource_id`),
  KEY `datasource_id_index` (`datasource_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `developer_projects`
--

DROP TABLE IF EXISTS `developer_projects`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `developer_projects` (
  `dev_loginname` varchar(100) NOT NULL default '',
  `proj_unixname` varchar(100) NOT NULL default '',
  `is_admin` int(1) default NULL,
  `position` varchar(100) default NULL,
  `date_collected` datetime NOT NULL default '0000-00-00 00:00:00',
  `datasource_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`proj_unixname`,`datasource_id`,`dev_loginname`),
  KEY `proj_unixname` (`proj_unixname`),
  KEY `dev_loginname` (`dev_loginname`),
  KEY `datasource_id` (`datasource_id`),
  KEY `datasource_id_index12` (`datasource_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `developers`
--

DROP TABLE IF EXISTS `developers`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `developers` (
  `dev_loginname` varchar(100) NOT NULL default '',
  `realname` varchar(100) default NULL,
  `email` varchar(100) default NULL,
  `member_since` datetime default NULL,
  `user_id` int(11) default NULL,
  `date_collected` datetime NOT NULL default '0000-00-00 00:00:00',
  `datasource_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`dev_loginname`,`datasource_id`),
  KEY `datasource_id_index14` (`datasource_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `fm_project_authors`
--

DROP TABLE IF EXISTS `fm_project_authors`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `fm_project_authors` (
  `project_id` int(11) NOT NULL default '0',
  `datasource_id` int(11) NOT NULL default '0',
  `author_name` varchar(100) NOT NULL default '',
  `author_url` varchar(255) default '',
  `author_role` varchar(100) default '',
  `timestamp` datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`author_name`,`datasource_id`,`project_id`),
  KEY `datasource_id_index15` (`datasource_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `fm_project_dependencies`
--

DROP TABLE IF EXISTS `fm_project_dependencies`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `fm_project_dependencies` (
  `project_id` varchar(100) NOT NULL default '',
  `datasource_id` int(11) NOT NULL default '0',
  `dependency_project_id` int(11) NOT NULL default '0',
  `dependency_project_title` varchar(100) default '',
  `dependency_release_id` int(11) default '0',
  `dependency_branch_id` int(11) default '0',
  `timestamp` datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`project_id`,`datasource_id`,`dependency_project_id`),
  KEY `datasource_id_index16` (`datasource_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `fm_project_homepages`
--

DROP TABLE IF EXISTS `fm_project_homepages`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `fm_project_homepages` (
  `project_id` int(11) NOT NULL default '0',
  `datasource_id` int(11) NOT NULL default '0',
  `real_url_homepage` varchar(100) default '',
  `timestamp` datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`project_id`,`datasource_id`),
  KEY `datasource_id_index17` (`datasource_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `fm_project_trove`
--

DROP TABLE IF EXISTS `fm_project_trove`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `fm_project_trove` (
  `project_id` int(11) NOT NULL default '0',
  `datasource_id` int(11) NOT NULL default '0',
  `trove_id` int(11) NOT NULL default '0',
  `timestamp` datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`project_id`,`datasource_id`,`trove_id`),
  KEY `datasource_id_index18` (`datasource_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `fm_projects`
--

DROP TABLE IF EXISTS `fm_projects`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `fm_projects` (
  `project_id` int(11) NOT NULL default '0',
  `datasource_id` int(11) NOT NULL default '0',
  `date_added` varchar(100) NOT NULL default '',
  `date_updated` varchar(100) NOT NULL default '',
  `projectname_short` varchar(100) default '',
  `projectname_full` varchar(100) default '',
  `desc_short` varchar(100) default '',
  `desc_full` text,
  `vitality_score` varchar(100) default '',
  `vitality_percent` varchar(100) default '',
  `vitality_rank` varchar(100) default '',
  `popularity_score` varchar(100) default '',
  `popularity_percent` varchar(100) default '',
  `popularity_rank` varchar(100) default '',
  `rating` varchar(100) default '',
  `rating_count` varchar(100) default '',
  `rating_rank` varchar(100) default '',
  `subscriptions` varchar(100) default '',
  `branch_name` varchar(100) default '',
  `url_homepage` varchar(255) default '',
  `url_tgz` varchar(255) default '',
  `url_changelog` varchar(255) default '',
  `url_rpm` varchar(255) default '',
  `url_deb` varchar(255) default '',
  `url_bz2` varchar(255) default '',
  `url_cvs` varchar(255) default '',
  `url_bugtracker` varchar(255) default '',
  `url_list` varchar(255) default '',
  `url_zip` varchar(255) default '',
  `url_osx` varchar(255) default '',
  `url_bsdport` varchar(255) default '',
  `url_purchase` varchar(255) default '',
  `url_mirror` varchar(255) default '',
  `url_demo` varchar(255) default '',
  `url_project_page` varchar(255) default '',
  `license` varchar(100) default '',
  `latest_release_version` varchar(100) default '',
  `latest_release_id` varchar(100) default '',
  `latest_release_date` varchar(100) default '',
  `timestamp` datetime default '0000-00-00 00:00:00',
  `screenshot_thumb` varchar(255) default '',
  `projectname_short_fixed` varchar(100) default NULL,
  PRIMARY KEY  (`project_id`,`datasource_id`),
  KEY `projectname_short` (`projectname_short`),
  KEY `projectname_short_fixed` (`projectname_short_fixed`),
  KEY `datasource_id_index19` (`datasource_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `forges`
--

DROP TABLE IF EXISTS `forges`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `forges` (
  `forge_id` int(5) NOT NULL,
  `forge_abbr` varchar(2) character set utf8 NOT NULL,
  `forge_long_name` varchar(50) default NULL,
  `forge_home_page` varchar(255) character set utf8 NOT NULL,
  PRIMARY KEY  (`forge_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `ow_developer_projects`
--

DROP TABLE IF EXISTS `ow_developer_projects`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `ow_developer_projects` (
  `dev_loginname` varchar(100) NOT NULL default '',
  `proj_unixname` varchar(100) NOT NULL default '',
  `is_admin` int(1) default NULL,
  `position` varchar(100) default NULL,
  `date_collected` datetime NOT NULL default '0000-00-00 00:00:00',
  `datasource_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`proj_unixname`,`datasource_id`,`dev_loginname`),
  KEY `datasource_id_index26` (`datasource_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `ow_developers`
--

DROP TABLE IF EXISTS `ow_developers`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `ow_developers` (
  `dev_loginname` varchar(100) NOT NULL default '',
  `realname` varchar(100) default NULL,
  `dev_id` int(11) default NULL,
  `date_collected` datetime NOT NULL default '0000-00-00 00:00:00',
  `datasource_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`dev_loginname`,`datasource_id`),
  KEY `datasource_id_index27` (`datasource_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `ow_project_description`
--

DROP TABLE IF EXISTS `ow_project_description`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `ow_project_description` (
  `proj_unixname` varchar(100) NOT NULL default '',
  `description` varchar(254) default NULL,
  `datasource_id` int(11) NOT NULL default '0',
  `date_collected` datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`proj_unixname`,`datasource_id`),
  KEY `datasource_id_index28` (`datasource_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `ow_project_environment`
--

DROP TABLE IF EXISTS `ow_project_environment`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `ow_project_environment` (
  `proj_unixname` varchar(100) NOT NULL default '',
  `datasource_id` int(11) NOT NULL default '0',
  `code` varchar(10) NOT NULL default '',
  `description` varchar(100) NOT NULL default '',
  `date_collected` datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`code`,`proj_unixname`,`datasource_id`),
  KEY `datasource_id_index29` (`datasource_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `ow_project_intended_audience`
--

DROP TABLE IF EXISTS `ow_project_intended_audience`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `ow_project_intended_audience` (
  `proj_unixname` varchar(100) NOT NULL default '',
  `datasource_id` int(11) NOT NULL default '0',
  `code` varchar(10) NOT NULL default '',
  `description` varchar(100) NOT NULL default '',
  `date_collected` datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`code`,`proj_unixname`,`datasource_id`),
  KEY `datasource_id_index31` (`datasource_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `ow_project_licenses`
--

DROP TABLE IF EXISTS `ow_project_licenses`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `ow_project_licenses` (
  `proj_unixname` varchar(100) NOT NULL default '',
  `datasource_id` int(11) NOT NULL default '0',
  `code` varchar(10) NOT NULL default '',
  `description` varchar(100) NOT NULL default '',
  `date_collected` datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`code`,`proj_unixname`,`datasource_id`),
  KEY `datasource_id_index32` (`datasource_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `ow_project_operating_system`
--

DROP TABLE IF EXISTS `ow_project_operating_system`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `ow_project_operating_system` (
  `proj_unixname` varchar(100) NOT NULL default '',
  `datasource_id` int(11) NOT NULL default '0',
  `code` varchar(10) NOT NULL default '',
  `description` varchar(100) NOT NULL default '',
  `date_collected` datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`code`,`proj_unixname`,`datasource_id`),
  KEY `datasource_id_index33` (`datasource_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `ow_project_programming_language`
--

DROP TABLE IF EXISTS `ow_project_programming_language`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `ow_project_programming_language` (
  `proj_unixname` varchar(100) NOT NULL default '',
  `datasource_id` int(11) NOT NULL default '0',
  `code` varchar(10) NOT NULL default '',
  `description` varchar(100) NOT NULL default '',
  `date_collected` datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`code`,`proj_unixname`,`datasource_id`),
  KEY `datasource_id_index34` (`datasource_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `ow_project_status`
--

DROP TABLE IF EXISTS `ow_project_status`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `ow_project_status` (
  `proj_unixname` varchar(100) NOT NULL default '',
  `code` varchar(10) NOT NULL default '',
  `description` varchar(100) NOT NULL default '',
  `code_on_page` varchar(10) default NULL,
  `date_collected` datetime NOT NULL default '0000-00-00 00:00:00',
  `datasource_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`datasource_id`,`proj_unixname`,`code`),
  KEY `datasource_id_index35` (`datasource_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `ow_project_topic`
--

DROP TABLE IF EXISTS `ow_project_topic`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `ow_project_topic` (
  `proj_unixname` varchar(100) NOT NULL default '',
  `datasource_id` int(11) NOT NULL default '0',
  `code` varchar(10) NOT NULL default '',
  `description` varchar(100) NOT NULL default '',
  `date_collected` datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`code`,`proj_unixname`,`datasource_id`),
  KEY `datasource_id_index36` (`datasource_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `ow_projects`
--

DROP TABLE IF EXISTS `ow_projects`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `ow_projects` (
  `proj_unixname` varchar(100) NOT NULL,
  `url` varchar(255) default NULL,
  `real_url` varchar(255) default NULL,
  `date_registered` datetime default NULL,
  `proj_long_name` varchar(255) default NULL,
  `proj_id_num` int(10) default NULL,
  `dev_count` int(10) default NULL,
  `date_collected` datetime default NULL,
  `datasource_id` int(11) NOT NULL,
  PRIMARY KEY  (`proj_unixname`,`datasource_id`),
  KEY `datasource_id_index37` (`datasource_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `project_db_environment`
--

DROP TABLE IF EXISTS `project_db_environment`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `project_db_environment` (
  `proj_unixname` varchar(100) NOT NULL default '',
  `code` varchar(100) NOT NULL default '',
  `description` varchar(100) NOT NULL default '',
  `date_collected` datetime NOT NULL default '0000-00-00 00:00:00',
  `datasource_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`code`,`proj_unixname`,`datasource_id`),
  KEY `datasource_id_index38` (`datasource_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `project_description`
--

DROP TABLE IF EXISTS `project_description`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `project_description` (
  `proj_unixname` varchar(100) NOT NULL default '',
  `description` text,
  `datasource_id` int(11) NOT NULL default '0',
  `date_collected` datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`proj_unixname`,`datasource_id`),
  KEY `datasource_id_index39` (`datasource_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `project_donors`
--

DROP TABLE IF EXISTS `project_donors`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `project_donors` (
  `proj_unixname` varchar(100) NOT NULL default '',
  `donor_id` varchar(30) NOT NULL default '',
  `datasource_id` int(11) NOT NULL default '0',
  `date_collected` datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`proj_unixname`,`donor_id`,`datasource_id`),
  KEY `datasource_id_index40` (`datasource_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `project_environment`
--

DROP TABLE IF EXISTS `project_environment`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `project_environment` (
  `proj_unixname` varchar(100) NOT NULL default '',
  `code` varchar(100) NOT NULL default '',
  `description` varchar(100) NOT NULL default '',
  `date_collected` datetime NOT NULL default '0000-00-00 00:00:00',
  `datasource_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`code`,`proj_unixname`,`datasource_id`),
  KEY `datasource_id_index41` (`datasource_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `project_intended_audience`
--

DROP TABLE IF EXISTS `project_intended_audience`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `project_intended_audience` (
  `proj_unixname` varchar(100) NOT NULL default '',
  `code` varchar(100) NOT NULL default '',
  `description` varchar(100) NOT NULL default '',
  `date_collected` datetime NOT NULL default '0000-00-00 00:00:00',
  `datasource_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`code`,`proj_unixname`,`datasource_id`),
  KEY `datasource_id_index42` (`datasource_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `project_licenses`
--

DROP TABLE IF EXISTS `project_licenses`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `project_licenses` (
  `proj_unixname` varchar(100) NOT NULL default '',
  `code` varchar(100) NOT NULL default '',
  `description` varchar(100) NOT NULL default '',
  `date_collected` datetime NOT NULL default '0000-00-00 00:00:00',
  `datasource_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`datasource_id`,`code`,`proj_unixname`),
  KEY `datasource_id_index43` (`datasource_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `project_operating_system`
--

DROP TABLE IF EXISTS `project_operating_system`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `project_operating_system` (
  `proj_unixname` varchar(100) NOT NULL default '',
  `code` varchar(100) NOT NULL default '',
  `description` varchar(100) NOT NULL default '',
  `date_collected` datetime NOT NULL default '0000-00-00 00:00:00',
  `datasource_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`code`,`proj_unixname`,`datasource_id`),
  KEY `datasource_id_index45` (`datasource_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `project_programming_language`
--

DROP TABLE IF EXISTS `project_programming_language`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `project_programming_language` (
  `proj_unixname` varchar(100) NOT NULL default '',
  `code` varchar(100) NOT NULL default '',
  `description` varchar(100) NOT NULL default '',
  `date_collected` datetime NOT NULL default '0000-00-00 00:00:00',
  `datasource_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`proj_unixname`,`code`,`datasource_id`),
  KEY `code` (`code`(3)),
  KEY `code_2` (`code`(3)),
  KEY `datasource_id_index46` (`datasource_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `project_public_areas`
--

DROP TABLE IF EXISTS `project_public_areas`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `project_public_areas` (
  `proj_unixname` varchar(100) NOT NULL default '',
  `date_collected` datetime NOT NULL default '0000-00-00 00:00:00',
  `datasource_id` int(11) NOT NULL default '0',
  `numBugsOpen` int(11) default NULL,
  `numBugsTotal` int(11) default NULL,
  `numSROpen` int(11) default NULL,
  `numSRTotal` int(11) default NULL,
  `numPatchesOpen` int(11) default NULL,
  `numPatchesTotal` int(11) default NULL,
  `numFeatureOpen` int(11) default NULL,
  `numFeatureTotal` int(11) default NULL,
  `numForumMessages` int(11) default NULL,
  `numForumsTotal` int(11) default NULL,
  `numMailingLists` int(11) default NULL,
  `numCVSCommits` int(11) default NULL,
  `numCVSReads` int(11) default NULL,
  `numSVNCommits` int(11) default NULL,
  `numSVNReads` int(11) default NULL,
  PRIMARY KEY  (`proj_unixname`,`datasource_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `project_statistics_60`
--

DROP TABLE IF EXISTS `project_statistics_60`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `project_statistics_60` (
  `proj_unixname` varchar(100) NOT NULL default '',
  `datasource_id` int(11) NOT NULL default '0',
  `data_for_date` date NOT NULL default '0000-00-00',
  `date_collected` datetime NOT NULL default '0000-00-00 00:00:00',
  `is_partial` enum('y','n') NOT NULL default 'n',
  `rank` int(11) default NULL,
  `total_pages` int(11) default NULL,
  `downloads` int(11) default NULL,
  `project_web_hits` int(11) default NULL,
  `tracker_opened` varchar(12) default NULL,
  `tracker_closed` varchar(12) default NULL,
  `forum_posts` int(11) default NULL,
  PRIMARY KEY  (`proj_unixname`,`datasource_id`,`data_for_date`),
  KEY `datasource_id_index` (`datasource_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `project_status`
--

DROP TABLE IF EXISTS `project_status`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `project_status` (
  `proj_unixname` varchar(100) NOT NULL default '',
  `code` varchar(100) NOT NULL default '',
  `description` varchar(100) NOT NULL default '',
  `code_on_page` varchar(255) default NULL,
  `date_collected` datetime NOT NULL default '0000-00-00 00:00:00',
  `datasource_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`datasource_id`,`proj_unixname`,`code`),
  KEY `code` (`code`(3)),
  KEY `datasource_id_index49` (`datasource_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `project_topic`
--

DROP TABLE IF EXISTS `project_topic`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `project_topic` (
  `proj_unixname` varchar(100) NOT NULL default '',
  `code` varchar(100) NOT NULL default '',
  `description` varchar(100) NOT NULL default '',
  `date_collected` datetime NOT NULL default '0000-00-00 00:00:00',
  `datasource_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`proj_unixname`,`code`,`datasource_id`),
  KEY `datasource_id_index50` (`datasource_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `project_translations`
--

DROP TABLE IF EXISTS `project_translations`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `project_translations` (
  `proj_unixname` varchar(100) NOT NULL default '',
  `code` varchar(100) NOT NULL default '',
  `description` varchar(100) NOT NULL default '',
  `date_collected` datetime NOT NULL default '0000-00-00 00:00:00',
  `datasource_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`code`,`proj_unixname`,`datasource_id`),
  KEY `datasource_id_index42` (`datasource_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `project_user_interface`
--

DROP TABLE IF EXISTS `project_user_interface`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `project_user_interface` (
  `proj_unixname` varchar(100) NOT NULL default '',
  `code` varchar(100) NOT NULL default '',
  `description` varchar(100) NOT NULL default '',
  `date_collected` datetime NOT NULL default '0000-00-00 00:00:00',
  `datasource_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`proj_unixname`,`code`,`datasource_id`),
  KEY `datasource_id_index51` (`datasource_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `projects`
--

DROP TABLE IF EXISTS `projects`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `projects` (
  `proj_unixname` varchar(100) NOT NULL default '',
  `forge_id` int(11) NOT NULL default '0',
  `url` varchar(255) default '',
  `real_url` varchar(255) default NULL,
  `date_registered` datetime default '0000-00-00 00:00:00',
  `proj_long_name` varchar(255) default '',
  `proj_description` varchar(255) default '',
  `proj_id_num` int(10) unsigned default '0',
  `added_by_script` varchar(100) default '',
  `dev_count` int(10) unsigned default NULL,
  `lifespan` int(10) unsigned default NULL,
  `downloads_all_time` bigint(15) unsigned default NULL,
  `pageviews_all_time` bigint(15) unsigned default NULL,
  `takesdonations` enum('y','n') NOT NULL,
  `date_collected` datetime NOT NULL default '0000-00-00 00:00:00',
  `datasource_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`datasource_id`,`forge_id`,`proj_unixname`),
  KEY `dev_count` (`dev_count`),
  KEY `proj_unixname` (`proj_unixname`(10)),
  KEY `datasource_id_index52` (`datasource_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rf_developer_projects`
--

DROP TABLE IF EXISTS `rf_developer_projects`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rf_developer_projects` (
  `dev_loginname` varchar(100) NOT NULL default '',
  `proj_unixname` varchar(100) NOT NULL default '',
  `is_admin` int(1) default NULL,
  `position` varchar(100) default NULL,
  `date_collected` datetime NOT NULL default '0000-00-00 00:00:00',
  `datasource_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`proj_unixname`,`datasource_id`,`dev_loginname`),
  KEY `datasource_id_index53` (`datasource_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rf_developers`
--

DROP TABLE IF EXISTS `rf_developers`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rf_developers` (
  `dev_loginname` varchar(100) NOT NULL default '',
  `realname` varchar(100) default NULL,
  `email` varchar(1) default NULL,
  `date_collected` datetime NOT NULL default '0000-00-00 00:00:00',
  `datasource_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`dev_loginname`,`datasource_id`),
  KEY `datasource_id_index54` (`datasource_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rf_project_description`
--

DROP TABLE IF EXISTS `rf_project_description`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rf_project_description` (
  `proj_unixname` varchar(100) NOT NULL default '',
  `description` varchar(254) default NULL,
  `datasource_id` int(11) NOT NULL default '0',
  `date_collected` datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`proj_unixname`,`datasource_id`),
  KEY `datasource_id_index55` (`datasource_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rf_project_environment`
--

DROP TABLE IF EXISTS `rf_project_environment`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rf_project_environment` (
  `proj_unixname` varchar(100) NOT NULL default '',
  `datasource_id` int(11) NOT NULL default '0',
  `code` varchar(10) NOT NULL default '',
  `description` varchar(100) NOT NULL default '',
  `date_collected` datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`code`,`proj_unixname`,`datasource_id`),
  KEY `datasource_id_index56` (`datasource_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rf_project_intended_audience`
--

DROP TABLE IF EXISTS `rf_project_intended_audience`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rf_project_intended_audience` (
  `proj_unixname` varchar(100) NOT NULL default '',
  `datasource_id` int(11) NOT NULL default '0',
  `code` varchar(10) NOT NULL default '',
  `description` varchar(100) NOT NULL default '',
  `date_collected` datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`code`,`proj_unixname`,`datasource_id`),
  KEY `datasource_id_index58` (`datasource_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rf_project_licenses`
--

DROP TABLE IF EXISTS `rf_project_licenses`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rf_project_licenses` (
  `proj_unixname` varchar(100) NOT NULL default '',
  `datasource_id` int(11) NOT NULL default '0',
  `code` varchar(10) NOT NULL default '',
  `description` varchar(100) NOT NULL default '',
  `date_collected` datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`code`,`proj_unixname`,`datasource_id`),
  KEY `datasource_id_index59` (`datasource_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rf_project_natural_language`
--

DROP TABLE IF EXISTS `rf_project_natural_language`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rf_project_natural_language` (
  `proj_unixname` varchar(100) NOT NULL default '',
  `datasource_id` int(11) NOT NULL default '0',
  `code` varchar(10) NOT NULL default '',
  `description` varchar(100) NOT NULL default '',
  `date_collected` datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`code`,`proj_unixname`,`datasource_id`),
  KEY `datasource_id_index60` (`datasource_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rf_project_operating_system`
--

DROP TABLE IF EXISTS `rf_project_operating_system`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rf_project_operating_system` (
  `proj_unixname` varchar(100) NOT NULL default '',
  `datasource_id` int(11) NOT NULL default '0',
  `code` varchar(10) NOT NULL default '',
  `description` varchar(100) NOT NULL default '',
  `date_collected` datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`code`,`proj_unixname`,`datasource_id`),
  KEY `datasource_id_index61` (`datasource_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rf_project_programming_language`
--

DROP TABLE IF EXISTS `rf_project_programming_language`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rf_project_programming_language` (
  `proj_unixname` varchar(100) NOT NULL default '',
  `datasource_id` int(11) NOT NULL default '0',
  `code` varchar(10) NOT NULL default '',
  `description` varchar(100) NOT NULL default '',
  `date_collected` datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`code`,`proj_unixname`,`datasource_id`),
  KEY `datasource_id_index62` (`datasource_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rf_project_status`
--

DROP TABLE IF EXISTS `rf_project_status`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rf_project_status` (
  `proj_unixname` varchar(100) NOT NULL default '',
  `code` varchar(10) NOT NULL default '',
  `description` varchar(100) NOT NULL default '',
  `code_on_page` varchar(10) default NULL,
  `date_collected` datetime NOT NULL default '0000-00-00 00:00:00',
  `datasource_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`datasource_id`,`proj_unixname`,`code`),
  KEY `datasource_id_index63` (`datasource_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rf_project_topic`
--

DROP TABLE IF EXISTS `rf_project_topic`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rf_project_topic` (
  `proj_unixname` varchar(100) NOT NULL default '',
  `datasource_id` int(11) NOT NULL default '0',
  `code` varchar(10) NOT NULL default '',
  `description` varchar(100) NOT NULL default '',
  `date_collected` datetime NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`code`,`proj_unixname`,`datasource_id`),
  KEY `datasource_id_index64` (`datasource_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rf_projects`
--

DROP TABLE IF EXISTS `rf_projects`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `rf_projects` (
  `proj_unixname` varchar(100) NOT NULL,
  `url` varchar(255) default NULL,
  `real_url` varchar(255) default NULL,
  `date_registered` datetime default NULL,
  `proj_long_name` varchar(255) default NULL,
  `proj_id_num` int(10) default NULL,
  `dev_count` int(10) default NULL,
  `activity_percentile` float default NULL,
  `date_collected` datetime default NULL,
  `datasource_id` int(11) NOT NULL,
  PRIMARY KEY  (`proj_unixname`,`datasource_id`),
  KEY `datasource_id_index65` (`datasource_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2009-01-27  0:27:10
