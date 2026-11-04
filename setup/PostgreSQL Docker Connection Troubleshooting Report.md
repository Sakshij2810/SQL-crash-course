# PostgreSQL Docker Connection Troubleshooting Report

## Summary

The goal was to connect SQLTools (and `psql` from the Mac terminal) to a PostgreSQL 18 database running in Docker.

The Docker container and database were created successfully. The connection initially failed because Homebrew PostgreSQL services on the Mac were also listening on port `5432`. Connections were reaching the local PostgreSQL server instead of the Docker container.

After stopping the local PostgreSQL 15 and PostgreSQL 14 services, the connection reached the Docker PostgreSQL 18 server and succeeded.

## 1. Start Docker and run PostgreSQL

The first `docker run` attempt failed because Docker Desktop's daemon was not running:

```text
Cannot connect to the Docker daemon ... Is the docker daemon running?
```

Starting Docker Desktop resolved that issue. The container was then created with:

```bash
docker run -d --name sql_cc -e POSTGRES_PASSWORD=postgres -p 5432:5432 postgres:18
```

Confirm that it is running:

```bash
docker ps
```

The container appeared as `sql_cc`, with port `5432` published.

> If Docker reports that a container named `sql_cc` already exists, do not create another one. Check it with `docker ps -a` and start it with `docker start sql_cc` if it is stopped.

## 2. Create and verify the database inside Docker

Open `psql` inside the container:

```bash
docker exec -it sql_cc psql -U postgres
```

Create the database:

```sql
CREATE DATABASE chaicode_ecom_db;
```

Exit `psql` with the correct command:

```text
\q
```

(`/q` is not a valid `psql` quit command; it can leave the prompt in continuation mode.)

Connect directly to the new database inside the container:

```bash
docker exec -it sql_cc psql -U postgres -d chaicode_ecom_db
```

Verify the user and database:

```sql
SELECT current_user, current_database();
```

The result confirmed:

```text
current_user     | current_database
-----------------+------------------
postgres         | chaicode_ecom_db
```

This proved that the Docker PostgreSQL instance and database were configured correctly.

## 3. Identify why host connections failed

The following host commands initially failed:

```bash
psql -h localhost -p 5432 -U postgres -d chaicode_ecom_db
psql -h 127.0.0.1 -p 5432 -U postgres -d chaicode_ecom_db
```

The first error was:

```text
FATAL: role "postgres" does not exist
```

The port inspection command showed two servers listening on port `5432`:

```bash
lsof -nP -iTCP:5432 -sTCP:LISTEN
```

The output included a local `postgres` process and Docker's port-forwarding process. Homebrew services showed that PostgreSQL 15 was started and PostgreSQL 14 was in an error state:

```bash
brew services list
```

Stopping PostgreSQL 15 alone did not resolve the issue because another local PostgreSQL process continued listening. The next connection reached a PostgreSQL server but reported that `chaicode_ecom_db` did not exist—another indication that it was reaching the wrong instance.

## 4. Stop the conflicting local PostgreSQL services

Stop the Homebrew PostgreSQL 15 service:

```bash
brew services stop postgresql@15
```

Then stop PostgreSQL 14 as well:

```bash
brew services stop postgresql@14
```

Check port `5432` again:

```bash
lsof -nP -iTCP:5432 -sTCP:LISTEN
```

After both services were stopped, the remaining listener was Docker's port-forwarding process.

## 5. Connect to the Docker database from the Mac

Run:

```bash
psql -h 127.0.0.1 -p 5432 -U postgres -d chaicode_ecom_db
```

Enter the password configured for the container:

```text
postgres
```

The connection succeeded and displayed:

```text
psql (15.14 (Homebrew), server 18.6 (Debian 18.6-1.pgdg13+2))
WARNING: psql major version 15, server major version 18.
...
chaicode_ecom_db=#
```

The version warning is not a connection failure. It means the installed `psql` client is version 15 while the Docker PostgreSQL server is version 18. Basic connection and SQL usage worked.

## 6. SQLTools connection settings

Use these settings in SQLTools:

| Setting           | Value              |
| ----------------- | ------------------ |
| Connection method | Server and Port    |
| Server address    | `127.0.0.1`        |
| Port              | `5432`             |
| Database          | `chaicode_ecom_db` |
| Username          | `postgres`         |
| Password          | `postgres`         |
| SSL               | Disabled           |

Then use **Test Connection**.

## Final diagnosis

- Docker PostgreSQL 18 was working correctly.
- The database `chaicode_ecom_db` existed inside the Docker container.
- Homebrew PostgreSQL services on the Mac were conflicting with Docker on port `5432`.
- Stopping `postgresql@15` and `postgresql@14` cleared the conflict.
- The host `psql` connection then succeeded against the Docker server.

The local PostgreSQL services were stopped, not deleted; their local databases were not removed.
