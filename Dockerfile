FROM oven/bun:1-alpine

WORKDIR /app

# Install build tools for native dependencies (still needed for some packages)
RUN apk add --no-cache python3 make g++

# Copy package files first for better caching
COPY package.json ./

# Install dependencies
RUN bun install

# Copy everything else
COPY . .

# Build the application
RUN bun run build

# Expose port
EXPOSE 1337

# Start the application
CMD ["bun", "start"]