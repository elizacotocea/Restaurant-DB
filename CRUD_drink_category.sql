SELECT * FROM drink_category
GO
CREATE FUNCTION existaDrink_category (@ID int)
RETURNS INT AS
BEGIN
	DECLARE @ok INT;
	SET @ok=0;
	DECLARE @gasit int;
	SELECT @gasit=id_drink_category From drink_category where id_drink_category=@ID;
	if @gasit = @ID
		SET @ok=1
	RETURN @ok
END

GO
CREATE FUNCTION validareType(@type varchar(20))
RETURNS INT AS
BEGIN
	DECLARE @ok INT;
	SET @ok=1;
	if @type=''
		BEGIN
			SET @ok=0
		END
	RETURN @ok
END


GO
CREATE PROCEDURE insertIndrink_category @ID int, @type varchar(20)
AS
BEGIN
	DECLARE @exista INT;
	DECLARE @valid INT
	SET @exista = dbo.existaDrink_category(@ID);
	SET @valid = dbo.validareType(@type)
	if @valid = 1
	BEGIN
	if @exista = 0
		INSERT INTO drink_category (id_drink_category,type)
			VALUES(@ID, @type)
	else PRINT ('Exista deja in baza de date!');
	END
	else PRINT ('Trebuie introdus un tip!');
END

GO
ALTER PROCEDURE deleteFromDrink_category @ID int
AS
BEGIN
	DECLARE @exista INT;
	SET @exista = dbo.existaDrink_category(@ID);
	if @exista = 1
		BEGIN
			DELETE FROM drink_category_association where @ID=id_drink_category
			DELETE from drink_category where @ID = id_drink_category;
		END
	else PRINT ('Nu exista!');
END


GO
CREATE PROCEDURE updatedrink_category  @ID int, @type varchar(20)
AS
BEGIN
	DECLARE @exista INT;
	DECLARE @valid INT;
	SET @exista = dbo.existadrink_category(@ID)
	SET @valid=dbo.validareType(@type)
	if @valid = 1
	BEGIN
	if @exista = 1
		UPDATE drink_category SET id_drink_category=@ID, type=@type
			where id_drink_category=@ID
	else PRINT ('Nu exista!');
	END
	else PRINT ('Trebuie introdus un tip!')
END
	
GO
CREATE PROCEDURE findAlldrink_category
AS
BEGIN
	select * from drink_category
END
	
	
exec insertInDrink_category @ID=1022,@type='Bautura nonalcoolica'
exec deleteFromDrink_category @ID=1022;
exec updateDrink_category @ID=1022,@type='Bautura neacidulata'

exec findAlldrink_category

