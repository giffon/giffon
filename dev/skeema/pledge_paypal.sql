CREATE TABLE `pledge_paypal` (
  `pledge_id` int NOT NULL,
  `paypal_order_id` varchar(64) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`pledge_id`),
  UNIQUE KEY `pledge_paypal_UN` (`paypal_order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
