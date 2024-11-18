## Certificate Authority
# Global CA
# - Create private key for CA
openssl genrsa -out ca.key 2048
# - Create CSR using the private key
openssl req -new -key ca.key -subj "/CN=KUBERNETES-CA/O=Kubernetes" -out ca.csr
# - Self sign the csr using its own private key
openssl x509 -req -in ca.csr -signkey ca.key -CAcreateserial -out ca.crt -days 1000 \
    -extensions v3_ca -extfile ca.cnf
rm ca.csr

# ETCD CA
# - Create private key for ETCD CA
openssl genrsa -out etcd-ca.key 2048
# - Create CSR using the private key
openssl req -new -key etcd-ca.key -subj "/CN=ETCD-CA/O=Etcd" -out etcd-ca.csr
# - Self sign the csr using its own private key
openssl x509 -req -in etcd-ca.csr -signkey etcd-ca.key -CAcreateserial -out etcd-ca.crt -days 1000 \
    -extensions v3_ca -extfile ca.cnf
rm etcd-ca.csr

## Server Certificates
# API server endpoint Server certificate
# openssl genrsa -out kube-apiserver.key 2048
# openssl req -new -key kube-apiserver.key \
#     -subj "/CN=kube-apiserver/O=Kubernetes" -out kube-apiserver.csr -config openssl.cnf
# openssl x509 -req -in kube-apiserver.csr \
#     -CA ca.crt -CAkey ca.key -CAcreateserial -out kube-apiserver.crt -extensions v3_req -extfile openssl.cnf -days 1000
# rm kube-apiserver.csr


# Etcd Server certificate  
openssl genrsa -out etcd-server.key 2048
openssl req -new -key etcd-server.key \
    -subj "/CN=etcd-server/O=Kubernetes" -out etcd-server.csr -config openssl-etcd.cnf

openssl x509 -req -in etcd-server.csr \
    -CA etcd-ca.crt -CAkey etcd-ca.key -CAcreateserial -out etcd-server.crt -extensions v3_req -extfile openssl-etcd.cnf -days 1000
rm etcd-server.csr

# Kubelet Server certificates (for each node running kubelet)
# Front-proxy server certificate (Optional)

## Client Certificates
# API server ETCD endpoint Client certificate (To communicate with ETCD)

# # API server KUBELET endpoint Client certificate (To communicate with Kubelet)
# openssl genrsa -out apiserver-kubelet-client.key 2048
# openssl req -new -key apiserver-kubelet-client.key \
#     -subj "/CN=kube-apiserver-kubelet-client/O=system:masters" -out apiserver-kubelet-client.csr -config openssl-kubelet.cnf
# openssl x509 -req -in apiserver-kubelet-client.csr \
#     -CA ca.crt -CAkey ca.key -CAcreateserial -out apiserver-kubelet-client.crt -extensions v3_req -extfile openssl-kubelet.cnf -days 1000
# rm apiserver-kubelet-client.csr

# # Controller Manager Client Certificate (To communicate with API server)
# openssl genrsa -out kube-controller-manager.key 2048
# openssl req -new -key kube-controller-manager.key \
#    -subj "/CN=system:kube-controller-manager/O=system:kube-controller-manager" \
#    -out kube-controller-manager.csr
# openssl x509 -req -in kube-controller-manager.csr \
#     -CA ca.crt -CAkey ca.key -CAcreateserial -out kube-controller-manager.crt -days 1000
# rm kube-controller-manager.csr

# # Scheduler Client Certificate (To communicate with API server)
# openssl genrsa -out kube-scheduler.key 2048
# openssl req -new -key kube-scheduler.key \
#     -subj "/CN=system:kube-scheduler/O=system:kube-scheduler" -out kube-scheduler.csr
# openssl x509 -req -in kube-scheduler.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out kube-scheduler.crt -days 1000
# rm kube-scheduler.csr

# # Kube Proxy Client Certificate (for each node)
# openssl genrsa -out kube-proxy.key 2048
# openssl req -new -key kube-proxy.key \
#     -subj "/CN=system:kube-proxy/O=system:node-proxier" -out kube-proxy.csr
# openssl x509 -req -in kube-proxy.csr \
#     -CA ca.crt -CAkey ca.key -CAcreateserial -out kube-proxy.crt -days 1000
# rm kube-proxy.csr

# Admin Client Certificate (Optional)
openssl genrsa -out admin.key 2048
# - Generate CSR for admin user. Note the OU.
openssl req -new -key admin.key -subj "/CN=admin/O=system:masters" -out admin.csr
# - Sign certificate for admin user using CA servers private key
openssl x509 -req -in admin.csr \
   -CA ca.crt -CAkey ca.key -CAcreateserial -out admin.crt -days 1000
rm admin.csr

# # The Service Account Key Pair
# openssl genrsa -out service-account.key 2048
# openssl req -new -key service-account.key \
#     -subj "/CN=service-accounts/O=Kubernetes" -out service-account.csr
# openssl x509 -req -in service-account.csr \
#     -CA ca.crt -CAkey ca.key -CAcreateserial -out service-account.crt -days 1000
# rm service-account.csr

# Front-proxy client certificate (Optional)
