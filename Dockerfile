FROM node:carbon

WORKDIR /usr/src/app

COPY package*.json ./
COPY ./src .

RUN npm install --only=production

CMD ["node", "./index.js"]

