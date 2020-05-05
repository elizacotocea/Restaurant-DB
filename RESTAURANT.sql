use RESTAURANT;

create table waiter(
id_waiter int primary key,
name varchar(20),
sex varchar(10),
age int
);

create table client(
id_client int primary key,
id_waiter int foreign key references waiter(id_waiter),
name varchar(20),
sex varchar(10),
);

create table drink_category(
id_drink_category int primary key,
type varchar(40)
);

create table menu(
id_menu int primary key,
id_client int foreign key references client(id_client),
color varchar(20),
type varchar(20)
);

create table dish(
id_dish int primary key,
name varchar(20),
price float,
chef varchar(20)
);

create table ingredients(
id_ingredient int primary key,
name varchar(20),
quantity float,
origin varchar(20)
);

create table recipe(
id_dish int foreign key references dish(id_dish),
id_ingredient int foreign key references ingredients(id_ingredient),
primary key (id_dish,id_ingredient),
);


create table drink(
id_drink int primary key,
name varchar(20),
price float
);

create table drink_category_association(
id_drink int foreign key references drink(id_drink),
id_drink_category int foreign key references drink_category(id_drink_category),
primary key (id_drink,id_drink_category),
);

create table drink_order(
id_drink int foreign key references drink(id_drink),
id_menu int foreign key references menu(id_menu),
primary key (id_menu,id_drink),
number int
);

create table food_order(
id_dish int foreign key references dish(id_dish),
id_menu int foreign key references menu(id_menu),
primary key (id_menu,id_dish),
number int
);

INSERT INTO waiter (id_waiter,name,sex,age) VALUES (1,'Paula','feminin',19),(2,'Marius','masculin',28),(3,'Marian','masculin',36),
(4,'Diana','feminin',25),(5,'Alex','masculin',20);


INSERT INTO client (id_client,id_waiter,name,sex) VALUES (1,1,'Eliza','feminin'),(2,4,'Andreea','feminin'),
(3,2,'Ionut','masculin'),(4,2,'Octavian','masculin'),(5,1,'Andrei','masculin'),(6,4,'Anca','feminin'),(7,5,'Maria','feminin');
SElECT * from client;

INSERT INTO menu (id_menu,id_client,color,type) VALUES (1,1,'roz','desert'),(2,2,'rosu','bauturi'),(3,3,'verde','mic-dejun'),
(4,5,'rosu','preparate calde'),(5,4,'roz','bauturi'),(6,2,'verde','desert'),(7,4,'negru','bauturi');
SElECT * from menu;
INSERT INTO menu (id_menu,id_client,color,type) VALUES (8,5,'rosu','bauturi');

INSERT INTO dish (id_dish,name,price,chef) VALUES (1,'cheesecake',15,'Albu'),(2,'ciorba de pui',8.5,'Ana'),(3,'pizza',20,'Paul'),
(4,'omleta',10.5,'Albu'),(5,'tort ciocolata',15.5,'Ana'),(6,'burger',38,'Paul'),(7,'inghetata',12.5,'Diana'),(8,'clatite',10.5,'Albu'),
(9,'cartofi prajiti',5,'Ana'),(10,'salata',17,'Albu');
SELECT * from dish;

INSERT INTO food_order(id_dish,id_menu,number) VALUES (1,1,2),(2,4,3),(3,4,1),(4,3,5),(5,6,6),(6,4,10),(7,1,4),(1,6,11),(8,6,7),(9,4,8),(10,3,9);
SELECT * from food_order;

INSERT INTO ingredients(id_ingredient,name,quantity,origin) VALUES (1,'paprika',250,'Spania'), (2,'sare',100.5,'Romania'),
(3,'piper',50,'Argentina'),(4,'sos de rosii',250.5,'Italia'),(5,'branza',500,'Italia'),(6,'carne pui',500,'Romania'),
(7,'ciocolata',450,'Belgia'),(8,'cartofi',700,'Romania'),(9,'oua',200,'Romania'),(10,'salata',300,'Romania');

SELECT * from ingredients;

INSERT INTO drink (id_drink,name,price) VALUES (1,'apa plata',4.5),(2,'Coca-Cola',6.5),(3,'cafea',4),(4,'vin rosu',10),
(5,'Fanta',6.5),(11,'Hugo',18.5),(6,'Martini',19.5),(7,'vin alb',10),(8,'Cappy piersici',8),(9,'frappe',15.5),(10,'Sprite',7);
SELECT * from drink;

INSERT INTO drink_order(id_drink,id_menu,number) VALUES (1,2,1),(2,5,2),(3,7,3),(4,2,4),(5,7,5),(6,7,6),(7,5,7),(8,2,7),
(9,2,7),(10,5,8),(11,5,8);
SELECT * from drink_order;

INSERT INTO drink_order(id_drink,id_menu,number) VALUES (7,8,13),(11,2,14);

INSERT INTO drink_category(id_drink_category,type) VALUES (1,'bauturi carbogazoase'),(2,'bauturi necarbogazoase'),(3,'specialitati cafea'),
(4,'vinuri'),(5,'cocktail-uri');
INSERT INTO drink_category(id_drink_category,type) VALUES (6,'bauturi alcoolice')
SELECT * from drink_category;

INSERT INTO drink_category_association(id_drink,id_drink_category) VALUES (1,2),(2,1),(3,3),(4,4),(5,1),(6,5),(7,4),(8,2),(9,3),
(10,1),(11,5);
INSERT INTO drink_category_association(id_drink,id_drink_category) VALUES (11,6),(7,6),(6,6),(4,6);
SELECT * from drink_category_association;

INSERT INTO recipe(id_dish,id_ingredient) VAlUES (1,5),(1,7),(2,2),(2,8),(2,6),(3,4),(3,5),(4,9),(5,7),(6,6),(6,10),(6,8),(6,4),
(7,7),(8,7),(8,9),(9,8),(9,2),(10,6),(10,5),(10,10);
SELECT * from recipe;

SELECT name as 'nume preparat',price as 'pret',type as 'categorie' FROM dish D 
INNER JOIN food_order FD ON D.id_dish=FD.id_dish 
INNER JOIN menu M ON M.id_menu=FD.id_menu 
WHERE price<15;

SELECT DISTINCT D.name,D.price,DC.type FROM drink D 
left join drink_category_association DCA ON D.id_drink=DCA.id_drink 
left join drink_category DC ON DC.type='bauturi necarbogazoase' AND DC.id_drink_category=DCA.id_drink_category
WHERE D.price BETWEEN 6 AND 10;

SELECT D.chef,COUNT(D.name) AS 'Numar de mancaruri gatite' from dish D WHERE chef>='A' AND chef<'B' GROUP BY chef HAVING COUNT(name)>2;

SELECT D.chef,AVG(D.price) AS 'Profit obtinut' from dish D GROUP BY D.chef HAVING AVG(D.price)>10 ORDER BY AVG(D.price) DESC;

SELECT C.name as 'Nume client', M.type as 'Tip meniu' ,W.name As 'Nume ospatar' FROM waiter W 
INNER JOIN client C ON C.id_waiter=W.id_waiter 
INNER JOIN menu M ON M.id_client=C.id_client AND (M.type='desert' or M.type='bauturi') 
GROUP BY C.name,M.type,W.name;

SELECT DISTINCT D.name,I.origin FROM ingredients I 
INNER JOIN recipe R ON R.id_ingredient=I.id_ingredient 
INNER JOIN dish D ON D.id_dish=R.id_dish where I.origin='Romania';

SELECT C.name as 'nume client', D.name as 'nume preparat'from client C 
INNER JOIN menu M ON M.id_client=C.id_client 
INNER JOIN dish D ON D.id_dish=M.id_menu where C.name in ('Eliza', 'Andreea');

SELECT C.name as 'nume client', D.name as 'nume bautura' from client C 
INNER JOIN menu M ON M.id_client=C.id_client 
INNER JOIN drink D ON D.id_drink=M.id_menu where C.sex='masculin'
GROUP BY C.name, D.name;

SELECT DISTINCT C.name as 'nume client',DC.type as 'tip bautura' from client C INNER JOIN
menu M ON M.id_client=C.id_client
INNER JOIN drink_order DO ON DO.id_menu=M.id_menu
INNER JOIN drink D ON D.id_drink=DO.id_drink
INNER JOIN drink_category_association DCA ON DCA.id_drink=D.id_drink 
INNER JOIN drink_category DC ON DC.id_drink_category=DCA.id_drink_category AND DC.type='cocktail-uri';

SELECT C.name as 'nume client', SUM(DISH.price) as 'nota de plata mancare' from client C 
INNER JOIN menu M ON M.id_client=C.id_client
INNER JOIN food_order FO ON FO.id_menu=M.id_menu
INNER JOIN dish DISH ON DISH.id_dish=FO.id_dish
GROUP BY C.name;
