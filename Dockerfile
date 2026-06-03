FROM golang:1.19-alpine@sha256:0ec0646e208ea58e5d29e558e39f2e59fccf39b7bda306cb53bbaff91919eca5 AS build
RUN apk add --update --no-cache git
WORKDIR /src
COPY ./go.* ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -o /conoha_exporter

FROM alpine:3.16@sha256:452e7292acee0ee16c332324d7de05fa2c99f9994ecc9f0779c602916a672ae4
WORKDIR /app

RUN apk add --update ca-certificates openssl && \
    update-ca-certificates && \
    rm -rf /var/cache/apk/*

EXPOSE 9330

COPY --from=build /conoha_exporter ./

ENTRYPOINT ./conoha_exporter
