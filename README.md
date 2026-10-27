# SQL Revenue by Continent

## Task
Build a summary table by continent that combines sales, user and traffic metrics: total revenue, revenue by device type, share of total revenue, number of accounts, verified accounts and sessions.

## What the query does
- Calculates total revenue and revenue from mobile and desktop per continent
- Calculates each continent's share of total revenue using a window function
- Counts created and verified accounts per continent
- Counts sessions per continent
- Joins all metrics into one result table with `LEFT JOIN`

## SQL techniques used
CTEs, multiple `JOIN`s (including `USING` and `LEFT JOIN`), conditional aggregation (`SUM(CASE WHEN ...)`), `COUNT(DISTINCT ...)`, window function `SUM() OVER()`

## Tools
Google BigQuery
