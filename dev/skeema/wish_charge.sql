CREATE TABLE `wish_charge` (
  `charge_id` int(11) NOT NULL AUTO_INCREMENT,
  `charge_amount` decimal(16,4) NOT NULL,
  `charge_note` text COLLATE utf8mb4_bin,
  `charge_time_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` int(11) NOT NULL,
  `wish_id` int(11) NOT NULL,
  `charge_currency` varchar(16) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`charge_id`),
  KEY `charge_user_FK` (`user_id`),
  KEY `charge_wish_FK` (`wish_id`),
  CONSTRAINT `charge_user_FK` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`) ON UPDATE CASCADE,
  CONSTRAINT `charge_wish_FK` FOREIGN KEY (`wish_id`) REFERENCES `wish` (`wish_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
