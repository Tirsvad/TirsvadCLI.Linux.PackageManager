#!/bin/bash

declare TCLI_PACKAGEMANAGER_PATH_ROOT="$(dirname "$(realpath "${BASH_SOURCE}")")"
declare TCLI_PACKAGEMANAGER_REMOTE_SERVER=0
declare TCLI_PACKAGEMANAGER_REMOTE_SERVER_IP=0
declare TCLI_PACKAGEMANAGER_REMOTE_SERVER_PORT=22
declare TCLI_PACKAGEMANAGER_TERMINAL_OUTPUT

case $TCLI_LINUX_DISTRIBUTION_ID in
"Debian GNU/Linux")
	. $TCLI_PACKAGEMANAGER_PATH_ROOT/inc/packagesDebian10.sh
	;;
"Ubuntu")
	. $TCLI_PACKAGEMANAGER_PATH_ROOT/inc/packagesUbuntu2210.sh
	;;
esac

tcli_packageManager_install() {
	local _cmd
	if (( $TCLI_PACKAGEMANAGER_REMOTE_SERVER == 0 )); then
		_cmd=($TCLI_PKGS_INSTALL_CMD $@)
	else
		# _cmd=("ssh -p $TCLI_PACKAGEMANAGER_REMOTE_SERVER_PORT root@$TCLI_PACKAGEMANAGER_REMOTE_SERVER_IP $TCLI_PKGS_INSTALL_CMD ")
		_cmd=(ssh)
		_cmd+=(-p $TCLI_PACKAGEMANAGER_REMOTE_SERVER_PORT)
		_cmd+=(root@$TCLI_PACKAGEMANAGER_REMOTE_SERVER_IP)
		_cmd+=($TCLI_PKGS_INSTALL_CMD $@)
	fi
	TCLI_PACKAGEMANAGER_TERMINAL_OUTPUT=$(${_cmd[@]})
	if [ ! $? -eq 0 ]; then
		infoscreenwarn
		printf "Tried to install \"$@\" but failed: $_cmd\n"
		return 1
	fi
	while(( "$#" ))
	do
		printf "Installed $1\n"
		shift
	done
}

tcli_packageManager_system_update() {
	case $TCLI_LINUX_DISTRIBUTION_ID in
	"Debian GNU/Linux")
		local cmd="DEBIAN_FRONTEND=noninteractive apt-get update > /dev/null"
		;;
	"Ubuntu")
		local cmd="DEBIAN_FRONTEND=noninteractive apt-get update > /dev/null"
		;;
	esac
	if (( $TCLI_PACKAGEMANAGER_REMOTE_SERVER == 0 )); then
		$cmd
	else
		ssh -p $TCLI_PACKAGEMANAGER_REMOTE_SERVER_PORT root@$TCLI_PACKAGEMANAGER_REMOTE_SERVER_IP $cmd
	fi
	if [ $? -ne 0 ]; then
		infoscreenwarn
		printf "${FUNCNAME[0]}: WARNING\n"
	fi
}

tcli_packageManager_system_upgrade() {
	case $TCLI_LINUX_DISTRIBUTION_ID in
	"Debian GNU/Linux")
		local cmd="DEBIAN_FRONTEND=noninteractive apt-get -y upgrade > /dev/null"
		;;
	"Ubuntu")
		local cmd="DEBIAN_FRONTEND=noninteractive apt-get -y upgrade > /dev/null"
		;;
	esac
	if (( $TCLI_PACKAGEMANAGER_REMOTE_SERVER == 0 )); then
		$cmd
	else
		ssh -p $TCLI_PACKAGEMANAGER_REMOTE_SERVER_PORT root@$TCLI_PACKAGEMANAGER_REMOTE_SERVER_IP $cmd
	fi
	if [ $? -ne 0 ]; then
		infoscreenwarn
		printf "${FUNCNAME[0]}: WARNING\n"
	fi
}

