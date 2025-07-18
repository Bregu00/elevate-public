CREATE TABLE IF NOT EXISTS `drp_dpay_activities` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `date` date NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `positive` tinyint(1) NOT NULL,
  `isCompany` tinyint(1) NOT NULL,
  `number` varchar(20) NOT NULL,
  `userNumber` varchar(20) NOT NULL,
  `message` varchar(255) DEFAULT NULL,
  `isRequest` tinyint(1) DEFAULT NULL,
  `requestPaid` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
