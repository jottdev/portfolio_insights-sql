-- Early Payoff Analysis
-- Identifies loans repaid earlier than expected term.

WITH expected_end AS (
    SELECT 
        loan_id,
        disbursement_date + INTERVAL '1 month' * term_months AS expected_end_date
    FROM loans
),
actual_payoff AS (
    SELECT 
        loan_id,
        MAX(payment_date) AS actual_payoff_date,
        SUM(amount) AS total_paid
    FROM payments
    GROUP BY loan_id
),
loan_basic AS (
    SELECT 
        l.loan_id,
        l.principal_amount,
        l.principal_amount * (1 + (l.interest_rate / 100)) AS expected_total_payback
    FROM loans l
)

SELECT 
    e.loan_id,
    e.expected_end_date,
    a.actual_payoff_date,
    CASE WHEN a.actual_payoff_date < e.expected_end_date THEN TRUE ELSE FALSE END AS early_payoff,
    EXTRACT(month FROM (e.expected_end_date - a.actual_payoff_date)) AS months_saved
FROM expected_end e
JOIN actual_payoff a USING (loan_id)
JOIN loan_basic lb USING (loan_id)
WHERE a.total_paid >= lb.expected_total_payback
ORDER BY loan_id;
