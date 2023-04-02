# desafio-devops-ada

Desafio de devops para a empresa Ada, seguindo esse enunciado https://github.com/letscodebyada/desafio-devops

## Como subir a infra

Em primeiro lugar, é necessário estar com as credenciais da AWS configuradas.

Para criar os recursos na AWS, executar o comando `./create-aws-resources.sh`, que cria os recursos utilizando terraform.
Em seguida, pode ser feito o build das imagens docker, usando os workflows do Github `Docker build and push - backend` e `Docker build and push - frontend`.
Com as imagens publicadas no ECR, executar o comando `./create-k8s-resources.sh` para criar os recursos dentro do cluster kubernetes.