-- MySQL Workbench Forward Engineering


-- -----------------------------------------------------
-- Schema habcti
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema habcti
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS  "habcti"   ;

-- -----------------------------------------------------
-- Table "habcti"."agencies"
-- -----------------------------------------------------
DROP TABLE IF EXISTS "habcti"."agencies" CASCADE;

CREATE TABLE  "habcti"."agencies" (
  "agencyID" INT NOT NULL,
  "agencyName" VARCHAR(128) NULL DEFAULT NULL,
  "agencyType" VARCHAR(50) NULL DEFAULT NULL,
  "contactEmail" VARCHAR(128) NULL DEFAULT NULL,
  "contactPhone" VARCHAR(20) NULL DEFAULT NULL,
  "website" VARCHAR(128) NULL DEFAULT NULL,
  PRIMARY KEY ("agencyID"));



-- -----------------------------------------------------
-- Table "habcti"."state"
-- -----------------------------------------------------
DROP TABLE IF EXISTS "habcti"."state" CASCADE;

CREATE TABLE  "habcti"."state" (
  "stateID" INT NOT NULL,
  "stateName" VARCHAR(128) NULL DEFAULT NULL,
  "stateAbrv" VARCHAR(2) NULL DEFAULT NULL,
  PRIMARY KEY ("stateID"));



-- -----------------------------------------------------
-- Table "habcti"."localgov"
-- -----------------------------------------------------
DROP TABLE IF EXISTS "habcti"."localgov" CASCADE;

CREATE TABLE  "habcti"."localgov" (
  "localGovID" INT NOT NULL,
  "localGov" VARCHAR(128) NULL DEFAULT NULL,
  "govType" VARCHAR(50) NULL DEFAULT NULL,
  "stateID" INT NULL DEFAULT NULL,
  PRIMARY KEY ("localGovID"),
  CONSTRAINT "localgov_ibfk_1"
    FOREIGN KEY ("stateID")
    REFERENCES "habcti"."state" ("stateID"));



-- -----------------------------------------------------
-- Table "habcti"."bodiesofwater"
-- -----------------------------------------------------
DROP TABLE IF EXISTS "habcti"."bodiesofwater" CASCADE;

CREATE TABLE  "habcti"."bodiesofwater" (
  "bodyOfWaterID" INT NOT NULL,
  "bodyName" VARCHAR(128) NULL DEFAULT NULL,
  "bodyType" VARCHAR(50) NULL DEFAULT NULL,
  "freshOrSalt" VARCHAR(10) NULL DEFAULT NULL,
  "privateOrPublic" VARCHAR(10) NULL DEFAULT NULL,
  "drainageBasin" VARCHAR(50) NULL DEFAULT NULL,
  "stateID" INT NULL DEFAULT NULL,
  "localGovID" INT NULL DEFAULT NULL,
  PRIMARY KEY ("bodyOfWaterID"),
  CONSTRAINT "bodiesofwater_ibfk_1"
    FOREIGN KEY ("stateID")
    REFERENCES "habcti"."state" ("stateID"),
  CONSTRAINT "bodiesofwater_ibfk_2"
    FOREIGN KEY ("localGovID")
    REFERENCES "habcti"."localgov" ("localGovID"));



-- -----------------------------------------------------
-- Table "habcti"."regulationtype"
-- -----------------------------------------------------
DROP TABLE IF EXISTS "habcti"."regulationtype" CASCADE;

CREATE TABLE  "habcti"."regulationtype" (
  "typeID" INT NOT NULL,
  "type" VARCHAR(50) NULL,
  PRIMARY KEY ("typeID"));


-- -----------------------------------------------------
-- Table "habcti"."regulations"
-- -----------------------------------------------------
DROP TABLE IF EXISTS "habcti"."regulations" CASCADE;

CREATE TABLE  "habcti"."regulations" (
  "regulationID" INT NOT NULL,
  "regulationName" VARCHAR(128) NULL DEFAULT NULL,
  "lastUpdated" TIMESTAMP NULL DEFAULT NOW(),
  "regulationLink" VARCHAR(128) NULL DEFAULT NULL,
  "regulationNotes" TEXT NULL DEFAULT NULL,
  "effectiveDate" DATE NULL DEFAULT NULL,
  "agencyID" INT NULL DEFAULT NULL,
  "regulationtype_typeID" INT NOT NULL,
  PRIMARY KEY ("regulationID"),
  CONSTRAINT "regulations_ibfk_5"
    FOREIGN KEY ("agencyID")
    REFERENCES "habcti"."agencies" ("agencyID"),
  CONSTRAINT "fk_regulations_regulationtype1"
    FOREIGN KEY ("regulationtype_typeID")
    REFERENCES "habcti"."regulationtype" ("typeID")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);



-- -----------------------------------------------------
-- Table "habcti"."permits"
-- -----------------------------------------------------
DROP TABLE IF EXISTS "habcti"."permits" CASCADE;

CREATE TABLE  "habcti"."permits" (
  "permitID" INT NOT NULL,
  "permitName" VARCHAR(128) NULL DEFAULT NULL,
  "validFor" DATE NULL DEFAULT NULL,
  "permitDocs" TEXT NULL DEFAULT NULL,
  "permitLink" VARCHAR(128) NULL DEFAULT NULL,
  "permitNotes" TEXT NULL DEFAULT NULL,
  "regulationID" INT NULL DEFAULT NULL,
  "federalRegulationID" INT NULL DEFAULT NULL,
  PRIMARY KEY ("permitID"),
  CONSTRAINT "permits_ibfk_1"
    FOREIGN KEY ("regulationID")
    REFERENCES "habcti"."regulations" ("regulationID"));



-- -----------------------------------------------------
-- Table "habcti"."controlmethods"
-- -----------------------------------------------------
DROP TABLE IF EXISTS "habcti"."controlmethods" CASCADE;

CREATE TABLE  "habcti"."controlmethods" (
  "controlMethodID" INT NOT NULL,
  "controlName" VARCHAR(50) NULL DEFAULT NULL,
  "controlType" VARCHAR(50) NULL DEFAULT NULL,
  "controlCost" DECIMAL(19,4) NULL DEFAULT NULL,
  "algaeSpecies" VARCHAR(50) NULL DEFAULT NULL,
  "regulationID" INT NULL DEFAULT NULL,
  "permitID" INT NULL DEFAULT NULL,
  PRIMARY KEY ("controlMethodID"),
  CONSTRAINT "controlmethods_ibfk_1"
    FOREIGN KEY ("permitID")
    REFERENCES "habcti"."permits" ("permitID"),
  CONSTRAINT "controlmethods_ibfk_2"
    FOREIGN KEY ("regulationID")
    REFERENCES "habcti"."regulations" ("regulationID"));



-- -----------------------------------------------------
-- Table "habcti"."literature"
-- -----------------------------------------------------
DROP TABLE IF EXISTS "habcti"."literature" CASCADE;

CREATE TABLE  "habcti"."literature" (
  "literatureID" INT NOT NULL,
  "literatureLink" VARCHAR(128) NULL DEFAULT NULL,
  "literatureDescription" TEXT NULL DEFAULT NULL,
  "literaturePublishDate" DATE NULL DEFAULT NULL,
  "controlMethodID" INT NULL DEFAULT NULL,
  PRIMARY KEY ("literatureID"),
  CONSTRAINT "literature_ibfk_1"
    FOREIGN KEY ("controlMethodID")
    REFERENCES "habcti"."controlmethods" ("controlMethodID"));



-- -----------------------------------------------------
-- Table "habcti"."permits_tags"
-- -----------------------------------------------------
DROP TABLE IF EXISTS "habcti"."permits_tags" CASCADE;

CREATE TABLE  "habcti"."permits_tags" (
  "permitTagID" INT NOT NULL,
  "tag" VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY ("permitTagID"));



-- -----------------------------------------------------
-- Table "habcti"."permits_tags_list"
-- -----------------------------------------------------
DROP TABLE IF EXISTS "habcti"."permits_tags_list" CASCADE;

CREATE TABLE  "habcti"."permits_tags_list" (
  "permits_permitID" INT NOT NULL,
  "permittags_tagID" INT NOT NULL,
  PRIMARY KEY ("permits_permitID", "permittags_tagID"),
  CONSTRAINT "permitstags_ibfk_1"
    FOREIGN KEY ("permits_permitID")
    REFERENCES "habcti"."permits" ("permitID"),
  CONSTRAINT "permitstags_ibfk_2"
    FOREIGN KEY ("permittags_tagID")
    REFERENCES "habcti"."permits_tags" ("permitTagID"));



-- -----------------------------------------------------
-- Table "habcti"."regulationtags"
-- -----------------------------------------------------
DROP TABLE IF EXISTS "habcti"."regulationtags" CASCADE;

CREATE TABLE  "habcti"."regulationtags" (
  "regulationTagID" INT NOT NULL,
  "tag" VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY ("regulationTagID"));



-- -----------------------------------------------------
-- Table "habcti"."regulationstags"
-- -----------------------------------------------------
DROP TABLE IF EXISTS "habcti"."regulationstags" CASCADE;

CREATE TABLE  "habcti"."regulationstags" (
  "regulations_regulationID" INT NOT NULL,
  "regulationtags_regulationTagID" INT NOT NULL,
  PRIMARY KEY ("regulations_regulationID", "regulationtags_regulationTagID"),
  CONSTRAINT "regulationstags_ibfk_1"
    FOREIGN KEY ("regulations_regulationID")
    REFERENCES "habcti"."regulations" ("regulationID"),
  CONSTRAINT "regulationstags_ibfk_2"
    FOREIGN KEY ("regulationtags_regulationTagID")
    REFERENCES "habcti"."regulationtags" ("regulationTagID"));



-- -----------------------------------------------------
-- Table "habcti"."state_regulations"
-- -----------------------------------------------------
DROP TABLE IF EXISTS "habcti"."state_regulations" CASCADE;

CREATE TABLE  "habcti"."state_regulations" (
  "state_regulations_ID" INT NOT NULL,
  "regulations_regulationID" INT NOT NULL,
  "state_stateID" INT NOT NULL,
  "localgov_localGovID" INT NOT NULL,
  PRIMARY KEY ("state_regulations_ID"),
  CONSTRAINT "fk_state_regulations_regulations1"
    FOREIGN KEY ("regulations_regulationID")
    REFERENCES "habcti"."regulations" ("regulationID")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT "fk_state_regulations_state1"
    FOREIGN KEY ("state_stateID")
    REFERENCES "habcti"."state" ("stateID")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT "fk_state_regulations_localgov1"
    FOREIGN KEY ("localgov_localGovID")
    REFERENCES "habcti"."localgov" ("localGovID")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table "habcti"."local_regulations"
-- -----------------------------------------------------
DROP TABLE IF EXISTS "habcti"."local_regulations" CASCADE;

CREATE TABLE  "habcti"."local_regulations" (
  "local_regulations_ID" INT NOT NULL,
  "regulations_regulationID" INT NOT NULL,
  "localgov_localGovID" INT NOT NULL,
  "state_stateID" INT NOT NULL,
  "county" VARCHAR(128) NULL,
  "city" VARCHAR(128) NULL,
  PRIMARY KEY ("local_regulations_ID"),
  CONSTRAINT "fk_local_regulations_regulations1"
    FOREIGN KEY ("regulations_regulationID")
    REFERENCES "habcti"."regulations" ("regulationID")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT "fk_local_regulations_localgov1"
    FOREIGN KEY ("localgov_localGovID")
    REFERENCES "habcti"."localgov" ("localGovID")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT "fk_local_regulations_state1"
    FOREIGN KEY ("state_stateID")
    REFERENCES "habcti"."state" ("stateID")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


