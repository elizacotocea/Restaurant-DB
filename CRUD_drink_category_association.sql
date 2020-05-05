SELECT * FROM drink_category_association
GO
ALTER FUNCTION existaDrink_category_association (@IDdrink int, @IDdrinkcat int)
RETURNS INT AS
BEGIN
	DECLARE @ok INT;
	SET @ok=0;
	DECLARE @gasit int;
	SELECT @gasit=id_drink From drink_category_association where id_drink=@IDdrink AND id_drink_category=@IDdrinkcat;
	if @gasit = @IDdrink
		SET @ok=1
	RETURN @ok
END

GO
CREATE FUNCTION validareID(@IDdrink int, @IDdrinkcat int)
RETURNS INT AS
BEGIN
	DECLARE @ok INT;
	SET @ok=1;
	if @IDdrink<0 AND @IDdrinkcat<0
		BEGIN
			SET @ok=0
		END
	RETURN @ok
END


GO
ALTER PROCEDURE insertInDrink_category_association @IDdrink int, @IDdrinkcat int
AS
BEGIN
	DECLARE @exista INT;
	DECLARE @valid INT
	DECLARE @existadrink INT;
	DECLARE @existadrinkcat INT;
	SET @exista = dbo.existaDrink_category_association(@IDdrink,@IDdrinkcat);
	SET @existadrink=dbo.existaDrink(@IDdrink);
	SET @existadrinkcat=dbo.existaDrink_category(@IDdrinkcat);
	SET @valid = dbo.validareID(@IDdrink,@IDdrinkcat)
	if @valid = 1
	BEGIN
	if @exista = 0
		if @existadrink=0 AND @existadrinkcat=0
		INSERT INTO drink_category_association (id_drink,id_drink_category)
			VALUES(@IDdrink, @IDdrinkcat)
	else PRINT ('Exista deja in baza de date!');
	END
	else PRINT ('Trebuie introduse ID-uri mai mari decat 0!');
END

GO
CREATE PROCEDURE deleteFromDrink_category_association @IDdrink int, @IDdrinkcat int
AS
BEGIN
	DECLARE @exista INT;
	SET @exista = dbo.existaDrink_category_association(@IDdrink,@IDdrinkcat);
	if @exista = 1
		BEGIN
			DELETE FROM drink_category_association where @IDdrinkcat=id_drink_category AND @IDdrink=id_drink
		END
	else PRINT ('Nu exista!');
END


GO
CREATE PROCEDURE findAlldrink_category_association
AS
BEGIN
	select * from drink_category_association
END
	
	
exec insertIndrink_category_association @IDdrink=1004, @IDdrinkcat=2444
exec deleteFromdrink_category_association @IDdrink=1000, @IDdrinkcat=90

exec findAlldrink_category_association

