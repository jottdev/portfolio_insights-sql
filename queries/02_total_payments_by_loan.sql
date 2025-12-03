-- Loan overview with aggregated payments per loan.

WITH grouped_payments AS (
    SELECT 
        p.loan_id,
        SUM(p.amount) AS total_payment
    FROM payments p 
    GROUP BY p.loan_id
)
SELECT 
    l.loan_id,
    la.application_id,
    c.client_id,
    c.first_name,
    c.last_name,
    la.requested_amount,
    l.outstanding_amount,
    COALESCE(gr.total_payment, 0) AS total_payment,
    l.disbursement_date,
    l.status
FROM loans l
INNER JOIN loan_applications la ON l.application_id = la.application_id
INNER JOIN clients c ON c.client_id = la.client_id
LEFT JOIN grouped_payments gr ON gr.loan_id = l.loan_id
ORDER BY l.disbursement_date DESC, l.loan_id;
