use Bookstore;



-- Users
 
-- Creare utilizator cu permisiuni de citire (SELECT)
CREATE LOGIN utilizator_read WITH PASSWORD = 'parola_read';
	USE Bookstore;
	CREATE USER utilizator_read FOR LOGIN utilizator_read;
	GRANT SELECT ON SCHEMA::dbo TO utilizator_read;

-- Creare utilizator cu permisiuni de citire și scriere (SELECT, INSERT, UPDATE, DELETE)
CREATE LOGIN utilizator_read_write WITH PASSWORD = 'parola_read_write';
	USE Bookstore;
	CREATE USER utilizator_read_write FOR LOGIN utilizator_read_write;
	GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO utilizator_read_write;

EXECUTE AS USER = 'utilizator_read';
	USE Bookstore;
	SELECT * FROM CARTE; 
	INSERT INTO CARTE (TITLU, AUTOR) VALUES ('Exemplu', 'Autor'); -- Această comandă genereaza o eroare
REVERT;




-- Views

-- View 1 - Vedere pentru persoane cu vârsta sub 18 ani
CREATE VIEW View_PersoaneMinore AS
	SELECT NUME, VARSTA
	FROM PERSOANA
	WHERE VARSTA < 18;

SELECT * FROM View_PersoaneMinore;


-- View 2 - Vedere pentru detalii complete despre închirieri (incluzând informații despre persoane, cărți și filme)
CREATE VIEW View_DetaliiInchirieri AS
	SELECT I.ID_INCHIRIERE, I.DATA_INCHIRIERE, P.NUME AS NUME_PERSOANA, C.TITLU AS TITLU_CARTE, F.TITLU AS TITLU_FILM
	FROM INCHIRIERE I
	JOIN PERSOANA P ON I.ID_PERSOANA = P.ID_PERSOANA
	LEFT JOIN CARTE C ON I.ID_CARTE = C.ID_CARTE
	LEFT JOIN FILM F ON I.ID_FILM = F.ID_FILM;

SELECT * FROM View_DetaliiInchirieri;


-- View 3 - Vedere pentru detalii complete despre achizițiile recente, inclusiv produse și cumpărători
CREATE VIEW View_DetaliiAchizitiiRecente AS
	SELECT CUM.ID_CUMPARARE, P.NUME AS NUME_PERSOANA, R.NUME AS NUME_RECHIZITA, J.NUME AS NUME_JOC, F.ID_FACTURA
	FROM CUMPARARE CUM
	JOIN PERSOANA P ON CUM.ID_PERSOANA = P.ID_PERSOANA
	LEFT JOIN RECHIZITE R ON CUM.ID_PRODUS = R.ID_PRODUS
	LEFT JOIN JOCURI J ON CUM.ID_JOC = J.ID_JOC
	LEFT JOIN FACTURA F ON CUM.ID_FACTURA = F.ID_FACTURA
	WHERE F.DATA_FACTURARE >= DATEADD(day, -30, GETDATE());

SELECT * FROM View_DetaliiAchizitiiRecente;


-- View 4 - Vedere pentru informații complete despre cărți și filme împreună cu detalii despre închirieri
CREATE VIEW View_DetaliiCartiFilmeInchiriate AS
	SELECT I.ID_INCHIRIERE, I.DATA_INCHIRIERE, C.TITLU AS TITLU_CARTE, F.TITLU AS TITLU_FILM, P.NUME AS NUME_PERSOANA
	FROM INCHIRIERE I
	JOIN PERSOANA P ON I.ID_PERSOANA = P.ID_PERSOANA
	LEFT JOIN CARTE C ON I.ID_CARTE = C.ID_CARTE
	LEFT JOIN FILM F ON I.ID_FILM = F.ID_FILM;

SELECT * FROM View_DetaliiCartiFilmeInchiriate;




		-- Procedures

-- Procedure 1 - Procedura pentru Inserare în Tabela 'INCHIRIERE'
CREATE PROCEDURE InserareInchiriere
    @DataInchiriere DATE,
    @IdPersoana INT,
    @IdCarte INT,
    @IdFilm INT
AS
BEGIN
    INSERT INTO INCHIRIERE (DATA_INCHIRIERE, ID_PERSOANA, ID_CARTE, ID_FILM)
    VALUES (@DataInchiriere, @IdPersoana, @IdCarte, @IdFilm);
END;

DECLARE @DataInchiriere DATE = '2024-01-03';
DECLARE @IdPersoana INT = 4;  -- Replace with the actual ID of the person
DECLARE @IdCarte INT = 1;	  -- Replace with the actual ID of the book
DECLARE @IdFilm INT = null;   -- Replace with the actual ID of the movie


EXEC InserareInchiriere 
    @DataInchiriere = @DataInchiriere,
    @IdPersoana = @IdPersoana,
    @IdCarte = @IdCarte,
    @IdFilm = @IdFilm;


-- Procedure 2 - Procedura pentru Inserare în Tabela FACTURA
CREATE PROCEDURE InserareFactura
    @DataFacturare DATE,
    @OraFacturare TIME,
    @ReducereAcordata DECIMAL(6,2),
    @Total DECIMAL(6,2)
AS
BEGIN
    INSERT INTO FACTURA (DATA_FACTURARE, ORA_FACTURARE, REDUCERE_ACORDATA, TOTAL)
    VALUES (@DataFacturare, @OraFacturare, @ReducereAcordata, @Total);
END;

DECLARE @DataFacturare DATE = '2023-12-08';
DECLARE @OraFacturare TIME = '12:30:00';
DECLARE @ReducereAcordata DECIMAL(6,2) = 10.50;
DECLARE @Total DECIMAL(6,2) = 150.00;

EXEC InserareFactura 
    @DataFacturare = @DataFacturare,
    @OraFacturare = @OraFacturare,
    @ReducereAcordata = @ReducereAcordata,
    @Total = @Total;


-- Procedure 3 - Procedura pentru Inserare în Tabela CUMPARARE
CREATE PROCEDURE InserareCumparare
    @IdPersoana INT,
    @IdZiar INT,
    @IdProdus INT,
    @IdJoc INT,
    @IdFactura INT
AS
BEGIN
    INSERT INTO CUMPARARE (ID_PERSOANA, ID_ZIAR, ID_PRODUS, ID_JOC, ID_FACTURA)
    VALUES (@IdPersoana, @IdZiar, @IdProdus, @IdJoc, @IdFactura);
END;

EXEC InserareCumparare 
    @IdPersoana = 1,
    @IdZiar = null,
    @IdProdus = 3,
    @IdJoc = 4,
    @IdFactura = 1;



-- Procedure 4 - Procedura pentru actualizarea datelor în Tabela PERSOANA
CREATE PROCEDURE ActualizarePersoana
    @IdPersoana INT,
    @Nume VARCHAR(20),
    @UserName VARCHAR(30),
    @Parola VARCHAR(30),
    @Rol VARCHAR(10),
    @Adresa VARCHAR(20),
    @DataNastere DATE,
    @Varsta INTEGER,
    @Buget INTEGER,
    @Email VARCHAR(30),
    @CardFidelitate INTEGER
AS
BEGIN
    UPDATE PERSOANA
    SET
        NUME = @Nume,
        USERNAME = @UserName,
        PAROLA = @Parola,
        ROL = @Rol,
        ADRESA = @Adresa,
        DATA_NASTERE = @DataNastere,
        VARSTA = @Varsta,
        BUGET = @Buget,
        EMAIL = @Email,
        CARD_FIDELITATE = @CardFidelitate
    WHERE ID_PERSOANA = @IdPersoana;
END;


-- Procedure 5 - Procedura pentru Obținerea Informațiilor despre Închirieri pentru o Persoană Specifică
CREATE PROCEDURE InfoInchirieriPersoana
    @IdPersoana INT
AS
BEGIN
    SELECT I.*, C.TITLU AS TITLU_CARTE, F.TITLU AS TITLU_FILM
    FROM INCHIRIERE I
    LEFT JOIN CARTE C ON I.ID_CARTE = C.ID_CARTE
    LEFT JOIN FILM F ON I.ID_FILM = F.ID_FILM
    WHERE I.ID_PERSOANA = @IdPersoana;
END;

DECLARE @IdPersoana2 INT = 1;
EXEC InfoInchirieriPersoana @IdPersoana2;



-- Procedure 6 - Procedura pentru stergerea unei carti
CREATE PROCEDURE StergeCarte
    @IdCarte INT
AS
BEGIN
    -- Verifică dacă cartea este închiriată înainte de a o șterge
    IF NOT EXISTS (SELECT 1 FROM INCHIRIERE WHERE ID_CARTE = @IdCarte)
    BEGIN
        DELETE FROM CARTE WHERE ID_CARTE = @IdCarte;
        PRINT 'Cartea a fost ștearsă cu succes.';
    END
    ELSE
    BEGIN
        PRINT 'Cartea nu poate fi ștearsă deoarece este încă închiriată.';
    END
END;

DECLARE @IdCarteToDelete INT = 12; -- Înlocuiește 1 cu ID-ul cărții pe care dorești să o ștergi

EXEC StergeCarte @IdCarteToDelete;




		-- Triggers DML

GO
-- Trigger 1 - Trigger pentru inserare în tabela INCHIRIERE
ALTER TRIGGER trg_InsertInchiriere3
ON INCHIRIERE
AFTER INSERT
AS
BEGIN
   DECLARE @IdPersoana INT, @IdCarte INT, @IdFilm INT, @Test INT = 23;
    -- Obține valorile inserate
    SELECT @IdPersoana = ID_PERSOANA, @IdCarte = ID_CARTE, @IdFilm = ID_FILM
    FROM INSERTED;
	PRINT 'O noua inchiriere a fost adaugata. Persoana cu ID: ' + CONCAT(@IdPersoana,
                                  ', ID_CARTE: ', @IdCarte,
                                  ', ID_FILM: ', @IdFilm);
END;

INSERT INTO INCHIRIERE(DATA_INCHIRIERE, ID_PERSOANA, ID_CARTE, ID_FILM) VALUES ('2021-01-15', 1, 5, NULL);

-- trigger 2 - Pentru stergerea unei carti
ALTER TRIGGER trg_DeleteCarte
ON CARTE
AFTER DELETE
AS
BEGIN
    -- Verifică dacă s-a șters cel puțin un rând
    IF @@ROWCOUNT > 0 --  Această variabilă de sistem indică numărul de rânduri afectate de ultima instrucțiune DELETE. Verificăm dacă s-au șters cel puțin un rând pentru a continua cu logica trigger-ului.
    BEGIN
        PRINT 'Trigger pentru stergere carte activat.';

        -- Declara variabilele necesare
        DECLARE @DeletedCarteID INT;

        -- Obține ID-ul cărții șterse
        SELECT @DeletedCarteID = ID_CARTE
        FROM DELETED;
		
		PRINT 'A fost stearsa cartea cu ID: ' ;
		PRINT @DeletedCarteID;

    END
END;
select * from carte;
DELETE FROM CARTE WHERE ID_CARTE = 9;



		-- Triggere DDL

-- Trigger 1 - Trigger pentru CREATE Tabel
ALTER TRIGGER trg_CreateTable2
ON DATABASE
AFTER CREATE_TABLE
AS
BEGIN
    DECLARE @EventData XML = EVENTDATA();
    DECLARE @ObjectName NVARCHAR(255) = @EventData.value('(/EVENT_INSTANCE/ObjectName)[1]', 'NVARCHAR(255)');

    PRINT 'A fost adaugata o tabela cu numele '
    PRINT @ObjectName;
END;


-- Trigger 2 - Trigger pentru DROP Tabel
ALTER TRIGGER trg_DropTable1
ON DATABASE
AFTER DROP_TABLE
AS
BEGIN
    DECLARE @EventData XML = EVENTDATA();
    DECLARE @ObjectName NVARCHAR(255) = @EventData.value('(/EVENT_INSTANCE/ObjectName)[1]', 'NVARCHAR(255)');

    PRINT 'A fost stearsa tabela cu numele: ';
	PRINT @ObjectName;
END;

create table newTable(id INT IDENTITY(1,1) PRIMARY KEY);
drop table newTable;
	



	-- Cursoare


-- Cursor 1. Procedura pentru a itera prin închirieri folosind un cursor
GO
ALTER PROCEDURE InfoInchirieri
AS
	BEGIN
		-- Declara cursorul
		DECLARE InfoCursor CURSOR FOR
		SELECT ID_INCHIRIERE, DATA_INCHIRIERE, ID_PERSOANA, ID_CARTE, ID_FILM
		FROM INCHIRIERE;

		-- Variabile pentru valorile din cursor
		DECLARE @IdInchiriere INT, @DataInchiriere DATE, @IdPersoana INT, @IdCarte INT, @IdFilm INT;

	   -- Deschide cursorul
	OPEN InfoCursor;

	-- Iterează prin înregistrări
	FETCH NEXT FROM InfoCursor INTO @IdInchiriere, @DataInchiriere, @IdPersoana, @IdCarte, @IdFilm;

	IF @@FETCH_STATUS = -1
		BEGIN
			-- Nu există înregistrări, afișează un mesaj
			PRINT 'Nu există înregistrări în tabelul INCHIRIERE.';
		END
		ELSE
		BEGIN
			-- Există înregistrări, iterează prin cursor
			WHILE @@FETCH_STATUS = 0
			BEGIN
			
			PRINT 'ID_INCHIRIERE: ' + CONCAT(@IdInchiriere,
									  ', DATA_INCHIRIERE: ', @DataInchiriere,
									  ', ID_PERSOANA: ', @IdPersoana,
									  ', ID_CARTE: ', @IdCarte,
									  ', ID_FILM: ', @IdFilm);

				FETCH NEXT FROM InfoCursor INTO @IdInchiriere, @DataInchiriere, @IdPersoana, @IdCarte, @IdFilm;
			END
		END

	-- Închide cursorul
	CLOSE InfoCursor;
	DEALLOCATE InfoCursor;
END;

-- Execută procedura pentru a vedea informațiile despre închirieri
EXEC InfoInchirieri;


-- Cursor 2
-- Procedura pentru a itera prin înregistrările din tabela ZIAR folosind un cursor
GO
CREATE PROCEDURE InfoZiare
AS
BEGIN
    -- Declara cursorul pentru tabela ZIAR
    DECLARE ZiareCursor CURSOR FOR
    SELECT ID_ZIAR, TITLU, JOCURI, TIP, PRET, CATEGORIE_VARSTA, GEN, NUMAR_PAGINI, DIMENSIUNE, STOC, CADOU, EDITIE
    FROM ZIAR;

    -- Variabile pentru valorile din cursor
    DECLARE @IdZiar INT, @Titlu VARCHAR(30), @Jocuri BIT, @Tip VARCHAR(10), @Pret DECIMAL(6,2),
            @CategorieVarsta VARCHAR(20), @Gen VARCHAR(15), @NumarPagini INT, @Dimensiune VARCHAR(10),
            @Stoc INT, @Cadou VARCHAR(10), @Editie INT;

    -- Deschide cursorul pentru tabela ZIAR
    OPEN ZiareCursor;

    -- Iterează prin înregistrări
    FETCH NEXT FROM ZiareCursor INTO @IdZiar, @Titlu, @Jocuri, @Tip, @Pret, @CategorieVarsta, @Gen, @NumarPagini,
                                       @Dimensiune, @Stoc, @Cadou, @Editie;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Afișează informații despre ziar într-un format similar cu cel al exemplului dat
        PRINT 'Ziar - ID: ' + CAST(@IdZiar AS VARCHAR(10)) +
              ', Titlu: ' + @Titlu +
              ', Jocuri: ' + CASE WHEN @Jocuri = 1 THEN 'Da' ELSE 'Nu' END +
              ', Tip: ' + @Tip +
              ', Pret: ' + CAST(@Pret AS VARCHAR(10)) +
              ', Categorie Varsta: ' + @CategorieVarsta +
              ', Gen: ' + @Gen +
              ', Numar Pagini: ' + CAST(@NumarPagini AS VARCHAR(10)) +
              ', Dimensiune: ' + @Dimensiune +
              ', Stoc: ' + CAST(@Stoc AS VARCHAR(10)) +
              ', Cadou: ' + @Cadou +
              ', Editie: ' + CAST(@Editie AS VARCHAR(10));

        -- Fetch următoarea înregistrare
        FETCH NEXT FROM ZiareCursor INTO @IdZiar, @Titlu, @Jocuri, @Tip, @Pret, @CategorieVarsta, @Gen, @NumarPagini,
                                       @Dimensiune, @Stoc, @Cadou, @Editie;
    END

    -- Închide cursorul pentru tabela ZIAR
    CLOSE ZiareCursor;
    DEALLOCATE ZiareCursor;
END;

exec InfoZiare;

-- Cursor 3
-- Procedura pentru a itera prin înregistrările din tabela FACTURA folosind un cursor
GO
CREATE PROCEDURE InfoFacturi
AS
BEGIN
    -- Declara cursorul pentru tabela FACTURA
    DECLARE FacturiCursor CURSOR FOR
    SELECT ID_FACTURA, DATA_FACTURARE, ORA_FACTURARE, REDUCERE_ACORDATA, TOTAL
    FROM FACTURA;

    -- Variabile pentru valorile din cursor
    DECLARE @IdFactura INT, @DataFacturare DATE, @OraFacturare TIME,
            @ReducereAcordata DECIMAL(6,2), @Total DECIMAL(6,2);

    -- Deschide cursorul pentru tabela FACTURA
    OPEN FacturiCursor;

    -- Iterează prin înregistrări
    FETCH NEXT FROM FacturiCursor INTO @IdFactura, @DataFacturare, @OraFacturare, @ReducereAcordata, @Total;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Afișează informații detaliate despre factură
        PRINT 'Factura - ID: ' + CAST(@IdFactura AS VARCHAR(10)) +
              ', Data: ' + CAST(@DataFacturare AS VARCHAR(10)) +
              ', Ora: ' + CAST(@OraFacturare AS VARCHAR(10)) +
              ', Reducere Acordata: ' + CAST(@ReducereAcordata AS VARCHAR(10)) +
              ', Total: ' + CAST(@Total AS VARCHAR(10));

        -- Fetch următoarea înregistrare
        FETCH NEXT FROM FacturiCursor INTO @IdFactura, @DataFacturare, @OraFacturare, @ReducereAcordata, @Total;
    END

    -- Închide cursorul pentru tabela FACTURA
    CLOSE FacturiCursor;
    DEALLOCATE FacturiCursor;
END;
EXEC InfoFacturi


-- Cursor 4
-- Procedura pentru a itera prin comenzile unei persoane folosind un cursor
GO
CREATE PROCEDURE InfoComenziPersoana
    @IdPersoana INT
AS
BEGIN
    -- Declara cursorul pentru tabela CUMPARARE
    DECLARE ComenziCursor CURSOR FOR
    SELECT C.ID_CUMPARARE, C.ID_PERSOANA, C.ID_ZIAR, C.ID_PRODUS, C.ID_JOC, C.ID_FACTURA,
           F.DATA_FACTURARE, F.ORA_FACTURARE, F.REDUCERE_ACORDATA, F.TOTAL
    FROM CUMPARARE C
    LEFT JOIN FACTURA F ON C.ID_FACTURA = F.ID_FACTURA
    WHERE C.ID_PERSOANA = @IdPersoana;

    -- Variabile pentru valorile din cursor
    DECLARE @IdComanda INT, @IdZiar INT, @IdProdus INT, @IdJoc INT, @IdFactura INT,
            @DataFacturare DATE, @OraFacturare TIME, @ReducereAcordata DECIMAL(6,2), @Total DECIMAL(6,2);

    -- Deschide cursorul pentru tabela CUMPARARE
    OPEN ComenziCursor;

    -- Iterează prin înregistrări
    FETCH NEXT FROM ComenziCursor INTO @IdComanda, @IdPersoana, @IdZiar, @IdProdus, @IdJoc, @IdFactura,
                                        @DataFacturare, @OraFacturare, @ReducereAcordata, @Total;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Afișează informații detaliate despre comandă
        PRINT 'Comanda - ID: ' + CAST(@IdComanda AS VARCHAR(10)) +
              ', Persoana: ' + CAST(@IdPersoana AS VARCHAR(10)) +
              ', Ziar: ' + ISNULL(CAST(@IdZiar AS VARCHAR(10)), 'NULL') +
              ', Produs: ' + ISNULL(CAST(@IdProdus AS VARCHAR(10)), 'NULL') +
              ', Joc: ' + ISNULL(CAST(@IdJoc AS VARCHAR(10)), 'NULL') +
              ', Factura - Data: ' + ISNULL(CAST(@DataFacturare AS VARCHAR(10)), 'NULL') +
              ', Ora: ' + ISNULL(CAST(@OraFacturare AS VARCHAR(10)), 'NULL') +
              ', Reducere Acordata: ' + ISNULL(CAST(@ReducereAcordata AS VARCHAR(10)), 'NULL') +
              ', Total: ' + ISNULL(CAST(@Total AS VARCHAR(10)), 'NULL');

        -- Fetch următoarea înregistrare
        FETCH NEXT FROM ComenziCursor INTO @IdComanda, @IdPersoana, @IdZiar, @IdProdus, @IdJoc, @IdFactura,
                                            @DataFacturare, @OraFacturare, @ReducereAcordata, @Total;
    END

    -- Închide cursorul pentru tabela CUMPARARE
    CLOSE ComenziCursor;
    DEALLOCATE ComenziCursor;
END;

DECLARE @IdPersoana2 INT = 1;
EXEC InfoComenziPersoana @IdPersoana2;


		
		-- Indecsi

-- Exemplu pentru o tabelă CARTE și un index pe coloana TITLU
CREATE INDEX IX_CARTE_TITLU ON CARTE (TITLU);

-- Exemplu pentru o tabelă CARTE și un index compus pe coloanele AUTOR și AN_APARITIE
CREATE INDEX IX_CARTE_AUTOR_AN ON CARTE (AUTOR, AN_APARITIE);

-- Indice pe coloana DATA_INCHIRIERE, deoarece căutările sau filtrările după data de închiriere pot fi frecvente.
CREATE INDEX IX_INCHIRIERE_DATA ON INCHIRIERE(DATA_INCHIRIERE);

-- Indice pe coloana ID_PERSOANA, deoarece căutările după persoanele care au cumpărat pot fi frecvente.
-- Indice pe coloana ID_FACTURA, deoarece căutările după factură pot fi frecvente.
CREATE INDEX IX_CUMPARARE_PERSOANA ON CUMPARARE(ID_PERSOANA);
CREATE INDEX IX_CUMPARARE_FACTURA ON CUMPARARE(ID_FACTURA);

-- Index clusterizat pentru coloana ID_PERSOANA în tabela PERSOANA:
CREATE CLUSTERED INDEX IX_PERSOANA_ID_CLUSTERED ON PERSOANA(ID_PERSOANA);

-- Index clusterizat pentru coloana ID_FILM în tabela FILM:
CREATE CLUSTERED INDEX IX_FILM_ID_CLUSTERED ON FILM(ID_FILM);

ALTER TABLE PERSOANA
ADD CONSTRAINT UQ_PERSOANA_USERNAME UNIQUE (USERNAME);




		-- Jobs

-- Job 1
-- Procedura stocată pentru verificarea stocului ziarelor:
GO
CREATE PROCEDURE CheckNewspaperStock
    @ZiarID INT
AS
BEGIN
    DECLARE @StockCount INT;

    -- Verifică stocul pentru ziarul specific
    SELECT @StockCount = COUNT(*)
    FROM ZIAR
    WHERE ID_ZIAR = @ZiarID AND STOC > 0;

    -- Dacă stocul este diferit de zero, executați acțiunile necesare
    IF @StockCount > 0
    BEGIN
        -- Adăugați acțiunile dvs. aici, de exemplu, puteți trimite o notificare sau să faceți altceva
        PRINT 'Stocul pentru Ziarul cu ID ' + CAST(@ZiarID AS VARCHAR(10)) + ' este diferit de zero!';
    END
END;

GO
USE msdb;
GO
-- Verificați dacă job-ul există deja
IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = 'CheckNewspaperStockJob')
BEGIN
    -- Adăugați un job nou
    EXEC msdb.dbo.sp_add_job
        @job_name = 'CheckNewspaperStockJob',
        @enabled = 1;

    -- Adăugați un plan de întreținere pentru a rula zilnic
    EXEC msdb.dbo.sp_add_schedule
        @schedule_name = 'DailySchedule',
        @freq_type = 4,  -- Frecvență zilnică
        @freq_interval_type = 1;  -- Interval de 1 zi

    -- Asociați planul de întreținere cu job-ul
    EXEC msdb.dbo.sp_attach_schedule
        @job_name = 'CheckNewspaperStockJob',
        @schedule_name = 'DailySchedule';

    -- Adăugați un pas pentru a executa procedura stocată
    EXEC msdb.dbo.sp_add_jobstep
        @job_name = 'CheckNewspaperStockJob',
        @step_name = 'RunCheckNewspaperStock',
        @subsystem = 'TSQL',
        @command = 'EXEC dbo.CheckNewspaperStock';
END
ELSE
BEGIN
    PRINT 'Job-ul CheckNewspaperStockJob există deja.';
END


-- Job 2
-- Creați o procedură stocată care verifică numărul de facturi adăugate în ultimele 24 de ore:
GO
CREATE PROCEDURE dbo.CheckNewInvoices
AS
BEGIN
    DECLARE @NewInvoiceCount INT;

    -- Verifică numărul de facturi adăugate în ultimele 24 de ore
    SELECT @NewInvoiceCount = COUNT(*)
    FROM FACTURA
    WHERE DATA_FACTURARE >= DATEADD(DAY, -1, GETDATE());

    -- Afișează rezultatul sau puteți adăuga alte acțiuni aici
    PRINT 'Numărul de facturi noi adăugate în ultimele 24 de ore: ' + CAST(@NewInvoiceCount AS NVARCHAR(10));
END;

GO
USE msdb;
GO

-- Adăugați un job nou
EXEC msdb.dbo.sp_add_job
    @job_name = 'CheckNewInvoicesJob',
    @enabled = 1;

-- Adăugați un plan de întreținere pentru a rula zilnic
EXEC msdb.dbo.sp_add_jobschedule
    @job_name = 'CheckNewInvoicesJob',
    @name = 'DailySchedule_CheckNewInvoices',
    @freq_type = 4,  -- Frecvență zilnică
    @freq_interval = 1;  -- Interval de 1 zi

-- Adăugați un pas pentru a executa procedura stocată
EXEC msdb.dbo.sp_add_jobstep
    @job_name = 'CheckNewInvoicesJob',
    @step_name = 'RunCheckNewInvoices',
    @subsystem = 'TSQL',
    @command = 'EXEC dbo.CheckNewInvoices';



	-- Backup

USE Bookstore; -- Schimbă la baza de date "Bookstore"

-- Crează un backup complet al bazei de date
BACKUP DATABASE Bookstore
TO DISK = 'D:\OneDrive - Technical University of Cluj-Napoca\Desktop\utcn\anul 4\Sem 1 --- nu muta ASO\ABD - Administrarea Bazelor de Date\Proiect_ABD_TeocanPatricia_30641_Bookstore\backup_bd_bookstore_Teocan_Patricia_data.bak'
WITH FORMAT, NAME = 'Backup_bd_bookstore_Teocan_Patricia';

-- Încheie utilizarea bazei de date curente
USE master;


	
	-- Restore
USE master; -- Schimbă la baza de date master

-- Restaurează baza de date "Bookstore" din backup
RESTORE DATABASE Bookstore
FROM DISK = 'D:\OneDrive - Technical University of Cluj-Napoca\Desktop\utcn\anul 4\Sem 1 --- nu muta ASO\ABD - Administrarea Bazelor de Date\backup_bd_bookstore_Teocan_Patricia_data.bak'
WITH REPLACE, RECOVERY;

-- Încheie utilizarea bazei de date curente
USE master;
