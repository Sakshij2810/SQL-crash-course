 --------------------------------- departments ---------------------------------
-- -- create table
-- CREATE TABLE departments (
--     department_id SERIAL PRIMARY KEY,
--     department_name VARCHAR(20) NOT NULL
-- );

-- -- insert data values
-- INSERT INTO departments (department_name)
-- VALUES
-- ('Sales'),
-- ('Support'),
-- ('Warehouse');

-- -- constraints tests 

-- -- 1. null value in column "department_name" of relation "departments" violates not-null constraint
-- INSERT INTO departments (department_name)
-- VALUES
-- (NULL);

-- -- 2. duplicate key value violates unique constraint "departments_pkey"
-- INSERT INTO departments (department_id, department_name)
-- VALUES
-- (1, 'Tech');


-- -- display data
SELECT * FROM departments;

--------------------------------- employee ---------------------------------


CREATE TABLE employee (
    employee_id SERIAL PRIMARY KEY,
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
                     ),
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    department_id INT REFERENCES departments(department_id),
    manager_id INT REFERENCES employee(employee_id)
);



INSERT INTO employee ( first_name, last_name, email, department_id, job_title, salary, manager_id, hire_date)
VALUES
('Aarav', 'Shah', 'aarav.shah@techbazaar.com', 1, 'Sales Representative', 62000.00, NULL, '2021-03-10'),
('Meera', 'Patel', 'meera.patel@techbazaar.com', 2, 'Software Engineer', 85000.00, NULL, '2022-07-18'),
('Rohan', 'Desai', 'rohan.desai@techbazaar.com', 3, 'HR Specialist', 58000.00, NULL, '2020-11-02'),
('Ananya', 'Kulkarni', 'ananya.kulkarni@techbazaar.com', 2, 'Frontend Developer', 79000.00, NULL, '2023-01-09'),
('Vikram', 'Joshi', 'vikram.joshi@techbazaar.com', 1, 'Marketing Analyst', 71000.00, NULL, '2021-09-27'),
('Isha', 'Reddy', 'isha.reddy@techbazaar.com', 1, 'Account Executive', 65000.00, NULL, '2022-05-16'),
('Kabir', 'Singh', 'kabir.singh@techbazaar.com', 3, 'Recruiter', 56000.00, NULL, '2024-02-12'),
('Neha', 'Verma', 'neha.verma@techbazaar.com', 2, 'Marketing Manager', 92000.00, NULL, '2019-08-05');


UPDATE employee 
SET manager_id = 62
WHERE employee_id IN (57,58,59);

ALTER TABLE employee
ADD COLUMN internal_note VARCHAR(100) NOT NULL DEFAULT ('N/A');

ALTER TABLE employee
RENAME COLUMN internal_note TO hr_note;

ALTER TABLE employee
RENAME TO employees;

SELECT * FROM employees;

TRUNCATE TABLE employees;



--------------------------------- students ---------------------------------
CREATE TABLE students(
    student_id SERIAL PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    address TEXT
);

DROP TABLE students;