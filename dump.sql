-- MySQL dump 10.13  Distrib 8.0.15, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: ewordfun
-- ------------------------------------------------------
-- Server version	8.0.15

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
 SET NAMES utf8mb4 ;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `folder`
--

DROP TABLE IF EXISTS `folder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `folder` (
  `fid` int(11) NOT NULL AUTO_INCREMENT,
  `name` char(32) DEFAULT NULL,
  `intro` char(255) DEFAULT NULL,
  `authorid` char(12) DEFAULT NULL,
  `createtime` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`fid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `folder`
--

LOCK TABLES `folder` WRITE;
/*!40000 ALTER TABLE `folder` DISABLE KEYS */;
INSERT INTO `folder` VALUES (1,'new one','this is a world for wizard.\n\n\n\n\n\n\n\n\n\n\n\n\n\n','bvsju9dklw1',1554791403986);
/*!40000 ALTER TABLE `folder` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `folder_set`
--

DROP TABLE IF EXISTS `folder_set`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `folder_set` (
  `fid` int(11) DEFAULT NULL,
  `sid` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `folder_set`
--

LOCK TABLES `folder_set` WRITE;
/*!40000 ALTER TABLE `folder_set` DISABLE KEYS */;
/*!40000 ALTER TABLE `folder_set` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `puzzle`
--

DROP TABLE IF EXISTS `puzzle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `puzzle` (
  `pid` int(11) NOT NULL AUTO_INCREMENT,
  `name` char(32) DEFAULT NULL,
  `intro` char(255) DEFAULT NULL,
  `sid` int(11) DEFAULT NULL,
  `chvps` varchar(2048) DEFAULT NULL,
  `authorid` char(12) DEFAULT NULL,
  PRIMARY KEY (`pid`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `puzzle`
--

LOCK TABLES `puzzle` WRITE;
/*!40000 ALTER TABLE `puzzle` DISABLE KEYS */;
/*!40000 ALTER TABLE `puzzle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `puzzle_user`
--

DROP TABLE IF EXISTS `puzzle_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `puzzle_user` (
  `pid` int(11) DEFAULT NULL,
  `uid` int(11) DEFAULT NULL,
  `sid` int(11) DEFAULT NULL,
  `rpuzzle` int(11) DEFAULT '0',
  `puzzle_progress` varchar(2048) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `puzzle_user`
--

LOCK TABLES `puzzle_user` WRITE;
/*!40000 ALTER TABLE `puzzle_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `puzzle_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `set`
--

DROP TABLE IF EXISTS `set`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `set` (
  `sid` int(11) NOT NULL AUTO_INCREMENT,
  `name` char(30) DEFAULT NULL,
  `intro` char(255) DEFAULT NULL,
  `vcount` int(11) DEFAULT NULL,
  `authorid` char(12) DEFAULT NULL,
  `createtime` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`sid`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `set`
--

LOCK TABLES `set` WRITE;
/*!40000 ALTER TABLE `set` DISABLE KEYS */;
INSERT INTO `set` VALUES (9,'test','test intro',8,'bvsju9dklw1',1554866535242);
/*!40000 ALTER TABLE `set` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `set_user`
--

DROP TABLE IF EXISTS `set_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `set_user` (
  `sid` int(11) DEFAULT NULL,
  `uid` char(12) DEFAULT NULL,
  `rmatrix` int(11) DEFAULT '0',
  `rwrite` int(11) DEFAULT '0',
  `latest_learntime` bigint(20) DEFAULT NULL,
  `stared` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `set_user`
--

LOCK TABLES `set_user` WRITE;
/*!40000 ALTER TABLE `set_user` DISABLE KEYS */;
INSERT INTO `set_user` VALUES (9,'bvsju9dklw1',0,0,1554866535242,0);
/*!40000 ALTER TABLE `set_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `user` (
  `uid` char(12) NOT NULL,
  `name` char(32) DEFAULT NULL,
  `password` varchar(512) DEFAULT NULL,
  `email` char(50) DEFAULT NULL,
  `createtime` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES ('b1kjuaymggi','tony','7f3c062810e5ba079c5aa585f42c9d56','990460889@qq.com',1554885404369),('bvsju9dklw1','benjamin','7f3c062810e5ba079c5aa585f42c9d56','1781530289@qq.com',1554789579985);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `v_record`
--

DROP TABLE IF EXISTS `v_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `v_record` (
  `rid` bigint(20) NOT NULL AUTO_INCREMENT,
  `uid` char(12) DEFAULT NULL,
  `vid` bigint(20) DEFAULT NULL,
  `rmatrix` tinyint(1) DEFAULT '0',
  `rmatrix_unpass_count` tinyint(4) DEFAULT '0',
  `rwrite` tinyint(1) DEFAULT '0',
  `rwrite_unpass_count` tinyint(4) DEFAULT '0',
  `sid` int(11) DEFAULT NULL,
  PRIMARY KEY (`rid`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `v_record`
--

LOCK TABLES `v_record` WRITE;
/*!40000 ALTER TABLE `v_record` DISABLE KEYS */;
INSERT INTO `v_record` VALUES (46,'bvsju9dklw1',46,0,0,0,0,9),(47,'bvsju9dklw1',47,0,0,0,0,9),(48,'bvsju9dklw1',48,0,0,0,0,9),(49,'bvsju9dklw1',49,0,0,0,0,9),(50,'bvsju9dklw1',50,0,0,0,0,9),(51,'bvsju9dklw1',51,0,0,0,0,9),(52,'bvsju9dklw1',52,0,0,0,0,9),(53,'bvsju9dklw1',53,0,0,0,0,9);
/*!40000 ALTER TABLE `v_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vocabulary`
--

DROP TABLE IF EXISTS `vocabulary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `vocabulary` (
  `vid` bigint(20) NOT NULL AUTO_INCREMENT,
  `term` char(32) DEFAULT NULL,
  `definition` varchar(1024) DEFAULT NULL,
  `sid` int(11) DEFAULT NULL,
  `authorid` char(12) DEFAULT NULL,
  PRIMARY KEY (`vid`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vocabulary`
--

LOCK TABLES `vocabulary` WRITE;
/*!40000 ALTER TABLE `vocabulary` DISABLE KEYS */;
INSERT INTO `vocabulary` VALUES (46,'stated','规定的；阐明的；定期的',9,'bvsju9dklw1'),(47,'overboard','adv. 自船上落下；向船外',9,'bvsju9dklw1'),(48,'nano','n. 纳；毫微',9,'bvsju9dklw1'),(49,'left unchecked','不受监管的',9,'bvsju9dklw1'),(50,'centrifugal','( technical 术语 ) moving or tending to move away from a centre 离心的',9,'bvsju9dklw1'),(51,'feed','[ VN ] to give a plant a special substance to make it grow 施（肥等）\nFeed the plants once a week. 每星期要给这些花草施一次肥。 ',9,'bvsju9dklw1'),(52,'resultant','[ only before noun ] ( formal ) caused by the thing that has just been mentioned 因而发生的；因此而产生的',9,'bvsju9dklw1'),(53,'marshal','( usually in compounds 通常构成复合词 ) an officer of the highest rank in the British army or air force （英国）陆军元帅，空军元帅',9,'bvsju9dklw1');
/*!40000 ALTER TABLE `vocabulary` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-04-17 15:28:38
