-- 1) Quantidade de produtos unicos
select distinct count(ID) as QtdeProdUnicos from Produtos

-- 2) produto mais vendido em todos os anos &
-- produto mais vendido em 2019
select
	--v.[Date],
	p.[Name],
	p.Size,
	sum(v.Quantity) as TotalProdutosVendidos
	--sum(v.Discount*v.UnitPrice*v.Quantity) as Total 
from Vendas v
	join Produtos p ON v.ProductID = p.ID
--where
	--p.Size = 'G'
	--v.[Date] between '2019-01-01' and '2019-12-31'
group by --v.[Date], 
	p.[Name], 
	p.Size, 
	--v.Discount, 
	--v.UnitPrice, 
	v.Quantity
order by TotalProdutosVendidos desc
--------------------------------------------------------
select
	--v.[Date],
	p.[Name],
	p.Size,
	sum(v.Quantity) as TotalProdutosVendidos
	--sum(v.Discount*v.UnitPrice*v.Quantity) as Total 
from Vendas v
	join Produtos p ON v.ProductID = p.ID
where
	--p.Size = 'G' and
	v.[Date] between '2019-01-01' and '2019-12-31'
group by --v.[Date], 
	p.[Name], 
	p.Size, 
	--v.Discount, 
	--v.UnitPrice, 
	v.Quantity
order by TotalProdutosVendidos desc 
-------------------------------------------------------
--select * from Vendas
--select * from Produtos
-------------------------------------------------------
-- 3) Total de produtos vendidos em 2019
select
	--v.[Date],
	--p.[Name],
	--p.Size,
	sum(v.Quantity) as TotalProdutosVendidos
	--sum(v.Discount*v.UnitPrice*v.Quantity) as Total 
from Vendas v
	join Produtos p ON v.ProductID = p.ID
where
	--p.Size = 'G'
	v.[Date] between '2019-01-01' and '2019-12-31'
--group by --v.[Date], 
	--p.[Name], 
	--p.Size, 
	--v.Discount, 
	--v.UnitPrice, 
	--v.Quantity
--------------------------------------------------------
-- 4) Receita Bruta em 2019
select
	--p.ID,
	--v.quantity,
	--v.discount,
	--v.unitprice,
	sum(v.quantity*v.unitprice - (v.quantity*v.Discount*v.unitprice)) as ReceitaTotal
from Vendas v
	--join Produtos p ON
	--v.ProductID = p.ID
where
	v.[Date] between '2019-01-01' and '2019-12-31'
--group by v.Quantity, v.Discount, v.UnitPrice
---------------------------------------------------------
-- 5) Valor total de cada produto vendido em 2019
select
	p.[Name],
	v.UnitPrice,
	v.Discount,
	v.Quantity,
	(v.quantity*v.unitprice - (v.quantity*v.Discount*v.unitprice)) as ValorTotalProduto
from Vendas v
	join Produtos p ON
	v.ProductID = p.ID
where v.[Date] between '2019-01-01' and '2019-12-31'
group by p.[Name], v.UnitPrice, v.Discount, v.Quantity
order by p.[Name]
-----------------------------------------------------------
-- 6) Qual foi o produto que mais vendeu e em qual loja foram feitas essas vendas
--select * from Lojas
select top 1
	l.[Name],
	p.[Name],
	sum(v.Quantity) as TotalVendas
from Vendas v
	join Lojas l ON
	v.StoreID = l.ID
	join Produtos p ON
	v.ProductID = p.ID
where v.[Date] between '2019-01-01' and '2019-12-31'
group by 
	l.[Name], 
	p.[Name]
order by TotalVendas desc
------------------------------------------------------------
-- 7) Qual foi a loja que mais vendeu em 2019
select
	l.[Name],
	--p.[Name],
	sum(v.Quantity) as TotalVendas
from Vendas v
	join Lojas l ON
	v.StoreID = l.ID
	join Produtos p ON
	v.ProductID = p.ID
where v.[Date] between '2019-01-01' and '2019-12-31'
group by l.[Name] 
	--p.[Name], 
	--v.Quantity
order by TotalVendas desc
-------------------------------------------------------------
-- 8) Qual são os valores de ReceitaTotal, média, desvio padrão e Mediana das vendas mensais de 2019
select --v.[Date],
	sum(v.quantity*v.unitprice - (v.quantity*v.Discount*v.unitprice)) as ReceitaBruta,
	avg(v.quantity*v.unitprice - (v.quantity*v.Discount*v.unitprice)) as MediaReceitaBruta,
	stdev(v.quantity*v.unitprice - (v.quantity*v.Discount*v.unitprice)) as DesvPadReceitaBruta
	-- Ver como se calcula a mediana
	--PERCENTILE_CONT(0.5) 
    --    WITHIN GROUP (ORDER BY MediaReceitaBruta)
    --    OVER (PARTITION BY v.[date]) AS MedianReceitaBruta
from Vendas v
where v.[Date] between '2019-01-01' and '2019-12-31'
--group by v.[Date]
--order by v.[Date] asc
-------------------------------------------------------------
-- 9) Receita Total da empresa desde o início até o presente momento
-- Com média, Mediana e Desvio Padrão
select
	sum(v.quantity*v.unitprice - (v.quantity*v.Discount*v.unitprice)) as ReceitaBruta,
	avg(v.quantity*v.unitprice - (v.quantity*v.Discount*v.unitprice)) as MediaReceitaBruta,
	stdev(v.quantity*v.unitprice - (v.quantity*v.Discount*v.unitprice)) as DesvPadReceitaBruta
	-- Ver como se calcula a mediana
	--PERCENTILE_CONT(0.5) 
    --    WITHIN GROUP (ORDER BY MediaReceitaBruta)
    --    OVER (PARTITION BY v.[date]) AS MedianReceitaBruta
from Vendas v
--------------------------------------------------------------
-- 10) Para que seja possível gerar gráficos, qual é a Receita Mensal Bruta da Empresa em 2019
-- Determine a curva de venda mensal no ano de 2019
select 
	month(v.[Date]) as Mes,
	--year(v.[Date]) as Ano,
	sum(v.quantity*v.unitprice - (v.quantity*v.Discount*v.unitprice)) as ReceitaBruta 
from Vendas v
where v.[Date] between '2019-01-01' and '2019-12-31'
group by month(v.[Date])--, 
	--v.Quantity, 
	--v.Discount, 
	--v.UnitPrice
order by Mes
----------------------------------------------------------------
-- 11) Para que seja possível gerar gráficos,
-- qual é o total de vendas efetuadas por cada loja em 2019
select 
	l.[Name],
	sum(v.Quantity) as TotalVendasPorLoja
from vendas v
	join Lojas l on
	v.StoreID = l.ID
where v.[Date] between '2019-01-01' and '2019-12-31'
group by 
	l.[Name]
order by l.[Name]
----------------------------------------------------------