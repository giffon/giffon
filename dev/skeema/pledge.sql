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
  KEY `pledge_wish_FK` (`wish_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
