CREATE TABLE `pledge_stripe` (
  `pledge_id` int NOT NULL,
  `stripe_charge_id` varchar(64) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`pledge_id`),
  UNIQUE KEY `pledge_stripe_UN` (`stripe_charge_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
