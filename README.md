# desafio-devops-ada

Desafio de devops para a empresa Ada, seguindo esse enunciado https://github.com/letscodebyada/desafio-devops

## Como subir a infra

Em primeiro lugar, é necessário estar com as credenciais da AWS configuradas.
Também precisam estar instalados o aws cli e kubectl.
Para criar os recursos na AWS, executar o comando `./create-aws-resources.sh`, que cria os recursos utilizando terraform.
Em seguida, pode ser feito o build das imagens docker, usando os workflows do Github `Docker build and push - backend` e `Docker build and push - frontend`.
Pegar o endpoint do banco de dados criado usando console ou aws cli e atualizar o secret dentro de backend/k8s/2-secret.yaml.
Com as imagens publicadas no ECR, executar o comando `./create-k8s-resources.sh` para criar os recursos dentro do cluster kubernetes.