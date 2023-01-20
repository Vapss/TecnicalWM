-- Crear base de datos pruebaTecnica
Create database pruebaTecnica2;
Use pruebaTecnica2;

-- Crear tabla VENTAS
Create table VENTAS(
    ID VARCHAR(90),
    Tienda VARCHAR(90),
    Producto VARCHAR(90),
    Venta FLOAT,
    Descuento VARCHAR(90),
    Fecha DATETIME not null
);

Insert into VENTAS(ID, Tienda, Producto, Venta, Descuento, Fecha)
values('1', 'Playa del Carmen - 100', 'Jabón', 59.99, '9.99', '2023-06-01 00:00:00');
Insert into VENTAS(ID, Tienda, Producto, Venta, Descuento, Fecha)
values('ORDEN2', 'CDMX - 35', 'Pilas', 25, '10%', '2022-12-31 00:00:00');
Insert into VENTAS(ID, Tienda, Producto, Venta, Descuento, Fecha)
values('3', 'Chihuahua - 71', 'Cereal', 84.5, 'NULL', '2022-12-26 00:00:00');

-- Corregir la columna ID
UPDATE VENTAS
SET ID = CONVERT(INT, SUBSTRING(ID, 6, LEN(ID)))
WHERE ID LIKE 'ORDEN%'

ALTER TABLE VENTAS ALTER COLUMN ID INT;

SELECT * FROM VENTAS;

-- Separar la columna Tienda en Nombre de Tienda y Numero de Tienda, notar que el nombre y numero estan separados por " - "
ALTER TABLE VENTAS ADD NombreTienda VARCHAR(90);
ALTER TABLE VENTAS ADD NumeroTienda VARCHAR(90);

UPDATE VENTAS
SET NombreTienda = PARSENAME(REPLACE(Tienda, ' - ', '.'), 2),
    NumeroTienda = PARSENAME(REPLACE(Tienda, ' - ', '.'), 1);

SELECT * FROM VENTAS;

-- Pregunta 3 En la columna ‘Descuento’ sustituir los valores con porcentaje, por ejemplo “10%” por el
-- valor respectivo de la venta. Es decir, si la venta fue 25, sustituir “10%” por 2.5. También
-- sustituir los valores nulos por 0.

ALTER TABLE VENTAS ADD DescuentoTemp DECIMAL(18,2)
ALTER TABLE VENTAS ADD EsPorcentaje BIT

UPDATE VENTAS
SET DescuentoTemp = TRY_CONVERT(DECIMAL(18,2), REPLACE(Descuento, '%',''))

UPDATE VENTAS SET EsPorcentaje = CASE WHEN Descuento LIKE '%[%]' THEN 1 ELSE 0 END

UPDATE VENTAS
SET Descuento = (DescuentoTemp * Venta /100)
WHERE EsPorcentaje = 1

UPDATE VENTAS
SET DescuentoTemp = ISNULL(DescuentoTemp, 0)

UPDATE VENTAS
SET Descuento = DescuentoTemp

SELECT * FROM VENTAS;
-- Pregunta 4 Cambiar el formato de la columna ‘Fecha’ de DD/MM/YY a MM/DD/YYYY.

UPDATE VENTAS
SET Fecha = CONVERT(DATETIME, CONVERT(VARCHAR(10), Fecha, 120))

SELECT * FROM VENTAS;

SET LANGUAGE 'us_english';
SELECT ID, Tienda, Producto, Venta, Descuento, CONVERT(VARCHAR(10), Fecha, 101) AS Fecha
FROM VENTAS;


-- Pregunta 5: Agregar la columna ‘Venta Neta’ con la resta de las columnas ‘Venta’ y ‘Descuento’.
ALTER TABLE VENTAS ADD Venta_Neta Decimal(18,2)
UPDATE VENTAS
SET Venta_Neta = Venta - Descuento

SELECT * FROM VENTAS;


-- 2.- Se requiere ver las ventas de cada tienda para las festividades del mes de diciembre; Navidad
-- (22 a 24 de diciembre) y Año Nuevo (29 a 31 de diciembre). Y se quiere ver cuáles son las 10
-- tiendas con mayor venta. Realiza la consulta para lo solicitado.

Select TOP 10 Tienda, Venta, Fecha
From VENTAS
WHERE Fecha BETWEEN '20221222' AND '20221224'

Select TOP 10 Tienda, Venta, Fecha
From VENTAS
WHERE Fecha BETWEEN '20221229' AND '20221231'

-- Se hace la implementación de una nueva base de datos, de la cual no se tiene conocimiento
-- alguno. Se quiere buscar dentro de todas las tablas de la base, columnas semejantes a las de la
-- tabla VENTAS. ¿Cómo harías esta investigación?

-- Podemos usar LIKE para que nos devuelva columnas o tablas que contienen nombres similares, pero esto no garantiza que exista una igual a Venta. 
SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME LIKE '%ID%' 
  OR COLUMN_NAME LIKE '%Tienda%' 
  OR COLUMN_NAME LIKE '%Producto%' 
  OR COLUMN_NAME LIKE '%Venta%' 
  OR COLUMN_NAME LIKE '%Descuento%' 
  OR COLUMN_NAME LIKE '%Fecha%'

-- En este caso analizaría todas con la siguiente consulta para ver cual es la que mas se asemeja a ventas y a las columnas que ya tenemos. Esta consulta nos regresa el nombre
-- De la tabla, la columna (nombre) y el tipo de dato.
SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
