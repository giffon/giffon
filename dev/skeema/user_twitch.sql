CREATE TABLE `user_twitch` (
  `user_id` int(11) NOT NULL,
  `twitch_id` varchar(64) COLLATE utf8mb4_bin NOT NULL,
  `passport_profile` json NOT NULL,
  `visible` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_twitch_UN` (`twitch_id`),
  CONSTRAINT `user_twitch_user_FK` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
