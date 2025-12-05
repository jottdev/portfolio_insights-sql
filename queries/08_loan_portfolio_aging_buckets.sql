-- Loan Aging Buckets (Days Past Due Approximation)
-- Uses inferred due dates based on monthly expected payments.

WITH expected_payment AS (
    SELECT 
        loan_id,
        (principal_amount * (1 + (interest_rate / 100))) / term_months AS monthly_payment,
        disbursement_date,
        term_months
    FROM loans
    WHERE status = 'active'
),
payment_summary AS (
    SELECT 
        loan_id,
        SUM(amount) AS total_paid,
        MAX(payment_date) AS last_payment_date
    FROM payments
    GROUP BY loan_id
),
loan_progress AS (
    SELECT 
        e.loan_id,
        e.monthly_payment,
        e.term_months,
        e.disbursement_date,
        COALESCE(p.total_paid, 0) AS total_paid,
        CEIL(COALESCE(p.total_paid, 0) / e.monthly_payment) AS months_paid,
        (CURRENT_DATE - 
					(
						e.disbursement_date::date
						+ (CEIL(COALESCE(p.total_paid, 0) / e.monthly_payment) * INTERVAL '1 month')
					)::date) AS days_past_due
    FROM expected_payment e
    LEFT JOIN payment_summary p USING (loan_id)
)

SELECT 
    loan_id,
    days_past_due,
    CASE 
        WHEN days_past_due <= 30 THEN '0-30'
        WHEN days_past_due BETWEEN 31 AND 60 THEN '31-60'
        WHEN days_past_due BETWEEN 61 AND 90 THEN '61-90'
        ELSE '90+'
    END AS aging_bucket
FROM loan_progress
ORDER BY loan_id;
