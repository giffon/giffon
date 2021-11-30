CREATE TABLE `pledge_coupon` (
  `pledge_id` int(11) NOT NULL,
  `coupon_id` int(11) NOT NULL,
  PRIMARY KEY (`pledge_id`),
  KEY `pledge_coupon_coupon_FK` (`coupon_id`),
  CONSTRAINT `pledge_coupon_coupon_FK` FOREIGN KEY (`coupon_id`) REFERENCES `coupon` (`coupon_id`) ON UPDATE CASCADE,
  CONSTRAINT `pledge_coupon_pledge_FK` FOREIGN KEY (`pledge_id`) REFERENCES `pledge` (`pledge_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
