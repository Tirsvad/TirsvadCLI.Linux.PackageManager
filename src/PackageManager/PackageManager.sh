#!/bin/bash

TCLI_PACKAGEMANAGER_PATH_ROOT="$(dirname "$(realpath "${BASH_SOURCE}")")"
TCLI_PACKMANAGER_REMOTE_SERVER=0
TCLI_PACKMANAGER_REMOTE_SERVER_IP=0
TCLI_PACKMANAGER_REMOTE_SERVER_PORT=22

case $DISTRIBUTION_ID in
"Debian GNU/Linux")
	. $TCLI_PACKAGEMANAGER_PATH_ROOT/inc/packagesDebian10.sh
	;;
"Ubuntu")
	. $TCLI_PACKAGEMANAGER_PATH_ROOT/inc/packagesUbuntu2210.sh
	;;
esac

tcli_packageManager_install() {
	if [ $? -ne 0 ]; then
		infoscreenwarn
		printf "${FUNCNAME[0]}: WARNING\n"
		return 1
	fi
	if (( $TCLI_PACKMANAGER_REMOTE_SERVER == 0 )); then
		$TCLI_PKGS_INSTALL_CMD $@
	else
		echo "ssh -p $TCLI_PACKMANAGER_REMOTE_SERVER_PORT root@$TCLI_PACKMANAGER_REMOTE_SERVER_IP $TCLI_PKGS_INSTALL_CMD $@"
		ssh -p $TCLI_PACKMANAGER_REMOTE_SERVER_PORT root@$TCLI_PACKMANAGER_REMOTE_SERVER_IP $TCLI_PKGS_INSTALL_CMD $@
	fi
}

tcli_packageManager_system_update() {
	case $DISTRIBUTION_ID in
	"Debian GNU/Linux")
		local cmd="DEBIAN_FRONTEND=noninteractive apt-get update"
		;;
	"Ubuntu")
		local cmd="DEBIAN_FRONTEND=noninteractive apt-get update"
		;;
	esac
	if (( $TCLI_PACKMANAGER_REMOTE_SERVER == 0 )); then
		$cmd
	else
		ssh -p $TCLI_PACKMANAGER_REMOTE_SERVER_PORT root@$TCLI_PACKMANAGER_REMOTE_SERVER_IP $cmd
	fi
	if [ $? -ne 0 ]; then
		infoscreenwarn
		printf "${FUNCNAME[0]}: WARNING\n"
	fi
}

tcli_packageManager_system_upgrade() {
	case $DISTRIBUTION_ID in
	"Debian GNU/Linux")
		local cmd="DEBIAN_FRONTEND=noninteractive apt-get -y upgrade"
		;;
	"Ubuntu")
		local cmd="DEBIAN_FRONTEND=noninteractive apt-get -y upgrade"
		;;
	esac
	if (( $TCLI_PACKMANAGER_REMOTE_SERVER == 0 )); then
		$cmd
	else
		ssh -p $TCLI_PACKMANAGER_REMOTE_SERVER_PORT root@$TCLI_PACKMANAGER_REMOTE_SERVER_IP $cmd
	fi
	if [ $? -ne 0 ]; then
		infoscreenwarn
		printf "${FUNCNAME[0]}: WARNING\n"
	fi
}

