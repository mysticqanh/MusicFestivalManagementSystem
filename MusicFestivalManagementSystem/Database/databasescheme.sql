
-- COMP1551 Music Festival Management System (MFMS)
-- Target: XAMPP MariaDB 10.4+ / compatible MySQL server; InnoDB.
-- Import once into a NEW/EMPTY database using phpMyAdmin -> Import.
-- No CREATE USER / GRANT: development connection uses local root as requested.
-- CREATE TABLE IF NOT EXISTS does not migrate an existing, differing schema.

CREATE DATABASE IF NOT EXISTS MFMS
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE MFMS;

-- Shared record; only one current Role per Person.
CREATE TABLE IF NOT EXISTS Persons (
    PersonID INT UNSIGNED NOT NULL AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Telephone VARCHAR(30) NOT NULL,
    Email VARCHAR(254) NOT NULL,
    Role VARCHAR(10) NOT NULL,
    CONSTRAINT PK_Persons PRIMARY KEY (PersonID),
    CONSTRAINT UQ_Persons_Email UNIQUE (Email),
    INDEX IX_Persons_Role (Role),
    CONSTRAINT CK_Persons_Name CHECK (CHAR_LENGTH(TRIM(Name)) > 0),
    CONSTRAINT CK_Persons_Telephone CHECK (CHAR_LENGTH(TRIM(Telephone)) > 0),
    CONSTRAINT CK_Persons_Email CHECK (CHAR_LENGTH(TRIM(Email)) > 0),
    CONSTRAINT CK_Persons_Role CHECK (Role IN ('Performer','Crew','Vendor'))
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Performers (
    PersonID INT UNSIGNED NOT NULL,
    Fee DECIMAL(12,2) NOT NULL,
    CONSTRAINT PK_Performers PRIMARY KEY (PersonID),
    CONSTRAINT CK_Performers_Fee CHECK (Fee >= 0),
    CONSTRAINT FK_Performers_Persons FOREIGN KEY (PersonID)
        REFERENCES Persons(PersonID) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Crew (
    PersonID INT UNSIGNED NOT NULL,
    HourlyRate DECIMAL(12,2) NOT NULL,
    EmploymentType VARCHAR(8) NOT NULL,
    WeeklyHours TINYINT UNSIGNED NOT NULL,
    CONSTRAINT PK_Crew PRIMARY KEY (PersonID),
    CONSTRAINT CK_Crew_HourlyRate CHECK (HourlyRate >= 0),
    CONSTRAINT CK_Crew_EmploymentType CHECK (EmploymentType IN ('FullTime','PartTime')),
    CONSTRAINT CK_Crew_WeeklyHours CHECK (
        (EmploymentType = 'FullTime' AND WeeklyHours BETWEEN 25 AND 40) OR
        (EmploymentType = 'PartTime' AND WeeklyHours BETWEEN 1 AND 24)
    ),
    CONSTRAINT FK_Crew_Persons FOREIGN KEY (PersonID)
        REFERENCES Persons(PersonID) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Vendors (
    PersonID INT UNSIGNED NOT NULL,
    VendorName VARCHAR(150) NOT NULL,
    CONSTRAINT PK_Vendors PRIMARY KEY (PersonID),
    CONSTRAINT CK_Vendors_Name CHECK (CHAR_LENGTH(TRIM(VendorName)) > 0),
    CONSTRAINT FK_Vendors_Persons FOREIGN KEY (PersonID)
        REFERENCES Persons(PersonID) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Genres (
    GenreID INT UNSIGNED NOT NULL AUTO_INCREMENT,
    GenreName VARCHAR(80) NOT NULL,
    CONSTRAINT PK_Genres PRIMARY KEY (GenreID),
    CONSTRAINT UQ_Genres_Name UNIQUE (GenreName),
    CONSTRAINT CK_Genres_Name CHECK (CHAR_LENGTH(TRIM(GenreName)) > 0)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS Product_Categories (
    CategoryID INT UNSIGNED NOT NULL AUTO_INCREMENT,
    CategoryName VARCHAR(100) NOT NULL,
    CONSTRAINT PK_Product_Categories PRIMARY KEY (CategoryID),
    CONSTRAINT UQ_Product_Categories_Name UNIQUE (CategoryName),
    CONSTRAINT CK_Product_Categories_Name CHECK (CHAR_LENGTH(TRIM(CategoryName)) > 0)
) ENGINE=InnoDB;

-- Performer <-> Genre: an individual pair cannot occur twice.
CREATE TABLE IF NOT EXISTS Performer_Genres (
    PersonID INT UNSIGNED NOT NULL,
    GenreID INT UNSIGNED NOT NULL,
    CONSTRAINT PK_Performer_Genres PRIMARY KEY (PersonID, GenreID),
    INDEX IX_Performer_Genres_Genre (GenreID),
    CONSTRAINT FK_PG_Performer FOREIGN KEY (PersonID)
        REFERENCES Performers(PersonID) ON DELETE CASCADE ON UPDATE RESTRICT,
    CONSTRAINT FK_PG_Genre FOREIGN KEY (GenreID)
        REFERENCES Genres(GenreID) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB;

-- Vendor <-> ProductCategory: an individual pair cannot occur twice.
CREATE TABLE IF NOT EXISTS Vendor_Product_Category (
    PersonID INT UNSIGNED NOT NULL,
    CategoryID INT UNSIGNED NOT NULL,
    CONSTRAINT PK_VPC PRIMARY KEY (PersonID, CategoryID),
    INDEX IX_VPC_Category (CategoryID),
    CONSTRAINT FK_VPC_Vendor FOREIGN KEY (PersonID)
        REFERENCES Vendors(PersonID) ON DELETE CASCADE ON UPDATE RESTRICT,
    CONSTRAINT FK_VPC_Category FOREIGN KEY (CategoryID)
        REFERENCES Product_Categories(CategoryID) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB;

-- IMPORTANT: Cross-table business invariants are NOT enforced by the FKs above.
-- ParticipantService + a single repository transaction must ensure:
-- 1) Exactly one subtype matching Persons.Role per Person;
-- 2) Exactly 2 DISTINCT genres per Performer;
-- 3) Exactly 3 DISTINCT categories per Vendor;
-- 4) Role change keeps PersonID and replaces old subtype/links atomically.
