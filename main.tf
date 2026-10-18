# =====================================================
# Atividade IaC e Terraform - abordagem declarativa (HCL)
# Comandos: terraform init | plan | apply | destroy
# =====================================================

# 1) TERRAFORM: configurações do próprio Terraform
#    (versão mínima e quais providers serão baixados no "init")
terraform {
  required_version = ">= 1.3.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

# 2) PROVIDER: plugin que sabe conversar com a plataforma alvo.
#    O provider "local" cria arquivos na própria máquina,
#    então não precisa de conta em nuvem nem credenciais.
provider "local" {}

# 3) VARIABLE: entradas parametrizáveis (evita valores fixos no código)
variable "nome_projeto" {
  description = "Nome do projeto usado no conteúdo do arquivo"
  type        = string
  default     = "atividade-iac"
}

variable "ambiente" {
  description = "Ambiente de execução (dev, hom ou prod)"
  type        = string
  default     = "dev"
}

# 4) RESOURCE: o recurso que queremos que exista (estado desejado).
#    Tipo: local_file | Nome interno: configuracao
resource "local_file" "configuracao" {
  filename = "${path.module}/${var.nome_projeto}-${var.ambiente}.txt"
  content  = <<-EOT
    Projeto:  ${var.nome_projeto}
    Ambiente: ${var.ambiente}
    Criado por Terraform (infraestrutura como código).
  EOT
}

# 5) OUTPUT: valores exibidos ao final do "apply"
output "caminho_do_arquivo" {
  description = "Caminho do arquivo criado pelo Terraform"
  value       = local_file.configuracao.filename
}

output "ambiente_configurado" {
  description = "Ambiente utilizado nesta execução"
  value       = var.ambiente
}
