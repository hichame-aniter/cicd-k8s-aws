ETCD_NAME=$1
PRIMARY_IP=$2
CONTROL01=$3
CONTROL01_NAME=$4
CONTROL02=$5
CONTROL02_NAME=$6

cat <<EOF | sudo tee /etc/systemd/system/etcd.service
[Unit]
Description=etcd
Documentation=https://github.com/coreos

[Service]
ExecStart=/usr/local/bin/etcd \\
  --name ${ETCD_NAME} \\
  --cert-file=/etc/etcd/etcd-server.crt \\
  --key-file=/etc/etcd/etcd-server.key \\
  --peer-cert-file=/etc/etcd/etcd-server.crt \\
  --peer-key-file=/etc/etcd/etcd-server.key \\
  --trusted-ca-file=/etc/etcd/ca.crt \\
  --peer-trusted-ca-file=/etc/etcd/ca.crt \\
  --peer-client-cert-auth \\
  --client-cert-auth \\
  --initial-advertise-peer-urls https://${PRIMARY_IP}:2380 \\
  --listen-peer-urls https://${PRIMARY_IP}:2380 \\
  --listen-client-urls https://${PRIMARY_IP}:2379,https://127.0.0.1:2379 \\
  --advertise-client-urls https://${PRIMARY_IP}:2379 \\
  --initial-cluster-token etcd-cluster-0 \\
  --initial-cluster ${CONTROL01_NAME}=https://${CONTROL01}:2380,${CONTROL02_NAME}=https://${CONTROL02}:2380 \\
  --initial-cluster-state new \\
  --data-dir=/var/lib/etcd
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF