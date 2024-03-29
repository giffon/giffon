-- MySQL dump 10.16  Distrib 10.3.9-MariaDB, for Win64 (AMD64)
--
-- Host: giffon.czhm2i8itlng.us-east-1.rds.amazonaws.com    Database: giffon
-- ------------------------------------------------------
-- Server version	5.7.25-log

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
-- Table structure for table `coupon`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `coupon` (
  `coupon_id` int(11) NOT NULL AUTO_INCREMENT,
  `coupon_creator_id` int(11) DEFAULT NULL,
  `coupon_code` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL,
  `coupon_value_HKD` decimal(16,4) DEFAULT NULL,
  `coupon_value_USD` decimal(16,4) DEFAULT NULL,
  `coupon_quota` int(11) DEFAULT NULL,
  `coupon_deadline` timestamp NULL DEFAULT NULL,
  `coupon_social` json DEFAULT NULL,
  PRIMARY KEY (`coupon_id`),
  UNIQUE KEY `coupon_UN` (`coupon_code`),
  KEY `coupon_user_FK` (`coupon_creator_id`),
  CONSTRAINT `coupon_user_FK` FOREIGN KEY (`coupon_creator_id`) REFERENCES `user` (`user_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `item`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `item` (
  `item_id` int(11) NOT NULL AUTO_INCREMENT,
  `item_url` varchar(1024) COLLATE utf8mb4_bin NOT NULL,
  `item_url_screenshot` longblob,
  `item_name` varchar(128) COLLATE utf8mb4_bin DEFAULT NULL,
  `item_price` decimal(16,4) DEFAULT NULL,
  `item_time_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `item_time_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `item_currency` varchar(16) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`item_id`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pledge`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pledge` (
  `pledge_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `wish_id` int(11) NOT NULL,
  `pledge_amount` decimal(16,4) NOT NULL,
  `pledge_time_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `pledge_method` varchar(64) COLLATE utf8mb4_bin NOT NULL,
  `pledge_note` text COLLATE utf8mb4_bin,
  `pledge_currency` varchar(16) COLLATE utf8mb4_bin NOT NULL,
  `pledge_visibility` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT 'HiddenFromAll',
  `pledge_name_visibility` varchar(32) COLLATE utf8mb4_bin NOT NULL DEFAULT 'VisibleToWishOwner',
  PRIMARY KEY (`pledge_id`),
  KEY `user_id` (`user_id`),
  KEY `pledge_wish_FK` (`wish_id`),
  CONSTRAINT `pledge_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON UPDATE CASCADE,
  CONSTRAINT `pledge_wish_FK` FOREIGN KEY (`wish_id`) REFERENCES `wish` (`wish_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pledge_coupon`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pledge_coupon` (
  `pledge_id` int(11) NOT NULL,
  `coupon_id` int(11) NOT NULL,
  PRIMARY KEY (`pledge_id`),
  KEY `pledge_coupon_coupon_FK` (`coupon_id`),
  CONSTRAINT `pledge_coupon_coupon_FK` FOREIGN KEY (`coupon_id`) REFERENCES `coupon` (`coupon_id`) ON UPDATE CASCADE,
  CONSTRAINT `pledge_coupon_pledge_FK` FOREIGN KEY (`pledge_id`) REFERENCES `pledge` (`pledge_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pledge_paypal`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pledge_paypal` (
  `pledge_id` int(11) NOT NULL,
  `paypal_order_id` varchar(64) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`pledge_id`),
  UNIQUE KEY `pledge_paypal_UN` (`paypal_order_id`),
  CONSTRAINT `pledge_paypal_FK` FOREIGN KEY (`pledge_id`) REFERENCES `pledge` (`pledge_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pledge_stripe`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pledge_stripe` (
  `pledge_id` int(11) NOT NULL,
  `stripe_charge_id` varchar(64) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`pledge_id`),
  UNIQUE KEY `pledge_stripe_UN` (`stripe_charge_id`),
  CONSTRAINT `pledge_stripe_pledge_FK` FOREIGN KEY (`pledge_id`) REFERENCES `pledge` (`pledge_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sessions`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sessions` (
  `session_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `expires` int(11) unsigned NOT NULL,
  `data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  PRIMARY KEY (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_hashid` varchar(128) COLLATE utf8mb4_bin DEFAULT NULL,
  `user_primary_email` varchar(128) COLLATE utf8mb4_bin DEFAULT NULL,
  `user_name` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL,
  `user_birthday` date DEFAULT NULL,
  `user_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `user_note` text COLLATE utf8mb4_bin,
  `user_avatar` longblob,
  `user_description` varchar(300) COLLATE utf8mb4_bin DEFAULT NULL,
  `user_avatar_url` mediumtext COLLATE utf8mb4_bin,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_hashid` (`user_hashid`),
  KEY `user_primary_email` (`user_primary_email`)
) ENGINE=InnoDB AUTO_INCREMENT=108 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_facebook`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_facebook` (
  `user_id` int(11) NOT NULL,
  `facebook_id` varchar(64) COLLATE utf8mb4_bin NOT NULL,
  `passport_profile` json DEFAULT NULL,
  `visible` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_facebook_UN` (`facebook_id`),
  CONSTRAINT `user_facebook_FK` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_github`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_github` (
  `user_id` int(11) NOT NULL,
  `github_id` varchar(64) COLLATE utf8mb4_bin NOT NULL,
  `passport_profile` json DEFAULT NULL,
  `visible` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_github_UN` (`github_id`),
  CONSTRAINT `user_github_FK` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_gitlab`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_gitlab` (
  `user_id` int(11) NOT NULL,
  `gitlab_id` varchar(64) COLLATE utf8mb4_bin NOT NULL,
  `passport_profile` json NOT NULL,
  `visible` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_gitlab_UN` (`gitlab_id`),
  CONSTRAINT `user_gitlab_FK` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_google`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_google` (
  `user_id` int(11) NOT NULL,
  `google_id` varchar(64) COLLATE utf8mb4_bin NOT NULL,
  `passport_profile` json NOT NULL,
  `visible` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_google_UN` (`google_id`),
  CONSTRAINT `user_google_FK` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_role`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_role` (
  `user_id` int(11) NOT NULL,
  `user_role` varchar(11) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`user_id`,`user_role`),
  CONSTRAINT `user_role_FK` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_stripe`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_stripe` (
  `user_id` int(11) NOT NULL,
  `stripe_customer_id` varchar(64) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`user_id`,`stripe_customer_id`),
  UNIQUE KEY `user_stripe_UN` (`stripe_customer_id`),
  CONSTRAINT `user_stripe_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_twitch`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_twitch` (
  `user_id` int(11) NOT NULL,
  `twitch_id` varchar(64) COLLATE utf8mb4_bin NOT NULL,
  `passport_profile` json NOT NULL,
  `visible` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_twitch_UN` (`twitch_id`),
  CONSTRAINT `user_twitch_user_FK` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_twitter`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_twitter` (
  `user_id` int(11) NOT NULL,
  `twitter_id` varchar(64) COLLATE utf8mb4_bin NOT NULL,
  `passport_profile` json NOT NULL,
  `visible` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_twitter_UN` (`twitter_id`),
  CONSTRAINT `user_twitter_FK` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_url`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_url` (
  `user_id` int(11) NOT NULL,
  `user_url` varchar(64) CHARACTER SET utf8mb4 NOT NULL,
  `time_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_latest` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`user_url`),
  KEY `user_url_user_FK` (`user_id`),
  CONSTRAINT `user_url_user_FK` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_youtube`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_youtube` (
  `user_id` int(11) NOT NULL,
  `youtube_id` varchar(64) COLLATE utf8mb4_bin NOT NULL,
  `passport_profile` json NOT NULL,
  `visible` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_youtube_UN` (`youtube_id`),
  CONSTRAINT `user_youtube_user_FK` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wish`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wish` (
  `wish_id` int(11) NOT NULL AUTO_INCREMENT,
  `wish_hashid` varchar(128) COLLATE utf8mb4_bin DEFAULT NULL,
  `user_id` int(11) NOT NULL COMMENT 'owner',
  `wish_time_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `wish_time_publish` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `wish_description` text COLLATE utf8mb4_bin,
  `wish_state` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT 'created',
  `wish_note` text COLLATE utf8mb4_bin,
  `wish_title` varchar(128) COLLATE utf8mb4_bin DEFAULT NULL,
  `wish_target_date` timestamp NULL DEFAULT NULL,
  `wish_currency` varchar(16) COLLATE utf8mb4_bin NOT NULL,
  `wish_banner_url` varchar(1024) COLLATE utf8mb4_bin DEFAULT NULL,
  `wish_additional_cost_amount` decimal(16,4) DEFAULT NULL,
  `wish_additional_cost_description` varchar(128) COLLATE utf8mb4_bin DEFAULT NULL,
  `wish_featured` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`wish_id`),
  UNIQUE KEY `wish_hashid` (`wish_hashid`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `wish_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wish_charge`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wish_charge` (
  `charge_id` int(11) NOT NULL AUTO_INCREMENT,
  `charge_amount` decimal(16,4) NOT NULL,
  `charge_note` text COLLATE utf8mb4_bin,
  `charge_time_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` int(11) NOT NULL,
  `wish_id` int(11) NOT NULL,
  `charge_currency` varchar(16) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`charge_id`),
  KEY `charge_user_FK` (`user_id`),
  KEY `charge_wish_FK` (`wish_id`),
  CONSTRAINT `charge_user_FK` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON UPDATE CASCADE,
  CONSTRAINT `charge_wish_FK` FOREIGN KEY (`wish_id`) REFERENCES `wish` (`wish_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wish_item`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wish_item` (
  `wish_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `item_quantity` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`wish_id`,`item_id`),
  KEY `wish_item_item_FK` (`item_id`),
  CONSTRAINT `wish_item_item_FK` FOREIGN KEY (`item_id`) REFERENCES `item` (`item_id`) ON UPDATE CASCADE,
  CONSTRAINT `wish_item_wish_FK` FOREIGN KEY (`wish_id`) REFERENCES `wish` (`wish_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'giffon'
--
