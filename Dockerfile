FROM node:22-alpine AS build

WORKDIR /app

COPY package*.json ./
RUN npm install
RUN npm ci
COPY . .

RUN npm run build

FROM nginx:alpine AS production-stage

COPY nginx-custom.conf /etc/nginx/conf.d/default.conf
COPY --from=build-stage /app/dist /usr/share/nginx/html

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]