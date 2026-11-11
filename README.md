# Library MVC

Spring Boot backend for a library management system, built with a layered MVC architecture.

## Contents

- [Tech stack](#tech-stack)
- [Quick start](#quick-start)
- [Configuration (.env)](#configuration-env)
- [Commands](#commands)

## Tech stack

| Area              | Technology                                 |
|-------------------|--------------------------------------------|
| Language          | Java 25                                    |
| Framework         | Spring Boot 4.1.1                          |
| Build             | Maven                                      |
| Database          | PostgreSQL 18                              |
| API documentation | OpenAPI, Swagger UI                        |
| Null-safety       | JSpecify, NullAway                         |
| Testing           | JUnit 6, Testcontainers                    |
| Code quality      | Spotless (Google Java Format), PMD         |
| Tooling           | Docker Compose, Task, direnv and Nix flake |
| CI                | GitHub Actions                             |

## Quick start

### Prerequisites

**Required**

- **[JDK 25](https://adoptium.net/temurin/releases/?version=25)**: compiles and runs the application. Check with `java -version`.
- **[Docker](https://docs.docker.com/get-started/get-docker/)**: runs PostgreSQL through Docker Compose, and the containers started by the tests (Testcontainers). Use Docker Desktop on macOS and Windows, or Docker Engine with the Compose plugin on Linux. Check with `docker compose version`.

Maven is not required: the Maven Wrapper downloads the pinned version when needed.

**Optional**

None of these is needed to build or run the project; they only make daily work shorter.

- **[Task](https://taskfile.dev/installation/)**: a task runner. `Taskfile.yaml` defines short commands such as `task run` and `task verify`, picks the right Maven Wrapper script for your system and loads `.env` for every command. Check with `task --version`.
- **[Nix](https://nixos.org/download/)** (Linux, macOS, WSL2): a package manager. `flake.nix` defines a dev shell with JDK 25 and Task, so you don't install tools by hand, and loads environment variables from `.env`. Run `nix develop` to open it (flakes must be enabled). Docker is not part of the shell and must be installed on the host.
- **[direnv](https://direnv.net/docs/installation.html)** (Linux, macOS, WSL2): loads environment variables when you enter a directory. The bundled `.envrc` loads `.env` and activates the Nix dev shell, so run `direnv allow` once after cloning. Set up its shell hook as described in the installation guide.

On Windows use PowerShell, or WSL2 with the Linux steps. Line endings are normalized by `.gitattributes`, so the wrapper script works from WSL and Git Bash.

### Run it

> [!NOTE]
> The commands below use Task. For plain commands see [Commands](#commands).

**1. Clone**

```bash
git clone <repository-url> library-mvc
cd library-mvc
```

**2. Create the environment file**

```bash
# Linux / macOS
cp .env.example .env
```

```powershell
# Windows (PowerShell)
Copy-Item .env.example .env
```

Set all variables in `.env`.

**3. Load the environment into your shell**

Docker Compose reads `.env` on its own, but the application reads configuration from the process environment.

If you don't use Task, Nix or direnv, load the variables manually:

```bash
# Linux / macOS
set -a
source .env
set +a
```

On Windows, set the environment variables in your PowerShell session.

**4. Run the application**

```bash
task run
```

Spring Boot automatically starts the PostgreSQL container using Docker Compose.

**5. Stop**

- `Ctrl+C` stops the application together with the PostgreSQL container.
- `task down` stops and removes the containers while preserving the database data.
- `task down-volumes` also deletes the local database data.

## Configuration (.env)

| Variable      | Purpose                      |
|---------------|------------------------------|
| `DB_NAME`     | PostgreSQL database name     |
| `DB_USERNAME` | PostgreSQL database username |
| `DB_PASSWORD` | PostgreSQL database password |

## Commands

| Task                | What it does                          | Without Task                   |
|---------------------|---------------------------------------|--------------------------------|
| `task run`          | Run the application                   | `./mvnw spring-boot:run`       |
| `task test`         | Run the tests                         | `./mvnw test`                  |
| `task verify`       | Tests, Spotless check, PMD            | `./mvnw clean verify`          |
| `task format`       | Format the code with Spotless         | `./mvnw spotless:apply`        |
| `task clean`        | Remove generated build files          | `./mvnw clean`                 |
| `task up`           | Start PostgreSQL in Docker            | `docker compose up --build -d` |
| `task down`         | Stop containers, keep data            | `docker compose down`          |
| `task down-volumes` | Stop containers and delete local data | `docker compose down -v`       |
| `task update-flake` | Update flake.lock (requires Nix)      | `nix flake update`             |

On Windows use `.\mvnw.cmd` instead of `./mvnw`.
