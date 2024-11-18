ENCRYPTION_KEY=$(head -c 32 /dev/urandom | base64)
BASE_DIR=$(dirname "$(realpath "$0")")

cat > ${BASE_DIR}/encrypt/encryption-config.yaml <<EOF
kind: EncryptionConfig
apiVersion: v1
resources:
  - resources:
      - secrets
    providers:
      - aescbc:
          keys:
            - name: key1
              secret: ${ENCRYPTION_KEY}
      - identity: {}
EOF