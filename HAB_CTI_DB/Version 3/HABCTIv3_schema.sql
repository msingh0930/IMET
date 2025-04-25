-- ============================================================
-- Drop and Create Database
-- ============================================================

DROP DATABASE IF EXISTS habctiv3;
CREATE DATABASE habctiv3;
USE habctiv3;

-- ============================================================
-- Core Tables
-- ============================================================

-- Table to store U.S. states
CREATE TABLE State (
  stateID INT PRIMARY KEY,
  stateName VARCHAR(128),
  stateAbrv VARCHAR(2)
);

-- Table to store local government entities
CREATE TABLE LocalGov (
  localGovID INT PRIMARY KEY,
  localGov VARCHAR(128),
  govType VARCHAR(50),
  stateID INT,
  FOREIGN KEY (stateID) REFERENCES State(stateID)
);

-- Table to store information about bodies of water
CREATE TABLE BodiesOfWater (
  bodyOfWaterID INT PRIMARY KEY,
  bodyName VARCHAR(128),
  bodyType VARCHAR(50),
  freshOrSalt VARCHAR(10),
  privateOrPublic VARCHAR(10),
  drainageBasin VARCHAR(50),
  stateID INT,
  localGovID INT,
  FOREIGN KEY (stateID) REFERENCES State(stateID),
  FOREIGN KEY (localGovID) REFERENCES LocalGov(localGovID)
);

-- ============================================================
-- Agencies Table
-- ============================================================

-- Table to store agency information
CREATE TABLE Agencies (
  agencyID INT PRIMARY KEY,
  agencyName VARCHAR(128),
  agencyType VARCHAR(50),
  contactEmail VARCHAR(128),
  contactPhone VARCHAR(20),
  website VARCHAR(128)
);

-- ============================================================
-- Federal Regulations Table
-- ============================================================

-- Table to store federal regulations
CREATE TABLE FederalRegulations (
  federalRegulationID INT PRIMARY KEY,
  regulationName VARCHAR(128),
  regulationType VARCHAR(45),
  lastUpdated DATETIME DEFAULT NOW(),
  regulationLink VARCHAR(128),
  regulationNotes TEXT,
  effectiveDate DATE,
  agencyID INT,
  FOREIGN KEY (agencyID) REFERENCES Agencies(agencyID)
);

-- ============================================================
-- State and Local Regulations and Permits
-- ============================================================

-- Table to store state and local regulations
CREATE TABLE Regulations (
  regulationID INT PRIMARY KEY,
  regulationName VARCHAR(128),
  regulationType VARCHAR(45),
  lastUpdated DATETIME DEFAULT NOW(),
  regulationLink VARCHAR(128),
  regulationNotes TEXT,
  effectiveDate DATE,
  stateID INT,
  localGovID INT,
  bodyOfWaterID INT,
  federalRegulationID INT,
  agencyID INT,
  FOREIGN KEY (stateID) REFERENCES State(stateID),
  FOREIGN KEY (localGovID) REFERENCES LocalGov(localGovID),
  FOREIGN KEY (bodyOfWaterID) REFERENCES BodiesOfWater(bodyOfWaterID),
  FOREIGN KEY (federalRegulationID) REFERENCES FederalRegulations(federalRegulationID),
  FOREIGN KEY (agencyID) REFERENCES Agencies(agencyID)
);

-- Table to store permits linked to regulations
CREATE TABLE Permits (
  permitID INT PRIMARY KEY,
  permitName VARCHAR(128),
  validFor DATE,
  permitDocs TEXT,
  permitLink VARCHAR(128),
  permitNotes TEXT,
  regulationID INT,
  federalRegulationID INT,
  FOREIGN KEY (regulationID) REFERENCES Regulations(regulationID),
  FOREIGN KEY (federalRegulationID) REFERENCES FederalRegulations(federalRegulationID)
);

-- ============================================================
-- Control Methods and Literature Tables
-- ============================================================

-- Table to store methods used to control algae blooms
CREATE TABLE ControlMethods (
  controlMethodID INT PRIMARY KEY,
  controlName VARCHAR(50),
  controlType VARCHAR(50),
  controlCost DECIMAL(19,4),
  algaeSpecies VARCHAR(50),
  regulationID INT,
  permitID INT,
  FOREIGN KEY (permitID) REFERENCES Permits(permitID),
  FOREIGN KEY (regulationID) REFERENCES Regulations(regulationID)
);

-- Table to store related literature for control methods
CREATE TABLE Literature (
  literatureID INT PRIMARY KEY,
  literatureLink VARCHAR(128),
  literatureDescription TEXT,
  literaturePublishDate DATE,
  controlMethodID INT,
  FOREIGN KEY (controlMethodID) REFERENCES ControlMethods(controlMethodID)
);

-- ============================================================
-- Tagging System for Permits and Regulations
-- ============================================================

-- Table to store tags for permits
CREATE TABLE PermitTags (
  permitTagID INT PRIMARY KEY,
  tag VARCHAR(45)
);

-- Many-to-many linking table between Permits and PermitTags
CREATE TABLE PermitsTags (
  permits_permitID INT,
  permittags_tagID INT,
  PRIMARY KEY (permits_permitID, permittags_tagID),
  FOREIGN KEY (permits_permitID) REFERENCES Permits(permitID),
  FOREIGN KEY (permittags_tagID) REFERENCES PermitTags(permitTagID)
);

-- Table to store tags for regulations
CREATE TABLE RegulationTags (
  regulationTagID INT PRIMARY KEY,
  tag VARCHAR(45)
);

-- Many-to-many linking table between Regulations and RegulationTags
CREATE TABLE RegulationsTags (
  regulations_regulationID INT,
  regulationtags_regulationTagID INT,
  PRIMARY KEY (regulations_regulationID, regulationtags_regulationTagID),
  FOREIGN KEY (regulations_regulationID) REFERENCES Regulations(regulationID),
  FOREIGN KEY (regulationtags_regulationTagID) REFERENCES RegulationTags(regulationTagID)
);