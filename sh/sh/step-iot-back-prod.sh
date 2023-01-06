#!/bin/bash
scriptDir=$(cd $(dirname $0); pwd)
#全局变量
#gitUrl若携带账号和密码，账号和密码中如若有@符号需用%40替换
gitUrl=
codePath=
#设置报错立刻退出
err_msg(){
echo -e "\033[1;31m----------------------------------发布失败------------------------------------\033[0m"
}
trap "err_msg" ERR
set -e
#进入代码目录，若目录不存在则创建
if [ ! -d "$codePath" ]; then
  mkdir -p $codePath
fi
cd $codePath
echo -e "\033[1;33m--------------------------------从git获取代码----------------------------------\033[0m"
#判断目录是否是一个git仓库，是仓库则执行git pull不是则git clone
if [ -d .git ]; then
  echo "git pull"
  docker run --rm -it --name git-temp -v $codePath:/git/repo wuliangxue/git:0.1-alpine git pull $gitUrl
else
  echo "git clone"
  docker run --rm -it --name git-temp -v $codePath:/git/repo wuliangxue/git:0.1-alpine git clone $gitUrl .
fi;
echo -e "\033[1;33m----------------------------------maven打包------------------------------------\033[0m"
docker run -it --rm --name maven-temp -v $codePath:/usr/src/app -v /webapps/maven/.m2:/root/.m2 -w /usr/src/app maven:3.8.5-openjdk-17 mvn clean install -Dmaven.test.skip=true
cd $scriptDir
if [ ! -d "../step-iot-back/bak/" ];then
	mkdir ../step-iot-back/bak
fi
if [ -f "../step-iot-back/step-iot-back.jar" ];then
	mv ../step-iot-back/step-iot-back.jar ../step-iot-back/bak/step-iot-back.jar.$(date "+%Y%m%d-%H:%M:%S").bak
fi
cp -f $codePath/iot-manager/target/step-iot-back.jar ../step-iot-back/
cp -f $codePath/iot-manager/Dockerfile ../step-iot-back/
sed -i "s/\.\/target\/step-iot-back.jar/step-iot-back.jar/g" ../step-iot-back/Dockerfile
cp -f $codePath/iot-manager/libtaos.so ../step-iot-back/
cp -f $codePath/iot-manager/taos.cfg ../step-iot-back/
echo
echo -e "\033[1;32m-------------------------------------------------------------------------------\033[0m"
echo -e "\033[1;32m-----------------------------------打包成功------------------------------------\033[0m"
echo -e "\033[1;32m-------------------------------------------------------------------------------\033[0m"
echo


