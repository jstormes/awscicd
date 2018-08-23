FROM ubuntu

ENV PATH="/root/.local/bin:${PATH}"
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN apt-get update \
    && apt-get install -y curl gnupg2 lsb-release software-properties-common python3-distutils \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    && apt-get update \
    && apt-get install -y docker-ce
RUN curl -O https://bootstrap.pypa.io/get-pip.py \
    && python3 get-pip.py --user
RUN pip install awscli --upgrade --user
RUN pip install ecs-deploy --upgrade --user
RUN aws --version


