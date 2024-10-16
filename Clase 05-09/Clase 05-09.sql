-- SUBSONSULTA

USE LIBRERIA
GO


-- Quiero una factura que supere el promedio de todas las ventas

select
c.ape_cliente,
df.pre_unitario * df.cantidad 'precio'
from facturas fac
join clientes c on c.cod_cliente = fac.cod_cliente
join detalle_facturas df on df.nro_factura = fac.nro_factura
where (df.pre_unitario * df.cantidad) >= (select avg(df2.cantidad * df2.pre_unitario)
										from detalle_facturas df2 
										)

-- Quiero una factura que supere el promedio de todas las ventas por cliente

select
c.ape_cliente,
df.pre_unitario * df.cantidad 'precio compra' 
from facturas fac
join clientes c on c.cod_cliente = fac.cod_cliente
join detalle_facturas df on df.nro_factura = fac.nro_factura
where (df.pre_unitario * df.cantidad) >= (select avg(df2.cantidad * df2.pre_unitario)
										from detalle_facturas df2
										join facturas f on f.nro_factura = df2.nro_factura
										where f.cod_cliente = c.cod_cliente
										)
order by c.ape_cliente desc,df.pre_unitario * df.cantidad desc

select
c.ape_cliente,
avg(df.pre_unitario * df.cantidad)
from clientes c
join facturas f on c.cod_cliente = f.cod_cliente
join detalle_facturas df on df.nro_factura = f.nro_factura
where c.ape_cliente = 'Ruiz'
group by c.ape_cliente
-- las notas del estudiante que supera el promedio global de estudiantes

--El maximo gastado en una factura de cada cliente
select
c.ape_cliente,
MAX(df.pre_unitario * df.cantidad) 'MAXIMA FACTURA',
MIN(df.pre_unitario * df.cantidad) 'MINIMA FACTURA' ,
AVG(df.pre_unitario * df.cantidad) 'FACTURA PROMEDIO' 
from clientes c
join facturas f on c.cod_cliente = f.cod_cliente
join detalle_facturas df on df.nro_factura = f.nro_factura
group by c.ape_cliente
--

-- SE QUIERE SABER QUE CLIENTES NO VINIERON ENTRE EL 12/12/2015 Y EL 13/7/2020

SELECT
c.ape_cliente, f.fecha
FROM clientes c
join facturas f on f.cod_cliente = c.cod_cliente
where c.cod_cliente not in (select f2.cod_cliente
						from facturas f2
						where fecha between '12-12-2015' and  '13-7-2020')

--LISTAR LOS DATOS DE LAS FACTURAS DE LOS CLIENTES QUE SOLO VIENEN A COMPRAR EN FEBRERO 
--ES DECIR QUE TODAS LAS VECES QUE VIENEN A COMPRAR HAYA SIDO EN EL MES DE FEBRERO Y NO OTRO MES

SELECT
F.nro_factura,
convert(varchar,f.fecha,103) 'fecha',
C.ape_cliente 'cliente'
FROM FACTURAS F
join clientes c on c.cod_cliente = f.cod_cliente
WHERE 2 = ALL (select MONTH(f2.fecha)
				from facturas f2
				where f2.cod_cliente = c.cod_cliente)


-- REALIZAR UN LISTADO DE NUMERO DE FACTURA,FECHA,CLIENTE,ART E IMPORTE PARA LOS CASOS 
-- EN QUE AL MENOS UNO DE LOS IMPORTES DE ESA FACTURA SEA MENOR A 3.000
SELECT
F.nro_factura,
F.fecha,
C.ape_cliente,
A.descripcion,
DF.pre_unitario * DF.CANTIDAD
FROM facturas F
JOIN clientes C ON C.cod_cliente = F.cod_cliente
JOIN detalle_facturas DF ON DF.nro_factura = F.nro_factura
JOIN articulos A ON DF.cod_articulo = A.cod_articulo
WHERE 3000 > ANY (SELECT DF2.pre_unitario * DF2.cantidad
							 FROM detalle_facturas DF2
							 WHERE DF2.nro_factura = F.nro_factura
							 )
--
--


