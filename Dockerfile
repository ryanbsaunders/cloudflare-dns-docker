FROM ubuntu:kinetic

ENV DEBIAN_FRONTEND noninteractive

RUN apt update && apt -y upgrade && apt -y install unbound ca-certificates && apt clean && rm -rf /var/lib/apt/lists/*

EXPOSE 53/udp

COPY unbound.conf /etc/unbound

HEALTHCHECK --interval=10m --timeout=3s --start-period=3s --retries=1 CMD ping -W 1 -w 2 cloudflare.com &> /dev/null || exit 1

ENTRYPOINT echo "nameserver 127.0.0.1" > /etc/resolv.conf && \
           echo "options ndots:0" >> /etc/resolv.conf && \
           unbound -d
