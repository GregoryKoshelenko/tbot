# tbot
Telegram bot that does nothing. 
t.me/gko_tbot

# CLI commands

- Format code:
`gofmt -s -w ./`

- Install dependencies
`go get`

- Build binay
```
go build -ldflags "-X="github.com/GregoryKoshelenko/tbot/cmd.appVersion=v1.0.1
```


# Makefile
In order to build binary for different platforms, you can use the provided Makefile.
- Build for default linux/amd64 platform:
```
make build
```
- Build for specific platform:
```
make linux
make windows
make macos
```


# Docker
Docker buildx plugin is required for building multi-platform images.
Details:
https://github.com/docker/buildx?tab=readme-ov-file#linux-packages

## Build MacOS ARM
docker buildx build --platform=darwin/arm64 -t tbot:macos-arm64 .

## Build Windows AMD64
docker buildx build --platform=windows/amd64 -t tbot:windows-amd64 .

## Build Linux ARM64
docker buildx build --platform=linux/arm64 -t tbot:linux-arm64 .

