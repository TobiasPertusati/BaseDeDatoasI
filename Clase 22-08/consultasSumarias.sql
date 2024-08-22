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
WHERE YEAR(F.fecha) = YEAR(GETDATE())
GROUP BY 
v.nom_vendedor + SPACE(1) + v.ape_vendedor,
C.nom_cliente + SPACE(1) + C.ape_cliente 
ORDER BY 1 , 2

--2)