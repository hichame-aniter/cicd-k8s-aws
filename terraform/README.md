# Infrastructure provisioning

## Deployment
```bash
terraform init

terraform apply

chmod 400 ansible/ssh_key.pem
```
## Destroy everything
```bash
terraform init
terraform destroy
```