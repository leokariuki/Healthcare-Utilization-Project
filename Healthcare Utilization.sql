-- Create Patients table
CREATE TABLE patients (
    id UUID PRIMARY KEY,
    birthdate DATE,
    deathdate DATE,
    ssn VARCHAR(11),
    drivers VARCHAR(10),
    passport VARCHAR(10),
    prefix VARCHAR(10),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    suffix VARCHAR(10),
    maiden VARCHAR(50),
    marital CHAR(1),
    race VARCHAR(50),
    ethnicity VARCHAR(50),
    gender CHAR(1),
    birthplace VARCHAR(100),
    address VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    county VARCHAR(50),
    zip VARCHAR(10),
    lat DECIMAL(10, 8),
    lon DECIMAL(11, 8),
    healthcare_expenses DECIMAL(12, 2),
    healthcare_coverage DECIMAL(12, 2)
);

-- Create Conditions table
CREATE TABLE conditions (
    start_date DATE,
    stop_date DATE,
    patient_id UUID REFERENCES patients(id),
    encounter_id UUID,
    code VARCHAR(20),
    description VARCHAR(100),
    PRIMARY KEY (patient_id, start_date, code)
);

-- Create Medications table
CREATE TABLE medications (
    start_timestamp TIMESTAMP,
    stop_timestamp TIMESTAMP,
    patient_id UUID REFERENCES patients(id),
    payer_id UUID,
    encounter_id UUID,
    code VARCHAR(20),
    description VARCHAR(255),
    base_cost DECIMAL(10, 2),
    payer_coverage DECIMAL(10, 2),
    dispenses INTEGER,
    total_cost DECIMAL(10, 2),
    reason_code VARCHAR(20),
    reason_description VARCHAR(100),
    PRIMARY KEY (patient_id, start_timestamp, code)
);

-- Create Encounters table
CREATE TABLE encounters (
    id UUID PRIMARY KEY,
    start_timestamp TIMESTAMP,
    stop_timestamp TIMESTAMP,
    pateint_id UUID REFERENCES patients(id),
    organization_id UUID,
    provider_id UUID,
    payer_id UUID,
    encounter_class VARCHAR(50),
    code VARCHAR(20),
    description VARCHAR(255),
    base_encounter_cost DECIMAL(10, 2),
    total_claim_cost DECIMAL(10, 2),
    payer_coverage DECIMAL(10, 2),
    reason_code VARCHAR(20),
    reason_description VARCHAR(255)
);

select * from patients

-- Load patients.csv
COPY patients
FROM '/Users/leokariuki/Downloads/csv/patients.csv'
DELIMITER ','
CSV HEADER;

-- Load conditions.csv
COPY conditions
FROM '/Users/leokariuki/Downloads/csv/conditions.csv'
DELIMITER ','
CSV HEADER;

-- Load encounters.csv
COPY encounters
FROM '/Users/leokariuki/Downloads/csv/encounters.csv'
DELIMITER ','
CSV HEADER;


select * from medications

-- Patients demographic overview
SELECT gender, race, COUNT(*) AS patient_count
FROM patients
GROUP BY gender, race
ORDER BY patient_count DESC;

-- View condtions table
SELECT * from conditions 
LIMIT 5

-- Top 10 condtions diagnosed
SELECT description, count(*) AS diagnosis_count
FROM conditions
GROUP BY description
ORDER BY diagnosis_count DESC
LIMIT 10;

-- View encounters table
SELECT * FROM encounters
LIMIT 5

-- Check hospital utilization - encounters by type
SELECT encounter_class, COUNT(*) AS total_visits,
       AVG(total_claim_cost) AS avg_cost
FROM encounters
GROUP BY encounter_class
ORDER BY total_visits DESC;

select * from patients
limit 5

-- Patients with more than 1 encounter
SELECT p.id, COUNT(e.id) AS visits
FROM patients p
JOIN encounters e ON p.id = e.pateint_id
GROUP BY p.id
HAVING COUNT(e.id) > 1
ORDER BY visits DESC;

SELECT * FROM conditions


SELECT start_date, description, COUNT(*) AS diagnosis_count
	FROM conditions
	GROUP BY start_date, description
	ORDER BY diagnosis_count DESC;
	