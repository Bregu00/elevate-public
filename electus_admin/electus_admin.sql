CREATE TABLE IF NOT EXISTS `electus_admin_active_admins` (
  `license` varchar(255) NOT NULL,
  `last_login` int(11) DEFAULT NULL,
  `saved_time` int(11) DEFAULT 0,
  `logged_in` tinyint(4) DEFAULT 1,
  PRIMARY KEY (`license`)
);

CREATE TABLE IF NOT EXISTS `electus_admin_alerts` (
  `alert_id` int(255) NOT NULL AUTO_INCREMENT,
  `alert_name` varchar(255) DEFAULT NULL,
  `alert_item` varchar(255) DEFAULT NULL,
  `alert_type` varchar(255) DEFAULT NULL,
  `amount` int(11) DEFAULT NULL,
  PRIMARY KEY (`alert_id`)
);

CREATE TABLE IF NOT EXISTS `electus_admin_active_alerts` (
  `alert_id` int(255) DEFAULT NULL,
  `identifier` varchar(46) DEFAULT NULL,
  `time` timestamp NULL DEFAULT current_timestamp(),
  KEY `electus_admin_alerts_alert_id_fk` (`alert_id`),
  CONSTRAINT `electus_admin_alerts_alert_id_fk` FOREIGN KEY (`alert_id`) REFERENCES `electus_admin_alerts` (`alert_id`) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE IF NOT EXISTS `electus_admin_bans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `license` varchar(100) DEFAULT NULL,
  `discord` varchar(100) DEFAULT NULL,
  `ip` varchar(50) DEFAULT NULL,
  `reason` text DEFAULT NULL,
  `expire` datetime DEFAULT NULL,
  `permanent` int(1) DEFAULT NULL,
  `banned_by` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `license` (`license`),
  KEY `discord` (`discord`),
  KEY `ip` (`ip`)
);

CREATE TABLE IF NOT EXISTS `electus_admin_daily_stats` (
  `players` int(11) DEFAULT NULL,
  `balance` int(11) DEFAULT NULL,
  `items` text DEFAULT NULL,
  `jobs` text DEFAULT NULL,
  `timestamp` datetime DEFAULT current_timestamp()
);

CREATE TABLE IF NOT EXISTS `electus_admin_monthly_stats` (
  `players` int(11) DEFAULT NULL,
  `balance` int(11) DEFAULT NULL,
  `items` text DEFAULT NULL,
  `jobs` text DEFAULT NULL,
  `timestamp` datetime DEFAULT current_timestamp()
);

CREATE TABLE IF NOT EXISTS `electus_admin_names` (
  `license` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS `electus_admin_roles` (
  `name` varchar(255) NOT NULL,
  `label` varchar(255) DEFAULT NULL,
  `color` varchar(50) DEFAULT NULL,
  `grade` smallint(6) DEFAULT NULL,
  `permissions` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`name`)
);

CREATE TABLE IF NOT EXISTS `electus_admin_staffs` (
  `username` varchar(200) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `license` varchar(255) DEFAULT NULL,
  `role` varchar(255) DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS `electus_admin_warnings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `license` varchar(100) DEFAULT NULL,
  `discord` varchar(50) DEFAULT NULL,
  `ip` varchar(50) DEFAULT NULL,
  `reason` text DEFAULT NULL,
  `warned_by` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `license` (`license`),
  KEY `discord` (`discord`),
  KEY `ip` (`ip`)
);

CREATE TABLE IF NOT EXISTS `electus_admin_weekly_stats` (
  `players` int(11) DEFAULT NULL,
  `balance` int(11) DEFAULT NULL,
  `items` text DEFAULT NULL,
  `jobs` text DEFAULT NULL,
  `timestamp` datetime DEFAULT current_timestamp()
);