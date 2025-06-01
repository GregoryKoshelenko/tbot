# tbot
Telegram bot that does nothing. 
t.me/gko_tbot

### CLI commands

- Format code:
`gofmt -s -w ./`

- Install dependencies
`go get`

- Build binay
```
go build -ldflags "-X="github.com/GregoryKoshelenko/tbot/cmd.appVersion=v1.0.1
```

# Задача 5

1. Мені потрібен Makefile, який дозволить зібрати код на різних платформах та архітектурах. Наприклад, якщо я хочу зібрати код для Linux, я повинен змогти запустити команду "make linux", яка збере код для Linux. Те саме повинно бути зроблено для arm, macOS та Windows.

```
make linux
```

2. Також для автоматизації тестів, мені потрібен Dockerfile, який дозволить запустити тестовий набір на різних платформах та архітектурах. Наприклад, якщо я хочу запустити тестовий набір на MacOs arm, я хочу Docker-контейнер із бінарним файлом саме в arm, без Qemu та Rosetta. Те саме повинно бути зроблено для Windows.

### Build MacOS ARM
```
docker buildx build --platform=darwin/arm64 -t tbot:macos-arm64 .
```

### Build Windows AMD64
`docker buildx build --platform=windows/amd64 -t tbot:windows-amd64 .`

### Build Linux ARM64
```
docker buildx build --platform=linux/arm64 -t tbot:linux-arm64 .
```

3. Використай будь ласка альтернативний container registry, щоб уникнути проблем з dockerhub ліцензуванням та лімітами.

```
make push REGISTRY=any-other-registry.com
```
