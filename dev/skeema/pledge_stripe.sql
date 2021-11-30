CREATE TABLE `pledge_stripe` (
  `pledge_id` int(11) NOT NULL,
  `stripe_charge_id` varchar(64) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`pledge_id`),
  UNIQUE KEY `pledge_stripe_UN` (`stripe_charge_id`),
  CONSTRAINT `pledge_stripe_pledge_FK` FOREIGN KEY (`pledge_id`) REFERENCES `pledge` (`pledge_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
