CREATE TABLE `user_role` (
  `user_id` int(11) NOT NULL,
  `user_role` varchar(11) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`user_id`,`user_role`),
  CONSTRAINT `user_role_FK` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
