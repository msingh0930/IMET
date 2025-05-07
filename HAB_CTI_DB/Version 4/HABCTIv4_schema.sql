CREATE DATABASE  IF NOT EXISTS `habcti` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `habcti`;
-- MySQL dump 10.13  Distrib 8.0.36, for macos14 (arm64)
--
-- Host: localhost    Database: habcti
-- ------------------------------------------------------
-- Server version	8.3.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `agencies`
--

DROP TABLE IF EXISTS `agencies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agencies` (
  `agencyID` int NOT NULL,
  `agencyName` varchar(128) DEFAULT NULL,
  `agencyType` varchar(50) DEFAULT NULL,
  `contactEmail` varchar(128) DEFAULT NULL,
  `contactPhone` varchar(20) DEFAULT NULL,
  `website` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`agencyID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agencies`
--

LOCK TABLES `agencies` WRITE;
/*!40000 ALTER TABLE `agencies` DISABLE KEYS */;
/*!40000 ALTER TABLE `agencies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bodiesofwater`
--

DROP TABLE IF EXISTS `bodiesofwater`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bodiesofwater` (
  `bodyOfWaterID` int NOT NULL,
  `bodyName` varchar(128) DEFAULT NULL,
  `bodyType` varchar(50) DEFAULT NULL,
  `freshOrSalt` varchar(10) DEFAULT NULL,
  `privateOrPublic` varchar(10) DEFAULT NULL,
  `drainageBasin` varchar(50) DEFAULT NULL,
  `stateID` int DEFAULT NULL,
  `localGovID` int DEFAULT NULL,
  PRIMARY KEY (`bodyOfWaterID`),
  KEY `stateID` (`stateID`),
  KEY `localGovID` (`localGovID`),
  CONSTRAINT `bodiesofwater_ibfk_1` FOREIGN KEY (`stateID`) REFERENCES `state` (`stateID`),
  CONSTRAINT `bodiesofwater_ibfk_2` FOREIGN KEY (`localGovID`) REFERENCES `localgov` (`localGovID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bodiesofwater`
--

LOCK TABLES `bodiesofwater` WRITE;
/*!40000 ALTER TABLE `bodiesofwater` DISABLE KEYS */;
/*!40000 ALTER TABLE `bodiesofwater` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `controlmethods`
--

DROP TABLE IF EXISTS `controlmethods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `controlmethods` (
  `controlMethodID` int NOT NULL,
  `controlName` varchar(50) DEFAULT NULL,
  `controlType` varchar(50) DEFAULT NULL,
  `controlCost` decimal(19,4) DEFAULT NULL,
  `algaeSpecies` varchar(50) DEFAULT NULL,
  `regulationID` int DEFAULT NULL,
  `permitID` int DEFAULT NULL,
  PRIMARY KEY (`controlMethodID`),
  KEY `permitID` (`permitID`),
  KEY `regulationID` (`regulationID`),
  CONSTRAINT `controlmethods_ibfk_1` FOREIGN KEY (`permitID`) REFERENCES `permits` (`permitID`),
  CONSTRAINT `controlmethods_ibfk_2` FOREIGN KEY (`regulationID`) REFERENCES `regulations` (`regulationID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `controlmethods`
--

LOCK TABLES `controlmethods` WRITE;
/*!40000 ALTER TABLE `controlmethods` DISABLE KEYS */;
/*!40000 ALTER TABLE `controlmethods` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `federalregulations`
--

DROP TABLE IF EXISTS `federalregulations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `federalregulations` (
  `federalRegulationID` int NOT NULL,
  `regulationName` varchar(128) DEFAULT NULL,
  `regulationType` varchar(45) DEFAULT NULL,
  `lastUpdated` datetime DEFAULT CURRENT_TIMESTAMP,
  `regulationLink` varchar(128) DEFAULT NULL,
  `regulationNotes` text,
  `effectiveDate` date DEFAULT NULL,
  `agencyID` int DEFAULT NULL,
  PRIMARY KEY (`federalRegulationID`),
  KEY `agencyID` (`agencyID`),
  CONSTRAINT `federalregulations_ibfk_1` FOREIGN KEY (`agencyID`) REFERENCES `agencies` (`agencyID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `federalregulations`
--

LOCK TABLES `federalregulations` WRITE;
/*!40000 ALTER TABLE `federalregulations` DISABLE KEYS */;
/*!40000 ALTER TABLE `federalregulations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `literature`
--

DROP TABLE IF EXISTS `literature`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `literature` (
  `literatureID` int NOT NULL,
  `literatureLink` varchar(128) DEFAULT NULL,
  `literatureDescription` text,
  `literaturePublishDate` date DEFAULT NULL,
  `controlMethodID` int DEFAULT NULL,
  PRIMARY KEY (`literatureID`),
  KEY `controlMethodID` (`controlMethodID`),
  CONSTRAINT `literature_ibfk_1` FOREIGN KEY (`controlMethodID`) REFERENCES `controlmethods` (`controlMethodID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `literature`
--

LOCK TABLES `literature` WRITE;
/*!40000 ALTER TABLE `literature` DISABLE KEYS */;
/*!40000 ALTER TABLE `literature` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `local_regulations`
--

DROP TABLE IF EXISTS `local_regulations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `local_regulations` (
  `local_regulations_ID` int NOT NULL,
  `local_regulation_name` varchar(45) DEFAULT NULL,
  `local_regulation` longtext,
  `localGovID` int DEFAULT NULL,
  `local_lastUpdated` datetime DEFAULT NULL,
  `local_notes` text,
  PRIMARY KEY (`local_regulations_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `local_regulations`
--

LOCK TABLES `local_regulations` WRITE;
/*!40000 ALTER TABLE `local_regulations` DISABLE KEYS */;
/*!40000 ALTER TABLE `local_regulations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `localgov`
--

DROP TABLE IF EXISTS `localgov`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `localgov` (
  `localGovID` int NOT NULL,
  `localGov` varchar(128) DEFAULT NULL,
  `govType` varchar(50) DEFAULT NULL,
  `stateID` int DEFAULT NULL,
  PRIMARY KEY (`localGovID`),
  KEY `stateID` (`stateID`),
  CONSTRAINT `localgov_ibfk_1` FOREIGN KEY (`stateID`) REFERENCES `state` (`stateID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `localgov`
--

LOCK TABLES `localgov` WRITE;
/*!40000 ALTER TABLE `localgov` DISABLE KEYS */;
/*!40000 ALTER TABLE `localgov` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permits`
--

DROP TABLE IF EXISTS `permits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permits` (
  `permitID` int NOT NULL,
  `permitName` varchar(128) DEFAULT NULL,
  `validFor` date DEFAULT NULL,
  `permitDocs` text,
  `permitLink` varchar(128) DEFAULT NULL,
  `permitNotes` text,
  `regulationID` int DEFAULT NULL,
  `federalRegulationID` int DEFAULT NULL,
  PRIMARY KEY (`permitID`),
  KEY `regulationID` (`regulationID`),
  KEY `federalRegulationID` (`federalRegulationID`),
  CONSTRAINT `permits_ibfk_1` FOREIGN KEY (`regulationID`) REFERENCES `regulations` (`regulationID`),
  CONSTRAINT `permits_ibfk_2` FOREIGN KEY (`federalRegulationID`) REFERENCES `federalregulations` (`federalRegulationID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permits`
--

LOCK TABLES `permits` WRITE;
/*!40000 ALTER TABLE `permits` DISABLE KEYS */;
/*!40000 ALTER TABLE `permits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permits_tags`
--

DROP TABLE IF EXISTS `permits_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permits_tags` (
  `permitTagID` int NOT NULL,
  `tag` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`permitTagID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permits_tags`
--

LOCK TABLES `permits_tags` WRITE;
/*!40000 ALTER TABLE `permits_tags` DISABLE KEYS */;
/*!40000 ALTER TABLE `permits_tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permits_tags_list`
--

DROP TABLE IF EXISTS `permits_tags_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permits_tags_list` (
  `permits_permitID` int NOT NULL,
  `permittags_tagID` int NOT NULL,
  PRIMARY KEY (`permits_permitID`,`permittags_tagID`),
  KEY `permittags_tagID` (`permittags_tagID`),
  CONSTRAINT `permitstags_ibfk_1` FOREIGN KEY (`permits_permitID`) REFERENCES `permits` (`permitID`),
  CONSTRAINT `permitstags_ibfk_2` FOREIGN KEY (`permittags_tagID`) REFERENCES `permits_tags` (`permitTagID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permits_tags_list`
--

LOCK TABLES `permits_tags_list` WRITE;
/*!40000 ALTER TABLE `permits_tags_list` DISABLE KEYS */;
/*!40000 ALTER TABLE `permits_tags_list` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `regulations`
--

DROP TABLE IF EXISTS `regulations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `regulations` (
  `regulationID` int NOT NULL,
  `regulationName` varchar(128) DEFAULT NULL,
  `regulationType` varchar(45) DEFAULT NULL,
  `lastUpdated` datetime DEFAULT CURRENT_TIMESTAMP,
  `regulationLink` varchar(128) DEFAULT NULL,
  `regulationNotes` text,
  `effectiveDate` date DEFAULT NULL,
  `stateID` int DEFAULT NULL,
  `localGovID` int DEFAULT NULL,
  `bodyOfWaterID` int DEFAULT NULL,
  `federalRegulationID` int DEFAULT NULL,
  `agencyID` int DEFAULT NULL,
  PRIMARY KEY (`regulationID`),
  KEY `stateID` (`stateID`),
  KEY `localGovID` (`localGovID`),
  KEY `bodyOfWaterID` (`bodyOfWaterID`),
  KEY `federalRegulationID` (`federalRegulationID`),
  KEY `agencyID` (`agencyID`),
  CONSTRAINT `regulations_ibfk_1` FOREIGN KEY (`stateID`) REFERENCES `state` (`stateID`),
  CONSTRAINT `regulations_ibfk_2` FOREIGN KEY (`localGovID`) REFERENCES `localgov` (`localGovID`),
  CONSTRAINT `regulations_ibfk_3` FOREIGN KEY (`bodyOfWaterID`) REFERENCES `bodiesofwater` (`bodyOfWaterID`),
  CONSTRAINT `regulations_ibfk_4` FOREIGN KEY (`federalRegulationID`) REFERENCES `federalregulations` (`federalRegulationID`),
  CONSTRAINT `regulations_ibfk_5` FOREIGN KEY (`agencyID`) REFERENCES `agencies` (`agencyID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `regulations`
--

LOCK TABLES `regulations` WRITE;
/*!40000 ALTER TABLE `regulations` DISABLE KEYS */;
/*!40000 ALTER TABLE `regulations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `regulationstags`
--

DROP TABLE IF EXISTS `regulationstags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `regulationstags` (
  `regulations_regulationID` int NOT NULL,
  `regulationtags_regulationTagID` int NOT NULL,
  PRIMARY KEY (`regulations_regulationID`,`regulationtags_regulationTagID`),
  KEY `regulationtags_regulationTagID` (`regulationtags_regulationTagID`),
  CONSTRAINT `regulationstags_ibfk_1` FOREIGN KEY (`regulations_regulationID`) REFERENCES `regulations` (`regulationID`),
  CONSTRAINT `regulationstags_ibfk_2` FOREIGN KEY (`regulationtags_regulationTagID`) REFERENCES `regulationtags` (`regulationTagID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `regulationstags`
--

LOCK TABLES `regulationstags` WRITE;
/*!40000 ALTER TABLE `regulationstags` DISABLE KEYS */;
/*!40000 ALTER TABLE `regulationstags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `regulationtags`
--

DROP TABLE IF EXISTS `regulationtags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `regulationtags` (
  `regulationTagID` int NOT NULL,
  `tag` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`regulationTagID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `regulationtags`
--

LOCK TABLES `regulationtags` WRITE;
/*!40000 ALTER TABLE `regulationtags` DISABLE KEYS */;
/*!40000 ALTER TABLE `regulationtags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `state`
--

DROP TABLE IF EXISTS `state`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `state` (
  `stateID` int NOT NULL,
  `stateName` varchar(128) DEFAULT NULL,
  `stateAbrv` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`stateID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `state`
--

LOCK TABLES `state` WRITE;
/*!40000 ALTER TABLE `state` DISABLE KEYS */;
/*!40000 ALTER TABLE `state` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `state_regulations`
--

DROP TABLE IF EXISTS `state_regulations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `state_regulations` (
  `state_regulations_ID` int NOT NULL,
  `state_regulation_name` varchar(45) DEFAULT NULL,
  `state_regulation` longtext,
  `stateID` int DEFAULT NULL,
  `state_lastUpdated` datetime DEFAULT NULL,
  `state_notes` text,
  PRIMARY KEY (`state_regulations_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `state_regulations`
--

LOCK TABLES `state_regulations` WRITE;
/*!40000 ALTER TABLE `state_regulations` DISABLE KEYS */;
/*!40000 ALTER TABLE `state_regulations` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-07 18:22:52
