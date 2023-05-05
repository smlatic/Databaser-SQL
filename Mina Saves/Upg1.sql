/****** Script for SelectTopNRows command from SSMS  ******/


-- A)
-- Ta ut data (select) från tabellen GameOfThrones på sådant sätt att ni får ut
--en kolumn ’Title’ med titeln samt en kolumn ’Episode’ som visar episoder
--och säsonger i formatet ”S01E01”, ”S01E02”, osv.
--Tips: kolla upp funktionen format() 

SELECT 
    Title,
    'S' + FORMAT(Season, '00') + 'E' + FORMAT(EpisodeInSeason, '00') AS Episode
FROM GameOfThrones_copy;

-- Notes: Format säger vilken kolumn och hur många digits man vill "tweaka" med.


-----------------------------------


--B)
--Uppdatera (kopia på) tabellen user och sätt username för alla användare så
--den blir de 2 första bokstäverna i förnamnet, och de 2 första i efternamnet
--(istället för 3+3 som det är i orginalet). Hela användarnamnet ska vara i små
--bokstäver. 

--SELECT *
--INTO Users_copy
--FROM Users;

-- NOtes: Skapa en kopia



UPDATE Users_copy
SET UserName = LOWER(LEFT(FirstName, 2) + LEFT(LastName, 2));

-- Notes: UPDATE vilken table man vill modifiera, SET är ge nya värden.


-----------------------------------------------



--C)
--Uppdatera (kopia på) tabellen airports så att alla null-värden i kolumnerna
--Time och DST byts ut mot ’-’

SELECT * 
INTO Airports_copy
FROM Airports;

UPDATE Airports_copy
SET Time = COALESCE(Time, '-'),
	DST = COALESCE(DST, '-')
WHERE Time IS NULL OR DST IS NULL;


--------------------------------------


-- D)

--Ta bort de rader från (kopia på) tabellen Elements där ”Name” är någon av
--följande: 'Erbium', 'Helium', 'Nitrogen', 'Platinum', 'Selenium', samt alla
--rader där ”Name” börjar på någon av bokstäverna d, k, m, o, eller u.

SELECT * 
INTO Elements_copy
FROM Elements;

DELETE FROM Elements_copy
	WHERE LOWER(Name) IN ('erbium', 'helium', 'nitrogen', 'platinum', 'selenium')
	OR LOWER(LEFT(Name, 1)) IN ('d', 'k', 'm', 'o', 'u');

	-- Notes: If OR basically




----------------------------------------

-- E)

--Skapa en ny tabell med alla rader från tabellen Elements. Den nya tabellen
--ska innehålla ”Symbol” och ”Name” från orginalet, samt en tredje kolumn
--med värdet ’Yes’ för de rader där ”Name” börjar med bokstäverna i
--”Symbol”, och ’No’ för de rader där de inte gör det.
--Ex: ’He’ -> ’Helium’ -> ’Yes’, ’Mg’ -> ’Magnesium’ -> ’No’. 


SELECT
    Symbol,
    Name,
    CASE
        WHEN LEFT(Name, LEN(Symbol)) = (Symbol) THEN 'yes'
        ELSE 'no'
    END as 'yes/no'

INTO Elements_new

FROM Elements;


--SELECT FirstName, LastName,
--    CASE
--        WHEN Age < 18 THEN 'Minor'
--        WHEN Age BETWEEN 18 AND 64 THEN 'Adult'
--        ELSE 'Senior'
--    END as AgeGroup
--FROM Users;

-- CASE EXAMPLE


--------------------------

-- F)

--Kopiera tabellen Colors till Colors2, men skippa kolumnen ”Code”. Gör
--sedan en select från Colors2 som ger samma resultat som du skulle fått från
--select * from Colors; (Dvs, återskapa den saknade kolumnen från RGBvärdena i resultatet). SELECT 	Name,	Red,	Green,	Blue,    '#' + RIGHT('0' + CONVERT(varchar(2), Red, 2), 2)
        + RIGHT('0' + CONVERT(varchar(2), Green, 2), 2)
        + RIGHT('0' + CONVERT(varchar(2), Blue, 2), 2) 		AS CodeINTO Colors2FROM Colors-- Notes: Hex koden är fel men pallar ej.------------------------- G)--Kopiera kolumnerna ”Integer” och ”String” från tabellen ”Types” till en ny
--tabell. Gör sedan en select från den nya tabellen som ger samma resultat
--som du skulle fått från select * from types; SELECT 	Integer,	String,INTO Types_newFROM Types-- Notes: -- Kolumner att få upp utöver, -- Float = Delar Integer med 100-- BOOl column = jämn o jämt integer-- Date = Kanske när värdet hämtades-----------------------------------------------------------