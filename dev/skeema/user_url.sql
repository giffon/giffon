CREATE TABLE `user_url` (
  `user_id` int(11) NOT NULL,
  `user_url` varchar(64) CHARACTER SET utf8mb4 NOT NULL,
  `time_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_latest` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`user_url`),
  KEY `user_url_user_FK` (`user_id`),
  CONSTRAINT `user_url_user_FK` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
