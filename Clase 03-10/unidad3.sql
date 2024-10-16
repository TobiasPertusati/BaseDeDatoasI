

--declare @CANT_CLIENTES int;

--select @CANT_CLIENTES=count(cod_cliente)
-- from clientes;--RETURN @CANT_CLIENTES--create procedure pa_factorial
--@numero int
--as
-- if @numero>=0 and @numero<=12
--	begin
--		 declare @resultado int
--		 declare @num int
--		 set @resultado=1 
--		 set @num=@numero 
--		 while (@num>1)
--			 begin
--				 set @resultado=@resultado*@num
--				 set @num=@num-1
--			 end
--	select rtrim(convert(char,@numero))+' != '+convert(char,@resultado)
--    end
-- else
-- select 'Debe ingresar un número entre 0 y 12';-- GUIA 3-- PUNTO 1 declare @codigo int;set @codigo = 5;declare @stock int;select @stock =  a.stock 				from articulos a 				where a.cod_articulo = @codigo;declare @stockMinimo int;select @stockMinimo =  a.stock_minimo 				from articulos a 				where a.cod_articulo = @codigoSELECT @codigo 'CODIGO', @stock 'STOCK', @stockMinimo 'STOCK MINIMO'-- PUNTO 2 IF(@stock IS NULL or @stockMinimo IS NULL)	begin		SELECT('NO TIENEN NIGUN VALOR');	endELSE IF(@stockMinimo > @stock)	BEGIN		SELECT CONCAT('ES NESECARIO REPONER EL ARTICULO CODIGO: ',@codigo )	ENDELSE 	BEGIN		SELECT CONCAT ('STOCK MINIMO ADECUADO DEL ARTICULO COD: ',@codigo)	END--PUNTO 3DECLARE @PRECIO DECIMAL(18,2);SELECT @PRECIO = A.pre_unitario FROM articulos A WHERE a.cod_articulo = @codigo;IF(@precio < 500)	begin		SELECT CONCAT('PRECIO ORIGINAL: ', @PRECIO)		UPDATE articulos SET pre_unitario = @PRECIO * 1.1		WHERE cod_articulo = @codigo		SELECT CONCAT('PRECIO ACTUALIZADO: ', A.pre_unitario) FROM articulos A WHERE cod_articulo = @codigo;	endELSE 	begin		SELECT CONCAT('PRE MAYOR A 500 ES:', @PRECIO)	end-- PUNTO 4DECLARE @NUMERO1 INTDECLARE @NUMERO2 INTSET @NUMERO1 = 12SET @NUMERO2 = 14--SELECT IIF(@NUMERO1 = @NUMERO2,'LOS NUMEROS SON IGUALES', --		CONCAT('LA SUMA DE LOS DOS NUMEROS ES: ', @NUMERO1 + @NUMERO2))DECLARE @MENOR INT;DECLARE @MAYOR INT;DECLARE @RESULTADO INT;IF (@NUMERO1 = @NUMERO2)	BEGIN		SELECT 'LOS NUMEROS SON IGUALES'	ENDELSE IF (@NUMERO1 > @NUMERO2)	BEGIN 		SET @MENOR = @NUMERO2		SET @MAYOR = @NUMERO1	ENDELSE	BEGIN		SET @MAYOR = @NUMERO2		SET @MENOR = @NUMERO1	ENDWHILE (@MENOR <= @MAYOR)	BEGIN		SET @RESULTADO += @MENOR		SET @MENOR += 1	ENDIF (@NUMERO1 != @NUMERO2)	BEGIN		SELECT CONCAT('LA SUMA DE LOS NUMEROS COMPRENDIDOS ENTRE ELLOS ES:', @RESULTADO)	END--PUNTO 5