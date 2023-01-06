#!/bin/bash
#全局变量
scriptDir=$(cd $(dirname $0); pwd)
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
read -p "是否执行npm install(y/n),默认n: " isInstall
echo -e "\033[1;33m--------------------------------从git获取代码----------------------------------\033[0m"
#判断目录是否是一个git仓库，是仓库则执行git pull不是则git clone
if [ -d .git ]; then
  echo "git pull"
  docker run --rm -it --name git-temp -v $codePath:/git/repo wuliangxue/git:0.1-alpine sh -c 'git stash && git pull $gitUrl'
else
  echo "git clone"
  docker run --rm -it --name git-temp -v $codePath:/git/repo wuliangxue/git:0.1-alpine git clone $gitUrl .
fi;
if [ "$isInstall" = "y" ]; then
	echo -e "\033[1;33m-------------------------------install并且打包---------------------------------\033[0m"
	docker run -it --rm --name node-temp -v $codePath:/app -w /app node:15.5.1-alpine3.10 sh -c 'yarn config set registry https://registry.npm.taobao.org && yarn config set disturl https://npm.taobao.org/dist && yarn install && yarn run build'
else
  echo -e "\033[1;33m-------------------------------------打包--------------------------------------\033[0m"
  docker run -it --rm --name node-temp -v $codePath:/app -w /app node:15.5.1-alpine3.10 sh -c 'yarn run build'
fi

cd $scriptDir
cp -rf $codePath/dist/* ../step-iot-front/
cp -rf $codePath/*-nginx.conf ../nginx/conf.d

echo
echo -e "\033[1;32m-------------------------------------------------------------------------------\033[0m"
echo -e "\033[1;32m-----------------------------------打包成功------------------------------------\033[0m"
echo -e "\033[1;32m-------------------------------------------------------------------------------\033[0m"
echo


