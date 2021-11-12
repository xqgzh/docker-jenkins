FROM jenkins/jenkins:latest-jdk11
USER root


RUN sed -i 's/deb.debian.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list
RUN sed -i 's/security.debian.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list

RUN apt-get update && apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common wget

# 安装Docker
RUN curl -fsSL https://mirrors.huaweicloud.com/docker-ce/linux/debian/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://mirrors.huaweicloud.com/docker-ce/linux/debian $(lsb_release -cs) stable"
RUN apt-get update 
RUN apt-get install -y docker-ce-cli

# 设为中国时区
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Git
RUN apt-get install -y git sudo
RUN apt-get clean all

# Maven
ARG MAVEN_VERSION=3.8.3
RUN wget --no-check-certificate --no-cookies https://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz -P /tmp/
RUN tar -zxvf /tmp/apache-maven-${MAVEN_VERSION}-bin.tar.gz -C /usr/share/
ENV MAVEN_VERSION=${MAVEN_VERSION}
ENV M2_HOME /usr/share/apache-maven-$MAVEN_VERSION
ENV maven.home $M2_HOME
ENV M2 $M2_HOME/bin
ENV PATH $M2:$PATH

# NodeJS
ARG NODE_VERSION=v14.18.1
RUN wget --no-check-certificate --no-cookies https://mirrors.tuna.tsinghua.edu.cn/nodejs-release/$NODE_VERSION/node-$NODE_VERSION-linux-x64.tar.gz -P /tmp/
RUN tar -zxvf /tmp/node-$NODE_VERSION-linux-x64.tar.gz -C /usr/share/
RUN mv /usr/share/node-$NODE_VERSION-linux-x64 /usr/share/node
WORKDIR /usr/share/node
ENV NODE_HOME /usr/share/node
RUN ln -s /usr/share/node/bin/node /usr/bin/node
RUN ln -s /usr/share/node/bin/npm /usr/bin/npm
ENV PATH $NODE_HOME/bin:$PATH

# 安装 jenkins 插件
# 使用国内镜像源下载插件
ENV JENKINS_UC https://mirrors.tuna.tsinghua.edu.cn/jenkins/updates/update-center.json
ENV JENKINS_UC_EXPERIMENTAL https://mirrors.tuna.tsinghua.edu.cn/jenkins/updates/experimental/update-center.json
ENV JENKINS_PLUGIN_INFO https://mirrors.tuna.tsinghua.edu.cn/jenkins/updates/current/plugin-versions.json
ENV JENKINS_UC_DOWNLOAD_URL https://mirrors.tuna.tsinghua.edu.cn/jenkins/
ENV JENKINS_UC_DOWNLOAD https://mirrors.tuna.tsinghua.edu.cn/jenkins/

ADD ./plugins.txt /tmp/
RUN jenkins-plugin-cli -f /tmp/plugins.txt --verbose

#清理安装文件
RUN rm -rf /tmp/*
