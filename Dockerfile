# Stage 1: Base & Dependencies
FROM node:20-slim AS base
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
ENV CI=true
RUN corepack enable pnpm

WORKDIR /usr/src/app

# Stage 2: Fetch & Build
FROM base AS builder
COPY pnpm-lock.yaml ./
# 'pnpm fetch' only needs the lockfile to download everything to the virtual store
RUN pnpm fetch 

COPY . .
RUN pnpm install --offline
RUN pnpm run build

# Stage 3: Production
FROM node:20-slim AS release
WORKDIR /usr/src/app
RUN corepack enable pnpm

# Copy only production dependencies and built files
COPY package*.json pnpm-lock.yaml ./
RUN pnpm install --prod --frozen-lockfile

COPY --from=builder /usr/src/app/dist ./dist

EXPOSE 5000
USER node
CMD [ "node", "dist/index.js" ]