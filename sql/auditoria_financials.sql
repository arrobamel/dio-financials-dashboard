-- AUDITORIA DATASET FINANCIALS - DIO PROJECT
-- Autor: arrobamel

-- 1. Visão geral - Total de registros e período
SELECT COUNT(*) as total_linhas, 
       MIN(Date) as data_inicio, 
       MAX(Date) as data_fim
FROM financials;

-- 2. Validação de nulos e negativos (qualidade dos dados)
SELECT 
    SUM(CASE WHEN Sales IS NULL OR Profit IS NULL THEN 1 ELSE 0 END) as nulos_financeiro,
    SUM(CASE WHEN Units_Sold <= 0 THEN 1 ELSE 0 END) as unidades_invalidas
FROM financials;

-- 3. Página 1 - Auditoria Visão de Produtos
SELECT Product, 
       SUM(Sales) as total_vendas, 
       SUM(Profit) as total_lucro,
       ROUND(SUM(Profit)*100.0/SUM(Sales),2) as margem_percentual
FROM financials
GROUP BY Product
ORDER BY total_vendas DESC;

-- 4. Página 2 - Auditoria Temporal
SELECT YEAR(Date) as ano, MONTH(Date) as mes,
       SUM(Sales) as vendas_mes,
       SUM(Profit) as lucro_mes
FROM financials
GROUP BY YEAR(Date), MONTH(Date)
ORDER BY ano, mes;

-- 5. Página 3 - Auditoria Geográfica (seu insight principal)
SELECT Country, Segment,
       SUM(Sales) as vendas_pais,
       SUM(Profit) as lucro_pais
FROM financials
GROUP BY Country, Segment
ORDER BY lucro_pais DESC;

-- 6. Top insight para README
SELECT Segment, SUM(Profit) as lucro_total,
       ROUND(SUM(Profit)*100.0/(SELECT SUM(Profit) FROM financials),2) as perc_lucro
FROM financials
GROUP BY Segment;
