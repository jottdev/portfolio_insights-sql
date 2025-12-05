-- Loan Profitability Variance
-- Compares expected interest vs actual interest received.

WITH loan_info AS (
    SELECT 
        l.loan_id,
        l.principal_amount,
        l.interest_rate,
        l.term_months
    FROM loans l
),
expected AS (
    SELECT 
        loan_id,
        principal_amount * (interest_rate / 100) * (term_months / 12.0) AS expected_interest
    FROM loan_info
),
actual AS (
    SELECT 
        loan_id,
        SUM(amount) - MIN(principal_amount) AS actual_interest
    FROM payments p
    JOIN loans l USING (loan_id)
    GROUP BY loan_id
)

SELECT 
    e.loan_id,
    ROUND(e.expected_interest) AS expected_interest,
    ROUND(a.actual_interest, 2) AS actual_interest,
    ROUND((a.actual_interest - e.expected_interest), 2) AS variance
FROM expected e
LEFT JOIN actual a USING (loan_id)
ORDER BY loan_id;
