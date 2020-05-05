SELECT * FROM drink
GO
CREATE FUNCTION existaDrink (@ID int)
RETURNS INT AS
BEGIN
	DECLARE @ok INT;
	SET @ok=0;
	DECLARE @gasit int;
	SELECT @gasit=id_drink From drink where id_drink=@ID;
	if @gasit = @ID
		SET @ok=1
	RETURN @ok
END

GO
CREATE FUNCTION validarePrice(@price float)
RETURNS INT AS
BEGIN
	DECLARE @ok INT;
	SET @ok=1;
	if @price<0
		BEGIN
			SET @ok=0
		END
	RETURN @ok
END


GO
CREATE PROCEDURE insertInDrink @ID int, @Name varchar(20), @price float
AS
BEGIN
	DECLARE @exista INT;
	DECLARE @valid INT
	SET @exista = dbo.existaDrink(@ID);
	SET @valid = dbo.validarePrice(@price)
	if @valid = 1
	BEGIN
	if @exista = 0
		INSERT INTO drink (id_drink,name,price)
			VALUES(@ID, @Name, @price)
	else PRINT ('Exista deja in baza de date!');
	END
	else PRINT ('Trebuie introdus un pret mai mare decat 0!');
END

GO
ALTER PROCEDURE deleteFromDrink @ID int
AS
BEGIN
	DECLARE @exista INT;
	SET @exista = dbo.existaDrink(@ID);
	if @exista = 1
		BEGIN
			DELETE FROM drink_category_association where @ID=id_drink
			DELETE from drink where @ID = id_drink;
		END
	else PRINT ('Nu exista!');
END


GO
ALTER PROCEDURE updateDrink  @ID int, @Name varchar(20), @price int
AS
BEGIN
	DECLARE @exista INT;
	DECLARE @valid INT;
	SET @exista = dbo.existaDrink(@ID)
	SET @valid=dbo.validarePrice(@price)
	if @valid = 1
	BEGIN
	if @exista = 1
		UPDATE drink SET id_drink=@ID, name=@Name, price=@price
			where id_drink=@ID
	else PRINT ('Nu exista!');
	END
	else PRINT ('Trebuie introdus un pret mai mare decat 0!')
END
	
GO
CREATE PROCEDURE findAllDrink
AS
BEGIN
	select * from drink
END
	
	
exec insertInDrink @ID=1022,@Name='Apa',@price=8
exec deleteFromDrink @ID=1022;
exec updateDrink @ID=1022,@Name='Apa',@price=10
exec findAllDrink

