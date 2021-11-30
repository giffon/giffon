CREATE TABLE `user_stripe` (
  `user_id` int(11) NOT NULL,
  `stripe_customer_id` varchar(64) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`user_id`,`stripe_customer_id`),
  UNIQUE KEY `user_stripe_UN` (`stripe_customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
