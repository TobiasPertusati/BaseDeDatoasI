USE LIBRERIA

-- U1
-- UNA CONSULTA QUE MUESTRE LOS ARTICULOS QUE SE VENDIERON CON MAS FRENCUENCIA
-- EN MARZO 2024
SELECT TOP 5
a.descripcion 'articulo',
COUNT(df.cod_articulo) 'Ventas'
FROM articulos a
JOIN detalle_facturas DF ON DF.cod_articulo = A.cod_articulo
JOIN facturas F ON F.nro_factura = DF.nro_factura
WHERE YEAR(F.fecha) = YEAR(GETDATE()) 
AND MONTH(F.fecha) = 3
GROUP BY a.descripcion
ORDER BY  2 DESC

-- EL ARTICULO QUE SE VENDIO EN MAYOR CANTIDAD EN MARZO DEL 2024
SELECT TOP 5
a.descripcion 'ARTICULO',
SUM(df.cantidad) 'COMPRAS '
FROM articulos a
JOIN detalle_facturas DF ON DF.cod_articulo = A.cod_articulo
JOIN facturas F ON F.nro_factura = DF.nro_factura
WHERE YEAR(F.fecha) = YEAR(GETDATE()) 
AND MONTH(F.fecha) = 3
GROUP BY a.descripcion
ORDER BY  2 DESC

-- UNA CONSULTA QUE MUESTRE LOS CLIENTES QUE COMPRARON CON MAS FRECUENCIA

SELECT TOP 5
CONCAT(C.nom_cliente,SPACE(1),C.ape_cliente) 'CLIENTE',
COUNT(C.cod_cliente) 'CANTIDAD COMPRAS'
FROM clientes C
JOIN facturas F ON C.cod_cliente = F.cod_cliente
--JOIN detalle_facturas DF ON F.nro_factura = DF.nro_factura
WHERE YEAR(F.fecha) = YEAR(GETDATE()) 
--AND MONTH(F.fecha) = 3
GROUP BY CONCAT(C.nom_cliente,SPACE(1),C.ape_cliente)
ORDER BY 2 DESC

CREATE VIEW DESEMPENO_VENDEDOR
AS
(
	SELECT TOP 10
	CONCAT(V.nom_vendedor,SPACE(1),v.ape_vendedor) 'VENDEDOR',
	COUNT(V.cod_vendedor) 'CANTIDAD VENTAS'
	FROM VENDEDORES V
	JOIN facturas F ON V.cod_vendedor = F.cod_vendedor
	WHERE YEAR(F.fecha) = YEAR(GETDATE()) 
	GROUP BY CONCAT(V.nom_vendedor,SPACE(1),v.ape_vendedor)
	ORDER BY 2 DESC
)
SELECT * from DESEMPENO_VENDEDOR

CREATE VIEW GENERADO_POR_VENDEDOR
AS
(
	SELECT TOP 10
	CONCAT(V.nom_vendedor,SPACE(1),v.ape_vendedor) 'VENDEDOR',
	SUM(DF.cantidad * DF.pre_unitario) 'CANTIDAD GENERADO'
	FROM VENDEDORES V
	JOIN facturas F ON V.cod_vendedor = F.cod_vendedor
	JOIN detalle_facturas DF ON F.nro_factura = DF.nro_factura
	WHERE YEAR(F.fecha) = YEAR(GETDATE()) 
	GROUP BY CONCAT(V.nom_vendedor,SPACE(1),v.ape_vendedor)
	ORDER BY 2 DESC
)
SELECT * FROM GENERADO_POR_VENDEDOR

SELECT c.cod_cliente, c.ape_cliente, 'cliente' TIPO FROM  clientes C 
UNION
SELECT v.cod_vendedor, v.ape_vendedor, 'vendedor' FROM vendedores V

-- UNION ALL SELECIONA TODO LOS DATOS CON REPETIDOS

-- CREAR UNA CONSULTA QUE MUESTREN CLIENTES 
-- DESTACANDO LA FIDELIDAD SEGUN DOS O MAS CRITERIOS

-- 1) CRITERIO QUE COMPRE EN ENERO 
-- 3) CRITERIO LOS 5 CON MAYOR FRECUENCIA
-- 2) CRITERIO LOS CLIENTES QUE ME COMPRAN MAS DE 3 PRODUCTOS


SELECT  
C.cod_cliente,
C.ape_cliente + ' ' + C.ape_cliente 'CLIENTE', 
'COMPRA EN ENERO' TIPO
FROM clientes C
JOIN facturas  F ON F.cod_cliente = C.cod_cliente
WHERE MONTH(F.FECHA) = 1
GROUP BY C.cod_cliente,
C.ape_cliente + ' ' + C.ape_cliente 

UNION

SELECT TOP 5
C.cod_cliente, 
C.ape_cliente + ' ' + C.ape_cliente 'CLIENTE', 
'CON MAYOR FRECUENCIA'
FROM clientes C
JOIN facturas F ON C.cod_cliente = F.cod_cliente
GROUP BY C.cod_cliente 
,C.ape_cliente + ' ' + C.ape_cliente
ORDER BY COUNT(F.nro_factura) DESC

UNION

SELECT
C.cod_cliente, C.ape_cliente + ' ' + C.nom_cliente 'CLIENTE', 'COMPRO MAS DE 3 ARTICULOS EN UNA MISMA FAC'
FROM clientes C
WHERE 3 <= ANY ( SELECT COUNT(DF.cod_articulo)
			FROM detalle_facturas DF
			JOIN facturas F ON DF.nro_factura = F.nro_factura
			WHERE C.cod_cliente = F.cod_cliente
			GROUP BY F.nro_factura
			)
GROUP BY C.cod_cliente, C.ape_cliente + ' ' + C.nom_cliente

SELECT 
F.nro_factura,
COUNT(DF.COD_ARTICULO) 'Cantidad de Articulos'
FROM detalle_facturas DF
JOIN facturas F ON F.nro_factura = DF.nro_factura
JOIN clientes C ON C.cod_cliente = F.cod_cliente
WHERE F.cod_cliente = 3
GROUP BY F.nro_factura


--EJERCICIOS PARA ENTREGAR U1.4.2 - U1.4.7





