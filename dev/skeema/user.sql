CREATE TABLE `user` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_hashid` varchar(128) COLLATE utf8mb4_bin DEFAULT NULL,
  `user_primary_email` varchar(128) COLLATE utf8mb4_bin DEFAULT NULL,
  `user_name` varchar(64) COLLATE utf8mb4_bin DEFAULT NULL,
  `user_birthday` date DEFAULT NULL,
  `user_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `user_note` text COLLATE utf8mb4_bin,
  `user_avatar` longblob,
  `user_description` varchar(300) COLLATE utf8mb4_bin DEFAULT NULL,
  `user_avatar_url` mediumtext COLLATE utf8mb4_bin,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_hashid` (`user_hashid`),
  KEY `user_primary_email` (`user_primary_email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
