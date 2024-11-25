### Oppgave 1:

A: Endpoint til Lambda funksjon: https://0v2ids1yv8.execute-api.eu-west-1.amazonaws.com/Prod/generate-image
Har hatt en del problemer her og får stadig bad gateway ved post. Har testet mye forskjellig, sjekket at funksjonen ikke krever authorization og prøvd ulike policies

B: Kjørt pipeline:
https://github.com/martinnessa/PGR-301-DevOps-Exam/actions/runs/11824568856/job/32946357720

### Oppgave 2:  
Terraform apply pipeline:
https://github.com/martinnessa/PGR-301-DevOps-Exam/actions/runs/12017906332/job/33501263876

Terraform plan pipeline:  https://github.com/martinnessa/PGR-301-DevOps-Exam/actions/runs/12018072513/job/33501766247

SQS queue: https://sqs.eu-west-1.amazonaws.com/244530008913/mane041_sqs_queue

 ### Oppgave 3:
Docker image: martinnessa/devopsexam  
SQS queue: https://sqs.eu-west-1.amazonaws.com/244530008913/mane041_sqs_queue  

#### Tagging strategi:
Min plan for tagging var at den nyeste releasen blir deployet ved push på main og tagges som latest-linux-corretto17 siden containeren kjøres i en linux container og bruker Corretto 17.
