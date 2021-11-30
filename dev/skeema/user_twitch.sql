CREATE TABLE `user_twitch` (
  `user_id` int NOT NULL,
  `twitch_id` varchar(64) COLLATE utf8mb4_bin NOT NULL,
  `passport_profile` json NOT NULL,
  `visible` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_twitch_UN` (`twitch_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
