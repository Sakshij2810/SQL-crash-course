# PostgreSQL DDL — Quick Revision Notes

## 1. What is DDL?

**DDL (Data Definition Language)** is a subset of SQL used to define, create, and modify the structure of database objects such as tables, schemas, and indexes.

DDL focuses on the structure of a database rather than the actual data stored inside it.

### Main DDL Commands

| Command    | Purpose                               |
| ---------- | ------------------------------------- |
| `CREATE`   | Create a database object              |
| `ALTER`    | Modify an existing object             |
| `DROP`     | Delete a database object              |
| `TRUNCATE` | Remove all rows from a table          |
| `COMMENT`  | Add documentation to database objects |

### DDL vs DML vs DQL

| Category | Purpose                   | Examples                     |
| -------- | ------------------------- | ---------------------------- |
| DDL      | Define database structure | `CREATE`, `ALTER`, `DROP`    |
| DML      | Modify table data         | `INSERT`, `UPDATE`, `DELETE` |
| DQL      | Retrieve table data       | `SELECT`                     |
| DCL      | Control permissions       | `GRANT`, `REVOKE`            |
| TCL      | Manage transactions       | `COMMIT`, `ROLLBACK`         |

---

## 2. CREATE TABLE

Creates a new table with specified columns, data types, and constraints.

### Syntax

```sql
CREATE TABLE table_name (
    column_name data_type constraints,
    column_name data_type constraints
);
```

### Example

```sql
CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL
);
```

### Common PostgreSQL Data Types

| Data type      | Description                         |
| -------------- | ----------------------------------- |
| `INT`          | Whole numbers                       |
| `SERIAL`       | Auto-incrementing integer           |
| `VARCHAR(n)`   | Variable-length string with a limit |
| `TEXT`         | Variable-length text                |
| `BOOLEAN`      | TRUE or FALSE                       |
| `DATE`         | Date without time                   |
| `TIMESTAMP`    | Date and time                       |
| `NUMERIC(p,s)` | Exact decimal values                |

For money or salaries requiring decimal precision, `NUMERIC` is often preferable to floating-point types.

---

## 3. Constraints

Constraints enforce rules on the data stored in a table.

### PRIMARY KEY

Uniquely identifies each row. It cannot contain NULL values.

```sql
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);
```

### FOREIGN KEY

Ensures that a value references an existing row in another table or the same table.

```sql
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    department_id INT REFERENCES departments(department_id)
);
```

A self-referencing foreign key:

```sql
manager_id INT REFERENCES employees(employee_id)
```

This allows one employee to reference another employee as their manager.

### NOT NULL

Prevents a column from containing NULL values.

```sql
name VARCHAR(50) NOT NULL
```

### UNIQUE

Prevents duplicate values in a column.

```sql
email VARCHAR(150) UNIQUE
```

### CHECK

Ensures that values satisfy a condition.

```sql
salary INT CHECK (salary > 0)
```

### DEFAULT

Provides a value when an INSERT statement does not specify that column.

```sql
is_active BOOLEAN DEFAULT TRUE
```

### Example with Multiple Constraints

```sql
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    salary NUMERIC(10,2) NOT NULL CHECK (salary > 0),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    department_id INT REFERENCES departments(department_id)
);
```

---

## 4. ALTER TABLE

Used to modify the structure of an existing table.

### Add a Column

```sql
ALTER TABLE employees
ADD COLUMN phone VARCHAR(20);
```

Add a column with a default value:

```sql
ALTER TABLE employees
ADD COLUMN hr_note VARCHAR(100) NOT NULL DEFAULT 'N/A';
```

### Rename a Column

```sql
ALTER TABLE employees
RENAME COLUMN hr_note TO internal_note;
```

### Rename a Table

```sql
ALTER TABLE employees
RENAME TO employee;
```

### Change a Column's Data Type

```sql
ALTER TABLE employees
ALTER COLUMN phone TYPE VARCHAR(30);
```

### Set a Default Value

```sql
ALTER TABLE employees
ALTER COLUMN salary SET DEFAULT 50000;
```

### Remove a Default Value

```sql
ALTER TABLE employees
ALTER COLUMN salary DROP DEFAULT;
```

### Add NOT NULL

```sql
ALTER TABLE employees
ALTER COLUMN salary SET NOT NULL;
```

The existing data must not contain NULL values.

### Remove NOT NULL

```sql
ALTER TABLE employees
ALTER COLUMN salary DROP NOT NULL;
```

### Drop a Column

```sql
ALTER TABLE employees
DROP COLUMN phone;
```

---

## 5. Add and Drop Constraints

Constraints can be added or removed after creating a table.

### Add a Constraint

```sql
ALTER TABLE employees
ADD CONSTRAINT salary_positive
CHECK (salary > 0);
```

Add a unique constraint:

```sql
ALTER TABLE employees
ADD CONSTRAINT unique_employee_email
UNIQUE (email);
```

Add a foreign key:

```sql
ALTER TABLE employees
ADD CONSTRAINT fk_employee_department
FOREIGN KEY (department_id)
REFERENCES departments(department_id);
```

### Drop a Constraint

```sql
ALTER TABLE employees
DROP CONSTRAINT salary_positive;
```

PostgreSQL automatically generates names for unnamed constraints. You can inspect the actual name before dropping it.

---

## 6. TRUNCATE TABLE

Removes all rows from a table while keeping its structure.

```sql
TRUNCATE TABLE employees;
```

Reset the auto-incrementing sequence:

```sql
TRUNCATE TABLE employees RESTART IDENTITY;
```

Important points:

- `TRUNCATE` removes all rows; it does not accept a `WHERE` clause.
- `RESTART IDENTITY` resets sequences owned by the table.
- `CONTINUE IDENTITY` is the default behavior.
- `TRUNCATE` can be rolled back in PostgreSQL when used inside a transaction.
- PostgreSQL may reject truncation when other tables reference the table through foreign keys.

To truncate referencing tables as well:

```sql
TRUNCATE TABLE employees CASCADE;
```

**Be careful:** `CASCADE` can remove data from other tables too.

---

## 7. DROP TABLE

Deletes the entire table, including its data and structure.

```sql
DROP TABLE employees;
```

Delete only if the table exists:

```sql
DROP TABLE IF EXISTS employees;
```

Drop a table and its dependent objects:

```sql
DROP TABLE employees CASCADE;
```

`CASCADE` can also drop dependent objects, so use it carefully.

---

## 8. CREATE INDEX

An index helps PostgreSQL find rows more efficiently.

```sql
CREATE INDEX idx_employee_last_name
ON employees(last_name);
```

Create a unique index:

```sql
CREATE UNIQUE INDEX idx_employee_email
ON employees(email);
```

Remove an index:

```sql
DROP INDEX idx_employee_last_name;
```

Important points:

- Indexes can improve SELECT query performance.
- Indexes require additional storage.
- Indexes can slow down INSERT, UPDATE, and DELETE operations because they must be maintained.
- Primary keys and unique constraints automatically create unique indexes in PostgreSQL.

---

## 9. CREATE TABLE AS SELECT

Creates a new table using the results of a query.

```sql
CREATE TABLE high_salary_employees AS
SELECT *
FROM employees
WHERE salary > 80000;
```

This creates a new table containing only employees earning more than 80,000.

Important: `CREATE TABLE AS` copies the query results, not the original table's constraints, indexes, or other structural properties.

---

## 10. CREATE SCHEMA

A schema is a logical namespace used to organize database objects.

```sql
CREATE SCHEMA company;
```

Create a table inside the schema:

```sql
CREATE TABLE company.employees (
    employee_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);
```

Drop a schema:

```sql
DROP SCHEMA company;
```

Drop a schema and its contained objects:

```sql
DROP SCHEMA company CASCADE;
```

---

## 11. COMMENT ON

Adds documentation to database objects.

```sql
COMMENT ON TABLE employees IS 'Stores employee information';

COMMENT ON COLUMN employees.salary IS 'Employee salary in INR';
```

Comments can be viewed in database tools or through PostgreSQL system catalogs.

---

## 12. Important Differences

### DELETE vs TRUNCATE vs DROP

| Command    | Removes rows | Removes table structure | WHERE allowed |
| ---------- | ------------ | ----------------------- | ------------- |
| `DELETE`   | Yes          | No                      | Yes           |
| `TRUNCATE` | All rows     | No                      | No            |
| `DROP`     | Yes          | Yes                     | No            |

### DROP vs ALTER

- `DROP` removes a database object.
- `ALTER` modifies the structure of an existing object.

### SERIAL vs IDENTITY

`SERIAL` is PostgreSQL shorthand that creates an integer column backed by a sequence.

Modern PostgreSQL also supports identity columns:

```sql
employee_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY
```

Identity columns are SQL-standard alternatives to `SERIAL`.

---

## 13. Practice Queries

Use the following queries to practice DDL operations on your employee table.

### Create a new table

```sql
CREATE TABLE projects (
    project_id SERIAL PRIMARY KEY,
    project_name VARCHAR(100) NOT NULL
);
```

### Add a column

```sql
ALTER TABLE employees
ADD COLUMN date_of_birth DATE;
```

### Rename a column

```sql
ALTER TABLE employees
RENAME COLUMN date_of_birth TO birth_date;
```

### Rename a table

```sql
ALTER TABLE employees
RENAME TO employee;
```

### Change a column's data type

```sql
ALTER TABLE employee
ALTER COLUMN phone TYPE VARCHAR(30);
```

### Add and remove a constraint

```sql
ALTER TABLE employee
ADD CONSTRAINT positive_salary
CHECK (salary > 0);

ALTER TABLE employee
DROP CONSTRAINT positive_salary;
```

### Drop a column

```sql
ALTER TABLE employee
DROP COLUMN birth_date;
```

### Create and drop an index

```sql
CREATE INDEX idx_employee_job_title
ON employee(job_title);

DROP INDEX idx_employee_job_title;
```

### Create a table from a query

```sql
CREATE TABLE active_employees AS
SELECT *
FROM employee
WHERE is_active = TRUE;
```

### Truncate a table

```sql
TRUNCATE TABLE active_employees RESTART IDENTITY;
```

### Drop a table

```sql
DROP TABLE IF EXISTS active_employees;
```

---

## 14. Quick Revision

- `CREATE` → Create a database object.
- `ALTER` → Modify an existing database object.
- `DROP` → Delete a database object.
- `TRUNCATE` → Remove all rows from a table.
- `COMMENT` → Document a database object.
- Constraints → Enforce data integrity.
- Indexes → Improve query performance.

**Remember:** DDL is about defining and modifying the structure of your database. DML is about inserting, updating, and deleting the actual data.
