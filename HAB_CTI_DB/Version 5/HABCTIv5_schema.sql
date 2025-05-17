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
-- Table `habcti`.`regulationtype`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `habcti`.`regulationtype` ;

CREATE TABLE IF NOT EXISTS `habcti`.`regulationtype` (
  `typeID` INT NOT NULL,
  `type` VARCHAR(50) NULL,
  PRIMARY KEY (`typeID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `habcti`.`regulations`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `habcti`.`regulations` ;

CREATE TABLE IF NOT EXISTS `habcti`.`regulations` (
  `regulationID` INT NOT NULL,
  `regulationName` VARCHAR(128) NULL DEFAULT NULL,
  `lastUpdated` DATETIME NULL DEFAULT NOW(),
  `regulationLink` VARCHAR(128) NULL DEFAULT NULL,
  `regulationNotes` TEXT NULL DEFAULT NULL,
  `effectiveDate` DATE NULL DEFAULT NULL,
  `agencyID` INT NULL DEFAULT NULL,
  `regulationtype_typeID` INT NOT NULL,
  PRIMARY KEY (`regulationID`),
  INDEX `agencyID` (`agencyID` ASC) VISIBLE,
  INDEX `fk_regulations_regulationtype1_idx` (`regulationtype_typeID` ASC) VISIBLE,
  CONSTRAINT `regulations_ibfk_5`
    FOREIGN KEY (`agencyID`)
    REFERENCES `habcti`.`agencies` (`agencyID`),
  CONSTRAINT `fk_regulations_regulationtype1`
    FOREIGN KEY (`regulationtype_typeID`)
    REFERENCES `habcti`.`regulationtype` (`typeID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
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
  PRIMARY KEY (`permitID`),
  INDEX `regulationID` (`regulationID` ASC) VISIBLE,
  CONSTRAINT `permits_ibfk_1`
    FOREIGN KEY (`regulationID`)
    REFERENCES `habcti`.`regulations` (`regulationID`))
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
-- Table `habcti`.`permitstags`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `habcti`.`permitstags` ;

CREATE TABLE IF NOT EXISTS `habcti`.`permitstags` (
  `permitTagID` INT NOT NULL,
  `tag` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`permitTagID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `habcti`.`permittaglist`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `habcti`.`permittaglist` ;

CREATE TABLE IF NOT EXISTS `habcti`.`permittaglist` (
  `permitstags_permitTagID` INT NOT NULL,
  `permits_permitID` INT NOT NULL,
  PRIMARY KEY (`permitstags_permitTagID`, `permits_permitID`),
  INDEX `fk_permittaglist_permits1_idx` (`permits_permitID` ASC) VISIBLE,
  CONSTRAINT `fk_permittaglist_permitstags1`
    FOREIGN KEY (`permitstags_permitTagID`)
    REFERENCES `habcti`.`permitstags` (`permitTagID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_permittaglist_permits1`
    FOREIGN KEY (`permits_permitID`)
    REFERENCES `habcti`.`permits` (`permitID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
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
-- Table `habcti`.`regulationtaglist`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `habcti`.`regulationtaglist` ;

CREATE TABLE IF NOT EXISTS `habcti`.`regulationtaglist` (
  `regulations_regulationID` INT NOT NULL,
  `regulationtags_regulationTagID` INT NOT NULL,
  PRIMARY KEY (`regulations_regulationID`, `regulationtags_regulationTagID`),
  INDEX `fk_regulationtaglist_regulationtags1_idx` (`regulationtags_regulationTagID` ASC) VISIBLE,
  CONSTRAINT `fk_regulationtaglist_regulations1`
    FOREIGN KEY (`regulations_regulationID`)
    REFERENCES `habcti`.`regulations` (`regulationID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_regulationtaglist_regulationtags1`
    FOREIGN KEY (`regulationtags_regulationTagID`)
    REFERENCES `habcti`.`regulationtags` (`regulationTagID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `habcti`.`stateregulations`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `habcti`.`stateregulations` ;

CREATE TABLE IF NOT EXISTS `habcti`.`stateregulations` (
  `state_regulations_ID` INT NOT NULL,
  `regulations_regulationID` INT NOT NULL,
  `state_stateID` INT NOT NULL,
  `localgov_localGovID` INT NOT NULL,
  PRIMARY KEY (`state_regulations_ID`),
  INDEX `fk_stateregulations_regulations1_idx` (`regulations_regulationID` ASC) VISIBLE,
  INDEX `fk_stateregulations_state1_idx` (`state_stateID` ASC) VISIBLE,
  INDEX `fk_stateregulations_localgov1_idx` (`localgov_localGovID` ASC) VISIBLE,
  CONSTRAINT `fk_stateregulations_regulations1`
    FOREIGN KEY (`regulations_regulationID`)
    REFERENCES `habcti`.`regulations` (`regulationID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_stateregulations_state1`
    FOREIGN KEY (`state_stateID`)
    REFERENCES `habcti`.`state` (`stateID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_stateregulations_localgov1`
    FOREIGN KEY (`localgov_localGovID`)
    REFERENCES `habcti`.`localgov` (`localGovID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `habcti`.`localregulations`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `habcti`.`localregulations` ;

CREATE TABLE IF NOT EXISTS `habcti`.`localregulations` (
  `local_regulations_ID` INT NOT NULL,
  `county` VARCHAR(128) NULL,
  `city` VARCHAR(128) NULL,
  `regulations_regulationID` INT NOT NULL,
  `state_stateID` INT NOT NULL,
  `localgov_localGovID` INT NOT NULL,
  PRIMARY KEY (`local_regulations_ID`),
  INDEX `fk_localregulations_regulations1_idx` (`regulations_regulationID` ASC) VISIBLE,
  INDEX `fk_localregulations_state1_idx` (`state_stateID` ASC) VISIBLE,
  INDEX `fk_localregulations_localgov1_idx` (`localgov_localGovID` ASC) VISIBLE,
  CONSTRAINT `fk_localregulations_regulations1`
    FOREIGN KEY (`regulations_regulationID`)
    REFERENCES `habcti`.`regulations` (`regulationID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_localregulations_state1`
    FOREIGN KEY (`state_stateID`)
    REFERENCES `habcti`.`state` (`stateID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_localregulations_localgov1`
    FOREIGN KEY (`localgov_localGovID`)
    REFERENCES `habcti`.`localgov` (`localGovID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
