FROM node:14-alpine3.14 as builder
WORKDIR /usr/build

# install git & openssh to fetch github packages
RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh make g++ cmake python3 jq grpc grpc-dev

WORKDIR /src

COPY ./src /src

RUN make

# Install app dependencies
COPY src/package*.json ./
RUN npm install --production

ENV TEMPORAL_WEB_ROOT_PATH=/
RUN npm run build-production

# Build final image
FROM node:14-alpine3.14
WORKDIR /usr/app

COPY --from=builder /src/ ./

RUN apk update && apk upgrade --no-cache

ENV NODE_ENV=production
ENV NPM_CONFIG_PRODUCTION=true
ENV TEMPORAL_WEB_ROOT_PATH=/
# ENV TEMPORAL_WEB_ROOT_PATH=/custom-path-example/
EXPOSE 8088
CMD [ "node", "server.js" ]