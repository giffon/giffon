CREATE TABLE `wish_item` (
  `wish_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `item_quantity` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`wish_id`,`item_id`),
  KEY `wish_item_item_FK` (`item_id`),
  CONSTRAINT `wish_item_item_FK` FOREIGN KEY (`item_id`) REFERENCES `item` (`item_id`) ON UPDATE CASCADE,
  CONSTRAINT `wish_item_wish_FK` FOREIGN KEY (`wish_id`) REFERENCES `wish` (`wish_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
