SELECT 
    c.client_id
    , CONCAT(c.first_name, ' ', c.last_name) AS full_name
    , l.loan_id
    , la.application_id AS app_id
    , la.requested_amount AS initial_amount
    , l.outstanding_amount AS outstanding
    , LOWER(l.status) AS current_status
    , l.disbursement_date AS disburse_date

FROM loans l
INNER JOIN loan_applications la ON la.application_id = l.application_id
INNER JOIN clients c ON c.client_id = la.client_id

    WHERE LOWER(l.status) = 'active'

ORDER BY l.disbursement_date;