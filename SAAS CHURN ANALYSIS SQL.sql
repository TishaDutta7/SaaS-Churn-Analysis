/* =========================================================
   SAAS CHURN & REVENUE ANALYSIS –
   ========================================================= */


/* ---------------------------------------------------------
   1. Total number of customers
   Business question: How big is the customer base?
---------------------------------------------------------- */
SELECT COUNT(*) AS total_customers
FROM customers;


/* ---------------------------------------------------------
   2. Subscription status distribution
   Business question: How many active vs cancelled subscriptions?
---------------------------------------------------------- */
SELECT status, COUNT(*) AS total_subscriptions
FROM subscriptions
GROUP BY status;


/* ---------------------------------------------------------
   3. User activity distribution
   Business question: What type of events users perform most?
---------------------------------------------------------- */
SELECT event_type, COUNT(*) AS total_events
FROM user_activity
GROUP BY event_type;


/* ---------------------------------------------------------
   4. Total revenue generated
   Business question: How much revenue has the company earned?
---------------------------------------------------------- */
SELECT SUM(amount) AS total_revenue
FROM transactions;


/* ---------------------------------------------------------
   5. Monthly revenue trend
   Business question: How does revenue change month over month?
---------------------------------------------------------- */
SELECT
    DATE_TRUNC('month', transaction_date) AS month,
    SUM(amount) AS monthly_revenue
FROM transactions
GROUP BY 1
ORDER BY 1;


/* ---------------------------------------------------------
   6. Customer Lifetime Value (LTV)
   Business question: Which customers generate the most revenue?
---------------------------------------------------------- */
SELECT
    customer_id,
    SUM(amount) AS lifetime_value
FROM transactions
GROUP BY customer_id
ORDER BY lifetime_value DESC;


/* ---------------------------------------------------------
   7. Active subscriptions by plan type
   Business question: Which plans are most popular among active users?
---------------------------------------------------------- */
SELECT
    plan_type,
    COUNT(*) AS active_subscriptions
FROM subscriptions
WHERE status = 'Active'
GROUP BY plan_type;


/* ---------------------------------------------------------
   8. Subscription duration (in days)
   Business question: How long do customers typically stay subscribed?
---------------------------------------------------------- */
SELECT
    customer_id,
    end_date - start_date AS subscription_duration_days
FROM subscriptions;


/* ---------------------------------------------------------
   9. Last login date per customer
   Business question: When did users last engage with the product?
---------------------------------------------------------- */
SELECT
    customer_id,
    MAX(event_date) AS last_login_date
FROM user_activity
WHERE event_type = 'Login'
GROUP BY customer_id;


/* ---------------------------------------------------------
   10. Monthly Active Users (MAU)
   Business question: How many users are active each month?
---------------------------------------------------------- */
SELECT
    DATE_TRUNC('month', event_date) AS month,
    COUNT(DISTINCT customer_id) AS monthly_active_users
FROM user_activity
WHERE event_type = 'Login'
GROUP BY 1
ORDER BY 1;


/* ---------------------------------------------------------
   11. Financial churn customers
   Definition: Customers who stopped paying in last 90 days
---------------------------------------------------------- */
SELECT
    customer_id,
    MAX(transaction_date) AS last_payment_date
FROM transactions
GROUP BY customer_id
HAVING MAX(transaction_date) < CURRENT_DATE - INTERVAL '90 days';


/* ---------------------------------------------------------
   12. Engagement churn customers
   Definition: Customers who haven't logged in for last 90 days
---------------------------------------------------------- */
SELECT
    customer_id,
    MAX(event_date) AS last_login_date
FROM user_activity
WHERE event_type = 'Login'
GROUP BY customer_id
HAVING MAX(event_date) < CURRENT_DATE - INTERVAL '90 days';


/* ---------------------------------------------------------
   13. Silent churn customers
   Definition: Customers who still pay but have not logged in
---------------------------------------------------------- */
SELECT
    t.customer_id,
    MAX(t.transaction_date) AS last_payment_date,
    MAX(ua.event_date) AS last_login_date
FROM transactions t
LEFT JOIN user_activity ua
    ON t.customer_id = ua.customer_id
GROUP BY t.customer_id
HAVING
    MAX(t.transaction_date) >= CURRENT_DATE - INTERVAL '90 days'
    AND MAX(ua.event_date) < CURRENT_DATE - INTERVAL '90 days';


/* ---------------------------------------------------------
   14. Final churn classification (customer personas)
   Business question: Which churn category does each customer belong to?
---------------------------------------------------------- */
SELECT
    c.customer_id,
    c.name,
    c.email,
    CASE
        WHEN fc.customer_id IS NOT NULL THEN 'Financial Churn'
        WHEN ec.customer_id IS NOT NULL THEN 'Engagement Churn'
        WHEN sc.customer_id IS NOT NULL THEN 'Silent Churn'
        ELSE 'Healthy Customer'
    END AS churn_type
FROM customers c
LEFT JOIN (
    SELECT customer_id
    FROM transactions
    GROUP BY customer_id
    HAVING MAX(transaction_date) < CURRENT_DATE - INTERVAL '90 days'
) fc ON c.customer_id = fc.customer_id
LEFT JOIN (
    SELECT customer_id
    FROM user_activity
    WHERE event_type = 'Login'
    GROUP BY customer_id
    HAVING MAX(event_date) < CURRENT_DATE - INTERVAL '90 days'
) ec ON c.customer_id = ec.customer_id
LEFT JOIN (
    SELECT t.customer_id
    FROM transactions t
    LEFT JOIN user_activity ua
        ON t.customer_id = ua.customer_id
    GROUP BY t.customer_id
    HAVING
        MAX(t.transaction_date) >= CURRENT_DATE - INTERVAL '90 days'
        AND MAX(ua.event_date) < CURRENT_DATE - INTERVAL '90 days'
) sc ON c.customer_id = sc.customer_id;


/* ---------------------------------------------------------
   15. Running revenue per customer (Window Function)
   Business question: How does revenue accumulate over time per customer?
---------------------------------------------------------- */
SELECT
    customer_id,
    transaction_date,
    amount,
    SUM(amount) OVER (
        PARTITION BY customer_id
        ORDER BY transaction_date
    ) AS running_revenue
FROM transactions;


/* ---------------------------------------------------------
   16. Country-wise customer distribution
   Business question: Which regions have the most customers?
---------------------------------------------------------- */
SELECT
    country,
    COUNT(*) AS total_customers
FROM customers
GROUP BY country
ORDER BY total_customers DESC;
