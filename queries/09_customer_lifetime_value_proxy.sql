-- Customer Lifetime Value (CLTV) Proxy
-- Calculates total revenue from each client (interest earned).

WITH loan_info AS (
    SELECT 
        l.loan_id,
        la.client_id,
        l.principal_amount,
        l.interest_rate,
        l.term_months
    FROM loans l
    JOIN loan_applications la USING (application_id)
),
expected_interest AS (
    SELECT 
        loan_id,
        client_id,
        (principal_amount * (interest_rate / 100) * (term_months / 12.0)) AS expected_interest
    FROM loan_info
),
actual_interest AS (
    SELECT 
        l.loan_id,
        la.client_id,
        (SUM(p.amount) - l.principal_amount) AS actual_interest
    FROM loans l
    JOIN loan_applications la USING (application_id)
    JOIN payments p USING (loan_id)
    GROUP BY l.loan_id, la.client_id
)

SELECT
    c.client_id,
    c.first_name,
    c.last_name,
    ROUND(COALESCE(SUM(a.expected_interest), 0), 2) AS expected_interest_total,
    COALESCE(SUM(ai.actual_interest), 0) AS actual_interest_total
FROM clients c
LEFT JOIN expected_interest a USING (client_id)
LEFT JOIN actual_interest ai USING (client_id)
GROUP BY c.client_id
ORDER BY actual_interest_total DESC;
