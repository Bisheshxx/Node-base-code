# Ghost Backend

A TypeScript + Express backend with centralized error handling, Docker support, and a simple health route.

## Project Structure

- .gitignore
  - Git ignore rules for dependencies, build output, logs, and env files.

- Dockerfile
  - Multi-stage Docker build.
  - builder stage installs dependencies and builds TypeScript.
  - release stage copies production dependencies and compiled output.

- docker-compose.yaml
  - Local container setup for development.
  - Builds the api service and runs pnpm run dev.
  - Maps host port 5001 to container port 6767.
  - Loads env values from .env.dev.

- package.json
  - Project metadata, dependencies, and scripts.
  - build: compile TypeScript.
  - dev: run ts-node-dev with auto-restart.
  - start: run compiled app from dist.

- tsconfig.json
  - TypeScript compiler settings.
  - Source directory: src.
  - Build output directory: dist.

- src/
  - app.ts
    - Creates and configures the Express app.
    - Registers middleware (helmet, cors, morgan, json parser).
    - Exposes GET /health route.
    - Adds 404 fallback using ApiError.
    - Attaches global error handler.

  - server.ts
    - App entrypoint.
    - Loads environment variables.
    - Starts HTTP server on process.env.PORT or 5000.

  - config/
    - Environment and app configuration files.
    - .env stores local configuration values.

  - controllers/
    - Request handler layer for route logic.

  - models/
    - Data models and schema definitions.

  - services/
    - Business logic and reusable service functions.

  - constants/server.messages.ts
    - Centralized user-facing server and error messages.
    - Centralized error codes used in responses.

  - middleware/Errorhandler.ts
    - Global error middleware.
    - Converts thrown errors into a consistent ApiResponse shape.
    - Uses status-based fallback messages and codes.

  - types/api.types.ts
    - Shared ApiResponse TypeScript interface.

  - utils/apiError.ts
    - Custom ApiError class with statusCode and optional code.

  - utils/asyncHandler.ts
    - Wrapper for async route handlers.
    - Forwards async exceptions to Express error middleware.

## Request Flow

1. Request enters app.ts.
2. Common middleware runs (security, CORS, logging, JSON parser).
3. Route handler executes (for example, GET /health).
4. If route is missing, app creates a 404 ApiError.
5. Errorhandler.ts formats and returns a user-friendly error response.

## Current Local Ports

- App inside container listens on PORT from env (currently 6767 via .env.dev).
- Docker maps host 5001 to container 6767.
- Local health check URL: http://localhost:5001/health

## Quick Start

1. Install dependencies
   - pnpm install

2. Run in dev mode (without Docker)
   - pnpm run dev

3. Build TypeScript
   - pnpm run build

4. Run with Docker Compose
   - docker-compose up --build

## Notes

- Keep user-facing text in constants/server.messages.ts so wording stays consistent.
- Use ApiError in routes for controlled status codes and messages.
- Wrap async routes with asyncHandler to avoid repetitive try/catch.
