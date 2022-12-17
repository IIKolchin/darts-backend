FROM node:14-alpine AS builder
WORKDIR /app
# COPY init.sql /docker-entrypoint-initdb.d/
COPY package*.json ./
RUN npm i
COPY . .
RUN npm run build

FROM node:14-alpine AS production
WORKDIR /app
COPY --from=builder /app/package*.json ./
RUN npm i --omit=dev
COPY --from=builder /app/dist ./dist
EXPOSE 3000
CMD ["node", "dist/main"]