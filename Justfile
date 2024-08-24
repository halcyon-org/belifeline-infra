set export

ansible_default_opt := ""
terraform_default_opt := ""

default:
  @just --list

copy-onpre:
  ./scripts/copy-onpre.bash

setup:
  @if ! {{path_exists("ansible/group_vars")}}; then \
    cd ansible && ln -s ../private/ansible/group_vars group_vars; \
  fi
  @if ! {{path_exists("ansible/roles/fail2ban/templates")}}; then \
    cd ansible/roles/fail2ban && ln -s ../../../private/ansible/roles/fail2ban/templates templates; \
  fi
  @if ! {{path_exists("ansible/roles/iptables/templates")}}; then \
    cd ansible/roles/iptables && ln -s ../../../private/ansible/roles/iptables/templates templates; \
  fi

  cd ansible && ansible-galaxy install -r requirements.yml

  cd terraform && terraform init

auth:
  ssh -T -F ansible/ssh_config ansible_user@halcyon-srv.shiron.dev

ansible opt=ansible_default_opt: setup
  cd ansible && ansible-playbook site.yml -C {{opt}}

ansible-run opt=ansible_default_opt: setup
  cd ansible && ansible-playbook site.yml {{opt}}

terraform opt=terraform_default_opt: setup
  cd terraform && terraform plan {{opt}}

terraform-apply opt=terraform_default_opt: setup
  cd terraform && terraform apply {{opt}}

infracost: setup
  cd terraform && infracost breakdown --path .

lint:
  cd ansible && ansible-lint
  cd terraform && terraform fmt -check -recursive

lint-fix:
  cd ansible && ansible-lint --fix
  cd terraform && terraform fmt -recursive

onpre-gen:
  cd scripts/gen && just gen

private-gen:
  cd private && just gen
