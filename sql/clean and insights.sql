USE Retail_Project_Database;
/*
SELECT 
SUM(quantity * list_price * (1 - discount)) AS Total_Revenue
FROM order_items;

SELECT COUNT(*) AS Total_Orders
FROM orders;

SELECT SUM(quantity) AS Total_Products_Sold
FROM order_items;

SELECT 
SUM(quantity * list_price * (1 - discount)) / COUNT(DISTINCT order_id)
AS Average_Order_Value
FROM order_items;

SELECT TOP 10
product_name,
list_price
FROM products
ORDER BY list_price DESC;
*/

/* clean */

/*
UPDATE customers
SET phone = 'Not Available'
WHERE phone IS NULL;


UPDATE orders
SET shipped_date = required_date
WHERE shipped_date is NULL;


UPDATE staffs
SET manager_id = 0
WHERE manager_id IS NULL;
*/

/*TOP SELLING PRODUCTS

SELECT 
p.product_name,
SUM(order_item.quantity) AS sold_quantity
FROM order_items order_item
JOIN products p 
ON order_item.product_id = p.product_id
GROUP BY p.product_name
ORDER BY sold_quantity DESC;
*/

/*Which customers spent the most money?

SELECT TOP 5
    p.product_name,
    SUM(order_item.quantity) AS sold_quantity
FROM order_items order_item
JOIN products p
ON order_item.product_id = p.product_id
GROUP BY p.product_name
ORDER BY sold_quantity DESC;
*/

/*Which store generated highest revenue?

SELECT 
    s.store_name,
    SUM(order_item.quantity * order_item.list_price * (1 - order_item.discount)) AS total_revenue
FROM stores s
JOIN orders o
ON s.store_id = o.store_id
JOIN order_items order_item
ON o.order_id = order_item.order_id
GROUP BY s.store_name
ORDER BY total_revenue DESC;

*/

/*How do sales change month-by-month?

SELECT 
    MONTH(o.order_date) AS sales_month,
    YEAR(o.order_date) AS sales_year,
    SUM(order_item.quantity * order_item.list_price * (1 - order_item.discount)) AS total_revenue
FROM orders o
JOIN order_items order_item
ON o.order_id = order_item.order_id
GROUP BY YEAR(o.order_date), MONTH(o.order_date)
ORDER BY sales_year, sales_month;

*/

/*Which product categories generate highest sales?



SELECT 
    c.category_name,
    SUM(order_item.quantity * order_item.list_price * (1 - order_item.discount)) AS total_revenue
FROM categories c
JOIN products p
ON c.category_id = p.category_id
JOIN order_items order_item
ON p.product_id = order_item.product_id
GROUP BY c.category_name
ORDER BY total_revenue DESC;

*/

/*Which products are running out of stock?

SELECT 
    p.product_name,
    s.quantity
FROM stocks s
JOIN products p
ON s.product_id = p.product_id
WHERE s.quantity < 10
ORDER BY s.quantity ASC;
*/

/*Which staff members generated highest sales?

SELECT 
    st.first_name,
    st.last_name,
    SUM(order_item.quantity * order_item.list_price * (1 - order_item.discount)) AS total_sales
FROM staffs st
JOIN orders o
ON st.staff_id = o.staff_id
JOIN order_items order_item
ON o.order_id = order_item.order_id
GROUP BY st.first_name, st.last_name
ORDER BY total_sales DESC;

*/


/*Which orders were shipped late?

SELECT 
    order_id,
    required_date,
    shipped_date,
    DATEDIFF(DAY, required_date, shipped_date) AS delayed_days
FROM orders
WHERE shipped_date > required_date
ORDER BY delayed_days DESC;
*/

/*Which customers place the most orders?

SELECT 
    c.first_name,
    c.last_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.first_name, c.last_name
ORDER BY total_orders DESC;
*/

/*Which brands generate highest revenue?

SELECT 
    b.brand_name,
    SUM(order_item.quantity * order_item.list_price * (1 - order_item.discount)) AS total_revenue
FROM brands b
JOIN products p
ON b.brand_id = p.brand_id
JOIN order_items order_item
ON p.product_id = order_item.product_id
GROUP BY b.brand_name
ORDER BY total_revenue DESC;
*/


/*How much average discount is company giving?

SELECT 
    AVG(discount) AS average_discount
FROM order_items;

*/


/*Which products are most demanded by customers?

SELECT 
    p.product_name,
    COUNT(order_item.order_id) AS total_orders,
    SUM(order_item.quantity) AS total_quantity_sold
FROM products p
JOIN order_items order_item
ON p.product_id = order_item.product_id
GROUP BY p.product_name
ORDER BY total_quantity_sold DESC;

*/

/*Which products generate highest revenue after discounts

SELECT 
    p.product_name,
    SUM(order_item.quantity * order_item.list_price * (1 - order_item.discount)) AS total_revenue
FROM products p
JOIN order_items order_item
ON p.product_id = order_item.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC;
*/

/*How many orders are still pending/not shipped?

SELECT 
    COUNT(*) AS pending_orders
FROM orders
WHERE shipped_date IS NULL;
*/

/*MOST ORDERED BRANDS*/


SELECT 
    b.brand_name,
    SUM(order_item.quantity) AS total_quantity_sold
FROM brands b
JOIN products p
ON b.brand_id = p.brand_id
JOIN order_items order_item
ON p.product_id = order_item.product_id
GROUP BY b.brand_name
ORDER BY total_quantity_sold DESC;

/*STORE-WISE INVENTORY*/

SELECT 
    s.store_name,
    SUM(st.quantity) AS total_inventory
FROM stores s
JOIN stocks st
ON s.store_id = st.store_id
GROUP BY s.store_name
ORDER BY total_inventory DESC;


/*  MONTHLY STORE REVENUE */

SELECT 
    s.store_name,
    MONTH(o.order_date) AS sales_month,
    YEAR(o.order_date) AS sales_year,
    SUM(order_item.quantity * order_item.list_price * (1 - order_item.discount)) AS total_revenue
FROM stores s
JOIN orders o
ON s.store_id = o.store_id
JOIN order_items order_item
ON o.order_id = order_item.order_id
GROUP BY s.store_name, YEAR(o.order_date), MONTH(o.order_date)
ORDER BY sales_year, sales_month;


/*YEARLY SALES GROWTH*/


SELECT 
    YEAR(o.order_date) AS sales_year,
    SUM(order_item.quantity * order_item.list_price * (1 - order_item.discount)) AS yearly_revenue
FROM orders o
JOIN order_items order_item
ON o.order_id = order_item.order_id
GROUP BY YEAR(o.order_date)
ORDER BY sales_year;


/*CUSTOMER SEGMENTATION*/

SELECT 
    c.first_name,
    c.last_name,
    SUM(order_item.quantity * order_item.list_price * (1 - order_item.discount)) AS total_spent,
    
    CASE 
        WHEN SUM(order_item.quantity * order_item.list_price * (1 - order_item.discount)) > 5000 
            THEN 'VIP Customer'
        WHEN SUM(order_item.quantity * order_item.list_price * (1 - order_item.discount)) BETWEEN 2000 AND 5000
            THEN 'Regular Customer'
        ELSE 'Low Value Customer'
    END AS customer_segment

FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_items order_item
ON o.order_id = order_item.order_id

GROUP BY c.first_name, c.last_name
ORDER BY total_spent DESC;


/*TOP 5 STORES BY SALES*/

SELECT TOP 5
    s.store_name,
    SUM(order_item.quantity * order_item.list_price * (1 - order_item.discount)) AS total_sales
FROM stores s
JOIN orders o
ON s.store_id = o.store_id
JOIN order_items order_item
ON o.order_id = order_item.order_id
GROUP BY s.store_name
ORDER BY total_sales DESC;


/*MOST DISCOUNTED PRODUCTS */

SELECT 
    p.product_name,
    AVG(order_item.discount) AS avg_discount
FROM products p
JOIN order_items order_item
ON p.product_id = order_item.product_id
GROUP BY p.product_name
ORDER BY avg_discount DESC;


/*PRODUCTS NEVER ORDERED*/


SELECT 
    p.product_name
FROM products p
LEFT JOIN order_items order_item
ON p.product_id = order_item.product_id
WHERE order_item.product_id IS NULL;


/*TOTAL REVENUE BY CATEGORY*/

SELECT 
    c.category_name,
    SUM(order_item.quantity * order_item.list_price * (1 - order_item.discount)) AS total_revenue
FROM categories c
JOIN products p
ON c.category_id = p.category_id
JOIN order_items order_item
ON p.product_id = order_item.product_id
GROUP BY c.category_name
ORDER BY total_revenue DESC;