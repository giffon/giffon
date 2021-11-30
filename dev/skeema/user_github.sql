CREATE TABLE `user_github` (
  `user_id` int NOT NULL,
  `github_id` varchar(64) COLLATE utf8mb4_bin NOT NULL,
  `passport_profile` json DEFAULT NULL,
  `visible` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_github_UN` (`github_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
