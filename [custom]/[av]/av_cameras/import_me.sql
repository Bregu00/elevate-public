CREATE TABLE IF NOT EXISTS `av_cameras` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) DEFAULT NULL,
  `owner` varchar(80) DEFAULT NULL,
  `group` varchar(50) DEFAULT NULL,
  `label` varchar(50) DEFAULT NULL,
  `location` longtext DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `thumbnail` longtext DEFAULT NULL,
  `coords` longtext DEFAULT NULL,
  `battery` varchar(50) DEFAULT NULL,
  `settings` longtext DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
