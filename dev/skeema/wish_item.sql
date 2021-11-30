CREATE TABLE `wish_item` (
  `wish_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `item_quantity` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`wish_id`,`item_id`),
  KEY `wish_item_item_FK` (`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
