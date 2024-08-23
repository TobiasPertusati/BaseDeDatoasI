USE LIBRERIA
GO

-- 1) CALCULAR EL TOTAL FACTURADO POR CADA VENDEDOR Y CADA CLIENTE EL 
-- A;O PASADO ORDENADO POR VENDEDOR PRIMERO Y LUEGO POR CLIENTE

SELECT
v.nom_vendedor + SPACE(1) + v.ape_vendedor 'VENDEDOR',
C.nom_cliente + SPACE(1) + C.ape_cliente 'CLIENTE',
SUM(df.cantidad * df.pre_unitario) 'TOTAL FACTURADO'
FROM vendedores V
JOIN facturas F ON F.cod_vendedor = V.cod_vendedor
JOIN detalle_facturas DF ON DF.nro_factura = f.nro_factura
JOIN clientes C	 ON c.cod_cliente = F.cod_cliente
WHERE DATEDIFF(YEAR,F.fecha,GETDATE()) = 1
GROUP BY 
v.nom_vendedor + SPACE(1) + v.ape_vendedor,
C.nom_cliente + SPACE(1) + C.ape_cliente 
ORDER BY 1 , 2

--2) SE NESECCITA UN LISTADO QUE INFORME SOBRE EL MOTNO MAXIMO, MINIMO Y TOTAL QUE GASTO
-- EN ESTA LIBRERIA CADA CLIENTE E A;O PASADO, PERO SOLO DONDE EL IMPORTE TOAL GASTADO POR
-- CLIENTE ESTE CUANDO ESTE ENTRE 50.000 Y 90.000
SELECT
C.nom_cliente + SPACE(1) + C.ape_cliente 'CLIENTE' ,
MAX(df.pre_unitario) 'MAXIMO GASTADO EN UN PRODUCTO',
MIN(df.pre_unitario) 'MINIMO GASTADO EN UN PRODUCTO',
SUM(df.cantidad * df.pre_unitario) 'TOTAL GASTADO'
FROM clientes C
JOIN facturas F ON f.cod_cliente = c.cod_cliente
JOIN detalle_facturas DF ON F.nro_factura = DF.nro_factura
WHERE DATEDIFF(YEAR,F.fecha,GETDATE()) = 1
GROUP BY C.nom_cliente + SPACE(1) + C.ape_cliente
HAVING SUM(df.cantidad * df.pre_unitario) BETWEEN 50000 AND 90000

--FUNCIONES INCORPORADAS
-- MANEJO DE CADENAS
-- MATEMATICAS
-- floor | avg | ceeling | floor |round | low
-- FECHAS/HORAS

--3) DESDE LA ADMINISTRACION SE SOLICITA UN REPORTE QUE MUESTRE EL PRECIO PROMEDIO DE LOS ARTICULOS, EL IMP TOTAL
-- Y EL PROM DEL IMP VENDIDO POR ARTICULO QUE NO COMIENCEN CON C, Y QUE ESE IMPORTE TOTAL
-- VENDIDO SEA SUPERIOR A 20000.

SELECT
A.descripcion 'ARTICULO',
FLOOR(AVG(A.pre_unitario)) 'PRECIO PROM ARTICULO',
CEILING(SUM(DF.cantidad * DF.pre_unitario)) 'IMP TOTAL',
FLOOR(AVG(DF.pre_unitario * df.cantidad)) 'IMP PROM VENDIDO POR ART'
FROM articulos A
JOIN detalle_facturas DF ON DF.cod_articulo = A.cod_articulo
JOIN facturas F ON F.nro_factura = DF.nro_factura
WHERE A.descripcion NOT LIKE 'C%'
GROUP BY A.descripcion
HAVING SUM(DF.cantidad * DF.pre_unitario) > 20000

--4) CALCULAR EL TOTAL FACTURADO POR CADA VENDEDOR
-- Y A CADA CLIENTE , POR VENDEDOR PRIMERO Y LUEGO POR CLIENTE, 
-- ADEMAS MOSTRAR NOMBRE DEL DIA DE LA VENTA
-- ACOMPA;ADO DEL A;O QUE SE REALIZO , ORDENARLO POR DIA SEMANAL

-- AGRUPA LO FACTURADO POR DIA EN EL AÑO
SELECT
SUM(df.pre_unitario * df.cantidad) 'IMPORTE GENERADO',
DATENAME(weekday,f.fecha) 'DIA' ,
YEAR(F.FECHA) 'AÑO' 
FROM facturas F
JOIN detalle_facturas DF ON DF.nro_factura = F.nro_factura
GROUP BY
DATENAME(weekday,f.fecha),
YEAR(F.FECHA)
ORDER BY 2




