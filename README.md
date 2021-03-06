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

Con un único commando construimos la imagenes para varias plataformas y se hace
push en dockerhub.

```
➜ $ docker buildx build --push --tag jmmirand/test:multi-arq --platform linux/amd64,linux/arm/v7,linux/arm/v8 .

[+] Building 76.4s (13/14)
....
 => pushing manifest for docker.io/jmmirand/test:multi-arq
 ```

* **Referencias** :
  * [Working with buildx**](https://docs.docker.com/buildx/working-with-buildx/)
  * [Video Youtube buildx](https://www.youtube.com/channel/UCrBzBOMcUVV8ryyAU_c6P5g)


# Motores de Integración Continua (CI)



## Github Actions

Hay dos workflows para Github Actions que publican la misma imagen
publica en docker-hub en amd64 y arm/v7. [node-app-test-hello-world](https://hub.docker.com/repository/registry-1.docker.io/jmmirand/node-app-test-hello-world/tags?page=1)

### docker/build-push-action@v2

**./node-app/.github/workflows/manual.yml**

Con esta acción (v2) definimos los parámetros de construcción y push al registro.

## Github Actions

Hay dos workflows para Github Actions que publican la misma imagen
publica en docker-hub en amd64 y arm/v7. [node-app-test-hello-world](https://hub.docker.com/repository/registry-1.docker.io/jmmirand/node-app-test-hello-world/tags?page=1)

### docker/build-push-action@v2

**./node-app/.github/workflows/manual.yml**

Con esta acción (v2) definimos los parámetros de construcción y push al registro.

```
- name: Login to DockerHub
  uses: docker/login-action@v1
  with:
    username: ${{ secrets.DOCKER_USERNAME }}
    password: ${{ secrets.DOCKER_PASSWORD }}

- name: Push to Docker Hub amd64
  uses: docker/build-push-action@v2
  with:
    file: ./Dockerfile
    platforms: linux/amd64,linux/arm64,linux/arm/v7
    tags: jmmirand/node-app-test-hello-world:latest-github
    push: true
```


**./node-app/.github/workflows/manual2.yml**

Se construye la imagen con el comando buildx.

```
- name: Login to DockerHub
  if: success() && github.event_name != 'pull_request'
  uses: docker/login-action@v1
  with:
    username: ${{ secrets.DOCKER_USERNAME }}
    password: ${{ secrets.DOCKER_PASSWORD }}
- name: Docker Buildx (push)
  if: success() && github.event_name != 'pull_request'
  run: |

```



  * *manual2.yml* : Construye la imagen con buildx

## Travis

En Travis también podemos gestionar la carga y publicación de las imágenes multi-arch.

Creando el fichero .travis.yaml y damos permisos al repositorio.

Sobre una imagen ubuntu instalamos docker.
  * Añadimos la key de docker para apt
  * Instalmaos el repositorio de docker
  * Instlamos el Contenedor docker-ce

En la máquina bionic viene instalada por defecto 18.06.0-ce y con el primer JavaScript
actualizamos la versión a 19.03.13

``` yaml  
language: bash
dist: bionic
before_install:
# update docker
  - sudo rm -rf /var/lib/apt/lists/*
  - curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  - sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) edge"
  - sudo apt-get update
  - sudo apt-get -y -o Dpkg::Options::="--force-confnew" install docker-ce
# update docker-buildx
  - mkdir -vp ~/.docker/cli-plugins/
  - curl --silent -L "https://github.com/docker/buildx/releases/download/v0.3.0/buildx-v0.3.0.linux-amd64" > ~/.docker/cli-plugins/docker-buildx
  - chmod a+x ~/.docker/cli-plugins/docker-buildx

script:
  - docker version
  - docker buildx version
```


### Referecias
  [Multi-arch build, what about Travis?](https://www.docker.com/blog/multi-arch-build-what-about-travis/)


##  Referencias

 * [ Actions Docker Buildx ](https://github.com/marketplace/actions/docker-buildx)
 * [ Docker Buildx ](https://github.com/docker/buildx)
 * [ Build and push docker images ](https://github.com/marketplace/actions/build-and-push-docker-images)
 * [Multi-arch build and images, the simple way 1/2](https://www.docker.com/blog/multi-arch-build-and-images-the-simple-way/)
 * [Multi-arch build, what about GitLab CI? 2/2](https://www.docker.com/blog/multi-arch-build-what-about-gitlab-ci/)
