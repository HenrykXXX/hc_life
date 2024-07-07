-- Create the database if it does not exist
CREATE DATABASE IF NOT EXISTS `hc_life`;

-- Use the newly created database
USE `hc_life`;

-- Create the users table if it does not exist
CREATE TABLE IF NOT EXISTS `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `identifier` varchar(255) NOT NULL,
  `license` varchar(255) DEFAULT NULL,
  `steam` varchar(255) DEFAULT NULL,
  `discord` varchar(255) DEFAULT NULL,
  `xbl` varchar(255) DEFAULT NULL,
  `live` varchar(255) DEFAULT NULL,
  `ip` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `money` int DEFAULT 0,
  `bank` int DEFAULT 0,
  `inventory` text,
  `vehicles` text,
  `last_login` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `identifier` (`identifier`)
);

-- Create the vehicles table if it does not exist
CREATE TABLE IF NOT EXISTS `vehicles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `model` varchar(255) NOT NULL,
  `trunk` text,
  `owner` varchar(255) NOT NULL,
  `spawned` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
);
