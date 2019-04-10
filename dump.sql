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
  `info` varchar(1024) DEFAULT NULL,
  `authorid` char(12) DEFAULT NULL,
  PRIMARY KEY (`pid`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
  `puzzle_progress` varchar(1024) DEFAULT NULL
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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `set`
--

LOCK TABLES `set` WRITE;
/*!40000 ALTER TABLE `set` DISABLE KEYS */;
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
INSERT INTO `user` VALUES ('bvsju9dklw1','benjamin','7f3c062810e5ba079c5aa585f42c9d56','1781530289@qq.com',1554789579985);
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
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `v_record`
--

LOCK TABLES `v_record` WRITE;
/*!40000 ALTER TABLE `v_record` DISABLE KEYS */;
INSERT INTO `v_record` VALUES (25,'bvsju9dklw1',25,0,0,0,0,5),(26,'bvsju9dklw1',26,0,0,0,0,5),(27,'bvsju9dklw1',27,0,0,0,0,5),(28,'bvsju9dklw1',28,0,0,0,0,5),(29,'bvsju9dklw1',29,0,0,0,0,5),(30,'bvsju9dklw1',30,0,0,0,0,5),(31,'bvsju9dklw1',31,0,0,0,0,5),(32,'bvsju9dklw1',32,0,0,0,0,5),(33,'bvsju9dklw1',33,0,0,0,0,5),(34,'bvsju9dklw1',34,0,0,0,0,5),(35,'bvsju9dklw1',35,0,0,0,0,5),(36,'bvsju9dklw1',36,0,0,0,0,5),(43,'bvsju9dklw1',43,0,0,0,0,8),(44,'bvsju9dklw1',44,0,0,0,0,8),(45,'bvsju9dklw1',45,0,0,0,0,8);
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
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vocabulary`
--

LOCK TABLES `vocabulary` WRITE;
/*!40000 ALTER TABLE `vocabulary` DISABLE KEYS */;
INSERT INTO `vocabulary` VALUES (25,'stated','ADJ (esp of a sum) determined by agreement; fixed (尤指总额)确定的; 固定的',5,'bvsju9dklw1'),(26,'feed','to provide enough food for a group of people 养活',5,'bvsju9dklw1'),(27,'resultant','ADJ Resultant means caused by the event just mentioned',5,'bvsju9dklw1'),(28,'martyr','someone who dies for their religious or political beliefs and is admired by people for this.',5,'bvsju9dklw1'),(29,'rancid','(used of decomposing oils or fats) having a rank smell or taste usually due to a chemical change or decomposition',5,'bvsju9dklw1'),(30,'overboard','ADV If you fall ~, you fall over the side of a boat into the water. ',5,'bvsju9dklw1'),(31,'centrifugal','ADJ acting, moving, or tending to move away from a centre',5,'bvsju9dklw1'),(32,'gallbladder','a muscular sac attached to the liver that secretes bile and stores it until needed for digestion',5,'bvsju9dklw1'),(33,'expletive','a rude word that you use when you are angry or in pain, for example ‘shit’',5,'bvsju9dklw1'),(34,'range','a number of people or things that are all different, but are all of the same general type',5,'bvsju9dklw1'),(35,'vendetta','a situation in which one person or group tries for a long time to harm another person',5,'bvsju9dklw1'),(36,'incline','[T] formal if a situation, fact etc inclines you to do or think something, it influences you towards a particular action or opinion',5,'bvsju9dklw1'),(43,'adfasf','dafa',8,'bvsju9dklw1'),(44,'adfdasf','adsf',8,'bvsju9dklw1'),(45,'adfaf','adsfdasf',8,'bvsju9dklw1');
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

-- Dump completed on 2019-04-10  9:13:52
