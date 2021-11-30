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
  KEY `coupon_user_FK` (`coupon_creator_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
