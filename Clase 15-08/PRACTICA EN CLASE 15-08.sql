USE LIBRERIA
GO

--VENDEDORES CON MAS DE 25 VENTAS EN EL 2024\
SELECT
V.nom_vendedor + SPACE(1) + V.ape_vendedor 'VENDEDOR',
COUNT(F.nro_factura) 'VENTAS'
FROM vendedores V
JOIN FACTURAS F ON F.cod_vendedor = V.cod_vendedor
WHERE YEAR(F.fecha) = 2024
GROUP BY
V.nom_vendedor + SPACE(1) + V.ape_vendedor
HAVING
COUNT(F.nro_factura) > 25

--OPTIMIZAR STOCK

-- LOS 5 MAS VENDIDOS DEL 2024
SELECT TOP 5
A.descripcion 'ARTICULO',
COUNT(A.cod_articulo) 'VENTAS'
FROM articulos A
JOIN detalle_facturas DF ON DF.cod_articulo = A.cod_articulo
JOIN facturas F ON F.nro_factura = DF.nro_factura
WHERE YEAR(F.FECHA) = 2024
GROUP BY A.descripcion
ORDER BY COUNT(A.cod_articulo) DESC

-- LOS 5 MENOS VENDIDOS DEL 2024
SELECT TOP 5
A.descripcion 'ARTICULO',
COUNT(A.cod_articulo) 'VENTAS'
FROM articulos A
JOIN detalle_facturas DF ON DF.cod_articulo = A.cod_articulo
JOIN facturas F ON F.nro_factura = DF.nro_factura
WHERE YEAR(F.FECHA) = 2024
GROUP BY A.descripcion
ORDER BY COUNT(A.cod_articulo) ASC

-- STOCK DE LOS 5 PRODUCTOS MAS VENDIDOS DEL 2024
SELECT TOP 5
A.descripcion 'ARTICULO',
a.stock 'STOCK'
FROM articulos A
JOIN detalle_facturas DF ON DF.cod_articulo = A.cod_articulo
JOIN facturas F ON F.nro_factura = DF.nro_factura
WHERE YEAR(F.FECHA) = 2024
GROUP BY A.descripcion, a.stock
ORDER BY COUNT(A.cod_articulo) DESC

-- PRODUCTOS DE LOS QUE YA HAY STOCK MENOR A 5
SELECT
A.descripcion 'ARTICULO',
A.stock 'STOCK',
A.stock_minimo 'STOCK MINIMO'
FROM articulos A
WHERE A.stock < A.stock_minimo

-- EL TOTAL DE VENTAS POR ARTICULOS EN EL 2024
SELECT TOP 5
A.descripcion 'ARTICULO',
SUM(DF.CANTIDAD) 'CANTIDAD VENDIDA'
FROM articulos A
JOIN detalle_facturas DF ON DF.cod_articulo = A.cod_articulo
JOIN facturas F ON F.nro_factura = DF.nro_factura
WHERE YEAR(F.FECHA) = 2024
GROUP BY A.descripcion
ORDER BY 2 DESC

--MOST LOYAL CLIENT IN 2024
SELECT TOP 5
C.nom_cliente + SPACE(1) + C.ape_cliente 'CLIENTE',
SUM(DF.CANTIDAD * DF.pre_unitario) 'MONTO TOTAL QUE COMPRO'
FROM facturas F
JOIN detalle_facturas DF ON DF.nro_factura = F.nro_factura
JOIN clientes C ON F.cod_cliente = C.cod_cliente
WHERE YEAR(F.FECHA) = 2024
GROUP BY C.nom_cliente + SPACE(1) + C.ape_cliente
ORDER BY SUM(DF.CANTIDAD * DF.pre_unitario)  DESC

SELECT TOP 5
C.nom_cliente + SPACE(1) + C.ape_cliente 'CLIENTE',
COUNT(F.nro_factura) 'CANTIDAD DE VENTAS'
FROM facturas F
JOIN clientes C ON F.cod_cliente = C.cod_cliente
WHERE YEAR(F.FECHA) = 2024
GROUP BY C.nom_cliente + SPACE(1) + C.ape_cliente
ORDER BY COUNT(F.nro_factura)   DESC
-- BEST SELLER IN 2024
SELECT TOP 5
v.nom_vendedor + SPACE(1) + v.ape_vendedor 'VENDEDOR',
COUNT(F.nro_factura) 'VENTAS',
SUM(DF.CANTIDAD * DF.pre_unitario) 'MONTO TOTAL QUE VENDIO'
FROM vendedores V
JOIN FACTURAS F ON F.cod_vendedor = V.cod_vendedor
JOIN detalle_facturas DF ON DF.nro_factura = F.nro_factura
WHERE YEAR(F.FECHA) = 2024
GROUP BY V.nom_vendedor + SPACE(1) + v.ape_vendedor
ORDER BY SUM(DF.CANTIDAD * DF.pre_unitario)  DESC,COUNT(F.nro_factura) DESC
--ARTICULOS 


--Requerimientos del usuario del sistema:
--1. Se necesita saber a qué cliente se les vendió y qué vendedor realizó la venta
--en qué fecha y cuál fue el número de factura de los años 2010, 2017, 2018 y
--2022. (154)
SELECT
F.nro_factura 'NRO FACTURA',
C.nom_cliente + SPACE(1) + C.ape_cliente 'CLIENTE',
V.nom_vendedor + SPACE(1) + V.nom_vendedor 'VENDEDOR',
CONVERT(varchar,F.fecha,103) 'FECHA'
FROM facturas F
JOIN clientes C ON F.cod_cliente = C.cod_cliente
JOIN vendedores V ON F.cod_vendedor = V.cod_vendedor
WHERE YEAR(F.fecha) in (2010,2017,2018,2022)

--2. Emitir un reporte con los datos de todos los vendedores Si el vendedor ha
--tenido ventas en lo que va del año, muestre, además, el número de factura y
--la fecha de esas ventas.  (130)
SELECT 
V.nom_vendedor,
convert(varchar,F.fecha,103)
FROM vendedores V
JOIN facturas F ON F.cod_vendedor = v.cod_vendedor
WHERE YEAR(F.fecha) = YEAR(GETDATE())

--3. Generar un listado con los datos de las facturas incluidos los del vendedor y
--cliente) y de las ventas de esas facturas, incluido el importe; para las ventas
--de febrero y marzo de los años 2016 y 2020 y siempre que el artículo empiece
--con letras que van de la “a” a la “m”. Mostrar la fecha de la factura en orden
--día, mes y año, sin la hora.
SELECT
V.nom_vendedor + SPACE(1) + V.ape_vendedor 'VENDEDOR',
C.nom_cliente + SPACE(1) + C.ape_cliente 'CLIENTE',
A.descripcion 'ARTICULO',
DF.cantidad 'CANTIDAD VENDIDA',
STR(DF.pre_unitario * DF.cantidad,10,0) 'IMPORTE',
CONCAT(DATENAME(WEEKDAY,F.fecha),SPACE(1),CONVERT(varchar,F.fecha,103)) 'FECHA VENTA'
FROM FACTURAS F
JOIN vendedores V ON F.cod_vendedor = V.cod_vendedor
JOIN clientes C ON C.cod_cliente = F.cod_cliente
JOIN detalle_facturas DF ON DF.nro_factura = F.nro_factura
JOIN articulos A ON A.cod_articulo = DF.cod_articulo
WHERE MONTH(f.fecha) in (2,3)
AND YEAR(f.fecha) in (2016,2020)
AND a.descripcion like '[a-m]%'

--4. Se necesita mostrar el código, nombre, apellido y dirección completa en una
--sola columna de los clientes cuyo nombre comience con “C” y cuyo apellido
--termine con “Z” que fueron atendidos por vendedores que viven en barrios
--cuyos nombres no contienen letras que van de la “N” a la “P” o bien clientes
--cuyo de telefono o e-mail sean conocidos atendidos por vendedores de más
--de 50 años de edad que viven en calles con nombres que tienen más de 5
--letras.
SELECT
CONCAT(C.cod_cliente , ' | ' , C.nom_cliente ,SPACE(1) , c.ape_cliente , ' | ' ,c.calle,SPACE(1),c.altura) 'CLIENTE'
FROM clientes C
JOIN facturas F ON F.cod_cliente = C.cod_cliente
JOIN vendedores V ON V.cod_vendedor = F.cod_vendedor
JOIN barrios B ON V.cod_barrio = B.cod_barrio
WHERE C.nom_cliente LIKE 'C%' AND C.ape_cliente LIKE '%Z'
AND B.barrio NOT LIKE '%[N-P]%' 
OR ((C.[e-mail] IS NOT NULL OR C.[nro_tel] IS NOT NULL) AND DATEDIFF(YEAR,V.fec_nac,GETDATE()) > 50 AND LEN(V.calle) > 5  )


--5. Muestre los datos de los vendedores, cuyo cumpleaños sea el mes que viene
--(mes siguiente al actual), haya nacido en la década del 90 y que haya realizado
--ventas el mes pasado.
SELECT
V.nom_vendedor + SPACE(1) + V.ape_vendedor 'VENDEDOR',
YEAR(V.fec_nac) 'AÑO NACIMIENTO',
MONTH(V.fec_nac) 'MES CUMPLEAÑOS',
CONVERT(VARCHAR,F.fecha,103) 'VENTA EL MES PASADO'
FROM vendedores V
JOIN facturas F ON F.cod_vendedor = V.cod_vendedor
WHERE YEAR(v.fec_nac) between 1990 and 1999
AND MONTH(v.fec_nac) = MONTH(getdate()) +2
AND  MONTH(f.fecha) = month(GETDATE()) -1 AND YEAR(F.FECHA) = 2024

--6. Listar los datos de los artículos vendidos del 1 al 10 de cada mes dentro del
--año en curso cuyo precio al que fue vendido sea menor al precio actual, que
--tenga observaciones conocidas, y que estén en el momento de reposición
--(stock mínimo menor o igual al stock actual.


--7. Listar todos los datos de los artículos cuyo stock mínimo sea superior a 10 o
--cuyo precio sea inferior a 20. En ambos casos su descripción no debe
--comenzar con las letras “p”, “r” ni “v”, ni contener “h”, “j” ni “m”.


--8. Se quiere saber qué artículos se vendieron, siempre que el precio unitario sin
--iva al que fue vendido no esté entre $100 y $500 y que las ventas hayan sido
--realizadas por vendedores nacidos en febrero, abril, mayo o septiembre


--9. Emitir un reporte para informar qué artículos se vendieron, en las facturas
--cuyos números no estén entre 17 y 136. Liste la descripción, cantidad e
--importe (Importe=cantidad*pre_unitario). Ordenar por descripción y cantidad.
--No muestre las filas con valores duplicados
SELECT DISTINCT
A.descripcion 'ARTICULO',
DF.cantidad 'CANTIDAD VENDIDA',
DF.cantidad * DF.pre_unitario 'IMPORTE'
FROM articulos A
JOIN detalle_facturas DF ON DF.cod_articulo = A.cod_articulo
JOIN FACTURAS F ON DF.nro_factura = F.nro_factura
WHERE F.nro_factura NOT BETWEEN 17 AND 136
ORDER BY 'ARTICULO', DF.cantidad DESC

--10. Emitir un reporte de artículos vendidos en el 2021 a menos de $ 300 por
--vendedores hayan sido menor de 35 años, a qué precios se vendieron y qué
--precio tienen hoy. Mostrar el porcentaje de incremento.