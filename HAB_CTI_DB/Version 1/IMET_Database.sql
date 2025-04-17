DROP DATABASE IMETHAB;
CREATE DATABASE IMETHAB;
USE IMETHAB;

CREATE TABLE State (
stateID INT PRIMARY KEY,
stateName VARCHAR(20),
stateAbr VARCHAR(5));

CREATE TABLE LocalGov (
localGovID INT PRIMARY KEY,
localGov VARCHAR(100),
govType VARCHAR(50),
stateID INT,
FOREIGN KEY (stateID) REFERENCES State(stateID));

CREATE TABLE BodiesOfWater (
bodyOfWaterID INT PRIMARY KEY,
bodyName VARCHAR(100),
bodyType VARCHAR(50),
freshOrSalt VARCHAR(10),
privateOrPublic VARCHAR(10),
drainageBasin VARCHAR(50),
stateID INT,
localGovID INT,
FOREIGN KEY (stateID) REFERENCES State(stateID),
FOREIGN KEY (localGovID) REFERENCES LocalGov(localGovID)
);

CREATE TABLE Regulations (
regulationID INT PRIMARY KEY,
regulationName VARCHAR(100),
regulationType VARCHAR(50),
agency VARCHAR(50),
lastUpdated DATE,
regulationLink VARCHAR(100),
stateID INT,
localGovID INT,
bodyOfWaterID INT,
FOREIGN KEY (stateID) REFERENCES State(stateID),
FOREIGN KEY (localGovID) REFERENCES LocalGov(localGovID),
FOREIGN KEY (bodyOfWaterID) REFERENCES BodiesOfWater(bodyOfWaterID)
);
CREATE TABLE Permits(
permitID INT PRIMARY KEY,
permitName VARCHAR(100),
renewalPeriod VARCHAR(50),
permitDocs TEXT,
permitLink VARCHAR(100),
regulationID INT,
FOREIGN KEY (regulationID) REFERENCES Regulations(regulationID)
);
CREATE TABLE ControlMethods(
controlMethodID INT PRIMARY KEY,
controlName VARCHAR(50),
controlType VARCHAR(50),
controlCost INT,
algaeSpecies VARCHAR(50),
regulationID INT,
permitID INT,
FOREIGN KEY (permitID) REFERENCES Permits(permitID),
FOREIGN KEY (regulationID) REFERENCES Regulations(regulationID)
);


CREATE TABLE Literature(
literatureID INT PRIMARY KEY,
literatureLink VARCHAR(100),
literatureDescription TEXT,
literaturePublishDate DATE,
controlMethodID INT,
FOREIGN KEY (controlMethodID) REFERENCES ControlMethods(controlMethodID)
);








