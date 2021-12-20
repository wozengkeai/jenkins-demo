#FROM golang:1.8.0-alpine
#
#ADD . /go/src/app
#
#WORKDIR /go/src/app
#
#RUN GOOS=linux GOARCH=386 go build -v -o /go/src/app/jenkins-app && go get github.com/beego/beego/v2@v2.0.0
#
#CMD ["./jenkins-app"]

## 单阶段构建
#FROM golang:latest
#MAINTAINER  <>
#ENV APP_DIR $GOPATH/src/jenkins-demo
#RUN mkdir -p $APP_DIR
#WORKDIR $APP_DIR/
#COPY ./go.mod go.mod
#COPY ./go.sum go.sum
#COPY ./main.go main.go
#RUN ["ln","-sf","/usr/share/zoneinfo/Asia/Shanghai","/etc/localtime"]
#ENV GO111MODULE on
#ENV GOPROXY https://goproxy.io
#RUN ["go","mod","tidy"]
#RUN ["ls"]
#RUN ["go","build"]
#ENTRYPOINT ["./jenkins-demo"]


#############################
## 分阶段构建
## STEP 1 build executable binary
#############################
FROM golang:latest AS builder
RUN mkdir /app
WORKDIR /app
COPY . /app
RUN ["ln","-sf","/usr/share/zoneinfo/Asia/Shanghai","/etc/localtime"]
RUN GO111MODULE="on" GOPROXY="https://goproxy.cn" CGO_ENABLED=0 GOOS=linux go build -o jenkins-demo

#############################
## STEP 2 build a small image
############################
FROM scratch as final
COPY --from=builder /app/jenkins-demo /app/jenkins-demo
ENTRYPOINT ["./app/jenkins-demo"]