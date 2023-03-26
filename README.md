# desafio-devops-ada

Desafio de devops para a empresa Ada, seguindo esse enunciado https://github.com/letscodebyada/desafio-devops

## Como subir a infra

Dentro do diretorio terraform, executar o comando  `terraform apply`. Esse comando ira criar a vpc com 3 subnets publicas e 3 privadas, com rotas para acessar internet a partir da subnet publica, uma ec2 na subnet publica com jdk 11 instalado e um RDS MySQL na subnet privada com security group permitindo apenasa EC2 acessar.

Para destruir os recursos, executar o comando `terraform destroy`.