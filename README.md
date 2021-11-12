# 定制jenkins
基于 jenkins/jenkins:latest-jdk11 定制, 添加一些常用工具, 尽量使用国内源, 加快构建速度

## 特色
 * 使用华为镜像源安装 docker-ce
 * 使用清华镜像源安装 Apache Maven 3.8.3
   maven 默认使用阿里Maven源
 * 使用清华镜像源安装 nodejs v14.18.1
 * 使用清华镜像源安装 Jenkins 常用插件

## 使用方法
```
git clone https://github.com/xqgzh/docker-jenkins.git
cd docker-jenkins
docker built -t docker-jenkins:0.1 .
docker-compose up -d
```

上述操作执行完成后, 打开 http://localhost:9090/ 按照提示进行安装即可