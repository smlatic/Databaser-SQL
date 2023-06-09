

---------- MOON MISSIONS ----------------------

--Anv�nd �select into� f�r att ta ut kolumnerna �Spacecraft�, �Launch date�, 
--�Carrier rocket�, �Operator�, samt �Mission type� f�r alla lyckade uppdrag 
--(Successful outcome) och s�tt in i en ny tabell med namn �SuccessfulMissions�. SELECT 
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

--I kolumnen �Operator� har det smugit sig in ett eller flera mellanslag f�re 
--operat�rens namn skriv en query som uppdaterar �SuccessfulMissions� och tar 
--bort mellanslagen kring operat�r. 
UPDATE SuccessfulMissions
SET Operator = LTRIM(Operator);

GO

--------------------------------------

--I ett flertal fall har v�rden i kolumnen �Spacecraft� ett alternativt namn som st�r 
--inom parantes, t.ex: �Pioneer 0 (Able I)�. Skriv en query som uppdaterar 
--�SuccessfulMissions� p� ett s�dant s�tt att alla v�rden i kolumnen �Spacecraft� 
--endast inneh�ller originalnamnet, dvs ta bort alla paranteser och deras 
--inneh�ll. Ex: �Pioneer 0 (Able I)� => �Pioneer 0�. UPDATE SuccessfulMissions
SET Spacecraft = LEFT(Spacecraft, CHARINDEX(' (', Spacecraft) - 1)
WHERE CHARINDEX(' (', Spacecraft) > 0;


GO

---------------------------------

--Skriv en select query som tar ut, grupperar, samt sorterar p� kolumnerna 
--�Operator� och �Mission type� fr�n �SuccessfulMissions�. Som en tredje kolumn 
--�Mission count� i resultatet vill vi ha antal uppdrag av varje operat�r och typ. Ta 
--bara med de grupper som har fler �n ett (>1) uppdrag av samma typ och 
--operat�r. SELECT 
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
--Ta ut samtliga rader och kolumner fr�n tabellen �Users�, men sl� ihop 
--�Firstname� och �Lastname� till en ny kolumn �Name�, samt l�gg till en extra 
--kolumn �Gender� som du ger v�rdet �Female� f�r alla anv�ndare vars n�st sista 
--siffra i personnumret �r j�mn, och v�rdet �Male� f�r de anv�ndare d�r siffran �r 
--udda. S�tt in resultatet i en ny tabell �NewUsers�. 


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

--Skriv en query som returnerar en tabell med alla anv�ndarnamn i �NewUsers� 
--som inte �r unika i den f�rsta kolumnen, och antalet g�nger de �r duplicerade i 
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


--Skriv en f�ljd av queries som uppdaterar de anv�ndare med dubblerade 
--anv�ndarnamn som du fann ovan, s� att alla anv�ndare f�r ett unikt 
--anv�ndarnamn. D.v.s du kan hitta p� nya anv�ndarnamn f�r de anv�ndarna, s� 
--l�nge du ser till att alla i �NewUsers� har unika v�rden p� �Username�. 


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


--Skapa en query som tar bort alla kvinnor f�dda f�re 1970 fr�n �NewUsers�. 


DELETE FROM NewUsers
WHERE Gender = 'Female' AND CAST(LEFT(ID, 2) AS INT) < 70;



GO 

-------------------------------------


--L�gg till en ny anv�ndare i tabellen �NewUsers�. 


INSERT INTO NewUsers (ID, UserName, Password, FirstName, LastName, Email, Phone, Name, Gender)
VALUES ('987654-3210', 'spock', 'logic123', 'Spock', 'Unknown', 'spock@gmail.com', '123-123123', 'Spock', 'Male');


GO 

------------------------------------


--F�r betyg v�l godk�nt (endast f�ljande uppgift): 
--Skriv en query som returnerar tv� kolumner �gender� och �avarage age�, och tv� 
--rader d�r ena raden visar medel�ldern f�r m�n, och andra raden visar 
--medel�ldern p� kvinnor f�r alla anv�ndare i tabellen �NewUsers�. 

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
--Id � produktens id 
--Product � produktens namn 
--Supplier � namnet p� f�retaget som leverar produkten 
--Category � namnet p� kategorin som produkten tillh�r 

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
--Skriv en query som listar antal anst�llda i var och en av de fyra regionerna i 
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
--F�r betyg v�l godk�nt (endast f�ljande uppgift): 
--Vi har tidigare kollat p� one-to-many och many-to-many joins. Det finns �ven 
--det som brukar kallas f�r self-join, n�r en tabell joinar mot sig sj�lv. 
--Anv�nd en self-join f�r att lista alla (9) anst�llda och deras n�rmsta chef. 

--De anst�llda ska visas i tre kolumner: 
--Id � Den anst�lldes id. 
--Name � Den anst�lldes titel och fullst�ndiga namn (ex: Dr. Andrew Fuller) 
--Reports to � N�rmsta chefens titel och fullst�ndiga namn. 
--I de fall ReportsTo-kolumnen i company.employer �r NULL, visa �Nobody!� 

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
