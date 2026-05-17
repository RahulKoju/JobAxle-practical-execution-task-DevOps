# DevOps Node App

A containerized Node.js + Express application demonstrating a full DevOps workflow: Git version control, Docker, Docker Compose, Nginx reverse proxy, GitHub Actions CI/CD, Bash automation, secure environment configuration, static frontend deployment, and end-to-end deployment lifecycle documentation.

**Repository:** [GitHub](https://github.com/RahulKoju/JobAxle-practical-execution-task-DevOps)
**Frontend:** [https://jobaxle-devops-node.netlify.app/](https://jobaxle-devops-node.netlify.app/)

---

## Project Structure

```text
devops-node-app/
├── src/
│   ├── app.js               # Express app (routes)
│   ├── index.js             # Entry point (server listen)
│   └── index.test.js        # Jest + Supertest tests
├── nginx/
│   └── nginx.conf           # Nginx reverse proxy config
├── frontend/
│   ├── index.html           # Static frontend (deployed to Netlify)
│   └── netlify.toml         # Netlify build config
├── scripts/
│   └── deploy.sh            # Bash deployment automation script
├── .github/
│   └── workflows/
│       └── ci.yml           # GitHub Actions CI/CD pipeline
├── Dockerfile               # Optimized multi-stage Docker build
├── docker-compose.yml       # Multi-container setup (app + db + nginx)
├── .env.example             # Environment variable template
└── README.md
```

---

## Quick Start

### Prerequisites

Make sure you have these installed before running anything:

| Tool           | Version | Check                    |
| -------------- | ------- | ------------------------ |
| Node.js        | 18+     | `node -v`                |
| npm            | 9+      | `npm -v`                 |
| Docker         | Latest  | `docker --version`       |
| Docker Compose | v2+     | `docker compose version` |
| Git            | Any     | `git --version`          |

### Environment Variables

Copy the example file and fill in your values:

```bash
cp .env.example .env
```

Then open `.env` and set the following:

| Variable            | Description                        | Example                                        |
| ------------------- | ---------------------------------- | ---------------------------------------------- |
| `POSTGRES_USER`     | PostgreSQL username                | `postgres`                                     |
| `POSTGRES_PASSWORD` | PostgreSQL password                | `postgres`                                     |
| `POSTGRES_DB`       | PostgreSQL database name           | `appdb`                                        |
| `DATABASE_URL`      | Full connection string for the app | `postgresql://postgres:postgres@db:5432/appdb` |

> **Note:** Never commit your `.env` file. It is listed in `.gitignore`. Only `.env.example` is committed.

### Run with Docker Compose (recommended)

This starts the Node.js app, PostgreSQL database, and Nginx reverse proxy together:

```bash
# 1. Clone the repository
git clone https://github.com/RahulKoju/JobAxle-practical-execution-task-DevOps.git
cd JobAxle-practical-execution-task-DevOps

# 2. Set up environment variables
cp .env.example .env

# 3. Start all services
docker compose up -d

# 4. Verify everything is running
docker compose ps
curl http://localhost/health
```

The app is now accessible at `http://localhost` (port 80 via Nginx).

### Run without Docker (Node only)

```bash
npm install
npm start
# App runs at http://localhost:3000
```

### Run Tests

```bash
npm ci
npm test
```

### Deploy via Script

```bash
chmod +x scripts/deploy.sh
./scripts/deploy.sh
```

The script can also take an optional image tag:

```bash
./scripts/deploy.sh latest
```

### Stop All Services

```bash
docker compose down        # stop containers
docker compose down -v     # stop containers and remove DB volume
```

---

## Tasks

### Task 1 — Initialize Git Repo & Push code to GitHub with proper commit messages

**What was done:**
Created the Node.js project from scratch, initialized a Git repository, and pushed it to GitHub with structured, conventional commit messages.

**Steps:**

```bash
mkdir jobaxle-practical-execution-task-devops && cd jobaxle-practical-execution-task-devops
npm init -y
npm install express
git init
git add .
git commit -m "feat: initial project setup with Express server"
git remote add origin https://github.com/RahulKoju/JobAxle-practical-execution-task-DevOps.git
git branch -M main
git push -u origin main
```

**Commit message convention used:**

| Prefix   | Purpose                |
| -------- | ---------------------- |
| `feat:`  | New feature or file    |
| `fix:`   | Bug fix                |
| `docs:`  | Documentation changes  |
| `chore:` | Config, tooling, setup |
| `ci:`    | CI/CD pipeline changes |

---

### Task 2 — Branching Strategy

**What was done:**
Implemented a three-tier branching strategy: `feature/*` → `develop` → `main`. Feature branches were merged into `develop` via Pull Requests on GitHub (not direct git merge), and `develop` was merged into `main` via PR to simulate a release workflow.

**Branch flow:**

```text
feature/add-users-route
        │
        ▼  (Pull Request)
     develop
        │
        ▼  (Pull Request)
       main
```

**Steps:**

```bash
# Create develop branch
git checkout -b develop
git push -u origin develop

# Create a feature branch from develop
git checkout -b feature/add-users-route

# After making changes, push and open a PR on GitHub
git add .
git commit -m "feat: add /users endpoint"
git push -u origin feature/add-users-route

# PR: feature/add-users-route → develop (merged on GitHub)
# PR: develop → main (merged on GitHub)
```

**Branches created:**

- `main` — stable production branch
- `develop` — integration branch for completed features
- `feature/add-users-route` — isolated feature work
- `feature/update-home-branch-a` — used for merge conflict simulation
- `feature/update-home-branch-b` — used for merge conflict simulation

---

### Task 3 — Merge Conflict Resolution

**What was done:**
Simulated a merge conflict by creating two branches that both modified the same line in `src/app.js`. Branch A and Branch B each had different home route messages. Branch A was merged into `develop` first via PR, then Branch B was merged using `git merge` locally, causing a conflict that was resolved in VS Code.

**Steps:**

```bash
# Create branch A and change home message
git checkout develop
git checkout -b feature/update-home-branch-a
# Edit src/app.js → message: "Hello from Branch A"
git add . && git commit -m "feat: update home message in branch A"
git push origin feature/update-home-branch-a

# Create branch B with a conflicting change
git checkout develop
git checkout -b feature/update-home-branch-b
# Edit src/app.js → message: "Hello from Branch B"
git add . && git commit -m "feat: update home message in branch B"
git push origin feature/update-home-branch-b

# Merge branch A into develop first (via PR on GitHub)
# Then merge branch B locally to trigger the conflict
git checkout develop
git merge feature/update-home-branch-b
# CONFLICT (content): Merge conflict in src/app.js
```

**Conflict markers seen in `src/app.js`:**

```text
<<<<<<< HEAD
  message: "Hello from Branch A"
=======
  message: "Hello from Branch B"
>>>>>>> feature/update-home-branch-b
```

**Resolution:**
Opened the file in VS Code, which highlighted the conflict with "Accept Current Change / Accept Incoming Change / Accept Both" options. Manually edited the message to combine both, resulting in:

```js
message: "Hello from Branch A and B merged together in develop branch simulating merge conflicts";
```

**Completing the resolution:**

```bash
git add src/app.js
git commit -m "fix: resolve merge conflict between branch A and B on home route"
git push origin develop
```

---

### Task 4 — Dockerfile (Optimized for Small Image Size)

**What was done:**
Wrote a multi-stage Dockerfile using `node:18-alpine` as the base image. The first stage installs only production dependencies; the second stage copies only what is needed to run the app, resulting in a minimal final image.

**`Dockerfile`:**

```dockerfile
# Stage 1 - install dependencies
FROM node:18-alpine AS deps
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

# Stage 2 - final minimal image
FROM node:18-alpine AS runner
WORKDIR /app

COPY --from=deps /app/node_modules ./node_modules
COPY src/ ./src/
COPY package.json ./

EXPOSE 3000
CMD ["node", "src/index.js"]
```

**Optimization techniques applied:**

| Technique                  | Reason                                                     |
| -------------------------- | ---------------------------------------------------------- |
| `node:18-alpine` base      | Alpine Linux is smaller than full Debian images            |
| Multi-stage build          | Dev tools and build cache are not included in final image  |
| `npm ci --only=production` | Installs exact locked versions, excludes devDependencies   |
| Minimal COPY               | Only `src/`, `package.json`, and `node_modules` are copied |

**Build and verify:**

```bash
docker build -t devops-node-app:latest .
docker images devops-node-app
```

---

### Task 5 — Run a Container & Debug Issues

**What was done:**
Ran the container, simulated a failure by passing an invalid environment variable, and used Docker debugging commands to identify and fix the issue.

**Run the container:**

```bash
docker run -d -p 3000:3000 --name my-app devops-node-app:latest
curl http://localhost:3000/health
```

**Simulate a failure:**

```bash
docker stop my-app && docker rm my-app
docker run -d -p 3000:3000 --name my-app -e PORT=abc devops-node-app:latest
```

**Debug commands used:**

```bash
docker logs my-app
docker inspect my-app
docker exec -it my-app sh
docker stats my-app
docker ps -a
```

**Fix — restart with correct environment:**

```bash
docker stop my-app && docker rm my-app
docker run -d -p 3000:3000 --name my-app -e PORT=3000 devops-node-app:latest
curl http://localhost:3000/health
```

---

### Task 6 — Docker Compose (Multi-container: App + DB + Nginx)

**What was done:**
Used Docker Compose to manage three services together: the Node.js app, a PostgreSQL database, and Nginx as a reverse proxy. Services communicate over a shared internal network. The DB uses a named volume for data persistence and a healthcheck so the app only starts after the DB is ready.

**`docker-compose.yml`:**

```yaml
services:
  app:
    image: ${APP_IMAGE:-devops-node-app:latest}
    build: .
    ports:
      - "3000:3000"
    environment:
      - PORT=3000
      - DATABASE_URL=${DATABASE_URL}
    depends_on:
      db:
        condition: service_healthy
    networks:
      - app-network
    restart: unless-stopped

  db:
    image: postgres:16-alpine
    environment:
      - POSTGRES_USER=${POSTGRES_USER}
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
      - POSTGRES_DB=${POSTGRES_DB}
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test:
        [
          "CMD-SHELL",
          "pg_isready -U $$POSTGRES_USER -d $$POSTGRES_DB",
        ]
      interval: 10s
      timeout: 5s
      retries: 5
    networks:
      - app-network

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro
    depends_on:
      - app
    networks:
      - app-network
    restart: unless-stopped

volumes:
  postgres_data:

networks:
  app-network:
    driver: bridge
```

---

### Task 7 — Nginx Reverse Proxy

**What was done:**
Configured Nginx to listen on port 80 and forward requests to the Node app running on the `app` service inside the Docker Compose network.

**`nginx/nginx.conf`:**

```nginx
events {
  worker_connections 1024;
}

http {
  upstream node_backend {
    server app:3000;
  }

  server {
    listen 80;
    server_name localhost;

    location / {
      proxy_pass http://node_backend;
      proxy_http_version 1.1;

      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection 'upgrade';

      proxy_connect_timeout 10s;
      proxy_read_timeout 30s;
    }
  }
}
```

---

### Task 8 — Bash Deployment Script

**What was done:**
Created a Bash script to automate deployment checks, service startup, and health verification.

**`scripts/deploy.sh`:**

```bash
#!/bin/bash
set -e

APP_NAME="devops-node-app"
IMAGE_TAG="${1:-latest}"
ENV_FILE=".env"
APP_IMAGE="$APP_NAME:$IMAGE_TAG"

echo "Starting deployment of $APP_IMAGE"

if ! docker info > /dev/null 2>&1; then
  echo "ERROR: Docker is not running"
  exit 1
fi

if [ ! -f "$ENV_FILE" ]; then
  echo "ERROR: $ENV_FILE not found"
  exit 1
fi

echo "[1/4] Preparing image..."
if docker pull "$APP_IMAGE"; then
  COMPOSE_BUILD_FLAG="--no-build"
else
  echo "Image not available remotely, building locally"
  COMPOSE_BUILD_FLAG="--build"
fi

echo "[2/4] Stopping existing container..."
docker compose down || true

echo "[3/4] Starting services..."
APP_IMAGE="$APP_IMAGE" docker compose --env-file "$ENV_FILE" up -d $COMPOSE_BUILD_FLAG

echo "[4/4] Health check..."
sleep 5
if curl -sf http://localhost/health > /dev/null; then
  echo "Deployment successful: app is healthy"
else
  echo "Health check failed, stopping deployment"
  docker compose down
  exit 1
fi
```

---

### Task 14 — Full CI/CD YAML (Build, Test, Deploy)

**What was done:**
The GitHub Actions workflow covers all three stages of a CI/CD pipeline in sequence: test → build → deploy. Each job depends on the previous one passing.

**Full pipeline (`.github/workflows/ci.yml`):**

```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    name: Build & Test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: "18"
          cache: "npm"
      - run: npm ci
      - run: npm test

  docker-build:
    name: Build Docker Image
    runs-on: ubuntu-latest
    needs: test
    steps:
      - uses: actions/checkout@v4
      - name: Build image
        run: docker build -t devops-node-app:${{ github.sha }} .
      - name: Smoke test
        run: |
          docker run -d -p 3000:3000 --name test-app devops-node-app:${{ github.sha }}
          sleep 3
          curl -f http://localhost:3000/health
          docker stop test-app

  deploy:
    name: Deploy
    runs-on: ubuntu-latest
    needs: docker-build
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      - name: Deploy (simulated)
        run: echo "Deploying ${{ github.sha }} to production"
```

**Stage breakdown:**

| Stage  | Job            | Key actions                                             |
| ------ | -------------- | ------------------------------------------------------- |
| Test   | `test`         | Checkout, setup Node 18, `npm ci`, `npm test`           |
| Build  | `docker-build` | Build Docker image tagged with Git SHA, curl smoke test |
| Deploy | `deploy`       | Runs only on `main` branch after build passes           |

---

### Task 15 — End-to-End Deployment Lifecycle

**Overview:**

The full journey from writing code to serving a user request passes through these stages:

```text
Code written → git commit → git push → GitHub Actions triggered
→ Tests run → Docker image built → Smoke tested
→ Deploy job runs → Container starts → Nginx proxies traffic
→ User request served
```

**Detailed stage breakdown:**

**1. Code & Commit**
Developer writes code and commits with a conventional message. Branching strategy ensures no direct commits to `main`.

**2. Pull Request**
Feature branch is opened as a PR to `develop` or `main`. CI pipeline triggers on the PR automatically.

**3. CI — Test Stage**
GitHub Actions checks out code, installs dependencies with `npm ci`, and runs Jest tests. If any test fails, the pipeline stops.

**4. CI — Build Stage**
Docker image is built using the multi-stage Dockerfile. The image is tagged with the Git commit SHA for traceability. A smoke test runs the container and curls `/health` to confirm it starts correctly.

**5. CI — Deploy Stage**
Runs only when a push hits `main`. In this project it is simulated with an echo.

**6. Runtime — Docker Compose**
On the server, `docker compose up -d` starts the app, PostgreSQL, and Nginx. The app waits for the DB healthcheck before starting.

**7. Traffic — Nginx**
Incoming HTTP traffic on port 80 hits Nginx first. Nginx proxies the request to the Node app on port 3000 inside the Docker network.

---

## API Endpoints

| Method | Endpoint  | Description                               |
| ------ | --------- | ----------------------------------------- |
| GET    | `/`       | Returns app info + merge conflict message |
| GET    | `/health` | Health check — returns `{ status: "ok" }` |
| GET    | `/users`  | Returns list of users                     |

---

## Tech Stack

| Category         | Technology             |
| ---------------- | ---------------------- |
| Runtime          | Node.js 18             |
| Framework        | Express 5              |
| Database         | PostgreSQL 16          |
| Containerization | Docker, Docker Compose |
| Reverse Proxy    | Nginx (Alpine)         |
| CI/CD            | GitHub Actions         |
| Testing          | Jest, Supertest        |
| Frontend Hosting | Netlify                |
| Scripting        | Bash                   |

---

## Appendix A — Merge Conflict Resolution

### Overview

This section describes the merge conflict that was intentionally created to simulate a real-world scenario where two developers modify the same line of code in parallel branches, and how it was resolved.

### Scenario

Two feature branches were created from `develop`, both modifying the same line in `src/app.js`.

| Branch | Change Made |
|--------|------------|
| `feature/update-home-branch-a` | Changed home message to `"Hello from Branch A"` |
| `feature/update-home-branch-b` | Changed home message to `"Hello from Branch B"` |

Branch A was merged into `develop` first via Pull Request on GitHub. When Branch B was then merged locally using `git merge`, Git detected that the same line had been modified by both branches and could not automatically decide which version to keep.

### Steps Taken

#### Step 1 — Create Branch A and make a change

```bash
git checkout develop
git checkout -b feature/update-home-branch-a
```

Edited `src/app.js`:

```js
app.get("/", (req, res) =>
  res.json({ message: "Hello from Branch A" })
);
```

```bash
git add .
git commit -m "feat: update home message in branch A"
git push origin feature/update-home-branch-a
```

#### Step 2 — Create Branch B with a conflicting change

```bash
git checkout develop
git checkout -b feature/update-home-branch-b
```

Edited the same line:

```js
app.get("/", (req, res) =>
  res.json({ message: "Hello from Branch B" })
);
```

```bash
git add .
git commit -m "feat: update home message in branch B"
git push origin feature/update-home-branch-b
```

#### Step 3 — Trigger the conflict

```bash
git checkout develop
git merge feature/update-home-branch-b
```

Git output:

```text
Auto-merging src/app.js
CONFLICT (content): Merge conflict in src/app.js
Automatic merge failed; fix conflicts and then commit the result.
```

#### Step 4 — Identify the conflict

Opened `src/app.js`. Git inserted conflict markers:

```text
<<<<<<< HEAD
  res.json({ message: "Hello from Branch A" }),
=======
  res.json({ message: "Hello from Branch B" }),
>>>>>>> feature/update-home-branch-b
```

#### Step 5 — Resolve in VS Code

Instead of picking one side, the message was manually combined:

```js
app.get("/", (req, res) =>
  res.json({
    message:
      "Hello from Branch A and B merged together in develop branch simulating merge conflicts",
  })
);
```

#### Step 6 — Mark as resolved and commit

```bash
git add src/app.js
git commit -m "fix: resolve merge conflict between branch A and B on home route"
git push origin develop
```

### Key Learnings

- Merge conflicts happen when two branches modify the same lines of the same file.
- Git cannot auto-resolve these; a human decision is required.
- VS Code's conflict UI makes it easier to visualize both sides before deciding.
- Always run the app after resolving to confirm nothing is broken.

---

## Appendix B — Container Debugging

### Overview

This section covers how a failing container was debugged using Docker tools. A crash was intentionally simulated by pointing the start command to a non-existent file, then diagnosed and fixed.

### Simulating the Failure

```dockerfile
CMD ["node", "src/nonexistent.js"]
```

```bash
docker build -t devops-node-app:broken .
docker run -d -p 3000:3000 --name broken-app devops-node-app:broken
```

### Debugging Steps

#### Step 1 — Check container status

```bash
docker ps -a
```

The container exited immediately with status code `1`.

#### Step 2 — Read the logs

```bash
docker logs broken-app
```

Example error:

```text
Error: Cannot find module '/app/src/nonexistent.js'
```

#### Step 3 — Confirm the exit code

```bash
docker inspect broken-app --format='{{.State.ExitCode}}'
```

#### Step 4 — Inspect what files exist inside the image

```bash
docker run -it devops-node-app:broken sh
ls src/
```

This confirmed that `src/nonexistent.js` was never present and the correct entry point is `src/index.js`.

### Fix Applied

Corrected the Dockerfile:

```dockerfile
CMD ["node", "src/index.js"]
```

Then rebuilt and ran the fixed image:

```bash
docker build -t devops-node-app:latest .
docker rm broken-app
docker run -d -p 3000:3000 --name fixed-app devops-node-app:latest
```

### Verification

```bash
curl http://localhost:3000/health
curl http://localhost:3000/
```

### Debugging Command Reference

| Command | Purpose |
|---------|---------|
| `docker ps -a` | List all containers including stopped ones |
| `docker logs <name>` | View stdout/stderr output of a container |
| `docker logs -f <name>` | Follow logs in real time |
| `docker inspect <name>` | Full container metadata, state, config |
| `docker inspect <name> --format='{{.State.ExitCode}}'` | Get exit code of a stopped container |
| `docker run -it <image> sh` | Open a shell inside the image to explore filesystem |
| `docker exec -it <name> sh` | Open a shell inside a running container |
| `docker stats <name>` | Live CPU and memory usage |
| `docker events` | Stream real-time Docker daemon events |

---

## Appendix C — Log Analysis

### Overview

This section covers how application and container logs were analyzed to identify the root cause of failures.

### Commands Used

#### Docker Compose logs

```bash
docker compose logs
docker compose logs -f
docker compose logs -f app
docker compose logs -f db
docker compose logs -f nginx
docker compose logs --tail=50 app
docker compose logs app 2>&1 | grep -i "error\|warn\|fatal\|exception"
```

#### Individual container logs

```bash
docker logs my-app
docker logs -f my-app
docker logs -t my-app
docker logs --tail=100 my-app
```

#### Container state inspection

```bash
docker ps -a
docker inspect my-app --format='{{.State.ExitCode}}'
docker inspect my-app --format='{{json .State}}' | jq
```

#### Nginx logs

```bash
docker exec <nginx-container-name> cat /var/log/nginx/access.log
docker exec <nginx-container-name> cat /var/log/nginx/error.log
docker exec <nginx-container-name> tail -f /var/log/nginx/error.log
```

#### System-level

```bash
lsof -i :3000
lsof -i :80
journalctl -u docker -n 50
```

### Failure Patterns & Root Cause Analysis

#### 1. Port already in use

Example log:

```text
Error: listen EADDRINUSE: address already in use :::3000
```

Root cause: another process or container is already bound to port `3000`.

#### 2. Database connection refused

Example log:

```text
Error: connect ECONNREFUSED 127.0.0.1:5432
```

Root cause: the app started before PostgreSQL was ready, or it tried connecting to the wrong host. In Docker Compose, `DATABASE_URL` should use `db`, not `localhost`.

#### 3. Missing environment variable

Example log:

```text
TypeError: Cannot read properties of undefined
```

Root cause: a required environment variable such as `DATABASE_URL` was not set.

#### 4. Out of memory

Exit code `137` typically indicates the process was killed by the OS due to memory pressure.

#### 5. Module or file not found

Example log:

```text
Error: Cannot find module '/app/src/nonexistent.js'
```

Root cause: the Dockerfile `CMD` or Compose `command` points to a file that does not exist in the image.

#### 6. Nginx 502 Bad Gateway

Example Nginx error log:

```text
connect() failed (111: Connection refused) while connecting to upstream
```

Root cause: Nginx could not reach the `app` service, either because the app crashed or the upstream name/port did not match.

### Summary Table

| Exit Code | Meaning | Common Cause |
|-----------|---------|-------------|
| 0 | Clean exit | Normal shutdown |
| 1 | General error | App crash, unhandled exception |
| 137 | OOM kill (SIGKILL) | Out of memory |
| 139 | Segfault (SIGSEGV) | Memory corruption |
| 143 | Graceful shutdown (SIGTERM) | `docker stop` was called |
