--FUNCIONES LAG Y LEAD
SELECT 
PRODUCTO,
ANIO,
VENTAS,
LAG(VENTAS)OVER(PARTITION BY PRODUCTO ORDER BY ANIO ASC)VENTAS_ANTERIORES,
VENTAS-LAG(VENTAS)OVER(PARTITION BY PRODUCTO ORDER BY ANIO ASC)CRECIMIENTO,
LEAD(VENTAS)OVER(PARTITION BY PRODUCTO ORDER BY ANIO ASC)VENTAS_POSTERIORES
FROM(
SELECT PR.NOMBRE PRODUCTO, DP.CANTIDAD*DP.PRECIO_UNIDAD VENTAS, EXTRACT(YEAR FROM P.FECHA_PEDIDO)ANIO 
FROM PEDIDO P
INNER JOIN DETALLE_PEDIDO DP
ON P.CODIGO_PEDIDO=DP.CODIGO_PEDIDO
INNER JOIN PRODUCTO PR
ON DP.CODIGO_PRODUCTO=PR.CODIGO_PRODUCTO
WHERE UPPER(P.ESTADO)='ENTREGADO'
)


--funciones case y ntile
SELECT CLIENTE,VENTAS,NIVEL,
CASE WHEN NIVEL=1 THEN 'CATEGORIA A'
WHEN NIVEL=2 THEN 'CATEGORIA B'
WHEN NIVEL=3 THEN 'CATEGORIA C'
WHEN NIVEL=4 THEN 'CATEGORIA D'
END CATEGORIA
FROM(
SELECT CLIENTE,VENTAS,
NTILE(4)OVER(ORDER BY VENTAS DESC)AS NIVEL
FROM(
SELECT CL.NOMBRE_CLIENTE CLIENTE, SUM(DP.CANTIDAD*DP.PRECIO_UNIDAD)VENTAS
FROM PEDIDO P
INNER JOIN DETALLE_PEDIDO DP
ON P.CODIGO_PEDIDO=DP.CODIGO_PEDIDO
INNER JOIN PRODUCTO PR
ON DP.CODIGO_PRODUCTO=PR.CODIGO_PRODUCTO
INNER JOIN CLIENTE CL
ON P.CODIGO_CLIENTE=CL.CODIGO_CLIENTE
WHERE UPPER(P.ESTADO)='ENTREGADO'
GROUP BY CL.NOMBRE_CLIENTE
)
)
-- FUNCIONES ROLLUP Y CUBE
SELECT PRODUCTO,ANIO,SUM(VENTAS)VENTAS FROM (
SELECT PR.NOMBRE PRODUCTO, DP.CANTIDAD*DP.PRECIO_UNIDAD VENTAS, EXTRACT(YEAR FROM P.FECHA_ENTREGA)ANIO, 
P.ESTADO
FROM PEDIDO P
INNER JOIN DETALLE_PEDIDO DP
ON P.CODIGO_PEDIDO=DP.CODIGO_PEDIDO
INNER JOIN PRODUCTO PR
ON DP.CODIGO_PRODUCTO=PR.CODIGO_PRODUCTO)
GROUP BY ROLLUP (PRODUCTO,ANIO,ESTADO)

--FUNCION LISTTAG
SELECT DISTINCT CL.NOMBRE_CLIENTE CLIENTE,
LISTAGG(PR.NOMBRE,',')WITHIN GROUP(ORDER BY CL.NOMBRE_CLIENTE)
    OVER(PARTITION BY CL.NOMBRE_CLIENTE) PRODUCTOS
FROM PEDIDO P
INNER JOIN DETALLE_PEDIDO DP
ON P.CODIGO_PEDIDO=DP.CODIGO_PEDIDO
INNER JOIN PRODUCTO PR
ON DP.CODIGO_PRODUCTO=PR.CODIGO_PRODUCTO
INNER JOIN CLIENTE CL
ON P.CODIGO_CLIENTE=CL.CODIGO_CLIENTE
WHERE UPPER(P.ESTADO)='ENTREGADO'


SELECT * FROM CLIENTE
DESCRIBE PEDIDO


