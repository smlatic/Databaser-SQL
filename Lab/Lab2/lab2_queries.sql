

------- TABLES

CREATE TABLE F�rfattare (
    ID INT PRIMARY KEY IDENTITY,
    F�rnamn NVARCHAR(50) NOT NULL,
    Efternamn NVARCHAR(50) NOT NULL,
    F�delsedatum DATE NOT NULL
);

GO

CREATE TABLE B�cker (
    ISBN13 CHAR(13) PRIMARY KEY,
    Titel NVARCHAR(100) NOT NULL,
    Spr�k NVARCHAR(50) NOT NULL,
    Pris DECIMAL(10, 2) NOT NULL,
    Utgivningsdatum DATE NOT NULL,
    F�rfattareID INT FOREIGN KEY REFERENCES F�rfattare(ID)
);

GO

CREATE TABLE Butiker (
    ID INT PRIMARY KEY IDENTITY,
    Butiksnamn NVARCHAR(50) NOT NULL,
    Adress NVARCHAR(100) NOT NULL
);

GO

CREATE TABLE LagerSaldo (
    ButikID INT FOREIGN KEY REFERENCES Butiker(ID),
    ISBN13 CHAR(13) FOREIGN KEY REFERENCES B�cker(ISBN13),
    Antal INT NOT NULL,
    PRIMARY KEY (ButikID, ISBN13)
);

GO

CREATE TABLE Kunder (
    ID INT PRIMARY KEY IDENTITY,
    F�rnamn NVARCHAR(50) NOT NULL,
    Efternamn NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100),
    Adress NVARCHAR(100) NOT NULL
);

GO

CREATE TABLE Ordrar (
    ID INT PRIMARY KEY IDENTITY,
    KundID INT FOREIGN KEY REFERENCES Kunder(ID),
    ButikID INT FOREIGN KEY REFERENCES Butiker(ID),
    Orderdatum DATETIME DEFAULT GETDATE()
);

GO

CREATE TABLE OrderItems (
    OrderID INT FOREIGN KEY REFERENCES Ordrar(ID),
    ISBN13 CHAR(13) FOREIGN KEY REFERENCES B�cker(ISBN13),
    Antal INT NOT NULL,
    PRIMARY KEY (OrderID, ISBN13)
);

GO

CREATE TABLE F�rlag (
    ID INT PRIMARY KEY IDENTITY,
    Namn NVARCHAR(50) NOT NULL,
    Adress NVARCHAR(100)
);

GO

ALTER TABLE B�cker
ADD F�rlagID INT FOREIGN KEY REFERENCES F�rlag(ID);

GO



-------------------- Dummy data

INSERT INTO F�rfattare (F�rnamn, Efternamn, F�delsedatum) 
VALUES ('John', 'Smith', '1980-01-01');

INSERT INTO F�rfattare (F�rnamn, Efternamn, F�delsedatum) 
VALUES ('Jane', 'Doe', '1985-02-02');

INSERT INTO F�rfattare (F�rnamn, Efternamn, F�delsedatum) 
VALUES ('Tom', 'Jones', '1975-03-03');

INSERT INTO F�rfattare (F�rnamn, Efternamn, F�delsedatum) 
VALUES ('Emily', 'Brown', '1990-04-04');


GO

INSERT INTO B�cker (ISBN13, Titel, Spr�k, Pris, Utgivningsdatum, F�rfattareID)
VALUES ('9781234567890', 'Book Title 1', 'English', 100.0, '2023-01-01', 1);

INSERT INTO B�cker (ISBN13, Titel, Spr�k, Pris, Utgivningsdatum, F�rfattareID)
VALUES ('9781234567891', 'Book Title 2', 'English', 150.0, '2023-02-02', 2);

INSERT INTO B�cker (ISBN13, Titel, Spr�k, Pris, Utgivningsdatum, F�rfattareID)
VALUES ('9781234567892', 'Book Title 3', 'Swedish', 120.0, '2023-03-03', 3);

INSERT INTO B�cker (ISBN13, Titel, Spr�k, Pris, Utgivningsdatum, F�rfattareID)
VALUES ('9781234567893', 'Book Title 4', 'Swedish', 110.0, '2023-04-04', 4);

GO

INSERT INTO Butiker (Butiksnamn, Adress)
VALUES ('Store 1', 'Street 1, City 1, 12345');

INSERT INTO Butiker (Butiksnamn, Adress)
VALUES ('Store 2', 'Street 2, City 2, 23456');

INSERT INTO Butiker (Butiksnamn, Adress)
VALUES ('Store 3', 'Street 3, City 3, 34567');

GO

INSERT INTO LagerSaldo (ButikID, ISBN13, Antal)
VALUES
(1, '9781234567890', 10),
(1, '9781234567891', 5),
(1, '9781234567892', 15),
(1, '9781234567893', 7),
(2, '9781234567890', 8),
(2, '9781234567891', 10),
(2, '9781234567892', 6),
(2, '9781234567893', 12),
(3, '9781234567890', 9),
(3, '9781234567891', 4),
(3, '9781234567892', 10),
(3, '9781234567893', 5);

GO

INSERT INTO Kunder (F�rnamn, Efternamn, Email, Adress)
VALUES 
('Anna', 'Svensson', 'anna.svensson@example.com', 'Storgatan 1, Stockholm'),
('Bengt', 'Karlsson', 'bengt.karlsson@example.com', 'Lillgatan 2, G�teborg'),
('Carolina', 'Lind', 'carolina.lind@example.com', 'Mellangatan 3, Malm�'),
('David', 'Eriksson', 'david.eriksson@example.com', 'Storgatan 4, Uppsala'),
('Eva', 'Nilsson', 'eva.nilsson@example.com', 'Lillgatan 5, V�ster�s');

GO

INSERT INTO Ordrar (KundID, ButikID)
VALUES 
(1, 1),
(2, 2),
(3, 1),
(4, 2),
(5, 1);

GO

INSERT INTO OrderItems (OrderID, ISBN13, Antal)
VALUES 
(1, '9781234567890', 1),
(2, '9781234567891', 2),
(3, '9781234567892', 1),
(4, '9781234567893', 2),
(5, '9781234567890', 1);

GO

INSERT INTO F�rlag (Namn, Adress)
VALUES 
('F�rlag1', 'Adress1'),
('F�rlag2', 'Adress2'),
('F�rlag3', 'Adress3'),
('F�rlag4', 'Adress4'),
('F�rlag5', 'Adress5');

GO

--- Update b�cker med f�rlag

UPDATE B�cker SET F�rlagID = 1 WHERE ISBN13 = '9781234567890';
UPDATE B�cker SET F�rlagID = 2 WHERE ISBN13 = '9781234567891';
UPDATE B�cker SET F�rlagID = 3 WHERE ISBN13 = '9781234567892';
UPDATE B�cker SET F�rlagID = 4 WHERE ISBN13 = '9781234567893';

GO
-------- VYER

CREATE VIEW TitlarPerF�rfattare AS
SELECT 
    F.F�rnamn + ' ' + F.Efternamn AS Namn,
    DATEDIFF(YEAR, F.F�delsedatum, GETDATE()) AS �lder,
    COUNT(B.ISBN13) AS Titlar,
    SUM(B.Pris * L.Antal) AS Lagerv�rde
FROM 
    F�rfattare F
    LEFT JOIN B�cker B ON F.ID = B.F�rfattareID
    LEFT JOIN LagerSaldo L ON B.ISBN13 = L.ISBN13
GROUP BY 
    F.F�rnamn, F.Efternamn, F.F�delsedatum;



GO


----------------- STORED PROCEDURE --------------

CREATE PROCEDURE FlyttaBok 
    @FromButikID INT,
    @ToButikID INT,
    @ISBN13 CHAR(13),
    @Antal INT = 1
AS
BEGIN
    BEGIN TRANSACTION

    -- Check if enough books are available in the source store
    IF (SELECT Antal FROM LagerSaldo WHERE ButikID = @FromButikID AND ISBN13 = @ISBN13) < @Antal
    BEGIN
        ROLLBACK TRANSACTION
        RAISERROR ('Not enough books in the source store', 16, 1);
        RETURN
    END

    -- Decrease the amount of books in the source store
    UPDATE LagerSaldo 
    SET Antal = Antal - @Antal 
    WHERE ButikID = @FromButikID AND ISBN13 = @ISBN13

    -- Increase the amount of books in the destination store, or insert a new row if the book is not present yet
    IF EXISTS (SELECT 1 FROM LagerSaldo WHERE ButikID = @ToButikID AND ISBN13 = @ISBN13)
    BEGIN
        UPDATE LagerSaldo 
        SET Antal = Antal + @Antal 
        WHERE ButikID = @ToButikID AND ISBN13 = @ISBN13
    END
    ELSE
    BEGIN
        INSERT INTO LagerSaldo (ButikID, ISBN13, Antal) 
        VALUES (@ToButikID, @ISBN13, @Antal)
    END

    COMMIT TRANSACTION
END


GO

--- Execute stored procedure

EXEC FlyttaBok @FromButikID = 1, @ToButikID = 2, @ISBN13 = '9781234567890', @Antal = 2;

GO

--- Check if it worked

SELECT ButikID, ISBN13, Antal 
FROM LagerSaldo
WHERE ISBN13 = '9781234567890' AND ButikID IN (1, 2);

GO


