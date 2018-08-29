# awscicd
CI/CD Docker in Docker image for pushing Docker Images to AWS's repo.


This image is used to build test and push your Docker images to AWS from GitLab's 
CI/CD process.

# Example `.getlab-ci.yml` file:

Pass two environment variables into the container AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY.

The line `eval "$( aws ecr get-login --no-include-email --region us-west-2 )"` will use these
environment variables to "login" to AWS' docker repo and ecs.

NOTE: TODO, the region is hardcoded.  Probably should be passed in as a variable.

```yaml
image: jstormes/awscicd

variables:
  # When using dind service we need to instruct docker, to talk with the
  # daemon started inside of the service. The daemon is available with
  # a network connection instead of the default /var/run/docker.sock socket.
  #
  # The 'docker' hostname is the alias of the service container as described at
  # https://docs.gitlab.com/ee/ci/docker/using_docker_images.html#accessing-the-services
  #
  # Note that if you're using Kubernetes executor, the variable should be set to
  # tcp://localhost:2375 because of how Kubernetes executor connects services
  # to the job container
  DOCKER_HOST: tcp://docker:2375/
  # When using dind, it's wise to use the overlayfs driver for
  # improved performance.
  DOCKER_DRIVER: overlay2
  #
  GIT_SSL_NO_VERIFY: "1"

services:
- docker:dind

before_script:
- docker info

build:
  stage: build
  script:
  - docker build -t image_name .
  - eval "$( aws ecr get-login --no-include-email --region us-west-2 )"
  - docker tag image_name 291763263022.dkr.ecr.us-west-2.amazonaws.com/image_name:build
  - docker push 291763263022.dkr.ecr.us-west-2.amazonaws.com/image_name:build

test:
  stage: test
  script:
  - eval "$( aws ecr get-login --no-include-email --region us-west-2 )"
  - docker pull 291763263022.dkr.ecr.us-west-2.amazonaws.com/image_name:build
  - docker run 291763263022.dkr.ecr.us-west-2.amazonaws.com/image_name:build /var/www/bin/test.sh

deploy:
  stage: deploy
  script:
  - ecs deploy oauth2-app oauth2-app --region us-west-2 --tag build --timeout 1200
```



