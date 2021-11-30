CREATE TABLE `pledge_coupon` (
  `pledge_id` int(11) NOT NULL,
  `coupon_id` int(11) NOT NULL,
  PRIMARY KEY (`pledge_id`),
  KEY `pledge_coupon_coupon_FK` (`coupon_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
