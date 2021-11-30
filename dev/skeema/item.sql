CREATE TABLE `item` (
  `item_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `item_url` varchar(1024) COLLATE utf8mb4_bin NOT NULL,
  `item_url_screenshot` longblob,
  `item_name` varchar(128) COLLATE utf8mb4_bin DEFAULT NULL,
  `item_price` decimal(16,4) DEFAULT NULL,
  `item_time_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `item_time_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `item_currency` varchar(16) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
