LOADBALANCER=$1
CONTROL01=$2
CONTROL01_NAME=$3
CONTROL02=$4
CONTROL02_NAME=$5

cat <<EOF | sudo tee /etc/haproxy/haproxy.cfg
frontend kubernetes
    bind ${LOADBALANCER}:6443
    option tcplog
    mode tcp
    default_backend kubernetes-controlplane-nodes

backend kubernetes-controlplane-nodes
    mode tcp
    balance roundrobin
    option tcp-check
    server ${CONTROL01_NAME} ${CONTROL01}:6443 check fall 3 rise 2
    server ${CONTROL02_NAME} ${CONTROL02}:6443 check fall 3 rise 2
EOF