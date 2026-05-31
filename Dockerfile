# syntax=docker/dockerfile:1

FROM golang:1.25-alpine AS builder

WORKDIR /src

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -trimpath -ldflags="-s -w" -o /bin/tracker .

FROM alpine:3.22

WORKDIR /app

COPY --from=builder /bin/tracker /app/tracker
COPY tracker.db /app/tracker.db

CMD ["/app/tracker"]
