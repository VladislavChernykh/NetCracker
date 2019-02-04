/* First Task Assignment*/
/*CREATE BLOCK*/

CREATE TABLE Object_types(
  object_type_id Number PRIMARY KEY,
  parent_id Number,
  name Varchar2(20),
  description Varchar2(20),
  order_number Varchar2(20)
);
Alter table object_types add foreign key (parent_id) references object_types (object_type_id);

CREATE TABLE Objects (
  object_id Number PRIMARY KEY,
  parent_id Number,
  object_type_id Number NOT NULL,
  name Varchar2(20),
  description Varchar2(20),
  order_number Varchar2(20)
);
Alter table Objects add foreign key (parent_id) references Objects (object_id);
Alter table Objects add foreign key (object_type_id) references Object_types (object_type_id);

CREATE TABLE Params (
  attr_id Number NOT NULL,
  object_id Number NOT NULL,
  value Varchar2(20),
  date_value Date,
  show_order Number
);
Alter table Params add foreign key (object_id) references Objects (object_id) on delete cascade;
Alter table Params add foreign key (attr_id) references Attributes (attr_id) on delete cascade; 

CREATE TABLE Attributes (
  attr_id Number PRIMARY KEY,
  attr_type_id Number NOT NULL,
  attr_group_id Number NOT NULL,
  name Varchar2(20),
  description Varchar2(20),
  ismultiple Number,
  properties Varchar2(20)
);
Alter table Attributes add unique (attr_id,Name);
Alter table Attributes add foreign key (attr_group_id) references Attr_groups(attr_group_id);

CREATE TABLE References (
  attr_id Number NOT NULL,
  object_id Number NOT NULL,
  reference_id Number NOT NULL,
  show_order Number
);

Alter table References add foreign key (attr_id) references Attributes(attr_id);
Alter table References add foreign key (object_id) references Objects(object_id);
Alter table References add foreign key (reference_id) references Objects(object_id);

CREATE TABLE Attr_binds (
  attr_id Number NOT NULL,
  object_type_id Number NOT NULL,
  options Varchar2(20),
  isrequired Number,
  default_value Varchar2(20)
);
Alter table Attr_binds add foreign key (object_type_id) references Object_types(object_type_id);
Alter table Attr_binds add foreign key (attr_id) references Attributes(attr_id);
Alter table Attr_binds add primary key (object_type_id, attr_id);

CREATE TABLE Attr_types (
  attr_type_id Number PRIMARY KEY,
  name Varchar2(20),
  properties Varchar2(20)
);

CREATE TABLE Attr_groups (
  attr_group_id Number PRIMARY KEY,
  name Varchar2(20),
  properties Varchar2(20)
);


/*INSERT BLOCK*/

--ATTR_TYPES--
INSERT INTO Attr_types (ATTR_TYPE_ID, NAME) VALUES ('1', 'Dots per Inch');
INSERT INTO Attr_types (ATTR_TYPE_ID, NAME) VALUES ('2', 'Pages per Minute');
INSERT INTO Attr_types (ATTR_TYPE_ID, NAME) VALUES ('3', 'Name');
INSERT INTO Attr_types (ATTR_TYPE_ID, NAME) VALUES ('4', 'Frequency');
INSERT INTO Attr_types (ATTR_TYPE_ID, NAME) VALUES ('5', 'Color');
INSERT INTO Attr_types (ATTR_TYPE_ID, NAME) VALUES ('6', 'Number of Colors');

--ATTR_GROUPS--
INSERT INTO Attr_groups (ATTR_GROUP_ID, NAME) VALUES ('1', 'MRS technique');
INSERT INTO Attr_groups (ATTR_GROUP_ID, NAME) VALUES ('2', 'UPT technique');
INSERT INTO Attr_groups (ATTR_GROUP_ID, NAME) VALUES ('3', 'NTP technique');
INSERT INTO Attr_groups (ATTR_GROUP_ID, NAME) VALUES ('4', 'VNR technique');
INSERT INTO Attr_groups (ATTR_GROUP_ID, NAME) VALUES ('5', 'PLT technique');

--OBJECT_TYPES--
INSERT INTO object_types (OBJECT_TYPE_ID, NAME, DESCRIPTION) VALUES ('2', 'Printer', 'Принтер');
INSERT INTO object_types (OBJECT_TYPE_ID, PARENT_ID, NAME, DESCRIPTION) VALUES ('3', '2', 'Inkjet Printer', 'Струйный');
INSERT INTO object_types (OBJECT_TYPE_ID, NAME, DESCRIPTION) VALUES ('4', 'Head', 'Головка');
INSERT INTO object_types (OBJECT_TYPE_ID, NAME, DESCRIPTION) VALUES ('5', 'ImageSetter', 'Фотон.');

--OBJECTS--
INSERT INTO Objects (OBJECT_ID, PARENT_ID, OBJECT_TYPE_ID, NAME) VALUES ('1', NULL, '1', 'MyComp');
INSERT INTO Objects (OBJECT_ID, PARENT_ID, OBJECT_TYPE_ID, NAME, DESCRIPTION, ORDER_NUMBER) VALUES ('2', NULL, '3', 'MyPrinter', 'HP DeskJet', '1');
INSERT INTO Objects (OBJECT_ID, PARENT_ID, OBJECT_TYPE_ID, NAME) VALUES ('3', '3', '4', 'Head1');
INSERT INTO Objects (OBJECT_ID, PARENT_ID, OBJECT_TYPE_ID, NAME) VALUES ('4', '3', '4', 'Head2');
INSERT INTO Objects (OBJECT_ID, PARENT_ID, OBJECT_TYPE_ID, NAME) VALUES ('5', '3', '4', 'Head3');
INSERT INTO Objects (OBJECT_ID, PARENT_ID, OBJECT_TYPE_ID, NAME) VALUES ('6', '3', '4', 'Head4');
INSERT INTO Objects (OBJECT_ID, PARENT_ID, OBJECT_TYPE_ID, NAME) VALUES (7, NULL, 2, 'NetPrinter');

--ATTRIBUTES--
INSERT INTO Attributes (ATTR_ID, ATTR_TYPE_ID, OBJECT_TYPE_ID, NAME, ISMULTIPLE) VALUES ('1', '1', '1', 'dpi', '0');
INSERT INTO Attributes (ATTR_ID, ATTR_TYPE_ID, OBJECT_TYPE_ID, NAME, ISMULTIPLE) VALUES ('2', '2', '2', 'ppm', '0');
INSERT INTO Attributes (ATTR_ID, ATTR_TYPE_ID, OBJECT_TYPE_ID, NAME, ISMULTIPLE) VALUES ('3', '3', '3', 'networkName', '1');
INSERT INTO Attributes (ATTR_ID, ATTR_TYPE_ID, OBJECT_TYPE_ID, NAME, ISMULTIPLE) VALUES ('4', '4', '4', 'CPUFrequency', '0');

--PARAMS--
INSERT INTO Params (ATTR_ID, OBJECT_ID, VALUE) VALUES ('3', '1', 'MyComputer');
INSERT INTO Params (ATTR_ID, OBJECT_ID, VALUE) VALUES ('3', '1', 'Ivanov');
INSERT INTO Params (ATTR_ID, OBJECT_ID, VALUE) VALUES ('4', '1', '2.6');
INSERT INTO Params (ATTR_ID, OBJECT_ID, VALUE) VALUES ('1', '2', '600');
INSERT INTO Params (ATTR_ID, OBJECT_ID, VALUE) VALUES ('2', '2', '3');
INSERT INTO Params (ATTR_ID, OBJECT_ID, VALUE) VALUES ('6', '2', '4');

--REFERENCES--
INSERT INTO References (ATTR_ID, OBJECT_ID, REFERENCE_ID, SHOW_ORDER) VALUES ('1', '1', '7', '7');
INSERT INTO References (ATTR_ID, OBJECT_ID, REFERENCE_ID, SHOW_ORDER) VALUES ('1', '2', '2', '3');

--ATTR_BINDS--
INSERT INTO Attr_binds (ATTR_ID, OBJECT_TYPE_ID, ISREQUIRED, DEFAULT_VALUE) VALUES ('1', '2', '0', 'Printer dpi');
INSERT INTO Attr_binds (ATTR_ID, OBJECT_TYPE_ID, ISREQUIRED, DEFAULT_VALUE) VALUES ('1', '5', '1', 'ImageSetter dpi');
INSERT INTO Attr_binds (ATTR_ID, OBJECT_TYPE_ID, ISREQUIRED, DEFAULT_VALUE) VALUES ('2', '2', '0', 'Printer ppm');
INSERT INTO Attr_binds (ATTR_ID, OBJECT_TYPE_ID, ISREQUIRED, DEFAULT_VALUE) VALUES ('1', '3', '0', 'Computer Name');


/*SELECT BLOCK*/

--1) Получение информации обо всех атрибутах(учитывая только атрибутную группу и атрибутные типы)(attr_id, attr_name, attr_group_id, attr_group_name, attr_type_id, attr_type_name)--
SELECT 
    attr.attr_id AS attr_id,
    attr.name AS attr_name,
    ag.attr_group_id AS attr_group_id,
    ag.name AS attr_group_name,
    ats.attr_type_id AS attr_type_id,
    ats.name AS attr_type_name
FROM Attributes attr 
RIGHT JOIN attr_groups ag 
    ON attr.attr_group_id = ag.attr_group_id
RIGHT JOIN attr_types ats
    ON attr.attr_type_id = ats.attr_type_id;
    
--2) Получение всех атрибутов для заданного объектного типа, без учета наследования(attr_id, attr_name )--
SELECT 
    attr.attr_id AS attr_id,
    attr.name AS attr_name
FROM Attributes attr
INNER JOIN attr_binds ab 
    ON attr.attr_id = ab.attr_id
WHERE ab.object_type_id = 2;

--3) Получение иерархии ОТ(объектных типов) для заданного объектного типа(нужно получить иерархию наследования) (ot_id, ot_name, level)--
SELECT
    ot.object_type_id AS ot_id,
    ot.name AS ot_name,
    LEVEL
FROM object_types ot
START WITH ot.object_type_id = 3
CONNECT BY PRIOR ot.parent_id = ot.object_type_id;

--4) Получение вложенности объектов для заданного объекта(нужно получить иерархию вложенности)(obj_id, obj_name, level)--
SELECT
    o.object_id AS obj_id,
    o.name AS obj_name,
    LEVEL
FROM Objects o
START WITH o.object_id = 3
CONNECT BY PRIOR o.parent_id = o.object_id;

--5) Получение объектов заданного объектного типа(учитывая только наследование ОТ)(ot_id, ot_name, obj_id, obj_name)--
SELECT
    ot.object_type_id AS ot_id,
    ot.name AS ot_name,
    o.object_id AS obj_id,
    o.name AS obj_name,
    LEVEL
FROM object_types ot
JOIN Objects o 
    ON o.object_type_id = ot.object_type_id
START WITH ot.object_type_id = 3
CONNECT BY PRIOR ot.parent_id = ot.object_type_id;

--6) Получение значений всех атрибутов(всех возможных типов) для заданного объекта(без учета наследования ОТ)(attr_id, attr_name, value)--
SELECT
    attr.attr_id AS attr_id,
    attr.name AS attr_name,
    p.value AS value,
    p.date_value AS date_value,
    p.show_order AS show_order
FROM Attributes attr
LEFT JOIN Params p
    ON p.attr_id = attr.attr_id
WHERE p.object_id = 1;

--7) Получение ссылок на заданный объект(все объекты, которые ссылаются на текущий)(ref_id, ref_name)--
SELECT
    ref.reference_id AS ref_id,
    o.name AS ref_name
FROM References ref
RIGHT JOIN Objects o
    ON ref.object_id = o.object_id
WHERE o.object_id = 1;

--8) Получение значений всех атрибутов(всех возможных типов, без повторяющихся атрибутов) для заданного объекта(с учетом наследования ОТ) Вывести в виде см. п.6 --
SELECT 
    DISTINCT attr.attr_id AS attr_id,
    attr.name AS attr_name,
    p.value AS value,
    o.object_type_id,
    p.date_value AS date_value,
    p.show_order AS show_order,
    LEVEL
FROM Attributes attr
LEFT JOIN Params p
    ON p.attr_id = attr.attr_id
JOIN Objects o
    ON o.object_id = p.object_id
START WITH o.object_id = 1
CONNECT BY PRIOR o.parent_id = o.object_type_id;
