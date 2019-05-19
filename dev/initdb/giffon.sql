-- MySQL dump 10.13  Distrib 5.7.25, for osx10.14 (x86_64)
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
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED='';

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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
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
  PRIMARY KEY (`pledge_id`),
  KEY `user_id` (`user_id`),
  KEY `pledge_wish_FK` (`wish_id`),
  CONSTRAINT `pledge_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON UPDATE CASCADE,
  CONSTRAINT `pledge_wish_FK` FOREIGN KEY (`wish_id`) REFERENCES `wish` (`wish_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
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
  `user_primary_email` varchar(128) COLLATE utf8mb4_bin NOT NULL,
  `user_name` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL,
  `user_birthday` date DEFAULT NULL,
  `user_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `user_note` text COLLATE utf8mb4_bin,
  `user_avatar` longblob,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_hashid` (`user_hashid`),
  KEY `user_primary_email` (`user_primary_email`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_facebook`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_facebook` (
  `user_id` int(11) NOT NULL,
  `facebook_id` varchar(64) COLLATE utf8mb4_bin NOT NULL,
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
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_github_UN` (`github_id`),
  CONSTRAINT `user_github_FK` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON UPDATE CASCADE
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
  PRIMARY KEY (`wish_id`),
  UNIQUE KEY `wish_hashid` (`wish_hashid`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `wish_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
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
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-05-19 19:11:33
