-- Sample SQL script with a more complex SELECT statement

WITH RegionSales AS (
    SELECT 
        r.region_name,
        SUM(s.amount) AS total_sales
    FROM sales_data s
    JOIN regions r ON s.region_id = r.id
    WHERE s.sale_date >= '2023-01-01'
    GROUP BY r.region_name
), 
TopCustomers AS (
    SELECT 
        c.customer_id, 
        c.customer_name,
        COUNT(o.order_id) AS order_count
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.customer_name
    HAVING COUNT(o.order_id) > 10
)
SELECT 
    tc.customer_name,
    tc.order_count,
    rs.region_name, 
    rs.total_sales,
    CURRENT_USER() as queried_by -- Function call
FROM TopCustomers tc
JOIN RegionSales rs ON LEFT(tc.customer_name, 1) = LEFT(rs.region_name, 1) -- Arbitrary join for complexity
ORDER BY tc.order_count DESC, rs.total_sales DESC; 