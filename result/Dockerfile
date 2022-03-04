FROM node:10-alpine

WORKDIR /app

RUN npm install -g nodemon

COPY package*.json ./

RUN npm ci \
 && npm cache clean --force

COPY . .

ENV PORT 80

EXPOSE 80

CMD ["node", "server.js"]
