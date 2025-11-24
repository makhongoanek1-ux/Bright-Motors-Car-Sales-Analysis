--1. Show all the data from the table

SELECT *
FROM CAR_SALES_ANALYSIS.BRIGHT_MOTORS.DATASET;

----------------------------------------------------
--2. Show the total overall revenue

SELECT SUM(sellingprice) AS Overall_revenue
FROM CAR_SALES_ANALYSIS.BRIGHT_MOTORS.DATASET;

-----------------------------------------------------
--3. Show the total revenue by year

SELECT 
    YEAR,
    SUM(SELLINGPRICE) AS Overall_revenue
FROM CAR_SALES_ANALYSIS.BRIGHT_MOTORS.DATASET
GROUP BY YEAR
ORDER BY YEAR;

-----------------------------------------------------
--3. Show the total revenue by brand

SELECT 
    make,
    SUM(SELLINGPRICE) AS Overall_revenue
FROM CAR_SALES_ANALYSIS.BRIGHT_MOTORS.DATASET
GROUP BY MAKE
ORDER BY Overall_revenue DESC;

-----------------------------------------------------
--3. Show the total revenue by model

SELECT 
    model,
    SUM(SELLINGPRICE) AS Overall_revenue
FROM CAR_SALES_ANALYSIS.BRIGHT_MOTORS.DATASET
GROUP BY model
ORDER BY Overall_revenue DESC;

----------------------------------------------------
--Show the final big query

SELECT
    --Information of the motor vehicles--
    NULLIF(TRIM(Year), '') AS manufacture_year,
    NULLIF(TRIM(Make), '') AS Make,
    NULLIF(TRIM(Model), '') AS Model,
    NULLIF(TRIM(Trim), '') AS Trim,
    NULLIF(TRIM(Body), '') AS Body,
    NULLIF(TRIM(Transmission), '') AS Transmission,
    NULLIF(TRIM(State), '') AS State,
    NULLIF(TRIM(Seller), '') AS Seller,
    NULLIF(TRIM(Condition), '') AS Condition,
    NULLIF(TRIM(Color), '') AS Color,
    NULLIF(TRIM(Interior), '') AS Interior,

    --Mileage--
    NULLIF(TRIM(Odometer), '') AS mileage,

    --Cleaned Numeric Prices--
    TO_NUMBER(NULLIF(REPLACE(SELLINGPRICE, ',', ''), '')) AS selling_price,
    TO_NUMBER(NULLIF(REPLACE(MMR, ',', ''), '')) AS market_value,

    1 AS units_sold,

    --Revenue--
    TO_NUMBER(NULLIF(REPLACE(SELLINGPRICE, ',', ''), '')) AS overall_revenue,

    --Profit--
    TO_NUMBER(NULLIF(REPLACE(SELLINGPRICE, ',', ''), '')) 
      - TO_NUMBER(NULLIF(REPLACE(MMR, ',', ''), '')) AS profit,

    --Profit Margin %--
    ROUND(
        (
            TO_NUMBER(NULLIF(REPLACE(SELLINGPRICE, ',', ''), '')) 
            - TO_NUMBER(NULLIF(REPLACE(MMR, ',', ''), ''))
        )
        / NULLIF(TO_NUMBER(NULLIF(REPLACE(SELLINGPRICE, ',', ''), '')), 0) * 100,
        2
    ) AS profit_margin,

    --Performance Ranking--
    CASE 
        WHEN (
            TO_NUMBER(NULLIF(REPLACE(SELLINGPRICE, ',', ''), '')) 
            - TO_NUMBER(NULLIF(REPLACE(MMR, ',', ''), ''))
        )
        / NULLIF(TO_NUMBER(NULLIF(REPLACE(SELLINGPRICE, ',', ''), '')), 0) * 100 >= 20 
            THEN 'High_Margin'
        WHEN (
            TO_NUMBER(NULLIF(REPLACE(SELLINGPRICE, ',', ''), '')) 
            - TO_NUMBER(NULLIF(REPLACE(MMR, ',', ''), ''))
        )
        / NULLIF(TO_NUMBER(NULLIF(REPLACE(SELLINGPRICE, ',', ''), '')), 0) * 100 BETWEEN 10 AND 19.99 
            THEN 'Medium_Margin'
        ELSE 'Low_Margin'
    END AS performance_ranking,

    --✅ Correct Date Handling--
    TO_DATE(
        TO_TIMESTAMP(
            NULLIF(TRIM(SALEDATE), ''),
            'DY MON DD YYYY HH24:MI:SS'
        )
    ) AS sale_date,

    DATE_TRUNC('month',
        TO_DATE(
            TO_TIMESTAMP(NULLIF(TRIM(SALEDATE), ''), 'DY MON DD YYYY HH24:MI:SS')
        )
    ) AS sale_month,

    DATE_TRUNC('quarter',
        TO_DATE(
            TO_TIMESTAMP(NULLIF(TRIM(SALEDATE), ''), 'DY MON DD YYYY HH24:MI:SS')
        )
    ) AS sale_quarter,

    DATE_TRUNC('year',
        TO_DATE(
            TO_TIMESTAMP(NULLIF(TRIM(SALEDATE), ''), 'DY MON DD YYYY HH24:MI:SS')
        )
    ) AS sale_year

FROM CAR_SALES_ANALYSIS.BRIGHT_MOTORS.DATASET;