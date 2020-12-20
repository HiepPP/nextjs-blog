#FROM node:alpine
#WORKDIR /usr/app
#RUN npm install --global pm2
#COPY ./package*.json ./
#RUN npm install
#COPY ./ ./
#RUN npm run build
#EXPOSE 3000
#USER node
#CMD [ "pm2-runtime", "npm", "--", "start" ]

FROM node:alpine as base
WORKDIR /app
RUN npm install --global next
COPY ./package*.json ./
RUN npm install
COPY ./ ./

FROM base as build
WORKDIR /app/build
COPY ./ ./
RUN npm run build
RUN npm run export

COPY ./ ./

FROM nginx:alpine as publish
COPY --from=build app/build/out /usr/share/nginx/html

FROM publish as final

