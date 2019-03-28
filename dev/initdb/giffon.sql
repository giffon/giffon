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
  `item_time_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
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
  `pledge_state` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT 'pledged',
  `pledge_note` text COLLATE utf8mb4_bin,
  PRIMARY KEY (`pledge_id`),
  UNIQUE KEY `wish_id` (`wish_id`) USING BTREE,
  KEY `user_id` (`user_id`),
  CONSTRAINT `pledge_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON UPDATE CASCADE,
  CONSTRAINT `pledge_wish_FK` FOREIGN KEY (`wish_id`) REFERENCES `wish` (`wish_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pledge_charge`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pledge_charge` (
  `charge_id` int(11) NOT NULL AUTO_INCREMENT,
  `pledge_id` int(11) NOT NULL,
  `charge_amount` decimal(16,4) NOT NULL,
  `charge_note` text COLLATE utf8mb4_bin,
  `charge_time_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`charge_id`),
  KEY `pledge_id` (`pledge_id`),
  CONSTRAINT `pledge_charge_ibfk_1` FOREIGN KEY (`pledge_id`) REFERENCES `pledge` (`pledge_id`) ON UPDATE CASCADE
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
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_hashid` (`user_hashid`),
  KEY `user_primary_email` (`user_primary_email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
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
  PRIMARY KEY (`wish_id`),
  UNIQUE KEY `wish_hashid` (`wish_hashid`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `wish_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON UPDATE CASCADE
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
  PRIMARY KEY (`wish_id`,`item_id`),
  KEY `wish_item_item_FK` (`item_id`),
  CONSTRAINT `wish_item_item_FK` FOREIGN KEY (`item_id`) REFERENCES `item` (`item_id`) ON UPDATE CASCADE,
  CONSTRAINT `wish_item_wish_FK` FOREIGN KEY (`wish_id`) REFERENCES `wish` (`wish_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'giffon'
--
