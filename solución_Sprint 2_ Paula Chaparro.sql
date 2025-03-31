-- ---------------------------------------------- Nivel 1 -------------------------------------------------------------

-- 1.)	Listado de los países que están haciendo compras.

SELECT distinct
C.country as 'Paises que están haciendo compras'
FROM company C
right join transaction T
on T.company_id = C.id
order by country asc
;

-- 2) Desde cuántos países se realizan las compras.

select count(country) as 'Número de países que están comprando'
from (select distinct
	C.country 
	FROM company C
	right join transaction T
	on T.company_id = C.id
) as Subquery -- para hacer join con país
;

-- 3.) Identifica la compañía con el promedio más grande de ventas.

select company_id, 
avg(amount) as promedio_top_ventas
from transaction
group by company_id
having avg(amount) = ( -- con el having filtro solo las compañías con esa media máxima.
		select max(promedio) -- con esta subquery obtengo la media más alta.
					 from (select company_id, 
						  avg(amount) as promedio
						  from transaction
						  group by company_id) as subquery -- con la subquery interna calculo la media de ventas por compañía.
				    )
;


-- 4) Muestra todas las transacciones realizadas por empresas de Alemania.

select id,
	company_id,
	user_id,
	timestamp,
	amount,
	(select country 
    from company 
    where id = company_id and country = 'Germany') as company_country
from transaction 
where company_id in (select id 
					from company
					where country = 'Germany'
                    )
Order by timestamp 
    ;

-- 5) Lista de las empresas que han realizado transacciones por un importe superior a la media de todas las transacciones. 

select id as lista_empresas
from company
where company.id in (select distinct company_id
					from transaction
					where amount > (select avg(amount)
					from transaction
			   )
			)
;

-- 6) Eliminarán del sistema las empresas que no tienen transacciones registradas. Entrega el listado de estas empresas. 

select id,
company_name
from company
where id not in (select company_id
				from transaction)
; -- El resultado no arroja nada porque no hay empresas que no tengan transacciones registradas.

-- ---------------------------------------------- Nivel 2 -------------------------------------------------------------

-- 7) Identifica los cinco días en los que se generó la cantidad más alta de ingresos en la empresa por ventas. 
	-- Muestra la fecha de cada transacción juntamente con el total de las ventas.
    
SELECT amount,
timestamp
from transaction
order by amount desc
limit 5
;

-- 8) Cuál es la media de ventas por país? Presenta los resultados ordenados de mayor a menor.

select C.country as Pais,
round(avg(amount),2) as Media_de_ventas
from transaction T , 
company C
where C.id = T.company_id 
group by country
order by Media_de_ventas desc
;

-- 9) En tu empresa, se plantea un nuevo proyecto para lanzar algunas publicitarias para hacer competencia a la compañía "Non Institute".
-- Por este motivo, te piden la lista de todas las transacciones realizadas por empresas que estánn situadas en el mismo país que esta compañía.

	-- 9.1) Muestra el listado aplicando JOIN y subconsultas.
    
select C.country, 
C.company_name,
T.company_id,
T.id as trans_code,
T.timestamp,
T.amount
from transaction T,
company C
where C.country in (select country
				   from company C
				   right join transaction T
	               on T.company_id = C.id
                   where C.company_name = 'Non Institute'
                   )
and C.company_name not like 'Non Institute'
order by C.company_name asc, T.amount desc
;

-- 9.2) Muestra el listado aplicando solamente subconsultas.

select C.country, 
C.company_name,
T.company_id,
T.id as trans_code,
T.timestamp,
T.amount
from transaction T,
company C
where C.country in (select country 
					from company
					where company_name = 'Non Institute' 
                   )
and C.company_name not like 'Non Institute'
order by C.company_name asc, T.amount desc
;


-- ---------------------------------------------- Nivel 3 -------------------------------------------------------------

-- 10) Presenta el nombre, teléfono, país, fecha e importe, de aquellas empresas que realizaron transacciones con un valor comprendido entre 100 i 200 euros 
-- euros y en alguna de estas fechas: 29 de abril del 2021, 20 de julio del 2021 i 13 de marzo del 2022.
-- Ordena los resultados de mayor a menor cantidad.

select C.company_name,
C.phone,
C.country,
T.timestamp,
T.amount
from company C, 
transaction T
where T.amount between 100 and 200 
and date(timestamp) in ('2021-04-29', '2021-07-20', '2022-03-13')
order by T.amount desc

;

-- 11) Necesitamos optimizar la asignación de recursos y dependerá de la capacidad operativa que se requiera. 
-- por este motivo te piden la información sobre la cantidad de transacciones que realizan las empresas, 
-- pero el departamento de recursos humanos es exigente y quiere un listado de las empresas donde especifiques si tiene más de 4 transacciones o menos.

select count(T.id) as listado_de_transacciones,
T.company_id,
C.company_name,
C.country,
case 
	when count(T.id) > 4 then 'Más de 4 transacciones'
    else 'Menos de 4 transacciones'
 end as 'Número de Transacciones'   
from transaction T
join company C on C.id = T.company_id
group by T.company_id
;








