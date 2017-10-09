-- MySQL dump 10.16  Distrib 10.1.19-MariaDB, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: 127.0.0.1
-- ------------------------------------------------------
-- Server version	10.1.16-MariaDB-1~jessie

--
-- Table structure for table `admin`
--

create database postfix;
GRANT ALL PRIVILEGES ON postfix.* TO 'mysqluser'@'%' WITH GRANT OPTION;
USE postfix;

DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin` (
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `superadmin` tinyint(1) NOT NULL DEFAULT '0',
  `created` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `modified` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`username`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Postfix Admin - Virtual Admins';

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
INSERT INTO `admin` VALUES ('admin@domain.tld','{SHA512-CRYPT}$6$Wt7uQEnB6HPP6mM0$lOP8IKtEUJKWSwczEC5/g6aYamkwh5rx3ztnRuqcRLJjGTXiLpUnxzUgy2rfNieH9C8x7M6Nr9q19SG6njUj//',1,'2016-11-28 08:53:31','2016-11-28 08:53:31',1);
UNLOCK TABLES;

--
-- Table structure for table `alias`
--

DROP TABLE IF EXISTS `alias`;
CREATE TABLE `alias` (
  `address` varchar(255) NOT NULL,
  `goto` text NOT NULL,
  `domain` varchar(255) NOT NULL,
  `created` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `modified` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`address`),
  KEY `domain` (`domain`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Postfix Admin - Virtual Aliases';

--
-- Dumping data for table `alias`
--

LOCK TABLES `alias` WRITE;
/*!40000 ALTER TABLE `alias` DISABLE KEYS */;
INSERT INTO `alias` VALUES ('postmaster@domain.tld','john.doe@domain.tld','domain.tld','2016-11-28 08:54:26','2016-11-28 08:58:19',1),('hostmaster@domain.tld','john.doe@domain.tld','domain.tld','2016-11-28 08:54:26','2016-11-28 08:58:19',1),('john.doe@domain.tld','john.doe@domain.tld','domain.tld','2016-11-28 08:56:47','2016-11-28 08:56:47',1),('sarah.connor@domain.tld','sarah.connor@domain.tld','domain.tld','2016-11-28 08:57:51','2016-11-28 08:57:51',1);
/*!40000 ALTER TABLE `alias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `alias_domain`
--

DROP TABLE IF EXISTS `alias_domain`;
CREATE TABLE `alias_domain` (
  `alias_domain` varchar(255) NOT NULL,
  `target_domain` varchar(255) NOT NULL,
  `created` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `modified` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`alias_domain`),
  KEY `active` (`active`),
  KEY `target_domain` (`target_domain`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Postfix Admin - Domain Aliases';

--
-- Dumping data for table `alias_domain`
--

LOCK TABLES `alias_domain` WRITE;
UNLOCK TABLES;

--
-- Table structure for table `config`
--

DROP TABLE IF EXISTS `config`;
CREATE TABLE `config` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL DEFAULT '',
  `value` varchar(20) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COMMENT='PostfixAdmin settings';

--
-- Dumping data for table `config`
--

LOCK TABLES `config` WRITE;
INSERT INTO `config` VALUES (1,'version','1835');
UNLOCK TABLES;

--
-- Table structure for table `domain`
--

DROP TABLE IF EXISTS `domain`;
CREATE TABLE `domain` (
  `domain` varchar(255) NOT NULL,
  `description` varchar(255) CHARACTER SET utf8 NOT NULL,
  `aliases` int(10) NOT NULL DEFAULT '0',
  `mailboxes` int(10) NOT NULL DEFAULT '0',
  `maxquota` bigint(20) NOT NULL DEFAULT '0',
  `quota` bigint(20) NOT NULL DEFAULT '0',
  `transport` varchar(255) NOT NULL,
  `backupmx` tinyint(1) NOT NULL DEFAULT '0',
  `created` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `modified` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`domain`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Postfix Admin - Virtual Domains';

--
-- Dumping data for table `domain`
--

LOCK TABLES `domain` WRITE;
INSERT INTO `domain` VALUES ('ALL','',0,0,0,0,'',0,'2016-11-28 08:53:31','2016-11-28 08:53:31',1),('domain.tld','Test domain',0,0,1,0,'virtual',0,'2016-11-28 08:54:26','2016-11-28 08:54:26',1);
UNLOCK TABLES;

--
-- Table structure for table `domain_admins`
--

DROP TABLE IF EXISTS `domain_admins`;
CREATE TABLE `domain_admins` (
  `username` varchar(255) NOT NULL,
  `domain` varchar(255) NOT NULL,
  `created` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  KEY `username` (`username`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Postfix Admin - Domain Admins';

--
-- Dumping data for table `domain_admins`
--

LOCK TABLES `domain_admins` WRITE;
INSERT INTO `domain_admins` VALUES ('admin@domain.tld','ALL','2016-11-28 08:53:31',1);
UNLOCK TABLES;

--
-- Table structure for table `fetchmail`
--

DROP TABLE IF EXISTS `fetchmail`;
CREATE TABLE `fetchmail` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `domain` varchar(255) DEFAULT '',
  `mailbox` varchar(255) NOT NULL,
  `src_server` varchar(255) NOT NULL,
  `src_auth` enum('password','kerberos_v5','kerberos','kerberos_v4','gssapi','cram-md5','otp','ntlm','msn','ssh','any') DEFAULT NULL,
  `src_user` varchar(255) NOT NULL,
  `src_password` varchar(255) NOT NULL,
  `src_folder` varchar(255) NOT NULL,
  `poll_time` int(11) unsigned NOT NULL DEFAULT '10',
  `fetchall` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `keep` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `protocol` enum('POP3','IMAP','POP2','ETRN','AUTO') DEFAULT NULL,
  `usessl` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `sslcertck` tinyint(1) NOT NULL DEFAULT '0',
  `sslcertpath` varchar(255) CHARACTER SET utf8 DEFAULT '',
  `sslfingerprint` varchar(255) DEFAULT '',
  `extra_options` text,
  `returned_text` text,
  `mda` varchar(255) NOT NULL,
  `date` timestamp NOT NULL DEFAULT '2000-01-01 00:00:00',
  `created` timestamp NOT NULL DEFAULT '2000-01-01 00:00:00',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `active` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `fetchmail`
--

LOCK TABLES `fetchmail` WRITE;
INSERT INTO `fetchmail` VALUES (1,'domain.tld','sarah.connor@domain.tld','127.0.0.1','password','john.doe@domain.tld','dGVzdHBhc3N3ZDEy','',10,1,1,'IMAP',1,0,'','','','','','2016-12-05 11:59:01','2016-12-05 11:58:53','2016-12-05 11:58:53',1);
UNLOCK TABLES;

--
-- Table structure for table `log`
--

DROP TABLE IF EXISTS `log`;
CREATE TABLE `log` (
  `timestamp` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `username` varchar(255) NOT NULL,
  `domain` varchar(255) NOT NULL,
  `action` varchar(255) NOT NULL,
  `data` text NOT NULL,
  KEY `timestamp` (`timestamp`),
  KEY `domain_timestamp` (`domain`,`timestamp`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Postfix Admin - Log';

--
-- Dumping data for table `log`
--

LOCK TABLES `log` WRITE;
UNLOCK TABLES;

--
-- Table structure for table `mailbox`
--

DROP TABLE IF EXISTS `mailbox`;
CREATE TABLE `mailbox` (
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `name` varchar(255) CHARACTER SET utf8 NOT NULL,
  `maildir` varchar(255) NOT NULL,
  `quota` bigint(20) NOT NULL DEFAULT '0',
  `local_part` varchar(255) NOT NULL,
  `domain` varchar(255) NOT NULL,
  `created` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `modified` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`username`),
  KEY `domain` (`domain`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='Postfix Admin - Virtual Mailboxes';

--
-- Dumping data for table `mailbox`
--

LOCK TABLES `mailbox` WRITE;
INSERT INTO `mailbox` VALUES ('john.doe@domain.tld','{SHA512-CRYPT}$6$v1LkarodHyGGmfoy$ZszVBzfEZ0CaVnYaBasgvaHJUCNfxwD/E0eNy3iuix56Vl1ZcuDvG9PVr9JRZx5k.7wp1nMb5M1V4aZXo2yfn0','John DOE','domain.tld/john.doe/',1024000,'john.doe','domain.tld','2016-11-28 08:56:47','2016-11-28 08:56:47',1),('sarah.connor@domain.tld','{SHA512-CRYPT}$6$ub.zCcyeaM7Mhs6S$rL4Yj2.Zsk8aFoF5l1mAddVrPo.UZ/1UrNwBC7UTBrX47cViSHo5eepEes6jMqC21P3cBm82adqJZvo91Ekme0','Sarah CONNOR','domain.tld/sarah.connor/',1024000,'sarah.connor','domain.tld','2016-11-28 08:57:51','2016-11-28 08:57:51',1);
UNLOCK TABLES;

--
-- Table structure for table `quota`
--

DROP TABLE IF EXISTS `quota`;
CREATE TABLE `quota` (
  `username` varchar(255) NOT NULL,
  `path` varchar(100) NOT NULL,
  `current` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`username`,`path`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `quota`
--

LOCK TABLES `quota` WRITE;
UNLOCK TABLES;

--
-- Table structure for table `quota2`
--

DROP TABLE IF EXISTS `quota2`;
CREATE TABLE `quota2` (
  `username` varchar(100) NOT NULL,
  `bytes` bigint(20) NOT NULL DEFAULT '0',
  `messages` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`username`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `quota2`
--

LOCK TABLES `quota2` WRITE;
INSERT INTO `quota2` VALUES ('john.doe@domain.tld',0,0),('sarah.connor@domain.tld',0,0);
UNLOCK TABLES;

--
-- Table structure for table `vacation`
--

DROP TABLE IF EXISTS `vacation`;
CREATE TABLE `vacation` (
  `email` varchar(255) NOT NULL,
  `subject` varchar(255) CHARACTER SET utf8 NOT NULL,
  `body` text CHARACTER SET utf8 NOT NULL,
  `activefrom` timestamp NOT NULL DEFAULT '2000-01-01 00:00:00',
  `activeuntil` timestamp NOT NULL DEFAULT '2000-01-01 00:00:00',
  `cache` text NOT NULL,
  `domain` varchar(255) NOT NULL,
  `interval_time` int(11) NOT NULL DEFAULT '0',
  `created` datetime NOT NULL DEFAULT '2000-01-01 00:00:00',
  `modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`email`),
  KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Postfix Admin - Virtual Vacation';

--
-- Dumping data for table `vacation`
--

LOCK TABLES `vacation` WRITE;
UNLOCK TABLES;

--
-- Table structure for table `vacation_notification`
--

DROP TABLE IF EXISTS `vacation_notification`;
CREATE TABLE `vacation_notification` (
  `on_vacation` varchar(255) CHARACTER SET latin1 NOT NULL,
  `notified` varchar(255) CHARACTER SET latin1 NOT NULL,
  `notified_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`on_vacation`,`notified`),
  CONSTRAINT `vacation_notification_pkey` FOREIGN KEY (`on_vacation`) REFERENCES `vacation` (`email`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Postfix Admin - Virtual Vacation Notifications';

--
-- Dumping data for table `vacation_notification`
--

LOCK TABLES `vacation_notification` WRITE;
UNLOCK TABLES;

--
-- Dumping routines for database 'postfix'
--
