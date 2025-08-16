
USE Zomato;

SELECT 
COLUMN_NAME, 
DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'Zomato_Dataset_updated'															-- Check Datatype of table


SELECT DISTINCT(TABLE_CATALOG),TABLE_NAME FROM INFORMATION_SCHEMA.COLUMNS						 -- CHECK TABLES IN ALL THE DATABSE
SELECT * FROM INFORMATION_SCHEMA.COLUMNS

SELECT * FROM Zomato_Dataset_updated



--CHECKING FOR DUPLICATE
SELECT RestaurantID,COUNT(RestaurantID) FROM 
Zomato_Dataset_updated
GROUP BY [RestaurantID]
ORDER BY 2 DESC

SELECT * FROM [Country-Code-csv];



--REMOVING UNWANTED ROWS

DELETE FROM Zomato_Dataset_updated
WHERE RestaurantID = '18306543'

SELECT * FROM Zomato_Dataset_updated



-- COUNTRY CODE COLUMN
SELECT A.CountryCode,B.COUNTRY
FROM Zomato_Dataset_updated A JOIN [Country-Code-csv] B
ON A.CountryCode = B.Country_Code

ALTER TABLE Zomato_Dataset_updated ADD COUNTRY_NAME VARCHAR(50)

UPDATE Zomato_Dataset_updated SET COUNTRY_NAME = B.COUNTRY					   -- MERGING AND ADDING COUNTRY DETAILS FROM DIFFERENT TABLE THROUGH UPDATE WITH JOIN STATEMENT
FROM Zomato_Dataset_updated A JOIN [Country-Code-csv] B
ON A.CountryCode = B.COUNTRY_CODE

SELECT *
FROM Zomato_Dataset_updated



--CITY COLUMN
SELECT DISTINCT City FROM Zomato_Dataset_updated
WHERE CITY LIKE '%?%'																  --IDENTIFYING IF THERE ARE ANY MISS-SPELLED WORD

SELECT REPLACE(CITY,'?','i') 
FROM Zomato_Dataset_updated WHERE CITY LIKE '%?%'											  --REPLACING MISS-SPELLED WORD

UPDATE Zomato_Dataset_updated SET City = REPLACE(CITY,'?','i') 
					 FROM Zomato_Dataset_updated WHERE CITY LIKE '%?%'	 			 -- UPDATING WITH REPLACE STRING FUNCTION

SELECT COUNTRY_NAME, CITY, COUNT([City]) TOTAL_REST							      -- COUNTING TOTAL REST. IN EACH CITY OF PARTICULAR COUNTRY
FROM Zomato_Dataset_updated
GROUP BY COUNTRY_NAME,CITY 
ORDER BY 1,2,3 DESC



--LOCALITY COLUMN
SELECT CITY,Locality, COUNT(Locality) COUNT_LOCALITY,														-- ROLLING COUNT
SUM(COUNT(Locality)) OVER(PARTITION BY [City] ORDER BY CITY,Locality) ROLL_COUNT
FROM Zomato_Dataset_updated
WHERE COUNTRY_NAME = 'INDIA'
GROUP BY Locality,CITY
ORDER BY 1,2,3 DESC



--DROP COLUMN,[LocalityVerbose]
ALTER TABLE Zomato_Dataset_updated DROP COLUMN LocalityVerbose 



-- CUISINES COLUMN 
SELECT Cuisines, COUNT(Cuisines) FROM Zomato_Dataset_updated
WHERE Cuisines IS NULL OR Cuisines = ' '
GROUP BY Cuisines
ORDER BY 2 DESC

SELECT Cuisines,COUNT(Cuisines) as Total_Cuisines
FROM Zomato_Dataset_updated
GROUP BY [Cuisines]
ORDER BY 2 DESC


-- CURRENCY COULMN
SELECT Currency, COUNT(Currency) AS Total_Currency FROM Zomato_Dataset_updated
GROUP BY Currency
ORDER BY 2 DESC



-- YES/NO COLUMNS
SELECT DISTINCT([Has_Table_booking]) FROM Zomato_Dataset_updated
SELECT DISTINCT([Has_Online_delivery]) FROM Zomato_Dataset_updated
SELECT DISTINCT([Is_delivering_now]) FROM Zomato_Dataset_updated
SELECT DISTINCT([Switch_to_order_menu]) FROM Zomato_Dataset_updated



-- DROP COULLMN [Switch_to_order_menu]
ALTER TABLE Zomato_Dataset_updated DROP COLUMN Switch_to_order_menu



-- PRICE RANGE COLUMN
SELECT DISTINCT(Price_range) FROM Zomato_Dataset_updated
select * from Zomato_Dataset_updated


-- VOTES COLUMN (CHECKING MIN,MAX,AVG OF VOTE COLUMN)
ALTER TABLE Zomato_Dataset_updated ALTER COLUMN Votes INT

SELECT MIN(CAST(Votes AS INT)) MIN_VT, AVG(CAST(Votes AS INT)) AVG_VT, MAX(CAST(Votes AS INT)) MAX_VT
FROM Zomato_Dataset_updated


-- COST COLUMN
ALTER TABLE Zomato_Dataset_updated ALTER COLUMN Average_Cost_for_two FLOAT

SELECT Currency,MIN(CAST(Average_Cost_for_two AS INT)) MIN_COST,
AVG(CAST(Average_Cost_for_two AS INT)) AVG_COST,
MAX(CAST(Average_Cost_for_two AS INT)) MAX_COST
FROM Zomato_Dataset_updated
--WHERE [Currency] LIKE '%U%'
GROUP BY Currency



--RATING COLUMN
SELECT MIN(Rating) Lowest_rating,
ROUND(AVG(CAST(Rating AS DECIMAL)),1) Avg_rating, 
MAX(Rating) Highest_rating 
FROM Zomato_Dataset_updated

--SELECT CAST(Rating AS decimal) NUM FROM Zomato_Dataset_updated WHERE CAST(Rating AS decimal) >= 4

ALTER TABLE Zomato_Dataset_updated ALTER COLUMN Rating DECIMAL

SELECT RestaurantID, RestaurantName, RATING FROM Zomato_Dataset_updated WHERE Rating >= 4

SELECT RestaurantID, RestaurantName, RATING,
CASE
WHEN Rating >= 1 AND Rating < 2.5 THEN 'POOR'
WHEN Rating >= 2.5 AND Rating < 3.5 THEN 'GOOD'
WHEN Rating >= 3.5 AND Rating < 4.5 THEN 'GREAT'
WHEN Rating >= 4.5 THEN 'EXCELLENT'
END RATE_CATEGORY
FROM Zomato_Dataset_updated

ALTER TABLE Zomato_Dataset_updated ADD Rating__CATEGORY_ VARCHAR(Max)


ALTER TABLE Zomato_Dataset_updated DROP COLUMN Rating_CATEGORY_
ALTER TABLE Zomato_Dataset_updated DROP COLUMN Rating__CATEGORY_
ALTER TABLE Zomato_Dataset_updated DROP COLUMN Rating_CATEGORY

SELECT * FROM Zomato_Dataset_updated


--UPDATING NEW ADDED COLUMN WITH REFFERENCE OF AN EXISTING COLUMN
UPDATE Zomato_Dataset_updated SET RATE_CATEGORY = (CASE								     	-- UPDATE WITH CASE-WHEN STATEMENT
WHEN Rating >= 1 AND Rating < 2.5 THEN 'POOR'
WHEN Rating >= 2.5 AND Rating < 3.5 THEN 'GOOD'
WHEN Rating >= 3.5 AND Rating < 4.5 THEN 'GREAT'
WHEN Rating >= 4.5 THEN 'EXCELLENT'
END)

SELECT * FROM Zomato_Dataset_updated

