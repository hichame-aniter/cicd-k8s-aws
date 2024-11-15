#!/bin/bash

# Variables
CA_DAYS=1000
CERT_DIR="certs"
mkdir -p $CERT_DIR

# Function to create a Certificate Authority (CA)
create_ca() {
  CA_NAME=$1
  openssl genrsa -out "${CERT_DIR}/${CA_NAME}.key" 2048
  openssl req -new -key "${CERT_DIR}/${CA_NAME}.key" -subj "/CN=${CA_NAME}/O=Kubernetes" -out "${CERT_DIR}/${CA_NAME}.csr"
  openssl x509 -req -in "${CERT_DIR}/${CA_NAME}.csr" -signkey "${CERT_DIR}/${CA_NAME}.key" -CAcreateserial -out "${CERT_DIR}/${CA_NAME}.crt" -days $CA_DAYS
  rm "${CERT_DIR}/${CA_NAME}.csr"
}

# Function to generate and sign a certificate
generate_cert() {
  NAME=$1
  CA_NAME=$2
  SUBJECT=$3
  CONFIG_FILE=$4

  openssl genrsa -out "${CERT_DIR}/${NAME}.key" 2048
  openssl req -new -key "${CERT_DIR}/${NAME}.key" -subj "$SUBJECT" -out "${CERT_DIR}/${NAME}.csr" ${CONFIG_FILE:+-config $CONFIG_FILE}
  openssl x509 -req -in "${CERT_DIR}/${NAME}.csr" \
      -CA "${CERT_DIR}/${CA_NAME}.crt" -CAkey "${CERT_DIR}/${CA_NAME}.key" -CAcreateserial \
      -out "${CERT_DIR}/${NAME}.crt" -days $CA_DAYS ${CONFIG_FILE:+-extensions v3_req -extfile $CONFIG_FILE}
  rm "${CERT_DIR}/${NAME}.csr"
}

# Create CA certificates
create_ca "ca"
create_ca "etcd-ca"

# Server certificates
generate_cert "kube-apiserver" "ca" "/CN=kube-apiserver/O=Kubernetes" "openssl.cnf"
generate_cert "etcd-server" "etcd-ca" "/CN=etcd-server/O=Kubernetes" "openssl-etcd.cnf"

# Client certificates
generate_cert "apiserver-etcd-client" "etcd-ca" "/CN=kube-apiserver-etcd-client/O=system:masters" "openssl-api-etcd.cnf"
generate_cert "apiserver-kubelet-client" "ca" "/CN=kube-apiserver-kubelet-client/O=system:masters" "openssl-kubelet.cnf"
generate_cert "kube-controller-manager" "ca" "/CN=system:kube-controller-manager/O=system:kube-controller-manager"
generate_cert "kube-scheduler" "ca" "/CN=system:kube-scheduler/O=system:kube-scheduler"
generate_cert "kube-proxy" "ca" "/CN=system:kube-proxy/O=system:node-proxier"
generate_cert "admin" "ca" "/CN=admin/O=system:masters"
generate_cert "service-account" "ca" "/CN=service-accounts/O=Kubernetes"

# Output
echo "All certificates are stored in the '$CERT_DIR' directory."
