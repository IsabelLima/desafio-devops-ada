FROM node:16.13-alpine
WORKDIR /app
RUN npm install -g @angular/cli
COPY package*.json ./
RUN npm install
COPY . .
CMD [ "ng", "serve" ] 