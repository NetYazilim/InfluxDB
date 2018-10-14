FROM netyazilim/alpine-base:3.8

ARG VERSION=1.6.3

WORKDIR /tmp
RUN wget --no-cache --quiet https://dl.influxdata.com/influxdb/releases/influxdb-${VERSION}-static_linux_amd64.tar.gz -O influxdb.tar.gz  && \
    tar xvfz influxdb.tar.gz  --strip 2 

FROM scratch

LABEL maintainer "Levent SAGIROGLU <LSagiroglu@gmail.com>"

EXPOSE 8086 8088 
ENV INFLUXDB_CONFIG_PATH /etc/influxdb.conf
VOLUME /shared

COPY --from=0 /tmp/influxd /bin/influxd
COPY --from=0 /tmp/influxdb.conf /etc/influxdb.conf
ENTRYPOINT ["/bin/influxd"]