use LIBRERIA


--Problema 1.1: Consultas Sumarias

--1.1.1
--Facturación total del negocio
select SUM(pre_unitario*cantidad) 'Facturación Total'
	from detalle_facturas 

--1.1.2 
--También se quiere saber el total de la factura Nro. 236, la cantidad de
--artículos vendidos, cantidad de ventas, el precio máximo y mínimo vendido.
select SUM(pre_unitario*cantidad) 'Total',
		SUM(cantidad) 'Cant. de Artículos',
		COUNT(*) 'Cant. de Items',
		MAX(pre_unitario) 'Mayor precio',
		MIN(pre_unitario) 'Menor precio'
	from detalle_facturas
	where nro_factura = 236

--1.1.3 --> Consigna incompleta!!!
--Se nos solicita además lo siguiente: ¿Cuánto se facturó el año pasado?
select SUM(pre_unitario*cantidad) 'Facturacion Total del año'
	from detalle_facturas df, facturas f
	where df.nro_factura = f.nro_factura
		and YEAR(fecha) = YEAR(GETDATE()) - 1

--1.1.4
--¿Cantidad de clientes con dirección de e-mail sea conocido (no nulo)
select COUNT(*) 'Cantidad de Clientes',
		COUNT ([e-mail]) 'Cantidad de Clientes con e-mail conocido'
	from clientes

--1.1.5
--¿Cuánto fue el monto total de la facturación de este negocio?
--¿Cuántas facturas se emitieron?
select SUM(pre_unitario*cantidad) 'Facturación Total',
		COUNT(f.nro_factura) 'Cantidad de detalles de Facturas',
		COUNT(distinct f.nro_factura) 'Cantidad de Facturas'
	from detalle_facturas df, facturas f
	where df.nro_factura = f.nro_factura

--1.1.6
--Se necesita conocer el promedio de monto facturado por factura el año pasado.
select AVG(pre_unitario*cantidad) 'Promedio por detalle de Factura',
		SUM(pre_unitario*cantidad)/COUNT(distinct df.nro_factura) 'Promedio por Factura'
	from detalle_facturas df, facturas f
	where df.nro_factura = f.nro_factura
		and YEAR(fecha) = YEAR(GETDATE()) - 1

--1.1.7
--Se quiere saber la cantidad de ventas que hizo el vendedor de código 3.
select COUNT(*) 'Cantidad de Ventas'
	from facturas
	where cod_vendedor = 3

--1.1.8
-- ¿Cuál fue la fecha de la primera y última venta que se realizó en 
--este negocio?
select FORMAT(MIN(fecha), 'dd MMM yyyy') 'Fecha de primera venta',
		FORMAT(MAX(fecha), 'dd MMM yyyy') 'Fecha de última venta'
	from facturas

--1.1.9
--Mostrar la siguiente información respecto a la factura nro.: 450:
--cantidad total de unidades vendidas, la cantidad de artículos 
--diferentes vendidos y el importe total.
select SUM(cantidad) 'Cant. total de unidades vendidas',
		COUNT(distinct cod_articulo) 'Cant. de articulos diferentes',
		SUM(pre_unitario*cantidad) 'Importe Total'
	from detalle_facturas
	where nro_factura = 450

--1.1.10
--¿Cuál fue la cantidad total de unidades vendidas, importe total 
--y el importe promedio para vendedores cuyos nombres 
--comienzan con letras que van de la “d” a la “l”?
select SUM(cantidad) 'Cant. Total unidades vendidas',
		SUM(pre_unitario*cantidad) 'Importe Total',
		AVG(pre_unitario*cantidad) 'Importe Promedio'
	from detalle_facturas, vendedores
	where nom_vendedor like '[d-l]%'

--1.1.11
--Se quiere saber el importe total vendido, el promedio del importe vendido y
--la cantidad total de artículos vendidos para el cliente Roque Paez.
select SUM(df.pre_unitario*df.cantidad) 'Importe Total vendido',
		AVG(df.pre_unitario*df.cantidad) 'Promedio de importe vendido',
		SUM(df.cantidad) 'Total de artículos vendidos'
	from detalle_facturas df
		join facturas f on f.nro_factura = df.nro_factura
		join clientes c on c.cod_cliente = f.cod_cliente
	where c.ape_cliente = 'Paez'
		and c.nom_cliente = 'Roque'

--1.1.12
--Mostrar la fecha de la primera venta, la cantidad total vendida y el importe
--total vendido para los artículos que empiecen con “C”.
select FORMAT(MIN(f.fecha), 'dd MMM yyyy') 'Fecha primera venta',
		SUM(df.cantidad) 'Cantidad Total vendida',
		SUM(df.pre_unitario*df.cantidad) 'Importe Total Vendido'
	from facturas f
		join detalle_facturas df on df.nro_factura = f.nro_factura
		join articulos a on a.cod_articulo = df.cod_articulo
	where a.descripcion like 'C%'

--1.1.13
--Se quiere saber la cantidad total de artículos vendidos y el importe total
--vendido para el periodo del 15/06/2011 al 15/06/2017.
select SUM(cantidad)'Cant. Total de artículos vendidos',
		SUM(pre_unitario*cantidad) 'Importe Total vendido'
	from detalle_facturas, facturas
	where fecha between '15/06/2011' and '15/06/2017'

--1.1.14
--Se quiere saber la cantidad de veces y la última vez que vino el cliente de
--apellido Abarca y cuánto gastó en total.
select COUNT(distinct df.nro_factura) 'Cant. de veces que vino el cliente',
		FORMAT(MAX(f.fecha), 'dd MMM yyyy') 'Última vez que vino el cliente',
		SUM(df.pre_unitario*df.cantidad) 'Total gastado por el cliente'
	from facturas f
		join clientes c on c.cod_cliente= f.cod_cliente 
		join detalle_facturas df on df.nro_factura = f.nro_factura
	where c.ape_cliente = 'Abarca'
	
--1.1.15
--Mostrar el importe total y el promedio del importe para los clientes cuya
--dirección de mail es conocida
select SUM(df.pre_unitario*df.cantidad) 'Importe Total',
		AVG(df.pre_unitario*df.cantidad) 'Promedio de importe'
	from detalle_facturas df
		join facturas f on f.nro_factura = df.nro_factura
		join clientes c on c.cod_cliente = f.cod_cliente
	where c.[e-mail] is not null

--1.1.16 --> Se agrega el promedio por factura!!!
--Obtener la siguiente información: el importe total vendido y el importe
--promedio vendido para números de factura que no sean los siguientes: 13,
--5, 17, 33, 24.
select SUM(pre_unitario*cantidad) 'Importe Total',
		AVG(pre_unitario*cantidad) 'Importe promedio',
		SUM(pre_unitario*cantidad)/COUNT(distinct nro_factura) 'Promedio por factura'
	from detalle_facturas
	where nro_factura in (13, 5, 17, 33, 24)

--<<------------------------------------------------------>>--

--Problema 1.2: Consultas agrupadas: Cláusula GROUP BY

--1.2.1
--Los importes totales de ventas por cada artículo que se tiene en el negocio
select cod_articulo 'Artículo',
		SUM(pre_unitario*cantidad) 'Total por artículo'
	from detalle_facturas
	group by cod_articulo

--1.2.2
--Por cada factura emitida mostrar la cantidad total de artículos vendidos
--(suma de las cantidades vendidas), la cantidad ítems que tiene cada factura
--en el detalle (cantidad de registros de detalles) y el Importe total de la
--facturación de este año.
select df.nro_factura,
		SUM(df.cantidad) 'Artículos vendidos',
		COUNT(*) 'Cant. Items',
		SUM(df.pre_unitario*df.cantidad) 'Importe total'
	from detalle_facturas df
		join facturas f on f.nro_factura = df.nro_factura
	where YEAR(f.fecha) = YEAR(GETDATE())
	group by df.nro_factura

--1.2.3
--Se quiere saber en este negocio, cuánto se factura:
--a. Diariamente
--b. Mensualmente
--c. Anualmente
--a)
select FORMAT(f.fecha, 'dd MMM yyyy') 'Fecha',
		SUM(df.pre_unitario*df.cantidad) 'Facturación Diaria'
	from detalle_facturas df
		join facturas f on f.nro_factura = df.nro_factura
	group by f.fecha
	order by f.fecha
--b)
select YEAR(f.fecha) 'Año',
		MONTH(f.fecha) 'Mes',
		SUM(df.pre_unitario*df.cantidad) 'Facturación Mensual'
	from detalle_facturas df
		join facturas f on f.nro_factura = df.nro_factura
	group by YEAR(f.fecha), MONTH(f.fecha)
	order by 1
--c)
select YEAR(f.fecha) 'Año',
		SUM(df.pre_unitario*df.cantidad) 'Facturación Anual'
	from detalle_facturas df
		join facturas f on f.nro_factura = df.nro_factura
	group by YEAR(f.fecha)
	order by 1

--1.2.4
--Emitir un listado de la cantidad de facturas confeccionadas diariamente,
--correspondiente a los meses que no sean enero, julio ni diciembre. Ordene
--por la cantidad de facturas en forma descendente y fecha.
select FORMAT(fecha, 'yyyy/MM/dd') 'Fecha',
		--fecha,
		COUNT(nro_factura) 'Facturas emitidas'
	from facturas
	where MONTH(fecha) not in (1, 7, 12)
	group by fecha
	order by 2 desc, fecha asc

--1.2.5
--Se quiere saber la cantidad y el importe promedio vendido por fecha y
--cliente, para códigos de vendedor superiores a 2. Ordene por fecha y
--cliente.
select FORMAT(fecha, 'yyyy/MM/dd') 'Fecha',
		CONCAT(c.ape_cliente, ' ', c.nom_cliente) 'Cliente' ,
		SUM(df.cantidad) 'Cantidad',
		SUM(df.pre_unitario*df.cantidad)/COUNT(df.nro_factura) 'Promedio de venta'
	from detalle_facturas df
		join facturas f on f.nro_factura = df.nro_factura
		join clientes c on c.cod_cliente = f.cod_cliente
	where f.cod_vendedor > 2
	group by f.fecha, CONCAT(c.ape_cliente, ' ', c.nom_cliente)
	order by f.fecha, 2

--1.2.6
--Se quiere saber el importe promedio vendido y la cantidad total vendida por
--fecha y artículo, para códigos de cliente inferior a 3. Ordene por fecha y
--artículo
select FORMAT(f.fecha, 'yyyy/MM/dd') 'Fecha',
		a.descripcion 'Artículo',
		AVG(df.pre_unitario*df.cantidad) 'Importe promedio vendido',
		SUM(df.cantidad) 'Cantidad Total vendida'
	from detalle_facturas df
		join facturas f on f.nro_factura = df.nro_factura
		join articulos a on a.cod_articulo = df.cod_articulo
	where f.cod_cliente < 3
	group by f.fecha, a.descripcion
	order by 1, 2

--1.2.7
--Listar la cantidad total vendida, el importe total vendido y el importe
--promedio total vendido por número de factura, siempre que la fecha no
--oscile entre el 13/2/2007 y el 13/7/2010.
select df.nro_factura 'factura',
		SUM(df.cantidad) 'Cantidad vendida',
		SUM(df.pre_unitario*df.cantidad) 'Importe Total vendido',
		AVG(df.pre_unitario*df.cantidad) 'Promedio vendido'
	from detalle_facturas df
		join facturas f on f.nro_factura = df.nro_factura
	where f.fecha not between '03/02/2007' and '13/07/2010'
	group by df.nro_factura

--1.2.8
--Emitir un reporte que muestre la fecha de la primer y última venta y el
--importe comprado por cliente. Rotule como CLIENTE, PRIMER VENTA,
--ÚLTIMA VENTA, IMPORTE.
select CONCAT(c.ape_cliente, ' ', c.nom_cliente) 'CLIENTE',
		FORMAT(MIN(f.fecha), 'yyyy/MM/dd') 'PRIMER VENTA',
		FORMAT(MAX(f.fecha), 'yyyy/MM/dd') 'ÚLTIMA VENTA',
		SUM(df.pre_unitario*df.cantidad) 'IMPORTE'
	from facturas f
		join detalle_facturas df on df.nro_factura = f.nro_factura
		join clientes c on c.cod_cliente = f.cod_cliente
	group by CONCAT(c.ape_cliente, ' ', c.nom_cliente)

--1.2.9
--Se quiere saber el importe total vendido, la cantidad total vendida y el precio
--unitario promedio por cliente y artículo, siempre que el nombre del cliente
--comience con letras que van de la “a” a la “m”. Ordene por cliente, precio
--unitario promedio en forma descendente y artículo. Rotule como IMPORTE
--TOTAL, CANTIDAD TOTAL, PRECIO PROMEDIO.
select CONCAT(c.ape_cliente, ' ', c.nom_cliente) 'Cliente',
		a.descripcion 'Artículo',
		SUM(df.pre_unitario*df.cantidad) 'IMPORTE TOTAL',
		SUM(df.cantidad) 'CANTIDAD TOTAL',
		AVG(df.pre_unitario) 'PRECIO PROMEDIO'
	from detalle_facturas df
		join facturas f on f.nro_factura = df.nro_factura
		join clientes c on c.cod_cliente = f.cod_cliente
		join articulos a on a.cod_articulo = df.cod_articulo
	where c.nom_cliente like '[a-m]%'
	group by CONCAT(c.ape_cliente, ' ', c.nom_cliente), a.descripcion
	order by 1, 5 desc, 2 

--1.2.10
--Se quiere saber la cantidad de facturas y la fecha la primer y última factura
--por vendedor y cliente, para números de factura que oscilan entre 5 y 30.
--Ordene por vendedor, cantidad de ventas en forma descendente y cliente.
select CONCAT(v.ape_vendedor, ' ', v.nom_vendedor) 'Vendedor',
		CONCAT(c.ape_cliente, ' ', c.nom_cliente) 'Cliente',
		COUNT(f.nro_factura) 'Ventas',
		FORMAT(MIN(f.fecha), 'yyyy/MM/dd') 'Primer venta',
		FORMAT(MAX(f.fecha), 'yyyy/MM/dd') 'Última venta'
	from facturas f
		join vendedores v on v.cod_vendedor = f.cod_vendedor
		join clientes c on c.cod_cliente = f.cod_cliente
	where f.nro_factura between 5 and 30
	group by CONCAT(v.ape_vendedor, ' ', v.nom_vendedor), CONCAT(c.ape_cliente, ' ', c.nom_cliente)	
	order by 1, 3 desc, 2 
	
--<<------------------------------------------------------>>--

--Problema 1.3: Consultas agrupadas: Cláusula HAVING

--1.3.1
--Se necesita saber el importe total de cada factura, pero solo aquellas donde
--ese importe total sea superior a 2500.
select nro_factura,
		SUM(pre_unitario*cantidad) 'Total'
	from detalle_facturas 
	group by nro_factura
	having SUM(pre_unitario*cantidad) > 2500

--1.3.2
--Se desea un listado de vendedores y sus importes de ventas del año 2017
--pero solo aquellos que vendieron menos de $ 17.000.- en dicho año.
select f.cod_vendedor 'Código',
		v.ape_vendedor 'Apellido',
		SUM(df.pre_unitario*df.cantidad) 'Total'
	from detalle_facturas df
		join facturas f on f.nro_factura = f.nro_factura
		join vendedores v on v.cod_vendedor = f.cod_vendedor
	where YEAR(f.fecha) = 2017
	group by f.cod_vendedor, v.ape_vendedor
	having SUM(df.pre_unitario*df.cantidad) < 17000

--1.3.3
--Se quiere saber la fecha de la primera venta, la cantidad total vendida y el
--importe total vendido por vendedor para los casos en que el promedio de
--la cantidad vendida sea inferior o igual a 56.select CONCAT(v.ape_vendedor, ' ', v.nom_vendedor) 'Vendedor',
		FORMAT(MIN(f.fecha), 'yyyy/MM/dd') 'Primer venta',
		SUM(df.cantidad) 'Cant. vendida',
		SUM(df.pre_unitario*df.cantidad) 'Total vendido'
	from detalle_facturas df
		join facturas f  on f.nro_factura = df.nro_factura
		join vendedores v on v.cod_vendedor = f.cod_vendedor
	group by CONCAT(v.ape_vendedor, ' ', v.nom_vendedor)
	having AVG(df.cantidad) <= 56

--1.3.4
--Se necesita un listado que informe sobre el monto máximo, mínimo y total
--que gastó en esta librería cada cliente el año pasado, pero solo donde el
--importe total gastado por esos clientes esté entre 300 y 800.
select CONCAT(c.ape_cliente, ' ', c.nom_cliente) 'Cliente',
		MAX(df.pre_unitario*df.cantidad) 'Máximo gastado',
		MIN(df.pre_unitario*df.cantidad) 'Mínimo gastado',
		SUM(df.pre_unitario*df.cantidad) 'Total gastado'
	from detalle_facturas df
		join facturas f on f.nro_factura = df.nro_factura
		join clientes c on c.cod_cliente = f.cod_cliente
	where YEAR(f.fecha) = YEAR(GETDATE()) - 1
	group by CONCAT(c.ape_cliente, ' ', c.nom_cliente)
	having SUM(df.pre_unitario*df.cantidad) between 300 and 800

--1.3.5
--Muestre la cantidad facturas diarias por vendedor; para los casos en que
--esa cantidad sea 2 o más.
select FORMAT(f.fecha, 'yyyy/MM/dd') 'Fecha',
		CONCAT(v.ape_vendedor, ' ', v.nom_vendedor) 'Vendedor',
		COUNT(f.nro_factura) 'Cant. facturas'
	from facturas f
		join vendedores v on v.cod_vendedor = f.cod_vendedor
	group by CONCAT(v.ape_vendedor, ' ', v.nom_vendedor), f.fecha
	having COUNT(f.nro_factura) >= 2

--1.3.6
--Desde la administración se solicita un reporte que muestre el precio
--promedio, el importe total y el promedio del importe vendido por artículo
--que no comiencen con “c”, que su cantidad total vendida sea 100 o más o
--que ese importe total vendido sea superior a 700.
select a.descripcion 'Artículo',
		AVG(df.pre_unitario) 'Precio promedio',
		SUM(df.pre_unitario*df.cantidad) 'Importe Total',
		AVG(df.pre_unitario*df.cantidad) 'Importe promedio'
	from detalle_facturas df
		join articulos a on a.cod_articulo = df.cod_articulo
	where a.descripcion not like 'c%'
	group by a.descripcion
	having SUM(df.cantidad) > 700

--1.3.7
--Muestre en un listado la cantidad total de artículos vendidos, el importe
--total y la fecha de la primer y última venta por cada cliente, para lo
--números de factura que no sean los siguientes: 2, 12, 20, 17, 30 y que el
--promedio de la cantidad vendida oscile entre 2 y 6. 
select CONCAT(c.ape_cliente, ' ', c.nom_cliente) 'Cliente',
		SUM(df.cantidad) 'Total artículos vendidos',
		SUM(df.pre_unitario*df.cantidad) 'Importe Total',
		FORMAT(MIN(f.fecha), 'yyyy/MM/dd') 'Primer venta',
		FORMAT(MAX(f.fecha), 'yyyy/MM/dd') 'Última venta'
	from detalle_facturas df
		join facturas f on f.nro_factura = df.nro_factura
		join clientes c on c.cod_cliente = f.cod_cliente
	where df.nro_factura not in (2, 12, 20, 17, 30)
	group by CONCAT(c.ape_cliente, ' ', c.nom_cliente)
	having AVG(df.cantidad) between 2 and 6

--1.3.8
--Emitir un listado que muestre la cantidad total de artículos vendidos, el
--importe total vendido y el promedio del importe vendido por vendedor y
--por cliente; para los casos en que el importe total vendido esté entre 200
--y 600 y para códigos de cliente que oscilen entre 1 y 5.
select CONCAT(v.ape_vendedor, ' ', v.nom_vendedor) 'Vendedor',
		CONCAT(c.ape_cliente, ' ', c.nom_cliente) 'Cliente',
		SUM(df.cantidad) 'Total artículos vendidos',
		SUM(df.pre_unitario*df.cantidad) 'Importe Total',
		AVG(df.pre_unitario*df.cantidad) 'Promedio vendido'
	from detalle_facturas df
		join facturas f on f.nro_factura = df.nro_factura
		join vendedores v on v.cod_vendedor = f.cod_vendedor
		join clientes c on c.cod_cliente = f.cod_cliente
--	where f.cod_cliente between 1 and 5
	group by CONCAT(v.ape_vendedor, ' ', v.nom_vendedor), 
				CONCAT(c.ape_cliente, ' ', c.nom_cliente)
	having SUM(df.pre_unitario*df.cantidad) between 200 and 600

--1.3.9
--¿Cuáles son los vendedores cuyo promedio de facturación el mes pasado
--supera los $ 800?select CONCAT(v.ape_vendedor, ' ', v.nom_vendedor) 'Vendedor',
		SUM(df.pre_unitario*df.cantidad)/COUNT(df.nro_factura) 'promedio facturacion'
	from detalle_facturas df
		join facturas f on f.nro_factura = df.nro_factura
		join vendedores v on v.cod_vendedor = f.cod_vendedor
	where MONTH(f.fecha) = MONTH(GETDATE()) - 1
	group by CONCAT(v.ape_vendedor, ' ', v.nom_vendedor)
	having SUM(df.pre_unitario*df.cantidad)/COUNT(df.nro_factura) > 800

--1.3.10
--¿Cuánto le vendió cada vendedor a cada cliente el año pasado siempre
--que la cantidad de facturas emitidas (por cada vendedor a cada cliente)
--sea menor a 5?select CONCAT(v.ape_vendedor, ' ', v.nom_vendedor) 'Vendedor',
		CONCAT(c.ape_cliente, ' ', c.nom_cliente) 'Cliente', 
		SUM(df.pre_unitario*df.cantidad) 'Total vendido',
		COUNT(df.nro_factura) 'Cant. facturas'
	from detalle_facturas df
		join facturas f on f.nro_factura = df.nro_factura
		join vendedores v on f.cod_vendedor = f.cod_vendedor
		join clientes c on c.cod_cliente = f.cod_cliente
	where YEAR(f.fecha) = YEAR(GETDATE()) - 1
	group by CONCAT(v.ape_vendedor, ' ', v.nom_vendedor), 
				CONCAT(c.ape_cliente, ' ', c.nom_cliente)
	having COUNT(df.nro_factura) < 5

--<<------------------------------------------------------>>--

--Problema 1.4: Combinación de resultados de consultas. UNION

--1.4.1
--Confeccionar un listado de los clientes y los vendedores indicando a qué grupo
--pertenece cada uno. 
select CONCAT(ape_cliente, ' ', nom_cliente) 'Nombre',
		'Cliente' 'Tipo'
	from clientes
union
select CONCAT(ape_vendedor, ' ', nom_vendedor),
		'Vendedor' 
	from vendedores

--1.4.2
--Se quiere saber qué vendedores y clientes hay en la empresa; para los casos en
--que su teléfono y dirección de e-mail sean conocidos. Se deberá visualizar el
--código, nombre y si se trata de un cliente o de un vendedor. Ordene por la columna
--tercera y segunda.
select cod_vendedor 'Código',
		CONCAT(ape_vendedor, ' ', nom_vendedor) 'Nombre',
		'Vendedor' 'Tipo'
	from vendedores
	where [e-mail] is not null
		and nro_tel is not null
union
select cod_cliente,
		CONCAT(ape_cliente, ' ', nom_cliente),
		'Cliente'
	from clientes
	where [e-mail] is not null
		and nro_tel is not null
	order by 3, 2

--1.4.3
--Emitir un listado donde se muestren qué artículos, clientes y vendedores hay en
--la empresa. Determine los campos a mostrar y su ordenamiento.select descripcion 'Nombre',
		'Artículo' 'Tipo'
	from articulos
union
select CONCAT(ape_cliente, ' ', nom_cliente),
		'Cliente'
	from clientes
union
select CONCAT(ape_vendedor, ' ', nom_vendedor),
		'Vendedor'
	from vendedores
order by 2, 1

--1.4.4
--Se quiere saber las direcciones (incluido el barrio) tanto de clientes como de
--vendedores. Para el caso de los vendedores, códigos entre 3 y 12. En ambos casos
--las direcciones deberán ser conocidas. Rotule como NOMBRE, DIRECCION,
--BARRIO, INTEGRANTE (en donde indicará si es cliente o vendedor). Ordenado por
--la primera y la última columna.
--1.4.5
--Ídem al ejercicio anterior, sólo que además del código, identifique de donde
--obtiene la información (de qué tabla se obtienen los datos).
select CONCAT(c.ape_cliente, ' ', c.nom_cliente) 'NOMBRE',
		CONCAT(c.calle, ' ', c.altura) 'DIRECCIÓN',
		b.barrio 'BARRIO',
		'Cliente' 'INTEGRANTE'
	from clientes c
		join barrios b on b.cod_barrio = c.cod_barrio
	where 'DIRECCIÓN' is not null
union
select CONCAT(v.ape_vendedor, ' ', v.nom_vendedor), 
		CONCAT(v.calle, ' ', v.altura),
		b.barrio,
		'Vendedor'
	from vendedores v
		join barrios b on b.cod_barrio = v.cod_barrio
	where v.cod_vendedor between 3 and 12
	order by 1, 4

--1.4.6
--Listar todos los artículos que están a la venta cuyo precio unitario oscile entre 10
--y 50; también se quieren listar los artículos que fueron comprados por los clientes
--cuyos apellidos comiencen con “M” o con “P”.
select a.descripcion 'Artículo',
		'En venta entre 10 y 50' 'Criterio'
	from articulos a
	where a.pre_unitario between 10 and 50
union
select a.descripcion,
		'Comprado por clientes "M" y "P"'
	from articulos a
		join detalle_facturas df on df.cod_articulo = a.cod_articulo
		join facturas f on f.nro_factura = df.nro_factura
		join clientes c on c.cod_cliente = f.cod_cliente
	where c.ape_cliente like '[M,P]%'
	
--1.4.7
--El encargado del negocio quiere saber cuánto fue la facturación del año pasado.
--Por otro lado, cuánto es la facturación del mes pasado, la de este mes y la de hoy
--(Cada pedido en una consulta distinta, y puede unirla en una sola tabla de
--resultado)
select SUM(df.pre_unitario*df.cantidad) 'FACTURACIÓN',
		'Año pasado' 'PERIODO'
	from detalle_facturas df
		join facturas f on f.nro_factura = df.nro_factura
	where YEAR(f.fecha) = YEAR(GETDATE()) -1
union
select SUM(df.pre_unitario*df.cantidad),
		'Mes pasado'
	from detalle_facturas df
		join facturas f on f.nro_factura = df.nro_factura
	where YEAR(f.fecha) = YEAR(GETDATE())
		and	MONTH(f.fecha) = MONTH(GETDATE()) -1
union
select SUM(df.pre_unitario*df.cantidad),
		'Mes actual'
	from detalle_facturas df
		join facturas f on f.nro_factura = df.nro_factura
	where YEAR(f.fecha) = YEAR(GETDATE())
		and MONTH(f.fecha) = MONTH(GETDATE())
union
select SUM(df.pre_unitario*df.cantidad),
		'Hoy'
	from detalle_facturas df
		join facturas f on f.nro_factura = df.nro_factura
	where f.fecha = GETDATE()
	order by 1 desc, 2 desc

--<<------------------------------------------------------>>--

--Problema 1.5: Vistas

--1.5.1
--El código y nombre completo de los clientes, la dirección (calle y número) y
--barrio.create view vista_clientes
as
	select c.cod_cliente 'Código',
			CONCAT(c.ape_cliente, ' ', c.nom_cliente) 'Nombre',
			CONCAT(c.calle, ' ', c.altura) 'Dirección',
			b.barrio 'Barrio'
		from clientes c
			join barrios b on b.cod_barrio = c.cod_barrio 

select * from vista_clientes

--1.5.2
--Cree una vista que liste la fecha, la factura, el código y nombre del vendedor, el
--artículo, la cantidad e importe, para lo que va del año. Rotule como FECHA,
--NRO_FACTURA, CODIGO_VENDEDOR, NOMBRE_VENDEDOR, ARTICULO,
--CANTIDAD, IMPORTE.
create view vista_ventas
as
	select f.fecha 'FECHA',
			f.nro_factura 'NRO_FACTURA',
			f.cod_vendedor 'CODIGO_VENDEDOR',
			CONCAT(v.ape_vendedor, ' ', v.nom_vendedor) 'NOMBRE_VENDEDOR',
			a.descripcion 'ARTICULO',
			(df.cantidad) 'CANTIDAD',
			(df.pre_unitario*df.cantidad) 'IMPORTE'
		from detalle_facturas df
			join facturas f on f.nro_factura = df.nro_factura
			join vendedores v on v.cod_vendedor = f.cod_vendedor
			join articulos a on a.cod_articulo = df.cod_articulo
		where YEAR(f.fecha) = YEAR(GETDATE())

select * from vista_ventas		 

--1.5.3
--Modifique la vista creada en el punto anterior, agréguele la condición de que
--solo tome el mes pasado (mes anterior al actual) y que también muestre la
--dirección del vendedor.
alter view vista_ventas
as
	select f.fecha 'FECHA',
			f.nro_factura 'NRO_FACTURA',
			f.cod_vendedor 'CODIGO_VENDEDOR',
			CONCAT(v.ape_vendedor, ' ', v.nom_vendedor) 'NOMBRE_VENDEDOR',
			CONCAT(v.calle, ' ', v.altura) 'DIRECCION',
			b.barrio 'BARRIO',
			a.descripcion 'ARTICULO',
			(df.cantidad) 'CANTIDAD',
			(df.pre_unitario*df.cantidad) 'IMPORTE'
		from detalle_facturas df
			join facturas f on f.nro_factura = df.nro_factura
			join vendedores v on v.cod_vendedor = f.cod_vendedor
			join articulos a on a.cod_articulo = df.cod_articulo
			join barrios b on b.cod_barrio = v.cod_barrio
		where YEAR(f.fecha) = YEAR(GETDATE())
			and MONTH(f.fecha) >= MONTH(GETDATE()) - 1

select * from vista_ventas

--1.5.4
--Consulta las vistas según el siguiente detalle:
--a. Llame a la vista creada en el punto anterior pero filtrando por importes
--inferiores a $120.
select * from vista_ventas
	where IMPORTE < 120
--b. Llame a la vista creada en el punto anterior filtrando para el vendedor
--Miranda.
select * from vista_ventas
	where NOMBRE_VENDEDOR like '%miranda%'
--c. Llama a la vista creada en el punto 4 filtrando para los importes
--menores a 10.000.
select * from vista_ventas
	where IMPORTE < 10000

--1.5.5 --> ¿punto 3?
drop view vista_clientes
drop view vista_ventas
