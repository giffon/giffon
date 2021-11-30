CREATE TABLE `user_facebook` (
  `user_id` int NOT NULL,
  `facebook_id` varchar(64) COLLATE utf8mb4_bin NOT NULL,
  `passport_profile` json DEFAULT NULL,
  `visible` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_facebook_UN` (`facebook_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
