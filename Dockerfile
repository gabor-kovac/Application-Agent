FROM node:22-alpine AS ts-compiler

WORKDIR /usr/app

COPY package.json ./
COPY tsconfig.json ./
COPY src/ ./src/

RUN npm install && npm run build && rm -r node_modules && npm install --omit=dev

FROM node:22-alpine

LABEL org.opencontainers.image.source="https://github.com/gabor-kovac/Application-Agent"
LABEL org.opencontainers.image.description="Application agent"

WORKDIR /usr/app

COPY --from=ts-compiler /usr/app/package.json ./
COPY --from=ts-compiler /usr/app/dist ./dist/
COPY --from=ts-compiler /usr/app/node_modules ./node_modules/

USER node

CMD ["npm", "run", "start"]