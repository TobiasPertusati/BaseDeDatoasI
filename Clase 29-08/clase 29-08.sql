--Subsonsula
-- consulta que puede aparecer en un where o en un having
-- Operadores (de test de comparacion | in | EXISTS (test de existencia) | ANY (si alguna da true es TRUE) | ALL (TODAS TIENEN QUE SER TRUE))

--SELECT * 
--FROM PRODUCTOS
--WHERE IDPRODUCTO IN (SELECT IDPRODUCTO 
--					FROM DetallePedido 
--					WHERE Descuento = 0.25)
-- EN UNA SUBCONSULTA EN EL WHERE SOLO SE PUEDE PREGUNTAR POR UNA COLUMNA Y NO SE PUEDE USAR EL GRUOP BY
--

USE LIBRERIA
GO
--ссссссссссссссссссссссссссссссссссссссссссссссссссссvv

-- TODOS LOS ARTICULOS CUYO PRECIO UNITARIO SEA MENOR AL PRE_UNITARIO PROMEDIO DE LOS ARTICULOS
SELECT
a.cod_articulo,
descripcion 'articulo',
pre_unitario
FROM articulos a
WHERE pre_unitario < (SELECT 
					  AVG(pre_unitario)
				      FROM articulos)

-- Listar los datos de los clientes que no realizaron compras el aсo pasado (4)
SELECT
C.ape_cliente + SPACE(1) + C.nom_cliente 'CLIENTE'
FROM CLIENTES C
WHERE c.cod_cliente not in (select f.cod_cliente
						from facturas f
						where Year(fecha) = YEAR(getdate())- 1)

--LISTAR TODOS LOS CLIENTES QUE ALGUNA VEZ COMPRARON UN PRODUCTO MENOR A 10 PESOS
SELECT DISTINCT
C.ape_cliente + SPACE(1) + C.nom_cliente 'CLIENTE'
FROM CLIENTES C
JOIN FACTURAS F ON F.cod_cliente = C.cod_cliente
WHERE  10  > any (select df.pre_unitario
						from detalle_facturas df
						WHERE F.nro_factura = DF.nro_factura)

-- LISTADO DE FACTURAS EN LAS QUE UN PRECIO UNITARIO HAYA SIDO MENOR A 10
SELECT
F.nro_factura
FROM facturas F
WHERE 10 > ANY (SELECT DF.PRE_UNITARIO 
				FROM detalle_facturas DF
				WHERE F.nro_factura = DF.nro_factura)

-- Listar los clientes que compraron en el aсo pasado 
SELECT 
C.nom_cliente
FROM CLIENTES C
WHERE C.cod_cliente  = Any (SELECT F.cod_cliente FROM facturas F
							WHERE F.cod_cliente = C.cod_cliente)

-- Listar todos los clientes que fueron atendidos SOLO fueron atendidos por el vendodr numero 3
SELECT
C.nom_cliente + space(1) + c.ape_cliente 'CLIENTE'
FROM clientes c
WHERE  4 = ALL (select f.cod_vendedor 
							from facturas f
							where f.cod_cliente = c.cod_cliente)
AND 0 < (select count(*) 
							from facturas f
							where f.cod_cliente = c.cod_cliente)

--EMITIR UN LISTADO DE LOS ARTICULOS QUE NO FUERON VENDIDOS ESTE A;O. EN ESTE LISTADO
--SOLO INCLUIR, AQUELLOS CUYO PRECIO UNITARIO DEL ARTICULO OSCILE ENTRE 1000 Y 2000
SELECT
A.descripcion,
A.pre_unitario
FROM articulos A
WHERE A.cod_articulo not in (
							select df.cod_articulo
							from detalle_facturas Df
							join facturas f on f.nro_factura = df.nro_factura
							where datediff(year,f.fecha,getdate()) = 0
							)
and a.pre_unitario between 1000 and 2000

--ENUNCIADO 4
-- SE DEBERIAN LISTAR, EN UNA CONSULTA PRINCIPA, LOS VENDEDORES ON SUS VENTAS TOTALES
-- AGRUPADO POR VENDEDOR(COD Y NOMB) Y COMO CONDICION ES QUE SU VENTA TOTAL SEA
-- SUPERIO AL PROMEDIO GENERAL DE VENTAS
SELECT
CONCAT(V.cod_vendedor,' ', V.nom_vendedor),
SUM(Df.cantidad  * df.pre_unitario) 'VENTAS TOTALES',
FROM vendedores V
JOIN facturas F ON F.cod_vendedor = V.cod_vendedor
JOIN detalle_facturas DF ON DF.nro_factura = F.nro_factura
GROUP BY CONCAT(V.cod_vendedor,' ', V.nom_vendedor)
HAVING SUM(Df.cantidad  * df.pre_unitario) > (select sum(df.cantidad * df.pre_unitario)
												from detalle_facturas df)


