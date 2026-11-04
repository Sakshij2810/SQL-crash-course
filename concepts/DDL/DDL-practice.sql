 ------------------------------------------------------------------ departments ------------------------------------------------------------------
-- create table
CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY, -- value cannot be NULL and it must be unique
    department_name VARCHAR(50) NOT NULL
); 


-- insert data values
INSERT INTO departments (department_name) 
VALUES
('Sales'),
('Support'),
('Warehouse');

INSERT INTO departments (department_name)
VALUES
('tech'),
('hr');

-- constraints tests 

-- 1. null value in column "department_name" of relation "departments" violates not-null constraint
INSERT INTO departments (department_name)
VALUES
(NULL);

-- 2. duplicate key value violates unique constraint "departments_pkey"
INSERT INTO departments (department_id, department_name)
VALUES
(1, 'Tech');

DROP TABLE departments;


-- -- display data
SELECT * FROM departments;

------------------------------------------------------------------ employee ------------------------------------------------------------------

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY, -- cannot be null it is unique
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    phone VARCHAR(20),
    bio TEXT,
    job_title VARCHAR(50) NOT NULL,
    salary INT NOT NULL CHECK (salary > 0),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    hire_date DATE NOT NULL,
    last_login TIMESTAMP,
    employee_status VARCHAR(20) NOT NULL DEFAULT 'active'
                    CHECK (
                        employee_status IN ('active', 'on_leave', 'terminated')
                    ), -- active, on_leave, terminated
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    department_id INT REFERENCES departments(department_id),
    manager_id INT REFERENCES employees(employee_id)
);



INSERT INTO employees (first_name, last_name, email, department_id, job_title, salary, manager_id, hire_date) VALUES
    ('Priya',  'Nair',      'priya.nair@techbazaar.com',      1, 'Sales Representative', 62000.00, NULL,    '2020-06-15'),
    ('Fake',   'Robert',    'robert.chen@techbazaar.com',     1, 'Rep',                  50000.00, NULL,    '2024-01-01'),
    ('Marcus', 'Webb',      'marcus.webb@techbazaar.com',     1, 'Sales Representative', 58000.00, NULL,    '2021-09-01'),
    ('Elena',  'Garcia',    'elena.garcia@techbazaar.com',    1, 'Senior Sales Rep',     68000.00, NULL,    '2019-11-20'),
    ('James',  'Okafor',    'james.okafor@techbazaar.com',    2, 'Support Lead',         72000.00, NULL, '2018-05-10'),
    ('Lily',   'Zhang',     'lily.zhang@techbazaar.com',      2, 'Support Agent',        48000.00, NULL,    '2022-02-14'),
    ('Diego',  'Fernandez', 'diego.fernandez@techbazaar.com', 2, 'Support Agent',        46000.00, NULL,    '2023-01-09'),
    ('Sara',   'Osei',      'sara.osei@techbazaar.com',       5, 'Warehouse Lead',       55000.00, NULL, '2020-08-23');



UPDATE employees
SET manager_id = 1
WHERE employee_id IN (1,2,3,4);

UPDATE employees
SET manager_id = 5
WHERE employee_id IN (6,7);

ALTER TABLE employee
ADD COLUMN internal_note VARCHAR(100) NOT NULL DEFAULT ('N/A');

ALTER TABLE employee
RENAME COLUMN internal_note TO hr_note;

ALTER TABLE employee
RENAME TO employees;

SELECT * FROM employees
ORDER BY employee_id;

DROP TABLE employees;

TRUNCATE TABLE employees;



------------------------------------------------------------------ students ------------------------------------------------------------------
CREATE TABLE students(
    student_id SERIAL PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    address TEXT
);

DROP TABLE students;