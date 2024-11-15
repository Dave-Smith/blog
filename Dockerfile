FROM hugomods/hugo as hugo

WORKDIR /src

COPY . .

RUN hugo

# FROM caddy:2.1.1

# CMD ["dir"]

# EXPOSE 8080 

# COPY --from=hugo /src/public /usr/share/caddy/

# COPY ./Caddyfile /etc/caddy/Caddyfile

FROM nginx:alpine

COPY --from=hugo /src/public /usr/share/nginx/html

