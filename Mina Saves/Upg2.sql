--�vningsuppgifter 2 � Aggregering av data 
--Nu n�r vi l�rt oss grunderna i hur man plockar ut data ur tabeller med hj�lp av 
--SQL s� ska vi kolla p� hur vi f�r ut s�dan information som inte st�r i klartext, 
--men som vi kan r�kna ut och sammanst�lla p� olika vis. 

--------------- A ------------------
--a) Ta ut (select) en rad f�r varje (unik) period i tabellen �Elements� med 
--f�ljande kolumner: �period�, �from� med l�gsta atomnumret i perioden, 
--�to� med h�gsta atomnumret i perioden, �average isotopes� med 
--genomsnittligt antal isotoper visat med 2 decimaler, �symbols� med en 
--kommaseparerad lista av alla �mnen i perioden. 

SELECT 
    Period,
    MIN(Number) AS LowestNumber,
	MAX(Number) AS HighestNumber,
    FORMAT(AVG(cast(Stableisotopes) as float), '#.00') AS AverageIsotopes,
    STRING_AGG(Symbol, ',') AS SymbolList
FROM
    Elements
GROUP BY
    Period
ORDER BY
    Period;

-- Notes: CAST = s�tt den som float

---------------- B ---------------
--b) F�r varje stad som har 2 eller fler kunder i tabellen Customers, ta ut 
--(select) f�ljande kolumner: �Region�, �Country�, �City�, samt 
--�Customers� som anger hur m�nga kunder som finns i staden. 


SELECT
	Region,
	Country,
	City,
	COUNT(*) as customercount

FROM 
	company.customers
GROUP BY
    Region, Country, City;



---------------- C -----------------
--c) Skapa en varchar-variabel och skriv en select-sats som s�tter v�rdet: 

--	�S�song 1 s�ndes fr�n april till juni 2011. Totalt 
--	s�ndes 10 avsnitt, som i genomsnitt s�gs av 2.5 
--	miljoner m�nniskor i USA.�, f�ljt av radbyte/char(13), f�ljt av 
--	�S�song 2 s�ndes �� osv. 

--	N�r du sedan skriver (print) variabeln till messages ska du allts� f� en rad 
--	f�r varje s�song enligt ovan, med data sammanst�llt fr�n tabellen 
--	GameOfThrones. 
--	Tips: Ange �sv� som tredje parameter i format() f�r svenska m�nader.


Fattar ej fr�gan




----------------- D --------------------
--d) Ta ut (select) alla anv�ndare i tabellen �Users� s� du f�r tre kolumner: 
--�Namn� som har fulla namnet; ��lder� som visar hur m�nga �r personen 
--�r idag (ex. �45 �r�); �K�n� som visar om det �r en man eller kvinna. 
--Sortera raderna efter f�r- och efternamn. 

SELECT
	FirstName + ' ' + LastName as Namn,
	LEFT(ID, 6) as �lder

FROM Users;

-- Note saknar k�n? Ta fr�n namn p� n�got s�tt.


----------------- E ----------------------
--e) Ta ut en lista �ver regioner i tabellen �Countries� d�r det f�r varje region 
--framg�r regionens namn, antal l�nder i regionen, totalt antal inv�nare, 
--total area, befolkningst�theten med 2 decimaler, samt 
--sp�dbarnsd�dligheten per 100.000 f�dslar avrundat till heltal. 

SELECT *
FROM Countries;

SELECT 
	Region,
	SUM(Population) as TotalPop, 
	COUNT(*) as Countries, 
	[Infant mortality (per 1000 births)], 
	[Pop# Density (per sq# mi#)]

FROM Countries

GROUP BY
	Region, Population, Country, [Infant mortality (per 1000 births)], [Pop# Density (per sq# mi#)];



----------------- F -------------------------
--f) Fr�n tabellen �Airports�, gruppera per land och ta ut kolumner som visar: 
--land, antal flygplatser (IATA-koder), antal som saknar ICAO-kod, samt hur 
--m�nga procent av flygplatserna i varje land som saknar ICAO-kod.