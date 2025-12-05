/*
This query groups loans by the month they were disbursed and tracks their repayments over time. 
It calculates cumulative payments and repayment ratios for each cohort to show how quickly 
different groups of loans pay down their principal.
*/

WITH loan_cohorts AS (
    SELECT
        l.loan_id,
        DATE_TRUNC('month', l.disbursement_date) AS cohort_month,
        l.disbursement_date,
        l.principal_amount AS loan_amount
    FROM loans l
),

payments_enriched AS (
    SELECT
        p.payment_id,
        p.loan_id,
        p.amount AS payment_amount,
        p.created_at AS payment_date,
        lc.cohort_month,
        lc.disbursement_date,
        lc.loan_amount,

        -- Age of loan at payment time (in months)
        (
            (EXTRACT(YEAR FROM p.created_at) - EXTRACT(YEAR FROM lc.disbursement_date)) * 12
            + (EXTRACT(MONTH FROM p.created_at) - EXTRACT(MONTH FROM lc.disbursement_date))
        ) AS month_index

    FROM payments p
    JOIN loan_cohorts lc ON lc.loan_id = p.loan_id
),

cohort_aggregates AS (
    SELECT
        cohort_month,
        month_index,
        COUNT(DISTINCT loan_id) AS loans_with_payments,
        SUM(payment_amount) AS total_payments,
        SUM(loan_amount) AS cohort_total_amount
    FROM payments_enriched
    GROUP BY cohort_month, month_index
),

cohort_totals AS (
    SELECT
        cohort_month,
        SUM(loan_amount) AS cohort_principal_amount,
        COUNT(DISTINCT loan_id) AS cohort_size
    FROM loan_cohorts
    GROUP BY cohort_month
),

cumulative_rep AS (
    SELECT
        ca.cohort_month,
        ca.month_index,
        ca.cohort_total_amount,
        SUM(ca.total_payments) OVER (
            PARTITION BY ca.cohort_month
            ORDER BY ca.month_index
        ) AS cumulative_payments
    FROM cohort_aggregates ca
)

SELECT
    c.cohort_month,
    c.month_index,
    ct.cohort_size,
    ct.cohort_principal_amount,
    c.cumulative_payments,
    ROUND(c.cumulative_payments / ct.cohort_principal_amount, 2) AS repayment_ratio
FROM cumulative_rep c
JOIN cohort_totals ct 
    ON ct.cohort_month = c.cohort_month
ORDER BY c.cohort_month, c.month_index;
