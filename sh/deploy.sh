#!/bin/bash
#./sh/step-iot-back-prod.sh
#./sh/step-iot-front-prod.sh

#sudo docker-compose down
#sudo docker-compose up --build -d

red='\e[91m'
green='\e[92m'
yellow='\e[93m'
magenta='\e[95m'
cyan='\e[96m'
none='\e[0m'

deploy_apps=(
	./sh/step-iot-front-prod.sh
	./sh/step-iot-back-prod.sh
)

application=(
	step-iot-front
	step-iot-back
)

deploy_choose() {
	while :; do
		echo -e "请选择 "$yellow"docker-compose"$none" 应用 [${magenta}1-${#application[*]}$none]"
		echo
		for ((i = 1; i <= ${#application[*]}; i++)); do
			App="${application[$i - 1]}"
			if [[ "$i" -le 9 ]]; then
				# echo
				echo -e "$yellow  $i. $none${App}"
			else
				# echo
				echo -e "$yellow $i. $none${App}"
			fi
		done
		read -p "$(echo -e "(默认安装: ${cyan}所有$none)"):" app_install
		[ -z "$app_install" ] && app_install=0
		case $app_install in
		[1-2])
			echo
			echo
			echo -e "$yellow 安装 = $cyan${application[$app_install - 1]}$none"
			echo "----------------------------------------------------------------"
			echo
			break
			;;
		[0])
			echo
			echo
			echo -e "$yellow 安装 = $cyan所有$none"
			echo "----------------------------------------------------------------"
			echo
			break
			;;
		*)
			error
			;;
		esac
	done
	deploy_start
}

deploy_start() {
	case $app_install in
		0)
			for ((i = 1; i <= ${#application[*]}; i++)); do
				echo "执行脚本---------${deploy_apps[$i - 1]}"
				${deploy_apps[$i - 1]}
                                docker-compose up --build -d ${application[$i - 1]}
			done
			;;
		[1-2])
			${deploy_apps[${app_install} - 1]}
                        docker-compose up --build -d ${application[${app_install} - 1]}
			;;
	esac

}



deploy_choose
