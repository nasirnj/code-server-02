FROM ubuntu:latest

ENV HOME=/root

COPY code-server_4.103.2_amd64.deb /tmp/

RUN dpkg -i /tmp/code-server_4.103.2_amd64.deb && \
    rm -f /tmp/code-server_4.103.2_amd64.deb && \
    apt-get update && apt-get install -y openssl && \
    mkdir -p $HOME/.config/code-server

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
      -keyout $HOME/.config/code-server/key.pem \
      -out $HOME/.config/code-server/cert.pem \
      -subj "/C=US/ST=NJ/L=JC/O=Org/OU=NA/CN=localhost"

COPY config.yaml $HOME/.config/code-server/config.yaml
RUN chown -R root:root $HOME/.config/code-server && chmod 600 $HOME/.config/code-server/config.yaml

EXPOSE 8080
CMD ["code-server", "--bind-addr", "0.0.0.0:8080","--log", "info"]

