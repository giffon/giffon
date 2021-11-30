CREATE TABLE `pledge_paypal` (
  `pledge_id` int(11) NOT NULL,
  `paypal_order_id` varchar(64) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`pledge_id`),
  UNIQUE KEY `pledge_paypal_UN` (`paypal_order_id`),
  CONSTRAINT `pledge_paypal_FK` FOREIGN KEY (`pledge_id`) REFERENCES `pledge` (`pledge_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
