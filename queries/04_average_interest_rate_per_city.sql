SELECT
    c.city,
    ROUND(AVG(l.interest_rate), 2) AS avg_interest_per_city
FROM loans l
INNER JOIN loan_applications la ON la.application_id = l.application_id
INNER JOIN clients c ON c.client_id = la.client_id
GROUP BY c.city
ORDER BY c.city;