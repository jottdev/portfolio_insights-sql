-- Risk Exposure Analysis by City and Age Group
-- Calculates default rates by demographic segment.

WITH client_age AS (
    SELECT 
        c.client_id,
        c.city,
        DATE_PART('year', AGE(c.date_of_birth)) AS age
    FROM clients c
),
age_groups AS (
    SELECT 
        client_id,
        city,
        CASE 
            WHEN age < 25 THEN '18-24'
            WHEN age BETWEEN 25 AND 34 THEN '25-34'
            WHEN age BETWEEN 35 AND 44 THEN '35-44'
            WHEN age BETWEEN 45 AND 54 THEN '45-54'
            ELSE '55+'
        END AS age_group
    FROM client_age
),
loan_status AS (
    SELECT 
        l.loan_id,
        l.status,
        la.client_id
    FROM loans l
    JOIN loan_applications la 
        ON la.application_id = l.application_id
)

SELECT 
    ag.city,
    ag.age_group,
    COUNT(ls.loan_id) AS total_loans,
    COUNT(*) FILTER (WHERE ls.status = 'defaulted') AS defaulted_loans,
    ROUND(
        COUNT(*) FILTER (WHERE ls.status = 'defaulted')::numeric 
        / NULLIF(COUNT(ls.loan_id), 0), 4
    ) AS default_rate
FROM age_groups ag
JOIN loan_status ls 
    ON ls.client_id = ag.client_id
GROUP BY ag.city, ag.age_group
ORDER BY ag.city, ag.age_group;
