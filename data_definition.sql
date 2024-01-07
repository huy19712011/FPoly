-- This section shows you how to manage the most important database objects including databases and tables.
CREATE DATABASE data_definition;

USE data_definition;
GO;

-- Working with tables
/*
CREATE TABLE [database_name.][schema_name.]table_name (
    pk_column data_type PRIMARY KEY,
    column_1 data_type NOT NULL,
    column_2 data_type,
    ...,
    table_constraints
);
*/

-- 1. Creating tables
CREATE TABLE production.visits (
    visit_id INT PRIMARY KEY IDENTITY (1, 1),
    first_name VARCHAR (50) NOT NULL,
    last_name VARCHAR (50) NOT NULL,
    visited_at DATETIME,
    phone VARCHAR(20),
    store_id INT NOT NULL,
    FOREIGN KEY (store_id) REFERENCES sales.stores (store_id)
);

-- 2. IDENTITY[(seed,increment)]
CREATE TABLE person (
    person_id INT IDENTITY(10,1) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender VARCHAR(10) NOT NULL
);

INSERT INTO person(first_name, last_name, gender)
OUTPUT inserted.person_id
VALUES('John','Doe', 'M');

-- 3. DROP
-- drop table that does not exist
DROP TABLE IF EXISTS sales.renenues;
-- drop a single table
DROP TABLE sales.delivery;
-- drop table with foreign key constraint
CREATE SCHEMA procurement;
GO

CREATE TABLE procurement.supplier_groups (
    group_id INT IDENTITY PRIMARY KEY,
    group_name VARCHAR (50) NOT NULL
);

CREATE TABLE procurement.suppliers (
    supplier_id INT IDENTITY PRIMARY KEY,
    supplier_name VARCHAR (50) NOT NULL,
    group_id INT NOT NULL,
    FOREIGN KEY (group_id) REFERENCES procurement.supplier_groups (group_id)
);

DROP TABLE procurement.supplier_groups; --  error

DROP TABLE procurement.suppliers, procurement.supplier_groups; -- note: order of tables

-- 4. Rename table
-- using SSMS
-- using code
CREATE TABLE sales.contr (
    contract_no INT IDENTITY PRIMARY KEY,
    start_date DATE NOT NULL,
    expired_date DATE,
    customer_id INT,
    amount DECIMAL (10, 2)
); 

EXEC sp_rename 'sales.contr', 'contracts';

-- 5. Adding columns
/*
ALTER TABLE table_name
ADD column_name data_type column_constraint;

ALTER TABLE table_name
ADD 
    column_name_1 data_type_1 column_constraint_1,
    column_name_2 data_type_2 column_constraint_2,
    ...,
    column_name_n data_type_n column_constraint_n;
*/

CREATE TABLE sales.quotations (
    quotation_no INT IDENTITY PRIMARY KEY,
    valid_from DATE NOT NULL,
    valid_to DATE NOT NULL
);

ALTER TABLE sales.quotations 
ADD description VARCHAR (255) NOT NULL;

ALTER TABLE sales.quotations 
ADD 
    amount DECIMAL (10, 2) NOT NULL,
    customer_name VARCHAR (50) NOT NULL;


-- 6. SQL Server ALTER TABLE ALTER COLUMN
--Modify the data type
--Change the size
--Add a NOT NULL constraint

-- 7. SQL Server ALTER TABLE DROP COLUMN
--If the column that you want to delete has a CHECK constraint, you must delete the constraint first before removing the column.
--Also, SQL Server does not allow you to delete a column that has a PRIMARY KEY or a FOREIGN KEY constraint.
/*
ALTER TABLE table_name
DROP COLUMN column_name_1, column_name_2,...;
*/
CREATE TABLE sales.price_lists(
    product_id int,
    valid_from DATE,
    price DEC(10,2) NOT NULL CONSTRAINT ck_positive_price CHECK(price >= 0),
    discount DEC(10,2) NOT NULL,
    surcharge DEC(10,2) NOT NULL,
    note VARCHAR(255),
    PRIMARY KEY(product_id, valid_from)
); 

-- column without constraint
ALTER TABLE sales.price_lists
DROP COLUMN note;

-- column has constraint
ALTER TABLE sales.price_lists
DROP CONSTRAINT ck_positive_price;
ALTER TABLE sales.price_lists
DROP COLUMN price;


-- 8. SQL Server PRIMARY KEY constraint
/*
CREATE TABLE table_name (
    pk_column data_type PRIMARY KEY,
    ...
);

CREATE TABLE table_name (
    pk_column_1 data_type,
    pk_column_2 data type,
    ...
    PRIMARY KEY (pk_column_1, pk_column_2)
);
*/

-- e1
CREATE TABLE sales.activities (
    activity_id INT PRIMARY KEY IDENTITY,
    activity_name VARCHAR (255) NOT NULL,
    activity_date DATE NOT NULL
);

-- e2
CREATE TABLE sales.participants(
    activity_id int,
    customer_id int,
    PRIMARY KEY(activity_id, customer_id)
);

-- e3
CREATE TABLE sales.events(
    event_id INT NOT NULL,
    event_name VARCHAR(255),
    start_date DATE NOT NULL,
    duration DEC(5,2)
);

ALTER TABLE sales.events 
ADD PRIMARY KEY(event_id);

-- 9. SQL Server foreign key constraint
/*
-- syntax
CONSTRAINT fk_constraint_name 
FOREIGN KEY (column_1, column2,...)
REFERENCES parent_table_name(column1,column2,..)

-- or
FOREIGN KEY (column_1, column2,...)
REFERENCES parent_table_name(column1,column2,..)

-- Referential actions
FOREIGN KEY (foreign_key_columns)
    REFERENCES parent_table(parent_key_columns)
    ON UPDATE action 
    ON DELETE action;

-- Options: 4
ON DELETE NO ACTION: SQL Server raises an error and rolls back the delete action on the row in the parent table.
ON DELETE CASCADE: SQL Server deletes the rows in the child table that is corresponding to the row deleted from the parent table.
ON DELETE SET NULL: SQL Server sets the rows in the child table to NULL if the corresponding rows in the parent table are deleted.
To execute this action, the foreign key columns must be nullable.
ON DELETE SET DEFAULT SQL Server sets the rows in the child table to their default values if the corresponding rows in the parent table are deleted.
To execute this action, the foreign key columns must have default definitions.
Note that a nullable column has a default value of NULL if no default value specified.
*/
CREATE TABLE procurement.vendor_groups (
    group_id INT IDENTITY PRIMARY KEY,
    group_name VARCHAR (100) NOT NULL
);

CREATE TABLE procurement.vendors (
        vendor_id INT IDENTITY PRIMARY KEY,
        vendor_name VARCHAR(100) NOT NULL,
        group_id INT NOT NULL,
        CONSTRAINT fk_group FOREIGN KEY (group_id) 
        REFERENCES procurement.vendor_groups(group_id)
);


-- 10. SQL Server CHECK Constraint
-- e1
CREATE TABLE test.products(
    product_id INT IDENTITY PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    unit_price DEC(10,2) CHECK(unit_price > 0)
);
-- e2
CREATE TABLE test.products(
    product_id INT IDENTITY PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    unit_price DEC(10,2) CONSTRAINT positive_price CHECK(unit_price > 0)
);

-- Note: NULL evaluates to UNKNOWN, it can be used in the expression to bypass a constraint.
-- Ok
INSERT INTO test.products(product_name, unit_price)
VALUES ('Another Awesome Bike', NULL);

-- multiple columns
-- v1
CREATE TABLE test.products(
    product_id INT IDENTITY PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    unit_price DEC(10,2) CHECK(unit_price > 0),
    discounted_price DEC(10,2) CHECK(discounted_price > 0),
    CHECK(discounted_price < unit_price)
);

-- v2
CREATE TABLE test.products(
    product_id INT IDENTITY PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    unit_price DEC(10,2),
    discounted_price DEC(10,2),
    CHECK(unit_price > 0),
    CHECK(discounted_price > 0),
    CHECK(discounted_price > unit_price)
);

-- v3
CREATE TABLE test.products(
    product_id INT IDENTITY PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    unit_price DEC(10,2),
    discounted_price DEC(10,2),
    CHECK(unit_price > 0),
    CHECK(discounted_price > 0),
    CONSTRAINT valid_prices CHECK(discounted_price > unit_price)
);

-- Add constraint to existing tables
CREATE TABLE test.products(
    product_id INT IDENTITY PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    unit_price DEC(10,2) NOT NULL
);

-- v1: add constraint to column
ALTER TABLE test.products
ADD CONSTRAINT positive_price CHECK(unit_price > 0);

-- v2: add new column with constraint
ALTER TABLE test.products
ADD discounted_price DEC(10,2)
CHECK(discounted_price > 0);

ALTER TABLE test.products
ADD CONSTRAINT valid_price 
CHECK(unit_price > discounted_price);

-- Remove CHECK constraints
ALTER TABLE table_name
DROP CONSTRAINT constraint_name;

-- Disable CHECK constraints for insert or update
ALTER TABLE test.products
NOCHECK CONSTRAINT valid_price;


-- 11. SQL Server UNIQUE Constraint
CREATE TABLE hr.persons(
    person_id INT IDENTITY PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE
);

CREATE TABLE hr.persons(
    person_id INT IDENTITY PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    UNIQUE(email)
);

-- with name
CREATE TABLE hr.persons (
    person_id INT IDENTITY PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    CONSTRAINT unique_email UNIQUE(email)
);

-- different between PRIMARY KEY vs UNIQUE: UNIQUE allows NULL, and note only one NULL value per column!

-- UNIQUE constraints for a group of columns
/*
CREATE TABLE table_name (
    key_column data_type PRIMARY KEY,
    column1 data_type,
    column2 data_type,
    column3 data_type,
    ...,
    UNIQUE (column1,column2)
);
*/

CREATE TABLE hr.person_skills (
    id INT IDENTITY PRIMARY KEY,
    person_id int,
    skill_id int,
    updated_at DATETIME,
    UNIQUE (person_id, skill_id)
);

-- Add UNIQUE constraints to existing columns
/*
ALTER TABLE table_name
ADD CONSTRAINT constraint_name 
UNIQUE(column1, column2,...);
*/

CREATE TABLE hr.persons (
    person_id INT IDENTITY PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    phone VARCHAR(20),
);

ALTER TABLE hr.persons
ADD CONSTRAINT unique_phone UNIQUE(phone); 

-- Delete UNIQUE constraints
ALTER TABLE hr.persons
DROP CONSTRAINT unique_phone;

-- Modify UNIQUE constraints:
-- SQL Server does not have any direct statement to modify a UNIQUE constraint,
-- you need to drop the constraint first and recreate it if you want to change the constraint.

-- 12. SQL Server NOT NULL Constraint
CREATE TABLE hr.persons(
    person_id INT IDENTITY PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(20)
);

-- Add NOT NULL constraint to an existing column
/*
To add the NOT NULL constraint to an existing column, you follow these steps:

First, update the table so there is no NULL in the column:
UPDATE table_name
SET column_name = <value>
WHERE column_name IS NULL;

Second, alter the table to change the property of the column:
ALTER TABLE table_name
ALTER COLUMN column_name data_type NOT NULL;
*/
UPDATE hr.persons
SET phone = "(408) 123 4567"
WHERE phone IS NULL;

ALTER TABLE hr.persons
ALTER COLUMN phone VARCHAR(20) NOT NULL;

-- Removing NOT NULL constraint
/*
ALTER TABLE table_name
ALTER COLUMN column_name data_type NULL;
*/
ALTER TABLE hr.pesons
ALTER COLUMN phone VARCHAR(20) NULL;


-- 13. SQL Server INSERT
/*
INSERT INTO table_name (column_list)
VALUES (value_list);

If a column of a table does not appear in the column list, SQL Server must be able to provide a value for insertion or the row cannot be inserted.
SQL Server automatically uses the following value for the column that is available in the table but does not appear in the column list of the INSERT statement:

+ The next incremental value if the column has an IDENTITY property.
+ The default value if the column has a default value specified.
+ The current timestamp value if the data type of the column is a timestamp data type.
+ The NULL if the column is nullable.
+ The calculated value if the column is a computed column.
*/

CREATE TABLE sales.promotions (
    promotion_id INT PRIMARY KEY IDENTITY (1, 1),
    promotion_name VARCHAR (255) NOT NULL,
    discount NUMERIC (3, 2) DEFAULT 0,
    start_date DATE NOT NULL,
    expired_date DATE NOT NULL
); 

-- e1: basic
INSERT INTO sales.promotions (
    promotion_name,
    discount,
    start_date,
    expired_date
)
VALUES
    (
        '2018 Summer Promotion',
        0.15,
        '20180601',
        '20180901'
    );

-- e2: return inserted values
INSERT INTO sales.promotions (
    promotion_name,
    discount,
    start_date,
    expired_date
) OUTPUT inserted.promotion_id
VALUES
    (
        '2018 Fall Promotion',
        0.15,
        '20181001',
        '20181101'
    );

INSERT INTO sales.promotions (
    promotion_name,
    discount,
    start_date,
    expired_date
) OUTPUT inserted.promotion_id,
 inserted.promotion_name,
 inserted.discount,
 inserted.start_date,
 inserted.expired_date
VALUES
    (
        '2018 Winter Promotion',
        0.2,
        '20181201',
        '20190101'
    );

-- Insert explicit values into the identity column
/*
SET IDENTITY_INSERT table_name ON;
SET IDENTITY_INSERT table_name OFF;
*/

SET IDENTITY_INSERT sales.promotions ON;

INSERT INTO sales.promotions (
    promotion_id,
    promotion_name,
    discount,
    start_date,
    expired_date
)
VALUES
    (
        4,
        '2019 Spring Promotion',
        0.25,
        '20190201',
        '20190301'
    );


SET IDENTITY_INSERT sales.promotions OFF;

-- 14. SQL Server INSERT Multiple Rows
/*
INSERT INTO table_name (column_list)
VALUES
    (value_list_1),
    (value_list_2),
    ...
    (value_list_n);
*/

-- e1
CREATE TABLE sales.promotions (
    promotion_id INT PRIMARY KEY IDENTITY (1, 1),
    promotion_name VARCHAR (255) NOT NULL,
    discount NUMERIC (3, 2) DEFAULT 0,
    start_date DATE NOT NULL,
    expired_date DATE NOT NULL
); 

INSERT INTO sales.promotions (
    promotion_name,
    discount,
    start_date,
    expired_date
)
VALUES
    (
        '2019 Summer Promotion',
        0.15,
        '20190601',
        '20190901'
    ),
    (
        '2019 Fall Promotion',
        0.20,
        '20191001',
        '20191101'
    ),
    (
        '2019 Winter Promotion',
        0.25,
        '20191201',
        '20200101'
    );


-- Inserting multiple rows and returning the inserted id list example
INSERT INTO 
	sales.promotions ( 
		promotion_name, discount, start_date, expired_date
	)
OUTPUT inserted.promotion_id
VALUES
	('2020 Summer Promotion',0.25,'20200601','20200901'),
	('2020 Fall Promotion',0.10,'20201001','20201101'),
	('2020 Winter Promotion', 0.25,'20201201','20210101');


-- 15. SQL Server UPDATE
/*
UPDATE table_name
SET c1 = v1, c2 = v2, ... cn = vn
[WHERE condition]
*/


