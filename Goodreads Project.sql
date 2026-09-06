--==============================================
--INVESTIGATING DATA
--==============================================

SELECT*
FROM Goodreads_raw;
-- I want to check the different authors in the data.
SELECT DISTINCT Author
FROM Goodreads_raw;
-- I want to check if any of Tittle, Author, Additional_Authors, Publisher, Binding names start with a lower case.
SELECT 
Title, 
Author, 
Additional_Authors,
Publisher,
Binding 
FROM Goodreads_raw
WHERE LEFT(Author, 1) != UPPER(LEFT(Author, 1)) 
OR LEFT(Additional_Authors, 1) != UPPER(LEFT(Additional_Authors, 1)) 
OR LEFT(Title, 1) != UPPER(LEFT(Title, 1))
OR LEFT(Publisher, 1) != UPPER(LEFT(Publisher, 1))
OR LEFT(Binding, 1) != UPPER(LEFT(Binding, 1))

-- I want to check for ISBN that doesn't start with a number.
SELECT 
ISBN
FROM Goodreads_raw
WHERE LEFT(ISBN, 1) NOT LIKE '%[0-9]';

-- I want to check for unique values in binding, for example the value where hardcover is written as HARDCOVER (This query didn't work for that but it show me something useful)
-- I tried another way to find Binding values written in capital letters.
-- This didn't work either, so I tried a different approach.

SELECT DISTINCT Binding
FROM Goodreads_raw;

SELECT
Binding
FROM Goodreads_raw
WHERE Binding = UPPER(Binding);

-- Finding year_published and origina_publication_year where there is more than 4 digits or NULL.
SELECT
Year_Published,
Original_Publication_Year
FROM Goodreads_raw
WHERE LEN(Year_Published) !=4
OR LEN(Original_Publication_Year) !=4
OR Year_Published IS NULL 
OR Original_Publication_Year IS NULL;

-- Some page numbers look suspicious, so I want to investigate them.
-- I am looking for values with more than 3 digits that end in 0 and doesn't start with 1.
-- As well as missing values.

SELECT
Number_of_Pages 
FROM Goodreads_raw
WHERE 
LEN(Number_of_Pages)>3 AND LEFT(Number_of_Pages,1) != '1'
AND Number_of_Pages LIKE '___0' OR Number_of_Pages IS NULL;

--Checking for unique values in Exclusive_Shelf.
SELECT DISTINCT Exclusive_Shelf
FROM Goodreads_raw;

--==================================================
-- TESTING DATA CLEANING
--==================================================

-- I found different ways of writing the same Binding so Im trying to make them consistent.
SELECT
CASE
WHEN Binding = 'HARDCOVER' OR Binding = 'hard Cover' THEN 'Hardcover'
WHEN Binding = 'Audible Audio' THEN 'Audiobook'
WHEN Binding = 'eBook' THEN 'e-Book'
WHEN Binding = 'Mass Market Paperback' OR Binding = 'paper Back' OR Binding = 'PAPERBACK' THEN 'Paperback'
WHEN Binding IS NULL THEN 'Unknown Binding'
ELSE Binding
END AS Cleaned_Binding
FROM Goodreads_raw;

-- I found different ways of writting the shelf names, so I am trying to make them consistent.

SELECT
CASE
WHEN Exclusive_Shelf = 'Currently-Reading' OR Exclusive_Shelf = 'currently reading' THEN 'Currently reading'
WHEN Exclusive_Shelf = 'read' THEN 'Read'
WHEN Exclusive_Shelf = 'To-Read' OR Exclusive_Shelf = 'to read' THEN 'To read'
ELSE Exclusive_Shelf
END AS Cleaned_Exclusive_Shelf
FROM Goodreads_raw;

-- I found different ways of writting in the shelf names, so I want to make them consistent.

SELECT Exclusive_Shelf,
TRIM(Exclusive_Shelf) AS Trimmed_Exclusive_Shelf
FROM Goodreads_raw;

-- I noticed some ISBNs have = and " around them, I am trying to remove these.
SELECT ISBN,
CASE
WHEN ISBN IS NULL THEN 'Unknown'
ELSE REPLACE(REPLACE(ISBN,'=',''),'"','')
END
FROM Goodreads_raw;

-- After removing = and " I noticed that some values are still blank, so I want to check what is happening.
SELECT ISBN,
LEN(ISBN) AS ISBN_Length
FROM Goodreads_raw;

-- I found that ="" becomes an empty value after cleaning so I will treat this the same as NULL and use unknown.
SELECT ISBN,
CASE
WHEN ISBN IS NULL 
OR LEN(REPLACE(REPLACE(ISBN,'=',''),'"',''))=0
THEN 'Unknown'
ELSE REPLACE(REPLACE(ISBN,'=',''),'"','')
END AS Cleaned_ISBN
FROM Goodreads_raw;

-- Removing extra 0 values from Year_Published and Orginal_Publication_Year.
SELECT Year_Published, Original_Publication_Year,
CASE 
WHEN LEN(Year_Published)!=4 THEN LEFT(Year_Published,4)
ELSE Year_Published
END AS Cleaned_Year_Published,
CASE
WHEN LEN(Original_Publication_Year)!=4 THEN LEFT(Original_Publication_Year,4)
ELSE Original_Publication_Year
END AS Cleaned_Original_Year
FROM Goodreads_raw;

--Investigating a way to remove suspicious number of pages were the first number is not 1 and more than 4 digits with a 0 at the end.
SELECT Number_of_Pages,
LEFT(Number_of_Pages, LEN(Number_of_Pages) -1) 
FROM Goodreads_raw
WHERE LEN(Number_of_Pages)>3
AND Number_of_Pages LIKE '___0';

-- Removing suspicious number of pages were the first number is not 1 and more than 4 digits with a 0 at the end.
SELECT Number_of_Pages,
CASE
WHEN LEN(Number_of_Pages)> 3 AND LEFT(Number_of_Pages, 1) !='1' AND Number_of_Pages LIKE '___0' 
THEN LEFT(Number_of_Pages, LEN(Number_of_Pages) -1) 
ELSE Number_of_Pages
END AS Cleaned_Number_of_Pages
FROM Goodreads_raw
WHERE LEN(Number_of_Pages)>3
AND Number_of_Pages LIKE '___0';

-- Changing NULL from Publisher to Unknown.
SELECT Publisher,
CASE WHEN Publisher IS NULL THEN 'Unknown'
ELSE Publisher
END AS Cleaned_Publisher
FROM Goodreads_raw;

-- Changing Date_Added format.
SELECT Date_Added,
CAST (Date_Added AS DATE) AS Cleaned_Date_Added
FROM Goodreads_raw;

-- Changing Date_Read NULL for not read yet -- I couldn't insert this to create the Goodreads_raw as I learn this column is only numberic and doesnt accept characters.

SELECT Date_Read,
CASE WHEN Date_Read IS NULL THEN 'Not read yet'
ELSE Date_Read
END AS Date_Read
FROM Goodreads_raw;

--======================================================
--CREATING THE CLEANED TABLE
--======================================================
SELECT 
Book_id,
Title,
Author,
Additional_Authors,

CASE
WHEN ISBN IS NULL 
OR LEN(REPLACE(REPLACE(ISBN,'=',''),'"',''))=0
THEN 'Unknown'
ELSE REPLACE(REPLACE(ISBN,'=',''),'"','')
END AS ISBN,

CASE WHEN Publisher IS NULL THEN 'Unknown'
ELSE Publisher
END AS Publisher,

CASE
WHEN Binding = 'HARDCOVER' OR Binding = 'hard Cover' THEN 'Hardcover'
WHEN Binding = 'Audible Audio' THEN 'Audiobook'
WHEN Binding = 'eBook' THEN 'e-Book'
WHEN Binding = 'Mass Market Paperback' OR Binding = 'paper Back' OR Binding = 'PAPERBACK' THEN 'Paperback'
WHEN Binding IS NULL THEN 'Unknown Binding'
ELSE Binding
END AS Binding,

CASE
WHEN LEN(Number_of_Pages)> 3 AND LEFT(Number_of_Pages, 1) !='1' AND Number_of_Pages LIKE '___0' 
THEN LEFT(Number_of_Pages, LEN(Number_of_Pages) -1) 
ELSE Number_of_Pages
END AS Number_of_Pages,

CASE 
WHEN LEN(Year_Published)!=4 THEN LEFT(Year_Published,4)
ELSE Year_Published
END AS Year_Published,

CASE
WHEN LEN(Original_Publication_Year)!=4 THEN LEFT(Original_Publication_Year,4)
ELSE Original_Publication_Year
END AS Original_Publication_Year,

CAST (Date_Added AS DATE) AS Date_Added,

Date_Read,

CASE
WHEN Exclusive_Shelf = 'Currently-Reading' OR Exclusive_Shelf = 'currently reading' THEN 'Currently reading'
WHEN Exclusive_Shelf = 'read' THEN 'Read'
WHEN Exclusive_Shelf = 'To-Read' OR Exclusive_Shelf = 'to read' THEN 'To read'
ELSE Exclusive_Shelf
END AS Exclusive_Shelf

INTO Goodreads_Clean
FROM Goodreads_Raw;

-- New table created Goodreads_Clean

SELECT *
FROM Goodreads_Clean;

--=================================================
-- CREATING SEPARATE TABLES
--=================================================

-- Books table.

SELECT
Book_id,
Title,
ISBN,
Publisher,
Binding,
Number_of_Pages,
Year_Published,
Original_Publication_Year
INTO Books
FROM Goodreads_Clean

-- Reading.

SELECT
Book_id,
Date_Added,
Date_Read,
Exclusive_Shelf
INTO Reading
FROM Goodreads_Clean

SELECT*
FROM Reading;

-- Authors table.

CREATE TABLE Authors (
Author_Id INT PRIMARY KEY,
Author_Name VARCHAR (50));

INSERT INTO Authors (Author_Name)
SELECT DISTINCT Author
FROM Goodreads_Clean;

-- At this stage I had to learn about IDENTITY as I didn't know how to give every Author_id a number, so I dropped the table and started again.

DROP TABLE Authors;

CREATE TABLE Authors (
Author_Id INT IDENTITY (1,1) PRIMARY KEY,
Author_Name VARCHAR (50));

INSERT INTO Authors (Author_Name)
SELECT DISTINCT Author
FROM Goodreads_Clean;

SELECT*
FROM Authors;

-- Creating a table combining books and authors.
 
 CREATE TABLE Books_and_Authors(Book_id INT, Author_ID INT);

INSERT INTO Books_and_Authors (Book_id, Author_id)
SELECT 
Book_id,
Author_id
FROM Goodreads_Clean
INNER JOIN Authors
ON Author = Author_Name;

--========================================
--INVESTIGATING ADDITIONAL AUTHORS
--========================================
-- I found some books with additional authors.
-- I am checking the data to understand how it is stored before deciding what to do with it.

SELECT *
FROM Books_and_Authors;

SELECT Additional_Authors
FROM Goodreads_clean
WHERE Additional_Authors IS NOT NULL;

SELECT Book_id, Additional_Authors
FROM Goodreads_clean
WHERE Additional_Authors IS NOT NULL;

SELECT Author, Additional_Authors
FROM Goodreads_clean
WHERE Author = Additional_Authors;
-- I found 60 books with additional author information.
-- For now I have decided to leave these values together because I don't know enough yet about the best way to split them.
-- I will come back to this later when I learn more about relationships between tables.