/*
CREATE VIEW daily_revenue AS
SELECT 
    orderdate,
    SUM(quantity * netprice * exchangerate) AS total_revenue
FROM sales
GROUP BY 
    orderdate;

SELECT * FROM daily_revenue dr ;

DROP VIEW daily_revenue;
*/

CREATE VIEW cohort_analysis AS  --create view as cohort_analysis
WITH customer_revenue AS (
	SELECT
		s.customerkey,
		s.orderdate,
		SUM(s.quantity * s.netprice * s.exchangerate) AS total_net_revenue,
		COUNT(s.orderkey) AS num_orders,
		c.countryfull,
		c.age,
		c.givenname,
		c.surname
	FROM sales s 
	LEFT JOIN customer c ON c.customerkey = s.customerkey
	GROUP BY
		s.customerkey,
		s.orderdate,
		c.countryfull,
		c.age,
		c.givenname,
		c.surname
)
SELECT
	cr.*,
	MIN(cr.orderdate) OVER (PARTITION BY cr.customerkey) AS first_purchase_date,
	EXTRACT(YEAR FROM MIN(cr.orderdate) OVER (PARTITION BY cr.customerkey)) AS cohort_year
FROM customer_revenue cr 
    
 