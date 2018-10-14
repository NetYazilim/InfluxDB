FROM netyazilim/alpine-base:3.8

ARG VERSION=1.6.3

WORKDIR /tmp
RUN wget --no-cache --quiet https://dl.influxdata.com/influxdb/releases/influxdb-${VERSION}-static_linux_amd64.tar.gz -O influxdb.tar.gz  && \
    tar xvfz influxdb.tar.gz  --strip 2 

FROM scratch

LABEL maintainer "Levent SAGIROGLU <LSagiroglu@gmail.com>"

EXPOSE 8086 8088 6060 8082 2003 25826 4242 8089
ENV INFLUXDB_CONFIG_PATH /etc/influxdb.conf
VOLUME /shared

COPY --from=0 /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=0 /etc/localtime /etc/localtime
COPY --from=0 /etc/timezone /etc/timezone

COPY --from=0 /tmp/influxd /bin/influxd
COPY --from=0 /tmp/influxdb.conf /etc/influxdb.conf
ENTRYPOINT ["/bin/influxd"]
