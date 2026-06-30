use onlinestore
ALTER VIEW vw_Master_Executive_Dashboard AS
SELECT 
    Date,
    Product_Name,
    Unit_price,
    CASE 
        WHEN Unit_price < 1000 THEN 'Consumerist' 
        WHEN Unit_price >= 1000 THEN 'Luxury'
        ELSE 'Others'
    END AS Category_type,
    SUM(Units_Sold) AS Total_unit_sold,
    SUM(Total_Revenue) AS Total_revenue,
    AVG(Total_Revenue / NULLIF(Units_Sold, 0)) AS Avg_unite_price,
    CAST(SUM(Total_Revenue) * 100.0 / SUM(SUM(Total_Revenue)) OVER() AS DECIMAL(10,2)) AS Revenue_Contribution_Pct,
    CAST(SUM(Total_Revenue) * 100.0 / SUM(SUM(Total_Revenue)) OVER(PARTITION BY CASE WHEN Unit_price < 1000 THEN 'Consumerist' ELSE 'Luxury' END) AS DECIMAL(10,2)) AS Category_Share_Pct

from sales_data
GROUP BY Date, Product_Name , Unit_price
