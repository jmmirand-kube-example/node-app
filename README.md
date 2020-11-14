# node-app
Aplicación Node Contenedor.

## Objetivo

Aplicacion simple hecha en Node que nos sirve para varias pruebas

  * Aplicación más contenedor
  * Creación de contenedores con Github


## Github Actions

Creado dos workflow de Github Actions construcción una imagen Docker que contine la aplicación node y se
publica en docker-hub [node-app-test-hello-world](https://hub.docker.com/repository/registry-1.docker.io/jmmirand/node-app-test-hello-world/tags?page=1)

  * *manual.yml* : Construye la imagen y publica con latest con la acción **build and push docker images** 
  * *manual2.yml* : Construye la imagen con buildx 


##  Referencias

 * [ Actions Docker Buildx ](https://github.com/marketplace/actions/docker-buildx)
 * [ Docker Buildx ](https://github.com/docker/buildx)
 * [ Build and push docker images ](https://github.com/marketplace/actions/build-and-push-docker-images)





