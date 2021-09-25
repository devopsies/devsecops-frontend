FROM node:12
WORKDIR /app
COPY . .
RUN npm install
RUN npm run ng build
