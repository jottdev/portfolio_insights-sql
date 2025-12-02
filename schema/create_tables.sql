-- This script creates the necessary tables for a loan management system,
-- including clients, loan applications, loans, and payments, with appropriate
-- constraints and relationships.
-- make sure you are in the testing environment before running this script.

DROP TABLE IF EXISTS public.payments;
DROP TABLE IF EXISTS public.loans;
DROP TABLE IF EXISTS public.loan_applications;
DROP TABLE IF EXISTS public.clients;

CREATE TABLE IF NOT EXISTS public.clients (
    client_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    
    first_name TEXT NOT NULL CHECK (length(trim(first_name)) > 0),
    last_name TEXT NOT NULL CHECK (length(trim(last_name)) > 0),
    
    identity_number TEXT UNIQUE NOT NULL,
    date_of_birth DATE NOT NULL,
    
    city TEXT NOT NULL,
    address TEXT NOT NULL,
    
    phone_number TEXT UNIQUE NOT NULL,
    email TEXT UNIQUE NOT NULL,
    
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.loan_applications (
    application_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    client_id BIGINT NOT NULL REFERENCES clients(client_id) ON DELETE CASCADE,
    
    application_date DATE NOT NULL,
    requested_amount NUMERIC(15,2) NOT NULL CHECK (requested_amount > 0),
    term_months INT NOT NULL CHECK (term_months > 0),

    status TEXT NOT NULL CHECK (status IN ('approved', 'rejected', 'pending')),
    
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);


CREATE TABLE IF NOT EXISTS public.loans (
    loan_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    application_id BIGINT NOT NULL REFERENCES loan_applications(application_id) ON DELETE CASCADE,
    
    disbursement_date DATE NOT NULL,
    term_months INT NOT NULL CHECK (term_months > 0),
    
    principal_amount NUMERIC(15,2) NOT NULL CHECK (principal_amount > 0),
    outstanding_amount NUMERIC(15,2) NOT NULL CHECK (outstanding_amount >= 0),
    
    interest_rate NUMERIC(5,2) NOT NULL CHECK (interest_rate >= 0),
    
    status TEXT NOT NULL CHECK (status IN ('active', 'closed', 'defaulted')),
    
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);


CREATE TABLE IF NOT EXISTS public.payments (
    payment_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    
    loan_id BIGINT NOT NULL REFERENCES loans(loan_id) ON DELETE CASCADE,
    payment_date DATE NOT NULL,
    
    amount NUMERIC(15,2) NOT NULL CHECK (amount > 0),
    
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
