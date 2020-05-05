SELECT * FROM waiter
GO
ALTER FUNCTION existaWaiter (@ID int)
RETURNS INT AS
BEGIN
	DECLARE @ok INT;
	SET @ok=0;
	DECLARE @gasit int;
	SELECT @gasit=id_waiter From waiter where id_waiter=@ID;
	if @gasit = @ID
		SET @ok=1
	RETURN @ok
END
GO
CREATE FUNCTION validareVarsta(@Varsta INT)
RETURNS INT AS
BEGIN
	DECLARE @ok INT;
	SET @ok=1;
	if @Varsta < 18
		BEGIN
			SET @ok=0
		END
	RETURN @ok
END


GO
ALTER PROCEDURE insertInWaiter @ID int, @Name varchar(20), @sex varchar(20), @age int
AS
BEGIN
	DECLARE @exista INT;
	DECLARE @valid INT
	SET @exista = dbo.existaWaiter(@ID);
	SET @valid = dbo.validareVarsta(@age)
	if @valid = 1
	BEGIN
	if @exista = 0
		INSERT INTO waiter (id_waiter,name,sex,age)
			VALUES(@ID, @Name, @sex,@age)
	else PRINT ('Exista deja in baza de date!');
	END
	else PRINT ('Nu se accepta minori!');
END

GO
ALTER PROCEDURE deleteFromWaiter @ID int
AS
BEGIN
	DECLARE @exista INT;
	SET @exista = dbo.existaWaiter(@ID);
	if @exista = 1
		BEGIN
			DELETE from Client where @ID = id_waiter;
			DELETE from Waiter where @ID = id_waiter;
		END
	else PRINT ('Nu exista!');
END


GO
ALTER PROCEDURE updateWaiter  @ID int, @Name varchar(20), @sex varchar(20), @age int
AS
BEGIN
	DECLARE @exista INT;
	DECLARE @valid INT;
	SET @exista = dbo.existaWaiter(@ID)
	SET @valid=dbo.validareVarsta(@age)
	if @valid = 1
	BEGIN
	if @exista = 1
		UPDATE waiter SET id_waiter=@ID, name=@Name, age=@age, sex=@sex
			where id_waiter=@ID
	else PRINT ('Nu exista!');
	END
	else PRINT ('Nu se accepta minori!')
END
	
GO
CREATE PROCEDURE findAll
AS
BEGIN
	select * from waiter
END
	
	
exec insertInWaiter @ID=1022,@Name='Dorel',@sex='masculin',@age=20
exec deleteFromWaiter @ID=1022;
exec updateWaiter @ID=1022,@Name='Dorel',@sex='masculin',@age=19
exec findAll
