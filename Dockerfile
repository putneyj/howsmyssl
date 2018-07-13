FROM golang:1.10

EXPOSE 10080
EXPOSE 10443

ADD . /go/src/github.com/putneyj/howsmyssl

RUN go install github.com/putneyj/howsmyssl

# Provided by kubernetes secrets or some such
# VOLUME "/secrets"
RUN mkdir /secrets
RUN mkdir /etc/howsmyssl-origins
RUN mkdir /etc/howsmyssl-allowlists

COPY ./config/origins.json /etc/howsmyssl-origins/origin.json
COPY ./config/allow_lists.json /etc/howsmyssl-allowlists/allow_lists.json

RUN chown -R www-data /go/src/github.com/putneyj/howsmyssl

USER www-data

CMD ["/bin/bash", "-c", "howsmyssl \
    -httpAddr=:10080 \
    -adminAddr=:4567 \
    -templateDir=/go/src/github.com/putneyj/howsmyssl/templates \
    -staticDir=/go/src/github.com/putneyj/howsmyssl/static \
    -vhost=$HOWSMYSSL_VHOST \
    -allowLogName=howsmyssl_allowance_checks]
