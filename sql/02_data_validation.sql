USE ecommerce_sales_analytics;

-- Preview customer data
SELECT *
FROM customers
LIMIT 10;

-- Check customer_id uniqueness
SELECT customer_id, COUNT(*) AS customer_count
FROM customers
GROUP BY customer_id;

-- Check for duplicate customer_id values
SELECT customer_id, COUNT(*) AS customer_count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Check missing country
SELECT COUNT(*)
FROM customers
WHERE country IS NULL;

-- Check missing age_range
SELECT COUNT(*)
FROM customers
WHERE age_range IS NULL;

-- Check missing signup_date
SELECT COUNT(*)
FROM customers
WHERE signup_date IS NULL;

-- Check age range distribution
SELECT age_range, COUNT(*) AS customer_count
FROM customers
GROUP BY age_range;

-- Check country distribution
SELECT country, COUNT(*) AS customer_count
FROM customers
GROUP BY country;

-- Check customer signup date range
SELECT
    MIN(signup_date) AS earliest_signup,
    MAX(signup_date) AS latest_signup
FROM customers;


-- Product row count
SELECT COUNT(*) AS product_count
FROM products;

-- Check duplicate product_id values
SELECT product_id, COUNT(*) AS product_count
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;

SELECT COUNT(*)
FROM products
WHERE product_name IS NULL;

-- Check missing catalog_price
SELECT COUNT(*)
FROM products
WHERE catalog_price IS NULL;

-- Check missing cost_price
SELECT COUNT(*)
FROM products
WHERE cost_price IS NULL;

-- Check negative prices
SELECT *
FROM products
WHERE catalog_price < 0
   OR cost_price < 0;
   
-- Check cost higher than catalog price
SELECT *
FROM products
WHERE cost_price > catalog_price;

-- Count products where cost is higher than catalog price
SELECT COUNT(*) AS invalid_price_count
FROM products
WHERE cost_price > catalog_price;

SELECT category
FROM products
GROUP BY category;

-- Check product count by category
SELECT category, COUNT(*) AS product_count
FROM products
GROUP BY category;

SELECT gender
FROM products
GROUP BY gender;

-- Check missing gender
SELECT COUNT(*)
FROM products
WHERE gender IS NULL;

-- Check product brands
SELECT brand
FROM products
GROUP BY brand;

-- Check product colors
SELECT color
FROM products
GROUP BY color;

-- Check product count by color
SELECT color, COUNT(*) AS product_count
FROM products
GROUP BY color;

-- Check product sizes
SELECT size
FROM products
GROUP BY size;

-- Check product count by size
SELECT size, COUNT(*) AS product_count
FROM products
GROUP BY size;

SELECT COUNT(*)
FROM products
WHERE category IS NULL;

-- Check missing brand
SELECT COUNT(*)
FROM products
WHERE brand IS NULL;

-- Check missing color
SELECT COUNT(*)
FROM products
WHERE color IS NULL;

-- Check missing size
SELECT COUNT(*)
FROM products
WHERE size IS NULL;

-- Check missing gender
SELECT COUNT(*)
FROM products
WHERE gender IS NULL;

-- Check unexpected gender values
SELECT DISTINCT gender
FROM products
WHERE gender NOT IN ('Female');

SELECT product_name, COUNT(*) AS product_count
FROM products
GROUP BY product_name
HAVING COUNT(*) > 1;

-- Check price range
SELECT
    MIN(catalog_price) AS min_catalog_price,
    MAX(catalog_price) AS max_catalog_price,
    MIN(cost_price) AS min_cost_price,
    MAX(cost_price) AS max_cost_price
FROM products;

-- Sales row count
SELECT COUNT(*) AS sales_count
FROM sales;

-- Check duplicate sale_id values
SELECT sale_id, COUNT(*) AS sale_count
FROM sales
GROUP BY sale_id
HAVING COUNT(*) > 1;

-- Check missing customer_id
SELECT COUNT(*)
FROM sales
WHERE customer_id IS NULL;

-- Check invalid customer_id references
SELECT s.customer_id
FROM sales s
LEFT JOIN customers c
    ON s.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Check missing total_amount
SELECT COUNT(*)
FROM sales
WHERE total_amount IS NULL;

-- Check negative total_amount
SELECT *
FROM sales
WHERE total_amount < 0;

-- Check discounted values
SELECT discounted, COUNT(*) AS sale_count
FROM sales
GROUP BY discounted;

-- Check sales channels
SELECT channel
FROM sales
GROUP BY channel;

-- Check sales count by channel
SELECT channel, COUNT(*) AS sale_count
FROM sales
GROUP BY channel;

-- Check sales countries
SELECT country
FROM sales
GROUP BY country;

-- Check sales count by country
SELECT country, COUNT(*) AS sale_count
FROM sales
GROUP BY country;

-- Check sales date range
SELECT
    MIN(sale_date) AS earliest_sale,
    MAX(sale_date) AS latest_sale
FROM sales;

-- Check missing sale_date
SELECT COUNT(*)
FROM sales
WHERE sale_date IS NULL;

-- Check missing channel
SELECT COUNT(*)
FROM sales
WHERE channel IS NULL;

-- Check missing country
SELECT COUNT(*)
FROM sales
WHERE country IS NULL;

-- Check missing discounted
SELECT COUNT(*)
FROM sales
WHERE discounted IS NULL;

-- Check sales count per customer
SELECT customer_id, COUNT(*) AS sale_count
FROM sales
GROUP BY customer_id
ORDER BY sale_count DESC;

-- Check customers with no sales
SELECT c.customer_id
FROM customers c
LEFT JOIN sales s
    ON c.customer_id = s.customer_id
WHERE s.customer_id IS NULL;

-- Count customers with no sales
SELECT COUNT(*) AS customers_without_sales
FROM customers c
LEFT JOIN sales s
    ON c.customer_id = s.customer_id
WHERE s.customer_id IS NULL;

-- Check country consistency between sales and customers
SELECT
    s.sale_id,
    s.customer_id,
    s.country AS sales_country,
    c.country AS customer_country
FROM sales s
JOIN customers c
    ON s.customer_id = c.customer_id
WHERE s.country <> c.country;

SELECT channel, SUM(total_amount) AS total_revenue
FROM sales
GROUP BY channel;

SELECT channel, AVG(total_amount) AS avg_order_value
FROM sales
GROUP BY channel;

SELECT discounted, AVG(total_amount) AS avg_order_value
FROM sales
GROUP BY discounted;

SELECT discounted, SUM(total_amount) AS total_revenue
FROM sales
GROUP BY discounted;

SELECT country, SUM(total_amount) AS total_revenue
FROM sales
GROUP BY country
ORDER BY total_revenue DESC;

SELECT country, AVG(total_amount) AS avg_order_value
FROM sales
GROUP BY country
ORDER BY avg_order_value DESC;

SELECT country,
       COUNT(*) AS sale_count,
       SUM(total_amount) AS total_revenue,
       AVG(total_amount) AS avg_order_value
FROM sales
GROUP BY country
ORDER BY total_revenue DESC;

SELECT SUM(total_amount) AS overall_revenue
FROM sales;

SELECT
    country,
    SUM(total_amount) AS total_revenue,
    (SELECT SUM(total_amount) FROM sales) AS overall_revenue
FROM sales
GROUP BY country;

SELECT
    country,
    SUM(total_amount) AS total_revenue,
    SUM(total_amount) /
    (SELECT SUM(total_amount) FROM sales) * 100 AS revenue_share_pct
FROM sales
GROUP BY country;

SELECT customer_id,
       SUM(total_amount) AS total_spent
FROM sales
GROUP BY customer_id
ORDER BY total_spent DESC;

SELECT customer_id,
       COUNT(*) AS purchase_count
FROM sales
GROUP BY customer_id
ORDER BY purchase_count DESC;

SELECT
    customer_id,
    COUNT(*) AS purchase_count,
    SUM(total_amount) AS total_spent,
    AVG(total_amount) AS avg_order_value
FROM sales
GROUP BY customer_id
ORDER BY total_spent DESC;

SELECT
    customer_id,
    COUNT(*) AS purchase_count,
    SUM(total_amount) AS total_spent,
    AVG(total_amount) AS avg_order_value
FROM sales
GROUP BY customer_id
HAVING COUNT(*) >= 3
ORDER BY total_spent DESC;

SELECT
    customer_id,
    COUNT(*) AS purchase_count,
    SUM(total_amount) AS total_spent,
    AVG(total_amount) AS avg_order_value
FROM sales
GROUP BY customer_id
HAVING COUNT(*) >= 3
   AND AVG(total_amount) > 400
ORDER BY total_spent DESC;

SELECT
    AVG(avg_order_value) AS overall_avg_order_value
FROM (
    SELECT
        customer_id,
        AVG(total_amount) AS avg_order_value
    FROM sales
    GROUP BY customer_id
) AS customer_metrics;

SELECT
    customer_id,
    COUNT(*) AS purchase_count,
    SUM(total_amount) AS total_spent,
    AVG(total_amount) AS avg_order_value
FROM sales
GROUP BY customer_id
HAVING COUNT(*) >= 3
   AND AVG(total_amount) > (
       SELECT AVG(avg_order_value)
       FROM (
           SELECT AVG(total_amount) AS avg_order_value
           FROM sales
           GROUP BY customer_id
       ) AS customer_metrics
   )
ORDER BY total_spent DESC;

SELECT AVG(total_spent) AS avg_customer_spending
FROM (
    SELECT
        customer_id,
        SUM(total_amount) AS total_spent
    FROM sales
    GROUP BY customer_id
) AS customer_spending;

SELECT AVG(purchase_count) AS avg_purchase_count
FROM (
    SELECT
        customer_id,
        COUNT(*) AS purchase_count
    FROM sales
    GROUP BY customer_id
) AS customer_frequency;

SELECT
    customer_id,
    COUNT(*) AS purchase_count,
    SUM(total_amount) AS total_spent,
    AVG(total_amount) AS avg_order_value
FROM sales
GROUP BY customer_id;


SELECT
    customer_id,
    COUNT(*) AS purchase_count,
    SUM(total_amount) AS total_spent,
    AVG(total_amount) AS avg_order_value
FROM sales
GROUP BY customer_id
HAVING
    COUNT(*) > 1.56
    AND SUM(total_amount) > 559.03
    AND AVG(total_amount) > 355.84;
    
SELECT COUNT(*) AS high_value_customers
FROM (
    SELECT
        customer_id,
        COUNT(*) AS purchase_count,
        SUM(total_amount) AS total_spent,
        AVG(total_amount) AS avg_order_value
    FROM sales
    GROUP BY customer_id
    HAVING
        COUNT(*) > 1.56
        AND SUM(total_amount) > 559.03
        AND AVG(total_amount) > 355.84
) AS high_value;

SELECT COUNT(*) AS total_customers
FROM customers;

SELECT
    SUM(total_spent) AS high_value_revenue
FROM (
    SELECT
        customer_id,
        SUM(total_amount) AS total_spent,
        COUNT(*) AS purchase_count,
        AVG(total_amount) AS avg_order_value
    FROM sales
    GROUP BY customer_id
    HAVING
        COUNT(*) > 1.56
        AND SUM(total_amount) > 559.03
        AND AVG(total_amount) > 355.84
) AS high_value;

SELECT
    121210.61 / 324236.66 * 100 AS high_value_revenue_share_pct;
    

SELECT
    channel,
    COUNT(*) AS purchase_count,
    SUM(total_amount) AS revenue
FROM sales
GROUP BY channel
ORDER BY revenue DESC;

SELECT
    s.channel,
    COUNT(*) AS purchase_count,
    SUM(s.total_amount) AS revenue
FROM sales s
WHERE s.customer_id IN (
    SELECT customer_id
    FROM sales
    GROUP BY customer_id
    HAVING
        COUNT(*) > 1.56
        AND SUM(total_amount) > 559.03
        AND AVG(total_amount) > 355.84
)
GROUP BY s.channel
ORDER BY revenue DESC;

SELECT
    channel,
    COUNT(*) AS purchase_count,
    AVG(total_amount) AS avg_order_value,
    SUM(total_amount) AS revenue
FROM sales
GROUP BY channel
ORDER BY avg_order_value DESC;

SELECT
    discounted,
    COUNT(*) AS purchase_count,
    AVG(total_amount) AS avg_order_value,
    SUM(total_amount) AS revenue
FROM sales
GROUP BY discounted
ORDER BY avg_order_value DESC;

SELECT
    channel,
    discounted,
    COUNT(*) AS purchase_count,
    AVG(total_amount) AS avg_order_value,
    SUM(total_amount) AS revenue
FROM sales
GROUP BY channel, discounted
ORDER BY channel, discounted;

SELECT
    channel,
    COUNT(*) AS total_purchases,
    SUM(discounted) AS discounted_purchases,
    SUM(discounted) / COUNT(*) * 100 AS discount_rate_pct
FROM sales
GROUP BY channel
ORDER BY discount_rate_pct DESC;

SELECT
    s.discounted,
    COUNT(*) AS purchase_count,
    SUM(s.total_amount) AS revenue
FROM sales s
WHERE s.customer_id IN (
    SELECT customer_id
    FROM sales
    GROUP BY customer_id
    HAVING
        COUNT(*) > 1.56
        AND SUM(total_amount) > 559.03
        AND AVG(total_amount) > 355.84
)
GROUP BY s.discounted
ORDER BY s.discounted;

SELECT
    s.discounted,
    COUNT(*) AS purchase_count,
    AVG(s.total_amount) AS avg_order_value,
    SUM(s.total_amount) AS revenue
FROM sales s
WHERE s.customer_id IN (
    SELECT customer_id
    FROM sales
    GROUP BY customer_id
    HAVING
        COUNT(*) > 1.56
        AND SUM(total_amount) > 559.03
        AND AVG(total_amount) > 355.84
)
GROUP BY s.discounted
ORDER BY s.discounted;

SELECT
    COUNT(*) AS total_customers,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM customers;

SELECT
    COUNT(*) AS customers_without_sales,
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM customers) AS no_purchase_rate_pct
FROM customers c
LEFT JOIN sales s
    ON c.customer_id = s.customer_id
WHERE s.customer_id IS NULL;


SELECT
    c.country,
    COUNT(*) AS customers_without_sales
FROM customers c
LEFT JOIN sales s
    ON c.customer_id = s.customer_id
WHERE s.customer_id IS NULL
GROUP BY c.country
ORDER BY customers_without_sales DESC;

SELECT
    c.country,
    COUNT(*) AS total_customers,
    SUM(
        CASE
            WHEN s.customer_id IS NULL THEN 1
            ELSE 0
        END
    ) AS customers_without_sales,
    SUM(
        CASE
            WHEN s.customer_id IS NULL THEN 1
            ELSE 0
        END
    ) * 100.0 / COUNT(*) AS no_purchase_rate_pct
FROM customers c
LEFT JOIN sales s
    ON c.customer_id = s.customer_id
GROUP BY c.country
ORDER BY no_purchase_rate_pct DESC;

SELECT
    CASE
        WHEN s.customer_id IS NULL THEN 'No Purchase'
        ELSE 'Purchased'
    END AS customer_status,
    COUNT(*) AS customer_count,
    AVG(c.age) AS avg_age
FROM customers c
LEFT JOIN sales s
    ON c.customer_id = s.customer_id
GROUP BY customer_status;

SELECT
    c.age_range,
    CASE
        WHEN s.customer_id IS NULL THEN 'No Purchase'
        ELSE 'Purchased'
    END AS customer_status,
    COUNT(DISTINCT c.customer_id) AS customer_count
FROM customers c
LEFT JOIN sales s
    ON c.customer_id = s.customer_id
GROUP BY
    c.age_range,
    customer_status
ORDER BY
    c.age_range,
    customer_status;
    
    
SELECT
    c.age_range,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    COUNT(DISTINCT CASE
        WHEN s.customer_id IS NULL THEN c.customer_id
    END) AS customers_without_sales,
    COUNT(DISTINCT CASE
        WHEN s.customer_id IS NULL THEN c.customer_id
    END) * 100.0
    / COUNT(DISTINCT c.customer_id) AS no_purchase_rate_pct
FROM customers c
LEFT JOIN sales s
    ON c.customer_id = s.customer_id
GROUP BY c.age_range
ORDER BY no_purchase_rate_pct DESC;

SELECT
    YEAR(c.signup_date) AS signup_year,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    COUNT(DISTINCT CASE
        WHEN s.customer_id IS NULL THEN c.customer_id
    END) AS customers_without_sales
FROM customers c
LEFT JOIN sales s
    ON c.customer_id = s.customer_id
GROUP BY YEAR(c.signup_date)
ORDER BY signup_year;

SELECT
    DATE_FORMAT(c.signup_date, '%Y-%m') AS signup_month,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    COUNT(DISTINCT CASE
        WHEN s.customer_id IS NULL THEN c.customer_id
    END) AS customers_without_sales
FROM customers c
LEFT JOIN sales s
    ON c.customer_id = s.customer_id
WHERE YEAR(c.signup_date) = 2024
GROUP BY DATE_FORMAT(c.signup_date, '%Y-%m')
ORDER BY signup_month;

SELECT
    DATE_FORMAT(c.signup_date, '%Y-%m') AS signup_month,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    COUNT(DISTINCT CASE
        WHEN s.customer_id IS NULL THEN c.customer_id
    END) AS customers_without_sales
FROM customers c
LEFT JOIN sales s
    ON c.customer_id = s.customer_id
WHERE YEAR(c.signup_date) = 2025
GROUP BY DATE_FORMAT(c.signup_date, '%Y-%m')
ORDER BY signup_month;

SELECT
    c.customer_id,
    c.signup_date,
    MIN(s.sale_date) AS first_purchase_date,
    DATEDIFF(
        MIN(s.sale_date),
        c.signup_date
    ) AS days_to_first_purchase
FROM customers c
JOIN sales s
    ON c.customer_id = s.customer_id
GROUP BY
    c.customer_id,
    c.signup_date
ORDER BY days_to_first_purchase;


SELECT
    c.customer_id,
    c.signup_date,
    MIN(s.sale_date) AS first_purchase_date,
    DATEDIFF(
        MIN(s.sale_date),
        c.signup_date
    ) AS days_to_first_purchase
FROM customers c
JOIN sales s
    ON c.customer_id = s.customer_id
    AND s.sale_date >= c.signup_date
GROUP BY
    c.customer_id,
    c.signup_date
ORDER BY days_to_first_purchase;

SELECT
    COUNT(*) AS customers_with_pre_signup_sales
FROM customers c
JOIN sales s
    ON c.customer_id = s.customer_id
WHERE s.sale_date < c.signup_date;

SELECT
    COUNT(DISTINCT c.customer_id) AS affected_customers
FROM customers c
JOIN sales s
    ON c.customer_id = s.customer_id
WHERE s.sale_date < c.signup_date;

SELECT
    COUNT(*) AS pre_signup_sales,
    SUM(s.total_amount) AS pre_signup_revenue
FROM customers c
JOIN sales s
    ON c.customer_id = s.customer_id
WHERE s.sale_date < c.signup_date;

SELECT
    MIN(DATEDIFF(c.signup_date, s.sale_date)) AS min_days_before_signup,
    MAX(DATEDIFF(c.signup_date, s.sale_date)) AS max_days_before_signup,
    AVG(DATEDIFF(c.signup_date, s.sale_date)) AS avg_days_before_signup
FROM customers c
JOIN sales s
    ON c.customer_id = s.customer_id
WHERE s.sale_date < c.signup_date;


SELECT
    AVG(days_to_first_purchase) AS avg_days_to_first_purchase
FROM (
    SELECT
        c.customer_id,
        DATEDIFF(
            MIN(s.sale_date),
            c.signup_date
        ) AS days_to_first_purchase
    FROM customers c
    JOIN sales s
        ON c.customer_id = s.customer_id
        AND s.sale_date >= c.signup_date
    GROUP BY
        c.customer_id,
        c.signup_date
) AS customer_purchase_time;

SELECT
    CASE
        WHEN days_to_first_purchase <= 7 THEN '0-7 days'
        WHEN days_to_first_purchase <= 30 THEN '8-30 days'
        WHEN days_to_first_purchase <= 60 THEN '31-60 days'
        ELSE '60+ days'
    END AS purchase_time_bucket,
    COUNT(*) AS customer_count
FROM (
    SELECT
        c.customer_id,
        DATEDIFF(
            MIN(s.sale_date),
            c.signup_date
        ) AS days_to_first_purchase
    FROM customers c
    JOIN sales s
        ON c.customer_id = s.customer_id
        AND s.sale_date >= c.signup_date
    GROUP BY
        c.customer_id,
        c.signup_date
) AS customer_purchase_time
GROUP BY purchase_time_bucket
ORDER BY
    CASE purchase_time_bucket
        WHEN '0-7 days' THEN 1
        WHEN '8-30 days' THEN 2
        WHEN '31-60 days' THEN 3
        ELSE 4
    END;
    
SELECT
    s.channel,
    COUNT(*) AS purchase_count
FROM sales s
GROUP BY s.channel;

SELECT
    c.customer_id,
    c.signup_date,
    MIN(s.sale_date) AS first_purchase_date
FROM customers c
JOIN sales s
    ON c.customer_id = s.customer_id
    AND s.sale_date >= c.signup_date
GROUP BY
    c.customer_id,
    c.signup_date;
    
    

SELECT
    c.customer_id,
    c.signup_date,
    MIN(s.sale_date) AS first_purchase_date,
    DATEDIFF(
        MIN(s.sale_date),
        c.signup_date
    ) AS days_to_first_purchase
FROM customers c
JOIN sales s
    ON c.customer_id = s.customer_id
    AND s.sale_date >= c.signup_date
GROUP BY
    c.customer_id,
    c.signup_date
ORDER BY days_to_first_purchase;

SELECT
    c.age_range,
    CASE
        WHEN s.customer_id IS NULL THEN 'No Purchase'
        ELSE 'Purchased'
    END AS customer_status,
    COUNT(DISTINCT c.customer_id) AS customer_count
FROM customers c
LEFT JOIN sales s
    ON c.customer_id = s.customer_id
GROUP BY
    c.age_range,
    customer_status
ORDER BY
    c.age_range,
    customer_status;
    
    
SELECT
    c.age_range,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    COUNT(DISTINCT CASE
        WHEN s.customer_id IS NULL THEN c.customer_id
    END) AS customers_without_sales,
    COUNT(DISTINCT CASE
        WHEN s.customer_id IS NULL THEN c.customer_id
    END) * 100.0
    / COUNT(DISTINCT c.customer_id) AS no_purchase_rate_pct
FROM customers c
LEFT JOIN sales s
    ON c.customer_id = s.customer_id
GROUP BY c.age_range
ORDER BY no_purchase_rate_pct DESC;

SELECT
    YEAR(c.signup_date) AS signup_year,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    COUNT(DISTINCT CASE
        WHEN s.customer_id IS NULL THEN c.customer_id
    END) AS customers_without_sales
FROM customers c
LEFT JOIN sales s
    ON c.customer_id = s.customer_id
GROUP BY YEAR(c.signup_date)
ORDER BY signup_year;

SELECT
    DATE_FORMAT(c.signup_date, '%Y-%m') AS signup_month,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    COUNT(DISTINCT CASE
        WHEN s.customer_id IS NULL THEN c.customer_id
    END) AS customers_without_sales
FROM customers c
LEFT JOIN sales s
    ON c.customer_id = s.customer_id
WHERE YEAR(c.signup_date) = 2024
GROUP BY DATE_FORMAT(c.signup_date, '%Y-%m')
ORDER BY signup_month;

SELECT
    DATE_FORMAT(c.signup_date, '%Y-%m') AS signup_month,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    COUNT(DISTINCT CASE
        WHEN s.customer_id IS NULL THEN c.customer_id
    END) AS customers_without_sales
FROM customers c
LEFT JOIN sales s
    ON c.customer_id = s.customer_id
WHERE YEAR(c.signup_date) = 2025
GROUP BY DATE_FORMAT(c.signup_date, '%Y-%m')
ORDER BY signup_month;

SELECT
    c.customer_id,
    c.signup_date,
    MIN(s.sale_date) AS first_purchase_date,
    DATEDIFF(
        MIN(s.sale_date),
        c.signup_date
    ) AS days_to_first_purchase
FROM customers c
JOIN sales s
    ON c.customer_id = s.customer_id
GROUP BY
    c.customer_id,
    c.signup_date
ORDER BY days_to_first_purchase;


SELECT
    c.customer_id,
    c.signup_date,
    MIN(s.sale_date) AS first_purchase_date,
    DATEDIFF(
        MIN(s.sale_date),
        c.signup_date
    ) AS days_to_first_purchase
FROM customers c
JOIN sales s
    ON c.customer_id = s.customer_id
    AND s.sale_date >= c.signup_date
GROUP BY
    c.customer_id,
    c.signup_date
ORDER BY days_to_first_purchase;

SELECT
    COUNT(*) AS customers_with_pre_signup_sales
FROM customers c
JOIN sales s
    ON c.customer_id = s.customer_id
WHERE s.sale_date < c.signup_date;

SELECT
    COUNT(DISTINCT c.customer_id) AS affected_customers
FROM customers c
JOIN sales s
    ON c.customer_id = s.customer_id
WHERE s.sale_date < c.signup_date;

SELECT
    COUNT(*) AS pre_signup_sales,
    SUM(s.total_amount) AS pre_signup_revenue
FROM customers c
JOIN sales s
    ON c.customer_id = s.customer_id
WHERE s.sale_date < c.signup_date;

SELECT
    MIN(DATEDIFF(c.signup_date, s.sale_date)) AS min_days_before_signup,
    MAX(DATEDIFF(c.signup_date, s.sale_date)) AS max_days_before_signup,
    AVG(DATEDIFF(c.signup_date, s.sale_date)) AS avg_days_before_signup
FROM customers c
JOIN sales s
    ON c.customer_id = s.customer_id
WHERE s.sale_date < c.signup_date;


SELECT
    AVG(days_to_first_purchase) AS avg_days_to_first_purchase
FROM (
    SELECT
        c.customer_id,
        DATEDIFF(
            MIN(s.sale_date),
            c.signup_date
        ) AS days_to_first_purchase
    FROM customers c
    JOIN sales s
        ON c.customer_id = s.customer_id
        AND s.sale_date >= c.signup_date
    GROUP BY
        c.customer_id,
        c.signup_date
) AS customer_purchase_time;

SELECT
    CASE
        WHEN days_to_first_purchase <= 7 THEN '0-7 days'
        WHEN days_to_first_purchase <= 30 THEN '8-30 days'
        WHEN days_to_first_purchase <= 60 THEN '31-60 days'
        ELSE '60+ days'
    END AS purchase_time_bucket,
    COUNT(*) AS customer_count
FROM (
    SELECT
        c.customer_id,
        DATEDIFF(
            MIN(s.sale_date),
            c.signup_date
        ) AS days_to_first_purchase
    FROM customers c
    JOIN sales s
        ON c.customer_id = s.customer_id
        AND s.sale_date >= c.signup_date
    GROUP BY
        c.customer_id,
        c.signup_date
) AS customer_purchase_time
GROUP BY purchase_time_bucket
ORDER BY
    CASE purchase_time_bucket
        WHEN '0-7 days' THEN 1
        WHEN '8-30 days' THEN 2
        WHEN '31-60 days' THEN 3
        ELSE 4
    END;
    
SELECT
    s.channel,
    COUNT(*) AS purchase_count
FROM sales s
GROUP BY s.channel;

SELECT
    c.customer_id,
    c.signup_date,
    MIN(s.sale_date) AS first_purchase_date
FROM customers c
JOIN sales s
    ON c.customer_id = s.customer_id
    AND s.sale_date >= c.signup_date
GROUP BY
    c.customer_id,
    c.signup_date;
    
    

SELECT
    c.customer_id,
    c.signup_date,
    MIN(s.sale_date) AS first_purchase_date,
    DATEDIFF(
        MIN(s.sale_date),
        c.signup_date
    ) AS days_to_first_purchase
FROM customers c
JOIN sales s
    ON c.customer_id = s.customer_id
    AND s.sale_date >= c.signup_date
GROUP BY
    c.customer_id,
    c.signup_date
ORDER BY days_to_first_purchase;

SELECT
    channel,
    AVG(days_to_first_purchase) AS avg_days_to_first_purchase
FROM (
    SELECT
        c.customer_id,
        s.channel,
        DATEDIFF(
            MIN(s.sale_date),
            c.signup_date
        ) AS days_to_first_purchase
    FROM customers c
    JOIN sales s
        ON c.customer_id = s.customer_id
        AND s.sale_date >= c.signup_date
    GROUP BY
        c.customer_id,
        c.signup_date,
        s.channel
) AS customer_purchase_time
GROUP BY channel
ORDER BY avg_days_to_first_purchase;

SELECT
    channel,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM sales
GROUP BY channel
ORDER BY unique_customers DESC;

SELECT
    channel,
    COUNT(DISTINCT customer_id) AS unique_customers,
    COUNT(DISTINCT customer_id) * 100.0 /
        (SELECT COUNT(DISTINCT customer_id) FROM sales) AS customer_share_pct
FROM sales
GROUP BY channel
ORDER BY customer_share_pct DESC;

SELECT
    channel,
    COUNT(DISTINCT customer_id) AS unique_customers,
    SUM(total_amount) AS revenue,
    SUM(total_amount) / COUNT(DISTINCT customer_id) AS revenue_per_customer
FROM sales
GROUP BY channel
ORDER BY revenue_per_customer DESC;

SELECT
    customer_id,
    COUNT(DISTINCT channel) AS channel_count
FROM sales
GROUP BY customer_id
HAVING COUNT(DISTINCT channel) > 1;

SELECT
    COUNT(*) AS multi_channel_customers,
    COUNT(*) * 100.0 /
        (SELECT COUNT(DISTINCT customer_id) FROM sales) AS multi_channel_rate_pct
FROM (
    SELECT
        customer_id
    FROM sales
    GROUP BY customer_id
    HAVING COUNT(DISTINCT channel) > 1
) AS multi_channel;


SELECT
    channel,
    COUNT(*) AS total_purchases,
    COUNT(DISTINCT customer_id) AS unique_customers,
    COUNT(*) * 1.0 / COUNT(DISTINCT customer_id) AS purchases_per_customer
FROM sales
GROUP BY channel
ORDER BY purchases_per_customer DESC;

SELECT
    CASE
        WHEN purchase_count = 1 THEN 'One-time'
        ELSE 'Repeat'
    END AS customer_type,
    COUNT(*) AS customer_count
FROM (
    SELECT
        customer_id,
        COUNT(*) AS purchase_count
    FROM sales
    GROUP BY customer_id
) AS customer_purchases
GROUP BY customer_type
ORDER BY customer_count DESC;

SELECT
    CASE
        WHEN purchase_count = 1 THEN 'One-time'
        ELSE 'Repeat'
    END AS customer_type,
    COUNT(*) AS customer_count,
    AVG(total_spent) AS avg_total_spent,
    AVG(avg_order_value) AS avg_order_value
FROM (
    SELECT
        customer_id,
        COUNT(*) AS purchase_count,
        SUM(total_amount) AS total_spent,
        AVG(total_amount) AS avg_order_value
    FROM sales
    GROUP BY customer_id
) AS customer_metrics
GROUP BY customer_type
ORDER BY avg_total_spent DESC;

SELECT
    COUNT(*) AS purchasing_customers,
    SUM(CASE WHEN purchase_count > 1 THEN 1 ELSE 0 END) AS repeat_customers,
    SUM(CASE WHEN purchase_count > 1 THEN 1 ELSE 0 END) * 100.0
        / COUNT(*) AS repeat_rate_pct
FROM (
    SELECT
        customer_id,
        COUNT(*) AS purchase_count
    FROM sales
    GROUP BY customer_id
) AS customer_purchases;

SELECT
    customer_type,
    COUNT(*) AS customer_count,
    SUM(total_spent) AS total_revenue,
    SUM(total_spent) * 100.0 /
        (SELECT SUM(total_amount) FROM sales) AS revenue_share_pct
FROM (
    SELECT
        customer_id,
        CASE
            WHEN COUNT(*) = 1 THEN 'One-time'
            ELSE 'Repeat'
        END AS customer_type,
        SUM(total_amount) AS total_spent
    FROM sales
    GROUP BY customer_id
) AS customer_metrics
GROUP BY customer_type
ORDER BY total_revenue DESC;

SELECT
    customer_id,
    COUNT(*) AS purchase_count,
    SUM(total_amount) AS total_spent,
    AVG(total_amount) AS avg_order_value
FROM sales
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 10;

SELECT
    c.country,
    COUNT(DISTINCT s.customer_id) AS purchasing_customers,
    SUM(s.total_amount) AS revenue,
    SUM(s.total_amount) / COUNT(DISTINCT s.customer_id) AS revenue_per_customer
FROM customers c
JOIN sales s
    ON c.customer_id = s.customer_id
GROUP BY c.country
ORDER BY revenue_per_customer DESC;

SELECT
    COUNT(*) AS total_purchases,
    COUNT(DISTINCT customer_id) AS purchasing_customers,
    SUM(total_amount) AS total_revenue,
    AVG(total_amount) AS avg_order_value
FROM sales;

SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN s.customer_id IS NOT NULL THEN 1 ELSE 0 END) AS purchasing_customers,
    SUM(s.total_amount) AS total_revenue,
    SUM(s.total_amount) / COUNT(*) AS revenue_per_customer,
    SUM(CASE WHEN s.customer_id IS NOT NULL THEN 1 ELSE 0 END) * 100.0
        / COUNT(*) AS purchase_rate_pct
FROM customers c
LEFT JOIN sales s
    ON c.customer_id = s.customer_id;
