CREATE TABLE `user_youtube` (
  `user_id` int(11) NOT NULL,
  `youtube_id` varchar(64) COLLATE utf8mb4_bin NOT NULL,
  `passport_profile` json NOT NULL,
  `visible` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_youtube_UN` (`youtube_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
