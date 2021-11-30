CREATE TABLE `user_gitlab` (
  `user_id` int(11) NOT NULL,
  `gitlab_id` varchar(64) COLLATE utf8mb4_bin NOT NULL,
  `passport_profile` json NOT NULL,
  `visible` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_gitlab_UN` (`gitlab_id`),
  CONSTRAINT `user_gitlab_FK` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
