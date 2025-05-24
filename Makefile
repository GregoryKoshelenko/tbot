APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=gkosh
VERSION=$(shell git describe --tags --always --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux
TARGETARCH=arm64

install:
	go get

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

build:
	CGO_ENABLED=0 GOOS=$(TARGETOS) GOARCH=$(TARGETARCH) \
		go build -v -o tbot -ldflags "-X github.com/GregoryKoshelenko/tbot/cmd.appVersion=${VERSION}"

image:
	docker build -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

clean:
	rm -rf tbot
	docker rmi ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

