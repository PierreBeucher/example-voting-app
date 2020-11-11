#!/bin/bash

set -e

# cleanup before run
rm -rf client ca server

# Init dirs
mkdir ${PWD}/ca
mkdir ${PWD}/client
mkdir ${PWD}/server

# CA
openssl genrsa -out ca/key.pem 4096
openssl req -subj "/CN=localhost" -new -x509 -days 365 -key ca/key.pem -sha256 -out ca/ca.pem

# Cert
openssl genrsa -out server/key.pem 4096
openssl req -subj "/CN=localhost" -sha256 -new -key server/key.pem -out server/server.csr

echo subjectAltName = DNS:localhost,IP:127.0.0.1 > extfile.cnf
echo extendedKeyUsage = serverAuth >> extfile.cnf

openssl x509 -req -days 365 -sha256 -in server/server.csr -CA ca/ca.pem -CAkey ca/key.pem -CAcreateserial -out server/cert.pem -extfile extfile.cnf

# Client
openssl genrsa -out client/key.pem 4096
openssl req -subj '/CN=client' -new -key client/key.pem -out client/client.csr

echo extendedKeyUsage = clientAuth > extfile-client.cnf

openssl x509 -req -days 365 -sha256 -in client/client.csr -CA ca/ca.pem -CAkey ca/key.pem -CAcreateserial -out client/cert.pem -extfile extfile-client.cnf

# copy CA for client
cp ca/ca.pem client/ca.pem

# Cleanup
rm client/*.csr server/*.csr *.cnf

# Generate config

echo "
  {
      \"tlsverify\": true,
      \"tlscacert\": \"${PWD}/ca/ca.pem\",
      \"tlscert\": \"${PWD}/server/cert.pem\",
      \"tlskey\": \"${PWD}/server/key.pem\",
      \"hosts\": [\"tcp://0.0.0.0:2376\"]
  }
" > docker-daemon-config.json

echo "----------"
echo "Copy content of docker-daemon-config to /etc/docker/daemon.json"
echo "And run "
echo
echo "  sudo systemctl restart docker"
echo
echo "Note: it may be necessary to update docker systemd file to remove -H option"
echo "such as in /lib/systemd/system/docker.service on Ubuntu 20"
echo
echo "Docker will now listen on tcp://0.0.0.0:2376 and require TLS Client auth"
echo
echo "Use:"
echo
echo "export DOCKER_HOST=tcp://localhost:2376"
echo "export DOCKER_CERT_PATH=${PWD}/client"
echo "export DOCKER_TLS=true"
echo "docker --tls ps"
