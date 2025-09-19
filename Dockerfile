FROM node:20-alpine

WORKDIR /app

# Install build tools for native dependencies
RUN apk add --no-cache python3 make g++

# Copy everything
COPY . .

# Install dependencies
RUN npm install

# Build the application
RUN npm run build

# Expose port
EXPOSE 5982

# Start the application
CMD ["npm", "start"]