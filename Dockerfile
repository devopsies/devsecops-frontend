FROM base-front as build

COPY . .

RUN npm run build

FROM nginx

COPY --from=build /usr/src/app/dist /usr/share/nginx/html
