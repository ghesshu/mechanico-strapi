# ---- Base Node Image ----
  FROM node:20-alpine AS base
  WORKDIR /app
  
  # install build tools (for pg, etc.)
  RUN apk add --no-cache python3 make g++
  
  # ---- Dependencies Stage ----
  FROM base AS deps
  COPY package*.json ./
  RUN npm install --omit=dev # or you could install dev, depends on build needs
  
  # ---- Build Stage ----
  FROM base AS build
  COPY --from=deps /app/node_modules ./node_modules
  COPY . .
  
  # Build the Strapi parts: backend + admin
  RUN npm run build
  
  # ---- Production Stage ----
  FROM base AS prod
  ENV NODE_ENV=production
  WORKDIR /app
  
  # Copy necessary files
  COPY --from=build /app/package*.json ./
  COPY --from=build /app/dist ./dist
  COPY --from=build /app/node_modules ./node_modules
  COPY --from=build /app/public ./public
  COPY --from=build /app/config ./config
  # If you have environment config files, they go here
  
  EXPOSE 1337
  
  CMD ["npm", "start"]