FROM ubuntu

#ENV DOCKER_HOST tcp://docker:2375/
ENV PATH="/root/.local/bin:${PATH}"

RUN apt-get update \
    && apt-get install -y curl gnupg2 lsb-release software-properties-common python3-distutils \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    && apt-get update \
    && apt-get install -y docker-ce
RUN curl -O https://bootstrap.pypa.io/get-pip.py \
    && python3 get-pip.py --user
RUN pip install awscli --upgrade --user
RUN aws --version


