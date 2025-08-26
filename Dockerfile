# Use the official Golang image to build the app
FROM golang:1.22-alpine AS builder

WORKDIR /app
COPY main.go .

RUN go build -o server main.go

# Use a minimal image for running
FROM alpine:3.20

WORKDIR /app
COPY --from=builder /app/server .

EXPOSE 8080

CMD ["./server"]
