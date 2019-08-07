FROM node as builder

ARG base_href="http://localhost/"

WORKDIR /
RUN git clone https://github.com/graueneko/aktools.git
WORKDIR /aktools
RUN npm i -s
RUN npm audit fix
RUN npm install -g @angular/cli
RUN ng build --prod --base-href ${base_href}

FROM nginx:1.17.0-alpine-perl
RUN rm /etc/nginx/conf.d/default.conf
COPY default.conf /etc/nginx/conf.d/
COPY --from=builder /aktools/dist/aktools  /usr/share/nginx/html/
