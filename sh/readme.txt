脚本逻辑：执行各应用编译脚本->copy编译结果至应用挂载目录->运行docker-compose
TODO: tdengine数据库初始化

1.目录说明
-mysql
-minio
-nginx
-redis
-step-iot-front
-step-iot-back
-tdengine
以上目录为各个应用挂载目录

2.部署执行deploy.sh,deploy.sh中选择执行sh目录下具体应用编译脚本
-sh
	-step-iot-back-prod.sh
	-step-iot-front-prod.sh
