USE LIBRERIA 


-- SUBSCONSULTAS EN LA CLAUSULA WHERE

-- TEST DE COMPARACIÓN (<> != = < > >= <= )
-- COMPARA EL VALOR DE UNA EXPRESIÓN CON EL VALOR ÚNICO PRODUCIDO POR UNA SUBCONSULTA
SELECT
cod_articulo,descripcion,pre_unitario
FROM articulos
WHERE pre_unitario < (SELECT AVG(PRE_UNITARIO) FROM ARTICULOS)

-- TEST DE PERTENCIA
-- COMPARA UN ÚNICO VALOR DE DATOS CON UNA COLUMNA DE VALORES PRODUCIDA POR UNA SUBCONSULTA Y DEVUELVE TRUE
-- SI EL VALOR COINCIDE CON AL MENOS UNO DE LOS VALORES DE LA COLUMNA
SELECT
*
FROM clientes
WHERE cod_cliente IN (SELECT cod_cliente 
					   FROM facturas
					   WHERE YEAR(FECHA) = YEAR(GETDATE())
					  )

SELECT
*
FROM clientes
WHERE cod_cliente NOT IN (SELECT cod_cliente 
					   FROM facturas
					   WHERE YEAR(FECHA) = YEAR(GETDATE())
					  )

-- TEST DE EXISTENCIA
-- COMPRUEBA SI UNA SUBCONSULTA PRODUCE ALGUNA FILA DE RESULTADOS.
--
SELECT 
cod_cliente 'Código',
ape_cliente +' '+ nom_cliente 'Nombre'
FROM clientes c
WHERE EXISTS (SELECT cod_cliente
			 FROM facturas f
			 WHERE c.cod_cliente = f.cod_cliente
			 AND YEAR(fecha) = YEAR(GETDATE())
			)
--En este caso las subconsulta devolvería filas de resultado si el cliente que se
--quiere listar en la consulta principal (recuerde que se realiza el análisis fila a fila)
--posee algún registro en la tabla facturas correspondiente a la fecha con año igual al
--año de la fecha actual

--Observe el c.cod_cliente de la subconsulta es una referencia externa
--dado que se trata de un campo utilizado en la subconsulta y que pertenece a la
--tabla de la consulta principal.

SELECT 
cod_cliente 'Código',
ape_cliente +' '+ nom_cliente 'Nombre'
FROM clientes c
WHERE NOT EXISTS (SELECT cod_cliente
				  FROM facturas f
				  WHERE c.cod_cliente = f.cod_cliente
				  AND YEAR(fecha) = YEAR(GETDATE())-1
				 )

-- TEST CUANTIFICADOS
-- UTILIZAN LOS OPERADORES DE COMPARACIÓN ( = , < , <= , > , >= , <>)

-- ANY
-- SI ALGUNAS DE LAS COMPARACIÓNES INDIVIDUALES PRODUCEN UN RESULTADO TRUE, EL TEST
-- ANY DEVUELVE EL RESULTADO COMO TRUE.

SELECT *
FROM CLIENTES C
WHERE 10 > ANY (SELECT D.pre_unitario
				FROM FACTURAS F
				JOIN detalle_facturas D ON F.nro_factura = D.nro_factura
				WHERE C.cod_cliente = F.cod_cliente
				)
ORDER BY C.cod_cliente
/*
La subconsulta de este ejemplo lista todos los precios unitarios de los
artículos vendidos al cliente que la consulta principal quiere listar; si alguno de
éstos precios es menor a 10 entonces el registro de ese cliente forma parte de las
filas de resultado.
*/

-- ALL
--Si TODAS las comparaciones individuales producen un resultado TRUE, el test ALL
--devuelve un resultado TRUE. 

SELECT *
FROM clientes C
WHERE 4 = ALL (SELECT F.cod_vendedor
			    FROM facturas F 
				WHERE F.cod_cliente = C.cod_cliente
				)

-- SUBCONSULTAS EN LA CLAUSULA HAVING

--También pueden utilizarse subconsultas en la cláusula HAVING y funciona 
--como parte de la selección de un grupo de filas efectuada por esta cláusula.  
--Si se quisiera listar los vendedores cuyas ventas totales sea superior al 
--promedio general de ventas. 
 
--Se debería listar, en la consulta principal, los vendedores con sus ventas 
--totales agrupado por vendedor (código y nombre) y como condición en el HAVING 
--es que su venta total sea superior al resultado de una subconsulta; esta 
--subconsulta deberá calcular el promedio general de ventas.

SELECT
CONCAT(V.cod_vendedor,' ', V.nom_vendedor) 'VENDEDOR',
SUM(Df.cantidad  * df.pre_unitario) 'VENTAS TOTALES'
FROM vendedores V
JOIN facturas F ON F.cod_vendedor = V.cod_vendedor
JOIN detalle_facturas DF ON DF.nro_factura = F.nro_factura
GROUP BY CONCAT(V.cod_vendedor,' ', V.nom_vendedor)
HAVING SUM(Df.cantidad  * df.pre_unitario) > (select AVG(SUMA)
												FROM( SELECT
												sum(df.cantidad * df.pre_unitario) AS SUMA
												from detalle_facturas df
												join facturas  f on f.nro_factura = df.nro_factura
												group by f.cod_vendedor
												) as ventas_por_vendedor)

--Problema 2.1: Subconsultas en el Where

--1. Se solicita un listado de artículos cuyo precio es inferior al promedio de 
--precios de todos los artículos. (está resuelto en el material teórico) 
SELECT
A.descripcion,
A.pre_unitario
FROM articulos A
WHERE A.pre_unitario < (SELECT AVG(A2.pre_unitario)
						FROM ARTICULOS A2
					    )

--2. Emitir un listado de los artículos que no fueron vendidos este año. En 
--ese listado solo incluir aquellos cuyo precio unitario del artículo oscile 
--entre 50 y 100. 

SELECT
A.cod_articulo,
'NO SE VENDIO ESTE AÑO' TIPO
FROM facturas F
JOIN detalle_facturas DF ON F.nro_factura = DF.nro_factura
JOIN articulos A ON DF.cod_articulo = A.cod_articulo
WHERE A.cod_articulo NOT IN (SELECT DISTINCT DF2.cod_articulo
							 FROM detalle_facturas DF2 
							 JOIN FACTURAS F2 ON DF2.nro_factura = F2.nro_factura
							 WHERE DF2.pre_unitario BETWEEN 50 AND 100
							 AND YEAR(F2.fecha) = YEAR(GETDATE())
							)
GROUP BY A.cod_articulo
--3. Genere un reporte con los clientes que vinieron más de 2 veces el año 
--pasado.  

SELECT DISTINCT
CONCAT(C.ape_cliente,' ',C.nom_cliente) 'CLIENTE'
FROM clientes C
JOIN facturas F ON F.cod_cliente = C.cod_cliente
WHERE 2 < ANY (SELECT COUNT(*) 
			   FROM facturas F2
			   WHERE F2.cod_cliente = C.cod_cliente
			   AND YEAR(F2.fecha) = YEAR(GETDATE()) - 1
			  )

--4. Se quiere saber qué clientes no vinieron entre el 12/12/2015 y el 13/7/2020  

set dateformat dmy

SELECT
cod_cliente,
CONCAT(C.ape_cliente,' ',C.nom_cliente) 'CLIENTE'
FROM clientes C
WHERE c.cod_cliente NOT IN (SELECT f2.cod_cliente
							FROM facturas F2
							WHERE F2.cod_cliente = C.cod_cliente
							AND F2.fecha BETWEEN '12/12/2015' AND '13/7/2020'
						   )

--5. Listar los datos de las facturas de los clientes que solo vienen a comprar 
--en febrero es decir que todas las veces que vienen a comprar haya sido 
--en el mes de febrero (y no otro mes).  
SELECT
cod_cliente,
CONCAT(C.ape_cliente,' ',C.nom_cliente) 'CLIENTE'
FROM clientes C
WHERE 2 = ALL (SELECT MONTH(F2.FECHA)
				FROM facturas F2
				WHERE F2.cod_cliente = C.cod_cliente
				)

--6. Mostrar los datos de las facturas para los casos en que por año se hayan 
--hecho menos de 9 facturas.  


-- INTERPRETACIÓN SE PIDE MOSTRAR LOS DATOS DE LAS FACTURAS DE LOS AÑOS
-- EN LOS QUE SE HAYA FACTURADO MENOS DE 9 VECES EN ESE AÑO
SELECT 
F.nro_factura 'NRO_FACTURA',
CONCAT(C.ape_cliente,' ',C.nom_cliente) 'CLIENTE',
CONCAT(V.ape_vendedor,' ',V.nom_vendedor) 'VENDEDOR',
CONVERT(VARCHAR,F.FECHA,103) 'FECHA'
FROM facturas F
JOIN clientes C ON C.cod_cliente = F.cod_cliente
JOIN vendedores V ON V.cod_vendedor = F.cod_vendedor
WHERE YEAR(F.fecha) = any (select YEAR(F2.FECHA)
						FROM facturas F2
						GROUP BY YEAR(F2.FECHA)
						HAVING COUNT(*) < 9
					    )
ORDER BY F.FECHA

-- SELECT
--COUNT(*) 'facturas',
--YEAR(F.FECHA) 'año' 
--		FROM facturas F
--		GROUP BY YEAR(F.FECHA)
--		HAVING COUNT(*) < 9

--7. Emitir un reporte con las facturas cuyo importe total haya sido superior a 
--1.500 (incluir en el reporte los datos de los artículos vendidos y los 
--importes). 
SELECT 
F.nro_factura 'NRO_FACTURA',
CONVERT(VARCHAR,F.FECHA,103) 'FECHA',
a.descripcion 'ARTICULO',
DF.pre_unitario  'IMPORTE', 
DF.cantidad 'CANTIDAD',
(DF.cantidad * df.pre_unitario) 'SUB_TOTAL'
FROM facturas F
JOIN detalle_facturas DF ON DF.nro_factura = F.nro_factura
JOIN articulos A ON A.cod_articulo = DF.cod_articulo
WHERE F.nro_factura = ANY (SELECT DF2.nro_factura
						  FROM detalle_facturas DF2
						  WHERE DF2.nro_factura = F.nro_factura
						  GROUP BY DF2.nro_factura, (DF2.pre_unitario * DF2.cantidad)
						  HAVING (DF2.pre_unitario * DF2.cantidad) > 1500
						 )
--8. Se quiere saber qué vendedores nunca atendieron a estos clientes: 1 y 6. 
--Muestre solamente el nombre del vendedor. 

SELECT
V.cod_vendedor,
CONCAT(V.ape_vendedor,' ',V.nom_vendedor) 'VENDEDOR'
FROM vendedores V
WHERE V.cod_vendedor NOT IN (SELECT F2.cod_vendedor
							FROM facturas F2
							WHERE F2.cod_vendedor = V.cod_vendedor
							AND F2.cod_cliente IN (1,6)
						   )
--9. Listar los datos de los artículos que superaron el promedio del Importe 
--de ventas de $ 1.000.  

-- EL SELECT DE LA SUBQUERY BUSCA LOS ARTICULOS DENTRO DE UNA FACTURA EN LOS QUE
-- LA CANTIDAD QUE SE COMPRO * SU PRE_UNITARIO SUPEREN LOS 1000, SI LO ENCUENTRA LO
-- SELECCIONA Y LOS MUESTRA LA QUERY PRINCIPAL (todos los articulos que se vendieron
-- alguna vez superan esa condición, pero si se aumenta menos articulos cumplen la condición.)

SELECT
a.cod_articulo,
a.descripcion 'ARTICULO'
FROM articulos A
WHERE a.cod_articulo = any (
						select
						cod_articulo
						from detalle_facturas df
						join facturas f on f.nro_factura = df.nro_factura
						group by f.nro_factura, df.cod_articulo
						having sum(df.pre_unitario * df.cantidad) > 1000
						)
select * from detalle_facturas where nro_factura=586

--10. ¿Qué artículos nunca se vendieron? Tenga además en cuenta que su 
--nombre comience con letras que van de la “d” a la “p”.  Muestre 
--solamente la descripción del artículo.  

-- LA SUBQUERY BUSCA TODOS LOS CODIGOS DE LOS ARTICULOS QUE ALGUNA SE VENDIERON
-- Y DESPUES MUESTRA SOLO AQUELLOS QUE VAN CON LETRA DE LA D A LA P
-- SOLO 4 ARTICULOS NO SE VENDIERON NUNCA, PERO TRAE 3 POR EL FILTRO DE LA LETRA CON LA QUE EMPIEZA

SELECT
A.descripcion 'ARTICULO'
FROM  articulos A 
WHERE A.cod_articulo NOT IN (SELECT DISTINCT DF2.cod_articulo
							 FROM detalle_facturas DF2
							 JOIN ARTICULOS A2 ON A2.cod_articulo = DF2.cod_articulo
							)
AND A.descripcion like '[d-p]%'


--11. Listar número de factura, fecha y cliente para los casos en que ese 
--cliente haya sido atendido alguna vez por el vendedor de código 3. 

-- INTERPRETACIÓN TODAS LAS FACTURAS DEL CLIENTE, SIN IMPORTAR QUIEN LE HAYA VENDIDO
-- PERO SI O SI ALGUNA VEZ SE TUVO QUE HABER ATENTIDO CON EL VENDEDOR (3)

SELECT 
F.nro_factura 'NRO_FACTURA',
CONCAT(C.ape_cliente,' ',C.nom_cliente) 'CLIENTE',
CONVERT(VARCHAR,F.FECHA,103) 'FECHA',
f.cod_vendedor
FROM facturas F
JOIN clientes C ON C.cod_cliente = F.cod_cliente
WHERE c.cod_cliente = ANY (select f2.cod_cliente
						   from facturas f2 
						   where f2.cod_vendedor = 3
						   )
						   
--12. Listar número de factura, fecha, artículo, cantidad e importe para los 
--casos en que todas las cantidades (de unidades vendidas de cada 
--artículo) de esa factura sean superiores a 40.  



--13. Emitir un listado que muestre número de factura, fecha, artículo, 
--cantidad e importe; para los casos en que la cantidad total de unidades 
--vendidas sean superior a 80.  


--14. Realizar un listado de número de factura, fecha, cliente, artículo e 
--importe para los casos en que al menos uno de los importes de esa 
--factura sea menor a 3.000.


--Problema 2.2: Subconsultas en el Having 
--Los usuarios finales del sistema en esta oportunidad necesitan obtener los 
--siguientes reportes de información para el funcionamiento del negocio y la toma de 
--decisiones: 

--1. Se quiere saber ¿cuándo realizó su primer venta cada vendedor? y 
--¿cuánto fue el importe total de las ventas que ha realizado? Mostrar 
--estos datos en un listado solo para los casos en que su importe 
--promedio de vendido sea superior al importe promedio general (importe 
--promedio de todas las facturas).  

--2. Liste los montos totales mensuales facturados por cliente y además del 
--promedio de ese monto y el promedio de precio de artículos Todos esto 
--datos correspondientes a período que va desde el 1° de febrero al 30 de 
--agosto del 2014. Sólo muestre los datos si esos montos totales son 
--superiores o iguales al promedio global.  

--3. Por cada artículo que se tiene a la venta, se quiere saber el importe 
--promedio vendido, la cantidad total vendida por artículo, para los casos 
--en que los números de factura no sean uno de los siguientes: 2, 10, 7, 13, 
--22 y que ese importe promedio sea inferior al importe promedio de ese 
--artículo.  

--4. Listar la cantidad total vendida, el importe y promedio vendido por fecha, 
--siempre que esa cantidad sea superior al promedio de la cantidad global. 
--Rotule y ordene.  

--5. Se quiere saber el promedio del importe vendido y la fecha de la primer 
--venta por fecha y artículo para los casos en que las cantidades vendidas 
--oscilen entre 5 y 20 y que ese importe sea superior al importe promedio 
--de ese artículo.  

--6. Emita un listado con los montos diarios facturados que sean inferior al 
--importe promedio general.  

--7. Se quiere saber la fecha de la primera y última venta, el importe total 
--facturado por cliente para los años que oscilen entre el 2010 y 2015 y que 
--el importe promedio facturado sea menor que el importe promedio total 
--para ese cliente.  

--8. Realice un informe que muestre cuánto fue el total anual facturado por 
--cada vendedor, para los casos en que el nombre de vendedor no 
--comience con ‘B’ ni con ‘M’, que los números de facturas oscilen entre 5 
--y 25 y que el promedio del monto facturado sea inferior al promedio de 
--ese año. 


--Problema 2.3: Otras Subconsultas 
--1. Se quiere listar el precio de los artículos y la diferencia de éste con el 
--precio del artículo más caro: 

--2. Listar el precio actual de los artículos y el precio histórico vendido más 
--barato 

--3. Se quiere emitir un listado de las facturas del año en curso detallando 
--número de factura, cliente, fecha y total de la misma. 

--4. Emitir un listado con la código y descripción de los artículos su precio 
--actual, el precio promedio al cuál se vendió el año pasado (ver diferencia 
--entre el promedio ponderado y el promedio simple) 

--5. Generar un reporte un listado con la código y descripción de los artículos 
--su precio actual, el precio más barato y el más caro al que se vendió hace 
--5 años. 

--6. Descontar un 3,5% los precios de los artículos que se vendieron menos 
--de 5 unidades los últimos 3 meses. 

--7. Se quiere eliminar los clientes que no vinieron nunca. 

--8. Eliminar los clientes que hace más de 10 años que no vienen 