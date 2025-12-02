-- This script inserts sample data into the clients, loan_applications, loans, and payments tables

INSERT INTO public.clients 
(first_name, last_name, identity_number, date_of_birth, city, address, phone_number, email)
VALUES
('Michael', 'Schneider', 'DE990001', '1988-02-14', 'Berlin', 'Alexanderplatz 5', '+49 151 0000001', 'm.schneider@example.com'),
('Julia', 'Kowalska', 'PL880002', '1990-11-23', 'Warsaw', 'Nowy Świat 12', '+48 600 000 002', 'j.kowalska@example.com'),
('Thomas', 'Van Dijk', 'NL770003', '1985-06-30', 'Amsterdam', 'Damrak 22', '+31 6 0000 0003', 't.vandijk@example.com'),
('Elena', 'Petrova', 'BG940004', '1994-09-10', 'Sofia', 'Vitosha Blvd 18', '+359 888 000004', 'e.petrova@example.com'),
('Lukas', 'Müller', 'DE900005', '1989-03-18', 'Munich', 'Leopoldstrasse 44', '+49 152 0000005', 'l.mueller@example.com'),
('Sara', 'Johansson', 'SE870006', '1987-05-05', 'Stockholm', 'Sveavägen 61', '+46 70 000 0006', 's.johansson@example.com');


INSERT INTO public.loan_applications
(client_id, application_date, requested_amount, term_months, status)
VALUES
(1, '2024-01-10', 5000, 24, 'approved'),
(2, '2024-01-15', 3200, 12, 'rejected'),
(3, '2024-02-01', 15000, 36, 'approved'),
(1, '2024-03-12', 2000, 12, 'pending'),
(4, '2024-03-20', 4000, 18, 'approved'),
(5, '2024-04-01', 8000, 24, 'approved'),
(6, '2024-04-18', 2500, 12, 'rejected'),
(2, '2024-05-10', 6000, 24, 'approved'),
(3, '2024-05-22', 3000, 6, 'pending'),
(4, '2024-06-05', 12000, 36, 'approved');



INSERT INTO public.loans
(application_id, disbursement_date, term_months, principal_amount, outstanding_amount, interest_rate, status)
VALUES
(1, '2024-01-20', 24, 5000, 4200, 7.5, 'active'),
(3, '2024-02-10', 36, 15000, 14800, 6.9, 'active'),
(5, '2024-03-25', 18, 4000, 3500, 8.2, 'active'),
(6, '2024-04-05', 24, 8000, 7900, 7.1, 'active'),
(8, '2024-05-15', 24, 6000, 5800, 7.8, 'active');


INSERT INTO public.payments
(loan_id, payment_date, amount)
VALUES
-- Loan 1 (Michael, Berlin)
(1, '2024-02-20', 250),
(1, '2024-03-20', 250),
(1, '2024-04-20', 260),

-- Loan 2 (Thomas, Amsterdam)
(2, '2024-03-10', 450),
(2, '2024-04-10', 450),
(2, '2024-05-10', 460),

-- Loan 3 (Elena, Sofia)
(3, '2024-04-25', 230),
(3, '2024-05-25', 230),

-- Loan 4 (Lukas, Munich)
(4, '2024-05-05', 330),
(4, '2024-06-05', 330),

-- Loan 5 (Julia, Warsaw)
(5, '2024-06-20', 310),
(5, '2024-07-20', 310);
