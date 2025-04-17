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
-- Table `habcti`.`State`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `habcti`.`State` ;

CREATE TABLE IF NOT EXISTS `habcti`.`State` (
  `stateID` INT NOT NULL,
  `stateName` VARCHAR(128) NULL DEFAULT NULL,
  `stateAbrv` VARCHAR(2) NULL DEFAULT NULL,
  PRIMARY KEY (`stateID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `habcti`.`LocalGov`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `habcti`.`LocalGov` ;

CREATE TABLE IF NOT EXISTS `habcti`.`LocalGov` (
  `localGovID` INT NOT NULL,
  `localGov` VARCHAR(128) NULL DEFAULT NULL,
  `govType` VARCHAR(50) NULL DEFAULT NULL,
  `stateID` INT NULL DEFAULT NULL,
  PRIMARY KEY (`localGovID`),
  INDEX `stateID` (`stateID` ASC) VISIBLE,
  CONSTRAINT `localgov_ibfk_1`
    FOREIGN KEY (`stateID`)
    REFERENCES `habcti`.`State` (`stateID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `habcti`.`BodiesOfWater`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `habcti`.`BodiesOfWater` ;

CREATE TABLE IF NOT EXISTS `habcti`.`BodiesOfWater` (
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
    REFERENCES `habcti`.`State` (`stateID`),
  CONSTRAINT `bodiesofwater_ibfk_2`
    FOREIGN KEY (`localGovID`)
    REFERENCES `habcti`.`LocalGov` (`localGovID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `habcti`.`Regulations`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `habcti`.`Regulations` ;

CREATE TABLE IF NOT EXISTS `habcti`.`Regulations` (
  `regulationID` INT NOT NULL,
  `regulationName` VARCHAR(128) NULL DEFAULT NULL,
  `regulationType` VARCHAR(45) NULL DEFAULT NULL,
  `agency` VARCHAR(45) NULL DEFAULT NULL,
  `lastUpdated` DATETIME NULL DEFAULT CURRENT_TIMESTAMP(),
  `regulationLink` VARCHAR(128) NULL DEFAULT NULL,
  `regulationNotes` TEXT NULL,
  `effectiveDate` DATE NULL,
  `stateID` INT NULL DEFAULT NULL,
  `localGovID` INT NULL DEFAULT NULL,
  `bodyOfWaterID` INT NULL DEFAULT NULL,
  PRIMARY KEY (`regulationID`),
  INDEX `stateID` (`stateID` ASC) VISIBLE,
  INDEX `localGovID` (`localGovID` ASC) VISIBLE,
  INDEX `bodyOfWaterID` (`bodyOfWaterID` ASC) VISIBLE,
  CONSTRAINT `regulations_ibfk_1`
    FOREIGN KEY (`stateID`)
    REFERENCES `habcti`.`State` (`stateID`),
  CONSTRAINT `regulations_ibfk_2`
    FOREIGN KEY (`localGovID`)
    REFERENCES `habcti`.`LocalGov` (`localGovID`),
  CONSTRAINT `regulations_ibfk_3`
    FOREIGN KEY (`bodyOfWaterID`)
    REFERENCES `habcti`.`BodiesOfWater` (`bodyOfWaterID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `habcti`.`Permits`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `habcti`.`Permits` ;

CREATE TABLE IF NOT EXISTS `habcti`.`Permits` (
  `permitID` INT NOT NULL,
  `permitName` VARCHAR(128) NULL DEFAULT NULL,
  `validFor` DATE NULL DEFAULT NULL,
  `permitDocs` TEXT NULL DEFAULT NULL,
  `permitLink` VARCHAR(128) NULL DEFAULT NULL,
  `permitNotes` TEXT NULL,
  `regulationID` INT NULL DEFAULT NULL,
  PRIMARY KEY (`permitID`),
  INDEX `regulationID` (`regulationID` ASC) VISIBLE,
  CONSTRAINT `permits_ibfk_1`
    FOREIGN KEY (`regulationID`)
    REFERENCES `habcti`.`Regulations` (`regulationID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `habcti`.`ControlMethods`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `habcti`.`ControlMethods` ;

CREATE TABLE IF NOT EXISTS `habcti`.`ControlMethods` (
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
    REFERENCES `habcti`.`Permits` (`permitID`),
  CONSTRAINT `controlmethods_ibfk_2`
    FOREIGN KEY (`regulationID`)
    REFERENCES `habcti`.`Regulations` (`regulationID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `habcti`.`Literature`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `habcti`.`Literature` ;

CREATE TABLE IF NOT EXISTS `habcti`.`Literature` (
  `literatureID` INT NOT NULL,
  `literatureLink` VARCHAR(128) NULL DEFAULT NULL,
  `literatureDescription` TEXT NULL DEFAULT NULL,
  `literaturePublishDate` DATE NULL DEFAULT NULL,
  `controlMethodID` INT NULL DEFAULT NULL,
  PRIMARY KEY (`literatureID`),
  INDEX `controlMethodID` (`controlMethodID` ASC) VISIBLE,
  CONSTRAINT `literature_ibfk_1`
    FOREIGN KEY (`controlMethodID`)
    REFERENCES `habcti`.`ControlMethods` (`controlMethodID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `habcti`.`PermitTags`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `habcti`.`PermitTags` ;

CREATE TABLE IF NOT EXISTS `habcti`.`PermitTags` (
  `permitTagID` INT NOT NULL,
  `tag` VARCHAR(45) NULL,
  PRIMARY KEY (`permitTagID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `habcti`.`PermitsTags`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `habcti`.`PermitsTags` ;

CREATE TABLE IF NOT EXISTS `habcti`.`PermitsTags` (
  `permits_permitID` INT NOT NULL,
  `permittags_tagID` INT NOT NULL,
  PRIMARY KEY (`permits_permitID`, `permittags_tagID`),
  INDEX `fk_permitsTags_permittags1_idx` (`permittags_tagID` ASC) VISIBLE,
  CONSTRAINT `fk_permitsTags_permits1`
    FOREIGN KEY (`permits_permitID`)
    REFERENCES `habcti`.`Permits` (`permitID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_permitsTags_permittags1`
    FOREIGN KEY (`permittags_tagID`)
    REFERENCES `habcti`.`PermitTags` (`permitTagID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `habcti`.`RegulationTags`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `habcti`.`RegulationTags` ;

CREATE TABLE IF NOT EXISTS `habcti`.`RegulationTags` (
  `regulationTagID` INT NOT NULL,
  `tag` VARCHAR(45) NULL,
  PRIMARY KEY (`regulationTagID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `habcti`.`RegulationsTags`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `habcti`.`RegulationsTags` ;

CREATE TABLE IF NOT EXISTS `habcti`.`RegulationsTags` (
  `regulations_regulationID` INT NOT NULL,
  `regulationtags_regulationTagID` INT NOT NULL,
  PRIMARY KEY (`regulations_regulationID`, `regulationtags_regulationTagID`),
  INDEX `fk_regulationTags_regulationtags1_idx` (`regulationtags_regulationTagID` ASC) VISIBLE,
  CONSTRAINT `fk_regulationTags_regulations1`
    FOREIGN KEY (`regulations_regulationID`)
    REFERENCES `habcti`.`Regulations` (`regulationID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_regulationTags_regulationtags1`
    FOREIGN KEY (`regulationtags_regulationTagID`)
    REFERENCES `habcti`.`RegulationTags` (`regulationTagID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
