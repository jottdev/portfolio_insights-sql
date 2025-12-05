-- Loan Application Funnel Metrics
-- Tracks stages from application to approval to funded loan.

WITH application_counts AS (
    SELECT 
        COUNT(*) AS total_applications,
        COUNT(*) FILTER (WHERE status = 'approved') AS approved,
        COUNT(*) FILTER (WHERE status = 'rejected') AS rejected,
        COUNT(*) FILTER (WHERE status = 'pending') AS pending
    FROM loan_applications
),
funded_loans AS (
    SELECT 
        COUNT(*) AS funded
    FROM loans
)

SELECT 
    ac.total_applications,
    ac.approved,
    ac.rejected,
    ac.pending,
    fl.funded,
    ROUND(ac.approved::numeric / ac.total_applications, 4) AS approval_rate,
    ROUND(fl.funded::numeric / ac.total_applications, 4) AS funding_rate
FROM application_counts ac
CROSS JOIN funded_loans fl;
