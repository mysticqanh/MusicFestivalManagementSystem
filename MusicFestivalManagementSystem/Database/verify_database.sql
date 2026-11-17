-- After schema + sample data: inspect results in MySQL Workbench
USE MFMS;

-- 1. Table count expected: 8
SELECT COUNT(*) AS TableCount
FROM information_schema.tables
WHERE table_schema = 'MFMS' AND table_type = 'BASE TABLE';
SHOW TABLES;

-- 2. Person counts expected: 2 per role
SELECT Role, COUNT(*) AS RecordCount
FROM Persons GROUP BY Role ORDER BY Role;

-- 3. Each Performer expected to have exactly 2 distinct Genres
SELECT p.PersonID, p.Name, COUNT(DISTINCT pg.GenreID) AS GenreCount,
       GROUP_CONCAT(g.GenreName ORDER BY g.GenreName SEPARATOR ', ') AS Genres
FROM Persons AS p
JOIN Performers AS pf ON pf.PersonID = p.PersonID
LEFT JOIN Performer_Genres AS pg ON pg.PersonID = pf.PersonID
LEFT JOIN Genres AS g ON g.GenreID = pg.GenreID
GROUP BY p.PersonID, p.Name ORDER BY p.PersonID;

-- 4. Each Vendor expected to have exactly 3 distinct Product Categories
SELECT p.PersonID, p.Name, v.VendorName,
       COUNT(DISTINCT vpc.CategoryID) AS CategoryCount,
       GROUP_CONCAT(pc.CategoryName ORDER BY pc.CategoryName SEPARATOR ', ') AS Categories
FROM Persons AS p
JOIN Vendors AS v ON v.PersonID = p.PersonID
LEFT JOIN Vendor_Product_Category AS vpc ON vpc.PersonID = v.PersonID
LEFT JOIN Product_Categories AS pc ON pc.CategoryID = vpc.CategoryID
GROUP BY p.PersonID, p.Name, v.VendorName ORDER BY p.PersonID;

-- 5. This query should return NO ROWS: unmatched/multiple subtypes
SELECT p.PersonID, p.Role,
       (IF(pf.PersonID IS NOT NULL,1,0) + IF(c.PersonID IS NOT NULL,1,0)
        + IF(v.PersonID IS NOT NULL,1,0)) AS SubtypeCount
FROM Persons p
LEFT JOIN Performers pf ON pf.PersonID = p.PersonID
LEFT JOIN Crew c ON c.PersonID = p.PersonID
LEFT JOIN Vendors v ON v.PersonID = p.PersonID
WHERE (IF(pf.PersonID IS NOT NULL,1,0) + IF(c.PersonID IS NOT NULL,1,0)
       + IF(v.PersonID IS NOT NULL,1,0)) <> 1
   OR (p.Role = 'Performer' AND pf.PersonID IS NULL)
   OR (p.Role = 'Crew' AND c.PersonID IS NULL)
   OR (p.Role = 'Vendor' AND v.PersonID IS NULL);

-- 6. This query should return NO ROWS: wrong association counts
SELECT pf.PersonID, 'Performer genre count' AS Issue,
       COUNT(pg.GenreID) AS ActualCount
FROM Performers pf
LEFT JOIN Performer_Genres pg ON pg.PersonID = pf.PersonID
GROUP BY pf.PersonID HAVING COUNT(pg.GenreID) <> 2
UNION ALL
SELECT v.PersonID, 'Vendor category count', COUNT(vpc.CategoryID)
FROM Vendors v
LEFT JOIN Vendor_Product_Category vpc ON vpc.PersonID = v.PersonID
GROUP BY v.PersonID HAVING COUNT(vpc.CategoryID) <> 3;

-- 7. DDL evidence: constraints
SHOW CREATE TABLE Persons;
SHOW CREATE TABLE Crew;
SHOW CREATE TABLE Performer_Genres;
SHOW CREATE TABLE Vendor_Product_Category;

-- 8. Expected: no duplicate emails
SELECT Email, COUNT(*) AS Copies FROM Persons GROUP BY Email HAVING COUNT(*) > 1;
