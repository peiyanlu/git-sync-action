FROM alpine

RUN apk add --no-cache git openssh-client

ADD *.sh /

chmod -R 777 "/entrypoint.sh"
ENTRYPOINT ["/entrypoint.sh"]
