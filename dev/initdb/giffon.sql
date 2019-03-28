-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Host: giffon.cluster-czhm2i8itlng.us-east-1.rds.amazonaws.com
-- Generation Time: Oct 13, 2018 at 08:02 AM
-- Server version: 5.6.10
-- PHP Version: 7.2.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `giffon`
--

-- --------------------------------------------------------

--
-- Table structure for table `campaign`
--

CREATE TABLE `campaign` (
  `campaign_id` int(11) NOT NULL,
  `campaign_hashid` varchar(128) COLLATE utf8mb4_bin DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `campaign_time_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `campaign_time_publish` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `item_group_id` int(11) DEFAULT NULL,
  `campaign_description` text COLLATE utf8mb4_bin,
  `campaign_type` varchar(64) COLLATE utf8mb4_bin NOT NULL,
  `campaign_state` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT 'created',
  `campaign_note` text COLLATE utf8mb4_bin
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- --------------------------------------------------------

--
-- Table structure for table `campaign_surprise`
--

CREATE TABLE `campaign_surprise` (
  `campaign_id` int(11) NOT NULL,
  `campaign_progress` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT 'started'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- --------------------------------------------------------

--
-- Table structure for table `item`
--

CREATE TABLE `item` (
  `item_id` int(11) NOT NULL,
  `item_url` varchar(1024) COLLATE utf8mb4_bin NOT NULL,
  `item_url_screenshot` longblob,
  `item_name` varchar(128) COLLATE utf8mb4_bin DEFAULT NULL,
  `item_price` decimal(16,4) DEFAULT NULL,
  `item_time_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `shop_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- --------------------------------------------------------

--
-- Table structure for table `item_group`
--

CREATE TABLE `item_group` (
  `item_group_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- --------------------------------------------------------

--
-- Table structure for table `pledge`
--

CREATE TABLE `pledge` (
  `pledge_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `campaign_id` int(11) NOT NULL,
  `pledge_amount` decimal(16,4) NOT NULL,
  `pledge_time_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `pledge_method` varchar(64) COLLATE utf8mb4_bin NOT NULL,
  `pledge_state` varchar(64) COLLATE utf8mb4_bin NOT NULL DEFAULT 'pledged',
  `pledge_note` text COLLATE utf8mb4_bin
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- --------------------------------------------------------

--
-- Table structure for table `pledge_charge`
--

CREATE TABLE `pledge_charge` (
  `charge_id` int(11) NOT NULL,
  `pledge_id` int(11) NOT NULL,
  `charge_amount` decimal(16,4) NOT NULL,
  `charge_note` text COLLATE utf8mb4_bin,
  `charge_time_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- --------------------------------------------------------

--
-- Table structure for table `shop`
--

CREATE TABLE `shop` (
  `shop_id` int(11) NOT NULL,
  `shop_name` varchar(64) COLLATE utf8mb4_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `user_id` int(11) NOT NULL,
  `user_hashid` varchar(128) COLLATE utf8mb4_bin DEFAULT NULL,
  `user_primary_email` varchar(128) COLLATE utf8mb4_bin NOT NULL,
  `user_name` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL,
  `user_birthday` date DEFAULT NULL,
  `user_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `user_note` text COLLATE utf8mb4_bin
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- --------------------------------------------------------

--
-- Table structure for table `user_email`
--

CREATE TABLE `user_email` (
  `user_id` int(11) NOT NULL,
  `user_email` varchar(128) COLLATE utf8mb4_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- --------------------------------------------------------

--
-- Table structure for table `user_stripe`
--

CREATE TABLE `user_stripe` (
  `user_id` int(11) NOT NULL,
  `stripe_customer_id` varchar(64) COLLATE utf8mb4_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `campaign`
--
ALTER TABLE `campaign`
  ADD PRIMARY KEY (`campaign_id`),
  ADD UNIQUE KEY `campaign_url_key` (`campaign_hashid`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `campaign_surprise`
--
ALTER TABLE `campaign_surprise`
  ADD PRIMARY KEY (`campaign_id`);

--
-- Indexes for table `item`
--
ALTER TABLE `item`
  ADD PRIMARY KEY (`item_id`),
  ADD KEY `shop_id` (`shop_id`);

--
-- Indexes for table `item_group`
--
ALTER TABLE `item_group`
  ADD PRIMARY KEY (`item_group_id`,`item_id`),
  ADD KEY `item_id` (`item_id`);

--
-- Indexes for table `pledge`
--
ALTER TABLE `pledge`
  ADD PRIMARY KEY (`pledge_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `campaign_id` (`campaign_id`);

--
-- Indexes for table `pledge_charge`
--
ALTER TABLE `pledge_charge`
  ADD PRIMARY KEY (`charge_id`),
  ADD KEY `pledge_id` (`pledge_id`);

--
-- Indexes for table `shop`
--
ALTER TABLE `shop`
  ADD PRIMARY KEY (`shop_id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `user_hashid` (`user_hashid`),
  ADD KEY `user_primary_email` (`user_primary_email`);

--
-- Indexes for table `user_email`
--
ALTER TABLE `user_email`
  ADD PRIMARY KEY (`user_id`,`user_email`),
  ADD KEY `user_email` (`user_email`);

--
-- Indexes for table `user_stripe`
--
ALTER TABLE `user_stripe`
  ADD PRIMARY KEY (`user_id`,`stripe_customer_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `campaign`
--
ALTER TABLE `campaign`
  MODIFY `campaign_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `item`
--
ALTER TABLE `item`
  MODIFY `item_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `item_group`
--
ALTER TABLE `item_group`
  MODIFY `item_group_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pledge`
--
ALTER TABLE `pledge`
  MODIFY `pledge_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pledge_charge`
--
ALTER TABLE `pledge_charge`
  MODIFY `charge_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `shop`
--
ALTER TABLE `shop`
  MODIFY `shop_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `campaign`
--
ALTER TABLE `campaign`
  ADD CONSTRAINT `campaign_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON UPDATE CASCADE;

--
-- Constraints for table `campaign_surprise`
--
ALTER TABLE `campaign_surprise`
  ADD CONSTRAINT `campaign_surprise_ibfk_1` FOREIGN KEY (`campaign_id`) REFERENCES `campaign` (`campaign_id`) ON UPDATE CASCADE;

--
-- Constraints for table `item`
--
ALTER TABLE `item`
  ADD CONSTRAINT `item_ibfk_1` FOREIGN KEY (`shop_id`) REFERENCES `shop` (`shop_id`) ON UPDATE CASCADE;

--
-- Constraints for table `item_group`
--
ALTER TABLE `item_group`
  ADD CONSTRAINT `item_group_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `item` (`item_id`) ON UPDATE CASCADE;

--
-- Constraints for table `pledge`
--
ALTER TABLE `pledge`
  ADD CONSTRAINT `pledge_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `pledge_ibfk_2` FOREIGN KEY (`campaign_id`) REFERENCES `campaign` (`campaign_id`) ON UPDATE CASCADE;

--
-- Constraints for table `pledge_charge`
--
ALTER TABLE `pledge_charge`
  ADD CONSTRAINT `pledge_charge_ibfk_1` FOREIGN KEY (`pledge_id`) REFERENCES `pledge` (`pledge_id`) ON UPDATE CASCADE;

--
-- Constraints for table `user_email`
--
ALTER TABLE `user_email`
  ADD CONSTRAINT `user_email_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON UPDATE CASCADE;

--
-- Constraints for table `user_stripe`
--
ALTER TABLE `user_stripe`
  ADD CONSTRAINT `user_stripe_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
