# Dockerfile
#
# - `docker build -f Dockerfile -t ng2-bs3-modal .`
# - `docker run -it ng2-bs3-modal`

FROM rockylinux:8

ENV LANG=en_DK.UTF8
ENV PYTHON=python2

RUN yum install -y epel-release
RUN yum install -y --nobest gcc gcc-c++ make python2 python2-devel
RUN yum install -y curl git jq ripgrep sqlite vim

RUN dnf module install -y nodejs:20
RUN npm install --global corepack@0.20
RUN corepack enable

WORKDIR /root

COPY dot-bashrc .bashrc

RUN mkdir ng2-bs3-modal
COPY . /root/ng2-bs3-modal/

WORKDIR /root/ng2-bs3-modal

RUN git checkout feature/angular-updates

RUN yarn
RUN yarn build:lib

WORKDIR /root/ng2-bs3-modal/dist

RUN tar cvfz ng2-bs3-modal.tar.gz ng2-bs3-modal/

SHELL ["/bin/bash", "-c"]
CMD echo -e "In another terminal execute:\n    - 'docker cp ${HOSTNAME}:$(pwd)/ng2-bs3-modal.tar.gz .'\nto copy the package out of the container." && read -p "Then press <Enter> to terminate this container."
