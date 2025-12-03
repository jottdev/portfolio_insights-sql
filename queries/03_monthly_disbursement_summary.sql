SELECT
    date_trunc('month', l.disbursement_date)::date AS disbursement_month,
    COUNT(*)                                       AS loans_disbursed,
    SUM(l.principal_amount)                        AS total_principal_disbursed,
    SUM(la.requested_amount)                       AS total_requested_amount
FROM loans l
INNER JOIN loan_applications la
    ON la.application_id = l.application_id
GROUP BY
    date_trunc('month', l.disbursement_date)
ORDER BY
    disbursement_month;
