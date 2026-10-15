SELECT * FROM classicmodels.orderdetails;

-- 1 muestra el ingreso total por pedidos enviados

select 
	sum(quantityordered*priceeach) as total
from orderdetails
join orders
using(ordernumber)
where status = 'shipped';

-- 2 cuales son los 5 paises que generan mayores ingesos por pedidos enviados

select 
	c.country,
	sum(od.quantityordered*od.priceeach) as total
from orderdetails od
join orders o
using(ordernumber)
join customers c
using(customernumber)
where o.status = 'shipped'
group by c.country
order by total desc
limit 5;
	
    
    
-- 3 los 10 productos que generan mayores ingresos en pedidos enviados

select
    p.productname,
    sum(od.quantityOrdered) as unidades_vendidas,
    sum(od.quantityordered*od.priceeach) as total
from products p
join orderdetails od
using(productcode)
join orders o
using(ordernumber)
where o.status = 'shipped'
group by p.productcode
order by total desc
limit 10;


-- 4 //los 10 clientes que mas dinero han gastado en pedidos enviados

select 
	c.customername,
    c.country,
    sum(od.quantityordered*od.priceeach) as total_gastado
from customers c
join orders o
using(customernumber)
join orderdetails od
using(ordernumber)
where o.status = 'shipped'
group by c.customerNumber,1,2
order by total_gastado desc
limit 10;

-- 5 Top 10 productos con mayores ingresos

SELECT
    p.productName,
    SUM(od.quantityOrdered) AS unidades_vendidas,
    SUM(od.quantityOrdered * od.priceEach) AS total
FROM products p
JOIN orderdetails od USING(productCode)
JOIN orders o USING(orderNumber)
WHERE o.status = 'Shipped'
GROUP BY p.productCode
ORDER BY total DESC
LIMIT 10;
-- Ejercicio 6: Top 10 clientes con mayor gasto

SELECT
    c.customerName,
    c.country,
    SUM(od.quantityOrdered * od.priceEach) AS total_gastado
FROM customers c
JOIN orders o USING(customerNumber)
JOIN orderdetails od USING(orderNumber)
WHERE o.status = 'Shipped'
GROUP BY c.customerNumber, 1, 2
ORDER BY total_gastado DESC
LIMIT 10;

-- Ejercicio 7: Clientes cuyo gasto supera el promedio

WITH gasto_cliente AS (
    SELECT
        c.customerName,
        c.country,
        SUM(od.quantityOrdered * od.priceEach) AS total_gastado
    FROM customers c
    JOIN orders o USING(customerNumber)
    JOIN orderdetails od USING(orderNumber)
    WHERE o.status = 'Shipped'
    GROUP BY c.customerNumber, 1, 2
)

SELECT
    customerName,
    country,
    total_gastado
FROM gasto_cliente
WHERE total_gastado > (
    SELECT AVG(total_gastado)
    FROM gasto_cliente
)
ORDER BY total_gastado DESC;


-- 8 // ranking de clientes por pais

with gasto_cliente as(
select 
	c.customername,
    c.country,
    sum(od.quantityordered*od.priceeach) as total_gastado
from customers c
join orders o
using(customernumber)
join orderdetails od
using(ordernumber)
where o.status = 'shipped'
group by c.customerNumber,1,2
),

ranking_clientes as(
select 
	customername,
    country,
    total_gastado,
    rank() over(
		partition by country
			order by total_gastado desc) as ranking
from gasto_cliente
)

select 
	customername,
    country,
    total_gastado,
    ranking
from ranking_clientes
where ranking <=3
order by 2,4;


-- 9. cuanto dinero genero classicmodels en cada año, 
-- 		considerando unicamente los pedidos enviados

select
	year(o.shippedDate) as año_enviado,
    sum(od.quantityordered*od.priceeach) as ingresos_totales,
    count(distinct od.orderNumber) as cantidad_pedidos
    
from orders o
join orderdetails od
using(ordernumber)
where o.status = 'shipped'
group by año_enviado
order by año_enviado;



-- 10- como han cambiado los ingresos de classicmodels de un año a otro

with calculo as(
select 
	year(o.shippedDate) as año_enviado,
	sum(od.quantityordered*od.priceeach) as ingresos_totales
from orders o
join orderdetails od
using(ordernumber)
where o.status = 'shipped'
group by año_enviado
)


select 
	año_enviado,
    ingresos_totales,
    lag(ingresos_totales) over (order by año_enviado) as año_anterior,
    ingresos_totales -
    lag(ingresos_totales) over (order by año_enviado) as diferencia_anual
from calculo;

-- 11 // ver si hay un año incompleto
select max(shippeddate) as fecha_maxima,
		min(shippedDate) as fecha_minima,
        count(shippedDate) as total_fechas
        
from orders
where status = 'shipped'




















