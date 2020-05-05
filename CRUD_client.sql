SELECT * FROM client
GO
CREATE FUNCTION existaClient (@ID int)
RETURNS INT AS
BEGIN
	DECLARE @ok INT;
	SET @ok=0;
	DECLARE @gasit int;
	SELECT @gasit=id_client From client where id_client=@ID;
	if @gasit = @ID
		SET @ok=1
	RETURN @ok
END

GO
ALTER FUNCTION validareSex(@sex varchar(20))
RETURNS INT AS
BEGIN
	DECLARE @ok INT;
	SET @ok=1;
	if @sex!='feminin' AND @sex!='masculin'
		BEGIN
			SET @ok=0
		END
	RETURN @ok
END


GO
ALTER PROCEDURE insertInClient @ID int, @Name varchar(20), @sex varchar(20), @id_waiter int
AS
BEGIN
	DECLARE @exista INT;
	DECLARE @valid INT
	DECLARE @exista_waiter INT;
	SET @exista_waiter=dbo.existaWaiter(@id_waiter)
	SET @exista = dbo.existaClient(@ID);
	SET @valid = dbo.validareSex(@sex)
	if @valid = 1
	BEGIN
	if @exista = 0
		if @exista_waiter=1
		INSERT INTO client (id_client,client_name,sex,id_waiter)
			VALUES(@ID, @Name, @sex,@id_waiter)
		else PRINT ('Ospatarul cu acest ID nu exista!')
	else PRINT ('Exista deja in baza de date!');
	END
	else PRINT ('Trebuie introdus un sex corect (FEMININ SAU MASCULIN)!');
END

GO
CREATE PROCEDURE deleteFromClient @ID int
AS
BEGIN
	DECLARE @exista INT;
	SET @exista = dbo.existaClient(@ID);
	if @exista = 1
		BEGIN
			DELETE from Client where @ID = id_client;
		END
	else PRINT ('Nu exista!');
END


GO
ALTER PROCEDURE updateClient  @ID int, @Name varchar(20), @sex varchar(20), @id_waiter int
AS
BEGIN
	DECLARE @exista INT;
	DECLARE @valid INT;
	DECLARE @exista_waiter INT;
	SET @exista_waiter=dbo.existaWaiter(@id_waiter)
	SET @exista = dbo.existaClient(@ID)
	SET @valid=dbo.validareSex(@sex)
	if @valid = 1
	BEGIN
	if @exista = 1
		if @exista_waiter=1
		UPDATE client SET id_client=@ID, client_name=@Name, sex=@sex, id_waiter=@id_waiter
			where id_client=@ID
		else PRINT ('Nu exista ospatarul cu ID-ul dat!');
	else PRINT ('Nu exista!');
	END
	else PRINT ('Trebuie introdus un sex corect (FEMININ SAU MASCULIN)!')
END
	
GO
CREATE PROCEDURE findAllClients
AS
BEGIN
	select * from client
END
	
	
exec insertInClient @ID=1032,@Name='Ana',@sex='feminin',@id_waiter=14
exec deleteFromClient @ID=1022;
exec updateClient @ID=1032,@Name='Anamaria',@sex='feminin',@id_waiter=1
exec findAllClients
