

---------- MOON MISSIONS ----------------------

--Använd ”select into” för att ta ut kolumnerna ’Spacecraft’, ’Launch date’, 
--’Carrier rocket’, ’Operator’, samt ’Mission type’ för alla lyckade uppdrag 
--(Successful outcome) och sätt in i en ny tabell med namn ”SuccessfulMissions”. SELECT 
    Spacecraft, 
    [Launch date], 
    [Carrier rocket], 
    Operator, 
    [Mission type]
INTO 
    SuccessfulMissions
FROM 
    MoonMissions
WHERE 
    Outcome = 'Successful';

GO

-------------------------------------

--I kolumnen ’Operator’ har det smugit sig in ett eller flera mellanslag före 
--operatörens namn skriv en query som uppdaterar ”SuccessfulMissions” och tar 
--bort mellanslagen kring operatör. 
UPDATE SuccessfulMissions
SET Operator = LTRIM(Operator);

GO

--------------------------------------

--I ett flertal fall har värden i kolumnen ’Spacecraft’ ett alternativt namn som står 
--inom parantes, t.ex: ”Pioneer 0 (Able I)”. Skriv en query som uppdaterar 
--”SuccessfulMissions” på ett sådant sätt att alla värden i kolumnen ’Spacecraft’ 
--endast innehåller originalnamnet, dvs ta bort alla paranteser och deras 
--innehåll. Ex: ”Pioneer 0 (Able I)” => ”Pioneer 0”. UPDATE SuccessfulMissions
SET Spacecraft = LEFT(Spacecraft, CHARINDEX(' (', Spacecraft) - 1)
WHERE CHARINDEX(' (', Spacecraft) > 0;


GO

---------------------------------

--Skriv en select query som tar ut, grupperar, samt sorterar på kolumnerna 
--’Operator’ och ’Mission type’ från ”SuccessfulMissions”. Som en tredje kolumn 
--’Mission count’ i resultatet vill vi ha antal uppdrag av varje operatör och typ. Ta 
--bara med de grupper som har fler än ett (>1) uppdrag av samma typ och 
--operatör. SELECT 
    Operator, 
    [Mission type], 
    COUNT(*) as [Mission count]
FROM SuccessfulMissions
GROUP BY Operator, [Mission type]
HAVING COUNT(*) > 1
ORDER BY [Mission count] DESC;

GO



--------------- USERS ---------------------------

--Users 
--Ta ut samtliga rader och kolumner från tabellen ”Users”, men slå ihop 
--’Firstname’ och ’Lastname’ till en ny kolumn ’Name’, samt lägg till en extra 
--kolumn ’Gender’ som du ger värdet ’Female’ för alla användare vars näst sista 
--siffra i personnumret är jämn, och värdet ’Male’ för de användare där siffran är 
--udda. Sätt in resultatet i en ny tabell ”NewUsers”. 


SELECT
	*, 
    FirstName + ' ' + LastName as Name,
    Gender = CASE
        WHEN CAST(SUBSTRING(ID, LEN(ID) - 1, 1) as INT) % 2 = 0 THEN 'Female'
        ELSE 'Male'
    END
INTO 
	NewUsers
FROM 
	Users;


GO 

---------------------------------------

--Skriv en query som returnerar en tabell med alla användarnamn i ”NewUsers” 
--som inte är unika i den första kolumnen, och antalet gånger de är duplicerade i 
--den andra kolumnen. 


SELECT
	UserName,
	COUNT(*) as 'Duplicate count'
FROM
	NewUsers
GROUP BY
	UserName
HAVING
	COUNT(*) > 1;

GO 

------------------------------


--Skriv en följd av queries som uppdaterar de användare med dubblerade 
--användarnamn som du fann ovan, så att alla användare får ett unikt 
--användarnamn. D.v.s du kan hitta på nya användarnamn för de användarna, så 
--länge du ser till att alla i ”NewUsers” har unika värden på ’Username’. 


UPDATE NewUsers
SET UserName = 'felbe1'
WHERE ID = (SELECT TOP 1 ID FROM NewUsers WHERE UserName = 'felber' ORDER BY ID DESC);

UPDATE NewUsers
SET UserName = 'sigpe1'
WHERE ID = (SELECT TOP 1 ID FROM NewUsers WHERE UserName = 'sigpet' ORDER BY ID DESC);

UPDATE NewUsers
SET UserName = 'sigpe2'
WHERE ID = (SELECT TOP 1 ID FROM NewUsers WHERE UserName = 'sigpet' ORDER BY ID DESC);



GO 

-------------------------------------------


--Skapa en query som tar bort alla kvinnor födda före 1970 från ”NewUsers”. 


DELETE FROM NewUsers
WHERE Gender = 'Female' AND CAST(LEFT(ID, 2) AS INT) < 70;



GO 

-------------------------------------


--Lägg till en ny användare i tabellen ”NewUsers”. 


INSERT INTO NewUsers (ID, UserName, Password, FirstName, LastName, Email, Phone, Name, Gender)
VALUES ('987654-3210', 'spock', 'logic123', 'Spock', 'Unknown', 'spock@gmail.com', '123-123123', 'Spock', 'Male');


GO 

------------------------------------


--För betyg väl godkänt (endast följande uppgift): 
--Skriv en query som returnerar två kolumner ’gender’ och ’avarage age’, och två 
--rader där ena raden visar medelåldern för män, och andra raden visar 
--medelåldern på kvinnor för alla användare i tabellen ”NewUsers”. 

SELECT
	Gender AS 'Gender',

	AVG(
		YEAR(GETDATE()) - (1900 + LEFT(ID, 2))
	) AS 'Average age'
FROM
	NewUsers
GROUP BY
	Gender;


GO


---------------------Company (Joins) --------------------- 
--Skriv en query som selectar ut alla (77) produkter i company.products 
--Dessa ska visas i 4 kolumner: 
--Id – produktens id 
--Product – produktens namn 
--Supplier – namnet på företaget som leverar produkten 
--Category – namnet på kategorin som produkten tillhör 

SELECT 
    p.Id,
    p.ProductName as Product,
    s.CompanyName as Supplier,
    c.CategoryName as Category
FROM 
    company.products as p
JOIN 
    company.suppliers as s ON p.SupplierId = s.Id
JOIN 
    company.categories as c ON p.CategoryId = c.Id;

GO 

--------------------------------------
--Skriv en query som listar antal anställda i var och en av de fyra regionerna i 
--tabellen company.regions 

SELECT 
	RegionDescription as 'Region',
	COUNT(*) AS 'Number of Employees'

FROM
	company.employees emp
	INNER JOIN company.employee_territory emp_terr ON emp.Id = emp_terr.EmployeeId
	INNER JOIN company.territories terr ON emp_terr.TerritoryId = terr.Id
	INNER JOIN company.regions reg ON terr.RegionId = reg.Id
GROUP BY
	RegionId,
	RegionDescription;



GO 

--------------------------------------
--För betyg väl godkänt (endast följande uppgift): 
--Vi har tidigare kollat på one-to-many och many-to-many joins. Det finns även 
--det som brukar kallas för self-join, när en tabell joinar mot sig själv. 
--Använd en self-join för att lista alla (9) anställda och deras närmsta chef. 

--De anställda ska visas i tre kolumner: 
--Id – Den anställdes id. 
--Name – Den anställdes titel och fullständiga namn (ex: Dr. Andrew Fuller) 
--Reports to – Närmsta chefens titel och fullständiga namn. 
--I de fall ReportsTo-kolumnen i company.employer är NULL, visa ’Nobody!’ 

SELECT
	emp.Id,
	CONCAT(emp.TitleOfCourtesy, ' ', emp.FirstName, ' ', emp.LastName) AS 'Name',

	CASE 
		WHEN emp.ReportsTo IS NULL THEN
			'Nobody!'
		ELSE
			CONCAT(Sup.TitleOfCourtesy, ' ', Sup.FirstName, ' ', Sup.LastName)
	END AS
		'Reports to'
FROM
	company.employees sup
	RIGHT OUTER JOIN company.employees emp ON sup.Id = emp.ReportsTo;
