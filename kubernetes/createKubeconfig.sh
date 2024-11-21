# Global Var
LOADBALANCER="192.168.56.30"
CLUSTER_NAME="cluster01"
CERT_DIR="/var/lib/kubernetes/pki"
BASE_DIR=$(dirname "$(realpath "$0")")
DEST_DIR="${BASE_DIR}/kubeconfig/"
create_kubeconfig() {
  COMPONENT=$1
  SERVER=$2
  KUBECONFIG_FILE="${COMPONENT}.kubeconfig"
  CLIENT_CERT="${CERT_DIR}/${COMPONENT}.crt"
  CLIENT_KEY="${CERT_DIR}/${COMPONENT}.key"
  NODE=$3

  kubectl config set-cluster "${CLUSTER_NAME}" \
      --certificate-authority="${CERT_DIR}/ca.crt" \
      --server="${SERVER}" \
      --kubeconfig="${DEST_DIR}${KUBECONFIG_FILE}"
  kubectl config set-credentials "system:${NODE}${COMPONENT}" \
      --client-certificate="${CLIENT_CERT}" \
      --client-key="${CLIENT_KEY}" \
      --kubeconfig="${DEST_DIR}${KUBECONFIG_FILE}"
  kubectl config set-context default \
      --cluster="${CLUSTER_NAME}" \
      --user="system:${NODE}${COMPONENT}" \
      --kubeconfig="${DEST_DIR}${KUBECONFIG_FILE}"
  kubectl config use-context default --kubeconfig="${DEST_DIR}${KUBECONFIG_FILE}"
}
create_kubeconfig "node01" "https://${LOADBALANCER}:6443" "node:"
create_kubeconfig "node02" "https://${LOADBALANCER}:6443" "node:"

# kube-proxy
create_kubeconfig "kube-proxy" "https://${LOADBALANCER}:6443"

# kube-controller-manager
create_kubeconfig "kube-controller-manager" "https://127.0.0.1:6443"

# kube-scheduler
create_kubeconfig "kube-scheduler" "https://127.0.0.1:6443"



# Admin (special case with different parameters)
kubectl config set-cluster "${CLUSTER_NAME}" \
    --certificate-authority=${BASE_DIR}/certs/ca.crt \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=${DEST_DIR}admin.kubeconfig
kubectl config set-credentials admin \
    --client-certificate=${BASE_DIR}/certs/admin.crt \
    --client-key=${BASE_DIR}/certs/admin.key \
    --embed-certs=true \
    --kubeconfig=${DEST_DIR}admin.kubeconfig
kubectl config set-context default \
    --cluster="${CLUSTER_NAME}" \
    --user=admin \
    --kubeconfig=${DEST_DIR}admin.kubeconfig
kubectl config use-context default --kubeconfig=${DEST_DIR}admin.kubeconfig
