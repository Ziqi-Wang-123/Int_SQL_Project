-- Customer Revenue By Cohort(Yearly Cohort Analysis)

SELECT
	cohort_year,
	count(DISTINCT customerkey) AS total_customers,
	sum(total_net_revenue)AS total_revenue,
	sum(total_net_revenue)/count(DISTINCT customerkey) AS customer_revenue
FROM
	cohort_analysis
GROUP BY
	cohort_year;
	
-- Monthly Revenue & Customer Trends 
	
/*
	This is the first bonus question to our project: 
	calculate the monthly revenue, customer totals, and average customer revenue to 
	explore why we are seeing customers spend less over time.

Use the cohort_analysis view to perform the analysis.
Group the orderdate by month and calculate the total revenue, total number of customers, 
and average revenue per customer for each month.
Order the results by month to observe the trends over time.
	*/
SELECT customer_revenue.*, 
avg(monthly_revenue/customer_total) AS avg_revenue_per_customer
FROM (
SELECT
	date_trunc('month', orderdate) AS order_month,
	sum(total_net_revenue) AS monthly_revenue,
	count(DISTINCT customerkey) AS customer_total
FROM 
	cohort_analysis
GROUP BY
	order_month) AS customer_revenue
GROUP BY  order_month,monthly_revenue,customer_total;

--Month Rolling Average
/*
 This is the final bonus question to our project: 
 Calculate the 3 month rolling average of monthly revenue, 
 customer totals, and average customer revenue to better explore why we are seeing customers spend less over time.

Use the query from the previous question (5.2.2) to start your analysis by putting it into a CTE.
Compute the rolling averages for total revenue, total customers, and customer revenue over a 3-month window.
Order the results by month to observe the trends over time.
 */
WITH monthly_revenue AS (
SELECT customer_revenue.*, 
avg(monthly_revenue/customer_total) AS avg_revenue_per_customer
FROM (
SELECT
	date_trunc('month', orderdate) AS order_month,
	sum(total_net_revenue) AS monthly_revenue,
	count(DISTINCT customerkey) AS customer_total
FROM 
	cohort_analysis
GROUP BY
	order_month) AS customer_revenue
GROUP BY  order_month,monthly_revenue,customer_total)

SELECT *,
avg(monthly_revenue)over(ORDER BY order_month ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING ) AS avg_total_revenue,
avg(customer_total)over(ORDER BY order_month ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING ) AS avg_customer_total,
avg(avg_revenue_per_customer )over(ORDER BY order_month ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING ) AS avg_revenue_per_customer
FROM monthly_revenue;






