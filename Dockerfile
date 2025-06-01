FROM --platform=$BUILDPLATFORM quay.io/projectquay/golang:1.19 AS builder
WORKDIR /go/src/app
COPY . .

# Install dependencies
RUN make deps

# Run tests
RUN GOOS=${TARGETOS} GOARCH=${TARGETARCH} go test -v ./...

# Build the application
RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} \
    go build -o /out/tbot -ldflags "-X github.com/GregoryKoshelenko/tbot/cmd.appVersion=${VERSION}"

FROM --platform=$TARGETPLATFORM scratch
WORKDIR /
COPY --from=builder /out/tbot .
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT ["./tbot"]
