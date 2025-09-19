FROM public.ecr.aws/docker/library/node:22.12.0-alpine

# Create and change to the app directory
WORKDIR /app

# Copy package.json
COPY package*.json ./

# Fix CVE-2024–21538 and install dependencies
# Upgrade system packages
# Make sure had ~/.npmrc
# docker build --secret id=npmrc,src=$HOME/.npmrc -t tesla-test-middleware .
RUN npm install -g npm@10.9.2 && \
    npm install --only=production && \
    npm cache clean --force

ENV NODE_ENV=production

COPY . .

USER node

CMD ["node", "server.js"]