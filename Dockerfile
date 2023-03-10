# Start from golang base image
FROM golang:alpine as builder

# ENV GO111MODULE=on

# Install git.
# Git is required for fetching the dependencies.
RUN apk update && apk add --no-cache git

# Set the current working directory inside the container 
WORKDIR /app

# Copy go mod and sum files 
COPY go.mod go.sum ./

# Download all dependencies. Dependencies will be cached if the go.mod and the go.sum files are not changed 
RUN go mod download 

# Install swag
RUN go install github.com/swaggo/swag/cmd/swag@latest

# Copy the source from the current directory to the working Directory inside the container 
COPY . .

RUN swag init -g benchmark-ws.go

# Build the Go app
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o benchmark-ws .

# Start a new stage from scratch
FROM alpine:latest
RUN apk --no-cache add ca-certificates

WORKDIR /root/

# Copy the Pre-built binary file from the previous stage.
COPY --from=builder /app/benchmark-ws .  
# COPY --from=builder /app/.env .   

# Expose port 1323 to the outside world
EXPOSE 1323

#Command to run the executable
CMD ["./benchmark-ws"]