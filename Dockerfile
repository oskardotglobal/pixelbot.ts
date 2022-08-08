###
### build runner
###

FROM node:lts-alpine as build-runner

# Set temp directory
WORKDIR /tmp/app

# Move package.json
COPY package.json .

# Install git
RUN apk add --no-cache git

# Get pnpm
RUN npm install pnpm -g

# Install dependencies
RUN pnpm install

# Move source files
COPY src ./src
COPY tsconfig.json   .

# Build project
RUN npm run build


###
### production runner
###

FROM node:lts-alpine as prod-runner

# Set work directory
WORKDIR /app

# Copy package.json from build-runner
COPY --from=build-runner /tmp/app/package.json /app/package.json

# Move build files
COPY --from=build-runner /tmp/app/build /app/build

# Install git
RUN apk add --no-cache git

# Get pnpm
RUN npm install pnpm -g

# Install dependencies
RUN pnpm install

# Start bot
CMD [ "node", "build/main.js" ]
