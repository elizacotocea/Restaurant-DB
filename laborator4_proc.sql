USE RESTAURANT
GO


INSERT INTO Tables (Name) VALUES ('client'),('waiter'),('drink'), ('drink_category'), ('drink_category_association')
GO

INSERT INTO Views (Name) VALUES ('viewWaiter'), ('viewClientWaiter'), ('viewDrinkCategory')
GO

INSERT INTO Tests (Name) VALUES ('INSERT'), ('DELETE'), ('VIEW')
GO

SELECT * FROm Tables

ALTER PROCEDURE insert_1 @nrRows INT
AS
BEGIN
	DECLARE @i int =1;
	WHILE @i<=@nrRows
	BEGIN
		IF @i%2=0 
			BEGIN
			INSERT INTO waiter(id_waiter,name,sex,age) 
			VALUES (@i,'waiter'+convert (varchar(100),@i),'feminin',21+@i);
			END
		ELSE
			BEGIN
			INSERT INTO waiter(id_waiter,name,sex,age) 
			VALUES(@i,'waiter'+convert (varchar(100),@i),'masculin',21+@i);
			END
		SET @i=@i+1
	END
END


GO

ALTER PROCEDURE delete_1
AS
BEGIN
	DELETE FROM waiter
	
END

GO


alter PROCEDURE insert_2 @nrRows INT
AS
BEGIN
	DECLARE @i int =1;
		WHILE @i<=@nrRows
		BEGIN
		IF @i%2=0 
			BEGIN
			INSERT INTO client(id_client,client_name,sex,id_waiter) VALUES (@i,'client'+convert (varchar(100),@i),'masculin',@i);
			END
		ELSE
			BEGIN
			INSERT INTO client(id_client,client_name,sex,id_waiter) VALUES (@i,'client'+convert (varchar(100),@i),'feminin',@i);
			END
		SET @i = @i + 1
		END
END



GO
ALTER PROCEDURE delete_2
AS
BEGIN
	DELETE FROM client;
END
GO



alter PROCEDURE insert_3 @nrRows INT
AS
BEGIN
	DECLARE @i int =1;
	DECLARE @price float=5;
	WHILE @i<=@nrRows
	BEGIN
		SET @price=@price+2;
		INSERT INTO drink(id_drink,name,price) VALUES (@i,'drink'+convert (varchar(100),@i),@price);
		SET @i = @i + 1
	END
END

ALTER PROCEDURE insert_4 @nrRows INT
AS
BEGIN
	DECLARE @i int =1;
	DECLARE @price float=50;
	WHILE @i<=@nrRows
	BEGIN
		INSERT INTO drink_category(id_drink_category,type) VALUES (@i,'drink_category'+convert (varchar(100),@i));
		SET @i = @i + 1
	END
END

alter PROCEDURE insert_5 @nrRows INT
AS
BEGIN
	DECLARE @i int =1;
	DECLARE @price float=50;
	WHILE @i<=@nrRows
	BEGIN
		INSERT INTO drink_category_association(id_drink, id_drink_category) VALUES (@i,@i);
		SET @i = @i + 1
	END
END

GO
alter PROCEDURE delete_3
AS
BEGIN

	DELETE FROM drink;
	
END

GO
alter PROCEDURE delete_4
AS
BEGIN
	DELETE FROM drink_category ;
	
END

GO
ALTER PROCEDURE delete_5
AS
BEGIN
	DELETE FROM drink_category_association ;
	
END


ALTER PROCEDURE view_1
AS
BEGIN
	SELECT * FROM viewWaiter
END

GO


CREATE PROCEDURE view_2
AS
BEGIN
	SELECT * FROM viewClientWaiter
END
GO



ALTER PROCEDURE view_3
AS
BEGIN
	SELECT * FROM viewDrinkCategory
END

GO


ALTER PROCEDURE executeViews
AS
BEGIN
DECLARE @operation VARCHAR(255), @viewID INT
	while EXISTS (SELECT * FROM TestViews)
		BEGIN
		SET @viewID = (SELECT TOP 1 ViewID FROM TestViews)
		SET @operation = 'view_' + CAST(@viewID AS VARCHAR(255))

		EXECUTE @operation
		DELETE FROM TestViews WHERE ViewID = @viewID
	END
END



GO
CREATE OR ALTER PROCEDURE executeTests @noRows INT
AS
BEGIN
	WHILE EXISTS (SELECT * FROM TestTables)
	BEGIN
		DECLARE @testID INT, @tableID INT, @operation VARCHAR(255)
		SET @testID = (SELECT TOP 1 TestID FROM TestTables)
		if @testID=1
		BEGIN
			SET @tableID = (SELECT TOP 1 TableID FROM TestTables where TestID=@testID ORDER BY Position DESC)
		END
		if @testID=2
		BEGIN
			SET @tableID = (SELECT TOP 1 TableID FROM TestTables where TestID=@testID ORDER BY Position ASC)
		END
		IF @testID = 1
		BEGIN
			SET @operation = 'delete_' + CAST(@tableID AS VARCHAR(255))
			EXECUTE @operation
		END
		ELSE
		BEGIN
			SET @operation = 'insert_' + CAST(@tableID AS VARCHAR(255))
				EXECUTE @operation @noRows
		END
		
		DELETE FROM TestTables WHERE TestID = @testID AND TableID = @tableID
	END
END

GO

GO
CREATE OR ALTER PROCEDURE run_tests (@operation VARCHAR(255), @table INT, @nrRows INT)
AS
BEGIN
	DECLARE @i INT
	SET @i = 1
	IF @operation = 'insert' AND @table=4
	BEGIN
		WHILE @i < 6
		BEGIN
			INSERT INTO TestTables (TestID, TableID, NoOfRows, Position)
				VALUES (1, @i, @nrRows, @i)
			INSERT INTO TestTables(
			TestID, TableID, NoOfRows, Position)
				VALUES (2, @i, @nrRows, @i)
			SET @i = @i + 1
		END
		EXECUTE executeTests @nrRows
	END

	else IF @operation='insert' AND @table<4
	BEGIN
		IF @table=1
		BEGIN
			INSERT INTO TestTables (TestID, TableID, NoOfRows, Position) VALUES (1, @table, @nrRows, 1)
			INSERT INTO TestTables (TestID, TableID, NoOfRows, Position) VALUES (1, @table+1, @nrRows, 2)
			INSERT INTO TestTables(TestID, TableID, NoOfRows, Position) VALUES (2, @table, @nrRows, 1)
		END
		ELSE IF @table=2
		BEGIN
			INSERT INTO TestTables (TestID, TableID, NoOfRows, Position) VALUES (1, @table-1, @nrRows, 1)
			INSERT INTO TestTables (TestID, TableID, NoOfRows, Position) VALUES (1, @table, @nrRows, 2)
			INSERT INTO TestTables(TestID, TableID, NoOfRows, Position) VALUES (2, @table-1, @nrRows, 1)
			INSERT INTO TestTables(TestID, TableID, NoOfRows, Position) VALUES (2, @table, @nrRows, 2)
		END
		ELSE IF @table=3
		BEGIN
			INSERT INTO TestTables (TestID, TableID, NoOfRows, Position) VALUES (1, @table, @nrRows, 3)
			INSERT INTO TestTables (TestID, TableID, NoOfRows, Position) VALUES (1, @table+1, @nrRows, 4)
			INSERT INTO TestTables (TestID, TableID, NoOfRows, Position) VALUES (1, @table+2, @nrRows, 5)
			INSERT INTO TestTables(TestID, TableID, NoOfRows, Position) VALUES (2, @table, @nrRows, 3)
			INSERT INTO TestTables(TestID, TableID, NoOfRows, Position) VALUES (2, @table+1, @nrRows, 4)
			INSERT INTO TestTables(TestID, TableID, NoOfRows, Position) VALUES (2, @table+2, @nrRows, 5)
		END
		EXECUTE executeTests @nrRows
	END

	DECLARE @j INT
	SET @j=1;
	IF @operation = 'view' AND @table<4
	BEGIN
		INSERT INTO TestViews (TestID, ViewID) VALUES (@j, @table)
		EXECUTE executeViews
	END
	IF @operation = 'view' AND @table=4
	BEGIN
		WHILE @j <4
		BEGIN
		INSERT INTO TestViews (TestID, ViewID) VALUES (@j, @j)
		SET @j = @j + 1
		END
		EXECUTE executeViews
	END
END
GO


CREATE OR ALTER PROCEDURE runProcedures @operation VARCHAR(255), @table INT, @nrRows INT
AS
BEGIN
	DECLARE @timestamp1 DATETIME
	DECLARE @timestamp2 DATETIME
	DECLARE @timestamp3 DATETIME
	DECLARE @testRunID VARCHAR(30)
	DECLARE @description VARCHAR(255)

	SET @description = @operation + CAST(@table AS VARCHAR(255))+ '_'+CAST(@nrRows AS VARCHAR(255))
	
	INSERT INTO TestRuns (Description, StartAt, EndAt)
		VALUES (@description, GETDATE(), GETDATE())

	SET @testRunID = (SELECT MAX(TestRunID) FROM TestRuns)
	SET @timestamp1 = GETDATE()
	IF @operation != 'view'
	BEGIN
		EXECUTE run_tests @operation, @table, @nrRows
	END
	
	SET @timestamp2 = GETDATE()
		EXECUTE run_tests 'view', @table, @nrRows
	SET @timestamp3 = GETDATE()

	INSERT INTO TestRunTables (TestRunID, TableID, StartAt, EndAt)
		VALUES (@testRunID, @table, @timestamp1, @timestamp2)
	INSERT INTO TestRunViews (TestRunID, ViewID, StartAt, EndAt)
		VALUES (@testRunID, @table, @timestamp2, @timestamp3)

	UPDATE TestRuns
	SET StartAt = @timestamp1, EndAt = @timestamp3
	WHERE TestRunID = @testRunID

	PRINT DATEDIFF(second, @timestamp1, @timestamp3)
END

SET NOCOUNT ON
GO
EXEC runProcedures 'insert',3, 1000

SELECT * FROM Tables
SELECT * from waiter;
SELECT * from TestViews;

sELECT * FROM TestRuns
DELETE FROM client;

DELETE FROM drink_category
DELETE FROM TestTables
DELETE FROM drink_category_association