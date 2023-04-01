# desafio-devops-ada

Desafio de devops para a empresa Ada, seguindo esse enunciado https://github.com/letscodebyada/desafio-devops

## Como subir a infra

Em primeiro lugar, é necessário estar com as credenciais da AWS configuradas.
Dentro do diretorio terraform, executar o comando  `terraform apply`. Esse comando ira criar a vpc com 3 subnets públicas e 3 privadas, com rotas para acessar internet a partir da subnet pública, uma ec2 na subnet pública com jdk 11 instalado e um RDS MySQL na subnet privada com security group permitindo apenas a EC2 acessar.

Para destruir os recursos, executar o comando `terraform destroy`.

É possível subir a infra usando github actions também, mas enquanto o estado do terraform está sendo armazenado localmente essa não deve ser usado pois o estado é perdido a cada execução. O ideal e que pretendo fazer se tiver tempo é usar S3 com backend do terraform.
