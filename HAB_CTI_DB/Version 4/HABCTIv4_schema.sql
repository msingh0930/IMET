-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema habcti
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema habcti
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `habcti` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `habcti` ;

-- -----------------------------------------------------
-- Table `habcti`.`agencies`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `habcti`.`agencies` ;

CREATE TABLE IF NOT EXISTS `habcti`.`agencies` (
  `agencyID` INT NOT NULL,
  `agencyName` VARCHAR(128) NULL DEFAULT NULL,
  `agencyType` VARCHAR(50) NULL DEFAULT NULL,
  `contactEmail` VARCHAR(128) NULL DEFAULT NULL,
  `contactPhone` VARCHAR(20) NULL DEFAULT NULL,
  `website` VARCHAR(128) NULL DEFAULT NULL,
  PRIMARY KEY (`agencyID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `habcti`.`state`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `habcti`.`state` ;

CREATE TABLE IF NOT EXISTS `habcti`.`state` (
  `stateID` INT NOT NULL,
  `stateName` VARCHAR(128) NULL DEFAULT NULL,
  `stateAbrv` VARCHAR(2) NULL DEFAULT NULL,
  PRIMARY KEY (`stateID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `habcti`.`localgov`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `habcti`.`localgov` ;

CREATE TABLE IF NOT EXISTS `habcti`.`localgov` (
  `localGovID` INT NOT NULL,
  `localGov` VARCHAR(128) NULL DEFAULT NULL,
  `govType` VARCHAR(50) NULL DEFAULT NULL,
  `stateID` INT NULL DEFAULT NULL,
  PRIMARY KEY (`localGovID`),
  INDEX `stateID` (`stateID` ASC) VISIBLE,
  CONSTRAINT `localgov_ibfk_1`
    FOREIGN KEY (`stateID`)
    REFERENCES `habcti`.`state` (`stateID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `habcti`.`bodiesofwater`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `habcti`.`bodiesofwater` ;

CREATE TABLE IF NOT EXISTS `habcti`.`bodiesofwater` (
  `bodyOfWaterID` INT NOT NULL,
  `bodyName` VARCHAR(128) NULL DEFAULT NULL,
  `bodyType` VARCHAR(50) NULL DEFAULT NULL,
  `freshOrSalt` VARCHAR(10) NULL DEFAULT NULL,
  `privateOrPublic` VARCHAR(10) NULL DEFAULT NULL,
  `drainageBasin` VARCHAR(50) NULL DEFAULT NULL,
  `stateID` INT NULL DEFAULT NULL,
  `localGovID` INT NULL DEFAULT NULL,
  PRIMARY KEY (`bodyOfWaterID`),
  INDEX `stateID` (`stateID` ASC) VISIBLE,
  INDEX `localGovID` (`localGovID` ASC) VISIBLE,
  CONSTRAINT `bodiesofwater_ibfk_1`
    FOREIGN KEY (`stateID`)
    REFERENCES `habcti`.`state` (`stateID`),
  CONSTRAINT `bodiesofwater_ibfk_2`
    FOREIGN KEY (`localGovID`)
    REFERENCES `habcti`.`localgov` (`localGovID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `habcti`.`federalregulations`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `habcti`.`federalregulations` ;

CREATE TABLE IF NOT EXISTS `habcti`.`federalregulations` (
  `federalRegulationID` INT NOT NULL,
  `regulationName` VARCHAR(128) NULL DEFAULT NULL,
  `regulationType` VARCHAR(45) NULL DEFAULT NULL,
  `lastUpdated` DATETIME NULL DEFAULT NOW(),
  `regulationLink` VARCHAR(128) NULL DEFAULT NULL,
  `regulationNotes` TEXT NULL DEFAULT NULL,
  `effectiveDate` DATE NULL DEFAULT NULL,
  `agencyID` INT NULL DEFAULT NULL,
  PRIMARY KEY (`federalRegulationID`),
  INDEX `agencyID` (`agencyID` ASC) VISIBLE,
  CONSTRAINT `federalregulations_ibfk_1`
    FOREIGN KEY (`agencyID`)
    REFERENCES `habcti`.`agencies` (`agencyID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `habcti`.`regulations`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `habcti`.`regulations` ;

CREATE TABLE IF NOT EXISTS `habcti`.`regulations` (
  `regulationID` INT NOT NULL,
  `regulationName` VARCHAR(128) NULL DEFAULT NULL,
  `regulationType` VARCHAR(45) NULL DEFAULT NULL,
  `lastUpdated` DATETIME NULL DEFAULT NOW(),
  `regulationLink` VARCHAR(128) NULL DEFAULT NULL,
  `regulationNotes` TEXT NULL DEFAULT NULL,
  `effectiveDate` DATE NULL DEFAULT NULL,
  `stateID` INT NULL DEFAULT NULL,
  `localGovID` INT NULL DEFAULT NULL,
  `bodyOfWaterID` INT NULL DEFAULT NULL,
  `federalRegulationID` INT NULL DEFAULT NULL,
  `agencyID` INT NULL DEFAULT NULL,
  PRIMARY KEY (`regulationID`),
  INDEX `stateID` (`stateID` ASC) VISIBLE,
  INDEX `localGovID` (`localGovID` ASC) VISIBLE,
  INDEX `bodyOfWaterID` (`bodyOfWaterID` ASC) VISIBLE,
  INDEX `federalRegulationID` (`federalRegulationID` ASC) VISIBLE,
  INDEX `agencyID` (`agencyID` ASC) VISIBLE,
  CONSTRAINT `regulations_ibfk_1`
    FOREIGN KEY (`stateID`)
    REFERENCES `habcti`.`state` (`stateID`),
  CONSTRAINT `regulations_ibfk_2`
    FOREIGN KEY (`localGovID`)
    REFERENCES `habcti`.`localgov` (`localGovID`),
  CONSTRAINT `regulations_ibfk_3`
    FOREIGN KEY (`bodyOfWaterID`)
    REFERENCES `habcti`.`bodiesofwater` (`bodyOfWaterID`),
  CONSTRAINT `regulations_ibfk_4`
    FOREIGN KEY (`federalRegulationID`)
    REFERENCES `habcti`.`federalregulations` (`federalRegulationID`),
  CONSTRAINT `regulations_ibfk_5`
    FOREIGN KEY (`agencyID`)
    REFERENCES `habcti`.`agencies` (`agencyID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `habcti`.`permits`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `habcti`.`permits` ;

CREATE TABLE IF NOT EXISTS `habcti`.`permits` (
  `permitID` INT NOT NULL,
  `permitName` VARCHAR(128) NULL DEFAULT NULL,
  `validFor` DATE NULL DEFAULT NULL,
  `permitDocs` TEXT NULL DEFAULT NULL,
  `permitLink` VARCHAR(128) NULL DEFAULT NULL,
  `permitNotes` TEXT NULL DEFAULT NULL,
  `regulationID` INT NULL DEFAULT NULL,
  `federalRegulationID` INT NULL DEFAULT NULL,
  PRIMARY KEY (`permitID`),
  INDEX `regulationID` (`regulationID` ASC) VISIBLE,
  INDEX `federalRegulationID` (`federalRegulationID` ASC) VISIBLE,
  CONSTRAINT `permits_ibfk_1`
    FOREIGN KEY (`regulationID`)
    REFERENCES `habcti`.`regulations` (`regulationID`),
  CONSTRAINT `permits_ibfk_2`
    FOREIGN KEY (`federalRegulationID`)
    REFERENCES `habcti`.`federalregulations` (`federalRegulationID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `habcti`.`controlmethods`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `habcti`.`controlmethods` ;

CREATE TABLE IF NOT EXISTS `habcti`.`controlmethods` (
  `controlMethodID` INT NOT NULL,
  `controlName` VARCHAR(50) NULL DEFAULT NULL,
  `controlType` VARCHAR(50) NULL DEFAULT NULL,
  `controlCost` DECIMAL(19,4) NULL DEFAULT NULL,
  `algaeSpecies` VARCHAR(50) NULL DEFAULT NULL,
  `regulationID` INT NULL DEFAULT NULL,
  `permitID` INT NULL DEFAULT NULL,
  PRIMARY KEY (`controlMethodID`),
  INDEX `permitID` (`permitID` ASC) VISIBLE,
  INDEX `regulationID` (`regulationID` ASC) VISIBLE,
  CONSTRAINT `controlmethods_ibfk_1`
    FOREIGN KEY (`permitID`)
    REFERENCES `habcti`.`permits` (`permitID`),
  CONSTRAINT `controlmethods_ibfk_2`
    FOREIGN KEY (`regulationID`)
    REFERENCES `habcti`.`regulations` (`regulationID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `habcti`.`literature`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `habcti`.`literature` ;

CREATE TABLE IF NOT EXISTS `habcti`.`literature` (
  `literatureID` INT NOT NULL,
  `literatureLink` VARCHAR(128) NULL DEFAULT NULL,
  `literatureDescription` TEXT NULL DEFAULT NULL,
  `literaturePublishDate` DATE NULL DEFAULT NULL,
  `controlMethodID` INT NULL DEFAULT NULL,
  PRIMARY KEY (`literatureID`),
  INDEX `controlMethodID` (`controlMethodID` ASC) VISIBLE,
  CONSTRAINT `literature_ibfk_1`
    FOREIGN KEY (`controlMethodID`)
    REFERENCES `habcti`.`controlmethods` (`controlMethodID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `habcti`.`permits_tags`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `habcti`.`permits_tags` ;

CREATE TABLE IF NOT EXISTS `habcti`.`permits_tags` (
  `permitTagID` INT NOT NULL,
  `tag` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`permitTagID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `habcti`.`permits_tags_list`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `habcti`.`permits_tags_list` ;

CREATE TABLE IF NOT EXISTS `habcti`.`permits_tags_list` (
  `permits_permitID` INT NOT NULL,
  `permittags_tagID` INT NOT NULL,
  PRIMARY KEY (`permits_permitID`, `permittags_tagID`),
  INDEX `permittags_tagID` (`permittags_tagID` ASC) VISIBLE,
  CONSTRAINT `permitstags_ibfk_1`
    FOREIGN KEY (`permits_permitID`)
    REFERENCES `habcti`.`permits` (`permitID`),
  CONSTRAINT `permitstags_ibfk_2`
    FOREIGN KEY (`permittags_tagID`)
    REFERENCES `habcti`.`permits_tags` (`permitTagID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `habcti`.`regulationtags`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `habcti`.`regulationtags` ;

CREATE TABLE IF NOT EXISTS `habcti`.`regulationtags` (
  `regulationTagID` INT NOT NULL,
  `tag` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`regulationTagID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `habcti`.`regulationstags`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `habcti`.`regulationstags` ;

CREATE TABLE IF NOT EXISTS `habcti`.`regulationstags` (
  `regulations_regulationID` INT NOT NULL,
  `regulationtags_regulationTagID` INT NOT NULL,
  PRIMARY KEY (`regulations_regulationID`, `regulationtags_regulationTagID`),
  INDEX `regulationtags_regulationTagID` (`regulationtags_regulationTagID` ASC) VISIBLE,
  CONSTRAINT `regulationstags_ibfk_1`
    FOREIGN KEY (`regulations_regulationID`)
    REFERENCES `habcti`.`regulations` (`regulationID`),
  CONSTRAINT `regulationstags_ibfk_2`
    FOREIGN KEY (`regulationtags_regulationTagID`)
    REFERENCES `habcti`.`regulationtags` (`regulationTagID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `habcti`.`state_regulations`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `habcti`.`state_regulations` ;

CREATE TABLE IF NOT EXISTS `habcti`.`state_regulations` (
  `state_regulations_ID` INT NOT NULL,
  `state_regulation_name` VARCHAR(45) NULL,
  `state_regulation` LONGTEXT NULL,
  `stateID` INT NULL,
  `state_lastUpdated` DATETIME NULL,
  `state_notes` TEXT NULL,
  `regulations_regulationID` INT NOT NULL,
  `agencies_agencyID` INT NOT NULL,
  PRIMARY KEY (`state_regulations_ID`),
  INDEX `fk_state_regulations_regulations1_idx` (`regulations_regulationID` ASC) VISIBLE,
  INDEX `fk_state_regulations_agencies1_idx` (`agencies_agencyID` ASC) VISIBLE,
  CONSTRAINT `fk_state_regulations_regulations1`
    FOREIGN KEY (`regulations_regulationID`)
    REFERENCES `habcti`.`regulations` (`regulationID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_state_regulations_agencies1`
    FOREIGN KEY (`agencies_agencyID`)
    REFERENCES `habcti`.`agencies` (`agencyID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `habcti`.`local_regulations`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `habcti`.`local_regulations` ;

CREATE TABLE IF NOT EXISTS `habcti`.`local_regulations` (
  `local_regulations_ID` INT NOT NULL,
  `local_regulation_name` VARCHAR(45) NULL,
  `local_regulation` LONGTEXT NULL,
  `localGovID` INT NULL,
  `local_lastUpdated` DATETIME NULL,
  `local_notes` TEXT NULL,
  `regulations_regulationID` INT NOT NULL,
  `agencies_agencyID` INT NOT NULL,
  PRIMARY KEY (`local_regulations_ID`),
  INDEX `fk_local_regulations_regulations1_idx` (`regulations_regulationID` ASC) VISIBLE,
  INDEX `fk_local_regulations_agencies1_idx` (`agencies_agencyID` ASC) VISIBLE,
  CONSTRAINT `fk_local_regulations_regulations1`
    FOREIGN KEY (`regulations_regulationID`)
    REFERENCES `habcti`.`regulations` (`regulationID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_local_regulations_agencies1`
    FOREIGN KEY (`agencies_agencyID`)
    REFERENCES `habcti`.`agencies` (`agencyID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
