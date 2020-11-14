# node-app

Aplicación Docker publicada en DockerHub en varias plataformas en :
 * Github Actions
 * Gitlab-CI
 * DockerHub
 * Travis

## Objetivo

El objetivo de este repo es entender bien como se construye las imágenes docker en
multi plataforma y como desde distintos construirlas en varios motores de CI.

La aplicación es simple y está hecha en Node, esta aplicación está compuesta de
un JavaScript y un DockerFile que construye la imagen.

## Docker multiplataforma

Existe dos maneras distintas de construir imágenes en varias plataformas.

### **Especificando en el Manifiesto**

Con el comando de **docker build** se puede mandar como argumento la arquitectura que queremos construir.

Generamos una imagen para la plataforma arm

```
$ docker build --tag jmmirand/test:armv7 --platform linux/arm/v7 .
```
 Otra forma de generar la imagen arm

```
$ docker build --tag jmmirand/test:armv8 --build-arg TARGETPLATFORM=linux/arm/v8 .
```

**El problema de este método es que una misma etiqueta no puede tener varias
arquitectura**


Referencia : [Automatic platform ARGs in the global scope](https://docs.docker.com/engine/reference/builder/#automatic-platform-args-in-the-global-scope)



### Docker Buildx

Esta funcionalidad es experimental en la versión 19.03.5 de
[buildx](https://docs.docker.com/buildx/working-with-buildx/) con un único
comando.

**Se requiere que se active la funcionalidad experimental**

```
➜ $ docker buildx build --push --tag jmmirand/test:multi-arq --platform linux/amd64,linux/arm/v7,linux/arm/v8 .

[+] Building 76.4s (13/14)
....
 => pushing manifest for docker.io/jmmirand/test:multi-arq
 ```







Referencia :



## Github Actions

Tengo dos workflows que publican la misma imagen
publica en docker-hub [node-app-test-hello-world](https://hub.docker.com/repository/registry-1.docker.io/jmmirand/node-app-test-hello-world/tags?page=1)

  * *manual.yml* : Construye la imagen y publica con latest con la acción **build and push docker images**
  * *manual2.yml* : Construye la imagen con buildx


##  Referencias

 * [ Actions Docker Buildx ](https://github.com/marketplace/actions/docker-buildx)
 * [ Docker Buildx ](https://github.com/docker/buildx)
 * [ Build and push docker images ](https://github.com/marketplace/actions/build-and-push-docker-images)
 * [Multi-arch build and images, the simple way 1/2](https://www.docker.com/blog/multi-arch-build-and-images-the-simple-way/)
 * [Multi-arch build, what about GitLab CI? 2/2](https://www.docker.com/blog/multi-arch-build-what-about-gitlab-ci/)
