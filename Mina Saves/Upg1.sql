/****** Script for SelectTopNRows command from SSMS  ******/


-- A)
-- Ta ut data (select) fr�n tabellen GameOfThrones p� s�dant s�tt att ni f�r ut
--en kolumn �Title� med titeln samt en kolumn �Episode� som visar episoder
--och s�songer i formatet �S01E01�, �S01E02�, osv.
--Tips: kolla upp funktionen format() 

SELECT 
    Title,
    'S' + FORMAT(Season, '00') + 'E' + FORMAT(EpisodeInSeason, '00') AS Episode
FROM GameOfThrones_copy;

-- Notes: Format s�ger vilken kolumn och hur m�nga digits man vill "tweaka" med.


-----------------------------------


--B)
--Uppdatera (kopia p�) tabellen user och s�tt username f�r alla anv�ndare s�
--den blir de 2 f�rsta bokst�verna i f�rnamnet, och de 2 f�rsta i efternamnet
--(ist�llet f�r 3+3 som det �r i orginalet). Hela anv�ndarnamnet ska vara i sm�
--bokst�ver. 

--SELECT *
--INTO Users_copy
--FROM Users;

-- NOtes: Skapa en kopia



UPDATE Users_copy
SET UserName = LOWER(LEFT(FirstName, 2) + LEFT(LastName, 2));

-- Notes: UPDATE vilken table man vill modifiera, SET �r ge nya v�rden.


-----------------------------------------------



--C)
--Uppdatera (kopia p�) tabellen airports s� att alla null-v�rden i kolumnerna
--Time och DST byts ut mot �-�

SELECT * 
INTO Airports_copy
FROM Airports;

UPDATE Airports_copy
SET Time = COALESCE(Time, '-'),
	DST = COALESCE(DST, '-')
WHERE Time IS NULL OR DST IS NULL;


--------------------------------------


-- D)

--Ta bort de rader fr�n (kopia p�) tabellen Elements d�r �Name� �r n�gon av
--f�ljande: 'Erbium', 'Helium', 'Nitrogen', 'Platinum', 'Selenium', samt alla
--rader d�r �Name� b�rjar p� n�gon av bokst�verna d, k, m, o, eller u.

SELECT * 
INTO Elements_copy
FROM Elements;

DELETE FROM Elements_copy
	WHERE LOWER(Name) IN ('erbium', 'helium', 'nitrogen', 'platinum', 'selenium')
	OR LOWER(LEFT(Name, 1)) IN ('d', 'k', 'm', 'o', 'u');

	-- Notes: If OR basically




----------------------------------------

-- E)

--Skapa en ny tabell med alla rader fr�n tabellen Elements. Den nya tabellen
--ska inneh�lla �Symbol� och �Name� fr�n orginalet, samt en tredje kolumn
--med v�rdet �Yes� f�r de rader d�r �Name� b�rjar med bokst�verna i
--�Symbol�, och �No� f�r de rader d�r de inte g�r det.
--Ex: �He� -> �Helium� -> �Yes�, �Mg� -> �Magnesium� -> �No�. 


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

--Kopiera tabellen Colors till Colors2, men skippa kolumnen �Code�. G�r
--sedan en select fr�n Colors2 som ger samma resultat som du skulle f�tt fr�n
--select * from Colors; (Dvs, �terskapa den saknade kolumnen fr�n RGBv�rdena i resultatet). SELECT 	Name,	Red,	Green,	Blue,    '#' + RIGHT('0' + CONVERT(varchar(2), Red, 2), 2)
        + RIGHT('0' + CONVERT(varchar(2), Green, 2), 2)
        + RIGHT('0' + CONVERT(varchar(2), Blue, 2), 2) 		AS CodeINTO Colors2FROM Colors-- Notes: Hex koden �r fel men pallar ej.------------------------- G)--Kopiera kolumnerna �Integer� och �String� fr�n tabellen �Types� till en ny
--tabell. G�r sedan en select fr�n den nya tabellen som ger samma resultat
--som du skulle f�tt fr�n select * from types; SELECT 	Integer,	String,INTO Types_newFROM Types-- Notes: -- Kolumner att f� upp ut�ver, -- Float = Delar Integer med 100-- BOOl column = j�mn o j�mt integer-- Date = Kanske n�r v�rdet h�mtades-----------------------------------------------------------