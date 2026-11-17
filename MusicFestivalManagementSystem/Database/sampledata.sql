
-- COMP1551 MFMS required seed: two Performers (2 genres each), two Crew,
-- two Vendors (3 product categories each).
-- Run ONCE after databasescheme.sql on a NEW/EMPTY MFMS database.
-- This file uses plain SQL (no stored procedure or DELIMITER) for phpMyAdmin Import.
-- If Import reports ANY error, do not trust the partial outcome; inspect it,
-- restore a clean database if necessary, and rerun from the start.
USE MFMS;
START TRANSACTION;

INSERT INTO Genres (GenreName) VALUES
('EDM'),('House'),('Jazz'),('Pop');

INSERT INTO Product_Categories (CategoryName) VALUES
('Food'),('Beverages'),('Merchandise'),('Accessories');

INSERT INTO Persons (Name,Telephone,Email,Role) VALUES
('Linh Tran','0901000001','linh.mfms@example.com','Performer');
SET @p1 := LAST_INSERT_ID();
INSERT INTO Performers (PersonID, Fee) VALUES (@p1,2500.00);
INSERT INTO Performer_Genres (PersonID,GenreID)
    SELECT @p1,GenreID FROM Genres WHERE GenreName IN ('EDM','House');

INSERT INTO Persons (Name,Telephone,Email,Role) VALUES
('Minh Le','0901000002','minh.mfms@example.com','Performer');
SET @p2 := LAST_INSERT_ID();
INSERT INTO Performers (PersonID, Fee) VALUES (@p2,1900.00);
INSERT INTO Performer_Genres (PersonID,GenreID)
    SELECT @p2,GenreID FROM Genres WHERE GenreName IN ('Jazz','Pop');

INSERT INTO Persons (Name,Telephone,Email,Role) VALUES
('An Nguyen','0901000003','an.mfms@example.com','Crew');
SET @c1 := LAST_INSERT_ID();
INSERT INTO Crew (PersonID,HourlyRate,EmploymentType,WeeklyHours)
    VALUES (@c1,25.00,'FullTime',35);

INSERT INTO Persons (Name,Telephone,Email,Role) VALUES
('Binh Pham','0901000004','binh.mfms@example.com','Crew');
SET @c2 := LAST_INSERT_ID();
INSERT INTO Crew (PersonID,HourlyRate,EmploymentType,WeeklyHours)
    VALUES (@c2,22.00,'PartTime',20);

INSERT INTO Persons (Name,Telephone,Email,Role) VALUES
('Hoa Vu','0901000005','hoa.mfms@example.com','Vendor');
SET @v1 := LAST_INSERT_ID();
INSERT INTO Vendors (PersonID,VendorName) VALUES (@v1,'Festival Bites');
INSERT INTO Vendor_Product_Category (PersonID,CategoryID)
    SELECT @v1,CategoryID FROM Product_Categories
    WHERE CategoryName IN ('Food','Beverages','Merchandise');

INSERT INTO Persons (Name,Telephone,Email,Role) VALUES
('Khanh Do','0901000006','khanh.mfms@example.com','Vendor');
SET @v2 := LAST_INSERT_ID();
INSERT INTO Vendors (PersonID,VendorName) VALUES (@v2,'Sound Market');
INSERT INTO Vendor_Product_Category (PersonID,CategoryID)
    SELECT @v2,CategoryID FROM Product_Categories
    WHERE CategoryName IN ('Beverages','Merchandise','Accessories');

COMMIT;
