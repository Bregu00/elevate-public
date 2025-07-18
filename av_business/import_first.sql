CREATE TABLE IF NOT EXISTS `av_items` (
  `job` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  `label` varchar(50) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `image` longtext DEFAULT NULL,
  `description` varchar(50) DEFAULT NULL,
  `weight` varchar(50) DEFAULT NULL,
  `ingredients` longtext DEFAULT NULL,
  `prop` varchar(50) DEFAULT NULL,
  `price` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `av_business` (
  `name` varchar(50) NOT NULL,
  `job` varchar(50) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `data` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `av_society` (
  `job` varchar(50) DEFAULT NULL,
  `money` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;