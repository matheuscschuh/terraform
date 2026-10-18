# Atividade: IaC e Terraform

Arquivo entregue: `main.tf` (abordagem declarativa, HCL).

## Conceitos aplicados no `main.tf`

| Conceito | Para que serve | No arquivo |
|---|---|---|
| **Terraform** | Define versão mínima e providers exigidos | bloco `terraform { ... }` |
| **Provider** | Plugin que comunica com a plataforma (nuvem, local etc.) | `provider "local" {}` |
| **Variable** | Entrada parametrizável, evita valores fixos | `nome_projeto` e `ambiente` |
| **Resource** | O recurso que deve existir (estado desejado) | `local_file.configuracao` |
| **Output** | Valor exibido ao final da execução | `caminho_do_arquivo` e `ambiente_configurado` |

## Como executar

```bash
terraform init      # baixa o provider e prepara o diretório
terraform plan      # mostra o que será criado, sem alterar nada
terraform apply     # cria o recurso de fato
terraform destroy   # remove tudo o que o Terraform criou
```

Para trocar uma variável: `terraform apply -var="ambiente=prod"`.

---

## Questão 1: Qual a mentalidade de automação aplicada com Terraform?

A mentalidade é a de **Infraestrutura como Código (IaC)** com abordagem **declarativa**. Em vez de criar servidores, redes e bancos manualmente por um painel ou executar scripts passo a passo (abordagem imperativa), eu **descrevo o estado final desejado** em arquivos `.tf` e o Terraform decide como chegar lá.

Isso traz vantagens práticas:

- **Reprodutibilidade:** o mesmo código gera o mesmo ambiente quantas vezes for preciso.
- **Versionamento:** a infraestrutura fica no Git, com histórico, revisão e possibilidade de voltar atrás.
- **Previsibilidade:** é possível ver o que vai mudar antes de aplicar.
- **Menos erro humano:** reduz cliques manuais e diferenças entre ambientes (dev, homologação, produção).
- **Idempotência:** rodar o mesmo código de novo não duplica recursos, ele só corrige o que divergir do estado desejado.

## Questão 2: Qual dos comandos faz o arquivo `.tf` ser essencial?

O comando **`terraform apply`**. Sem ele, o arquivo `.tf` seria só um texto descrevendo uma intenção. É o `apply` que lê essa descrição, compara com o estado atual (arquivo `terraform.tfstate`) e **cria, altera ou remove os recursos reais**, transformando o código em infraestrutura funcionando. Todos os outros comandos giram em torno dele: o `init` prepara, o `plan` mostra a prévia e o `destroy` desfaz o que o `apply` construiu. Mas só o `apply` materializa o que está escrito no arquivo.

## Questão 3: Qual comando é responsável por fazer a execução do Terraform ser eficaz?

O comando **`terraform plan`**. Ele gera um plano de execução mostrando exatamente o que será criado (`+`), alterado (`~`) ou destruído (`-`), **sem modificar nada** no ambiente real. Isso torna a execução eficaz e segura porque permite revisar o impacto antes de aplicar, evitando surpresas como apagar um recurso importante por engano, e também serve para validar mudanças em revisões de equipe e em pipelines de CI/CD. Em resumo: o `apply` executa, mas é o `plan` que garante que a execução seja a correta.
