#!/bin/bash

#declare IFS=$'\n'

## @file TirsvadCLI.Linux.PackageManager/src/PackageManager/PackageManager.sh
## @brief This script contains functions for the package manager.
##
## @details
## This script provides functionality to manage dependencies for the package manager.
## It includes a function to load dependencies by downloading and sourcing the required scripts.

## @fn tcli_linux_packagemanager_install()
## @brief Installs packages either locally or on a remote server.
##
## @param 
##   $@ - List of packages to install.
##
## @var
##   TCLI_LINUX_PACKAGEMANAGER_REMOTE_SERVER - Flag indicating if the installation is on a remote server (0 for local, non-zero for remote).
##   TCLI_LINUX_PACKAGEMANAGER_REMOTE_SERVER_PORT - Port number for the remote server SSH connection.
##   TCLI_LINUX_PACKAGEMANAGER_REMOTE_SERVER_IP - IP address of the remote server.
##   TCLI_LINUX_PACKAGEMANAGER_PKGS_INSTALL_CMD - Command used to install packages.
##   TCLI_LINUX_PACKAGEMANAGER_TERMINAL_OUTPUT - Variable to store the terminal output of the installation command.
##
## @return
##   0 - If the installation was successful.
##   1 - If the installation failed.
##
## @note
##   - If the installation is remote, the function constructs an SSH command to execute the package installation on the remote server.
##   - The function prints a warning message if the installation fails.
##   - The function prints the names of the installed packages.
tcli_linux_packagemanager_install() {
	local _cmd TCLI_LINUX_PACKAGEMANAGER_TERMINAL_OUTPUT

#	if (( $TCLI_LINUX_PACKAGEMANAGER_REMOTE_SERVER == 0 )); then
		# Local installation
		_cmd=($TCLI_LINUX_PACKAGEMANAGER_PKGS_INSTALL_CMD)
		for pkg in "$@"; do
			apt-cache show "$pkg" > /dev/null
			if [ $? -ne 0 ]; then
				infoscreenwarn
				printf "Package %s not found\n" "$pkg"
				return 1
			else
				printf "Package %s found\n" "$pkg"
				# _cmd+=("$pkg")
			fi
		done
		printf '%s ' "${_cmd[@]}"
		for cmd in  "${_cmd[@]}"; do
			printf "$cmd\n"
		done
#	else
		# Remote installation
		# _cmd=("ssh -p $TCLI_LINUX_PACKAGEMANAGER_REMOTE_SERVER_PORT root@$TCLI_LINUX_PACKAGEMANAGER_REMOTE_SERVER_IP $TCLI_LINUX_PACKAGEMANAGER_PKGS_INSTALL_CMD ")
#		_cmd=(ssh -p "$TCLI_LINUX_PACKAGEMANAGER_REMOTE_SERVER_PORT" root@"$TCLI_LINUX_PACKAGEMANAGER_REMOTE_SERVER_IP" "$TCLI_LINUX_PACKAGEMANAGER_PKGS_INSTALL_CMD" "$@")
#	fi
    # Execute the command
    #TCLI_LINUX_PACKAGEMANAGER_TERMINAL_OUTPUT=$("${_cmd[@]}" 2>&1)
    TCLI_LINUX_PACKAGEMANAGER_TERMINAL_OUTPUT=$("${_cmd[@]}")
    local cmd_exit_status=$?
	if [ $cmd_exit_status -ne 0 ]; then
        infoscreenwarn
        printf "Tried to install %s but failed: %s\n" "$*" "$TCLI_LINUX_PACKAGEMANAGER_TERMINAL_OUTPUT"
        return 1
    fi

	# Print the names of the installed packages
	while(( "$#" ))
	do
		printf "Installed $1\n"
		shift
	done
}

## @fn tcli_linux_packagemanager_system_update()
## @brief Updates the package list on the system based on the Linux distribution.
## @details
## This function updates the package list on a Debian-based Linux distribution.
## It supports both local and remote execution.
##
## @var
##   TCLI_LINUX_DISTRIBUTION_ID - The ID of the Linux distribution (e.g., "Debian GNU/Linux", "Ubuntu").
##   TCLI_LINUX_PACKAGEMANAGER_REMOTE_SERVER - Flag indicating whether to use a remote server (0 for local, non-zero for remote).
##   TCLI_LINUX_PACKAGEMANAGER_REMOTE_SERVER_PORT - The port number for SSH connection to the remote server.
##   TCLI_LINUX_PACKAGEMANAGER_REMOTE_SERVER_IP - The IP address of the remote server.
##
## @note
##   - Executes the package update command locally or on a remote server.
##   - Displays a warning message if the update command fails.
tcli_linux_packagemanager_system_update() {
	case $TCLI_LINUX_DISTRIBUTION_ID in
	"Debian GNU/Linux")
		local cmd="DEBIAN_FRONTEND=noninteractive apt-get update > /dev/null"
		;;
	"Ubuntu")
		local cmd="DEBIAN_FRONTEND=noninteractive apt-get update > /dev/null"
		;;
	esac
#	if (( $TCLI_LINUX_PACKAGEMANAGER_REMOTE_SERVER == 0 )); then
		$cmd
#	else
#		ssh -p $TCLI_LINUX_PACKAGEMANAGER_REMOTE_SERVER_PORT root@$TCLI_LINUX_PACKAGEMANAGER_REMOTE_SERVER_IP $cmd
#	fi
	if [ $? -ne 0 ]; then
		infoscreenwarn
		printf "${FUNCNAME[0]}: WARNING\n"
	fi
}

## @fn tcli_linux_packagemanager_system_upgrade()
## @brief Upgrades the system based on the Linux distribution.
## @details
## This function performs a system upgrade on a Debian-based Linux distribution.
## It supports both local and remote execution.
##
## @var
##   TCLI_LINUX_DISTRIBUTION_ID - The ID of the Linux distribution (e.g., "Debian GNU/Linux", "Ubuntu").
##   TCLI_LINUX_PACKAGEMANAGER_REMOTE_SERVER - Flag indicating if the upgrade should be performed on a remote server (0 for local, 1 for remote).
##   TCLI_LINUX_PACKAGEMANAGER_REMOTE_SERVER_PORT - The port number for SSH connection to the remote server.
##   TCLI_LINUX_PACKAGEMANAGER_REMOTE_SERVER_IP - The IP address of the remote server.
##
## @example
##   tcli_linux_packagemanager_system_upgrade
##
## @note
##   This function assumes that the user has the necessary permissions to perform the upgrade.
##   If the upgrade command fails, a warning message is displayed.
tcli_linux_packagemanager_system_upgrade() {
	case $TCLI_LINUX_DISTRIBUTION_ID in
	"Debian GNU/Linux")
		local cmd="DEBIAN_FRONTEND=noninteractive apt-get -y upgrade > /dev/null"
		;;
	"Ubuntu")
		local cmd="DEBIAN_FRONTEND=noninteractive apt-get -y upgrade > /dev/null"
		;;
	esac
#	if (( $TCLI_LINUX_PACKAGEMANAGER_REMOTE_SERVER == 0 )); then
		$cmd
#	else
#		ssh -p $TCLI_LINUX_PACKAGEMANAGER_REMOTE_SERVER_PORT root@$TCLI_LINUX_PACKAGEMANAGER_REMOTE_SERVER_IP $cmd
#	fi
	if [ $? -ne 0 ]; then
		infoscreenwarn
		printf "${FUNCNAME[0]}: WARNING\n"
	fi
}

printf "Loading package manager\n"

## @brief string for check if script is sourced
declare -r TCLI_LINUX_PACKAGEMANAGER

## @brief string for the version of the package manager
declare -r TCLI_LINUX_PACKAGEMANAGER_VERSION="0.1.0"

## @brief string for the root path of the package manager
declare -r TCLI_LINUX_PACKAGEMANAGER_PATH_ROOT="$(dirname "$(realpath "${BASH_SOURCE}")")"

declare -r TCLI_LINUX_PACKAGEMANAGER_PATH_INC="$TCLI_LINUX_PACKAGEMANAGER_PATH_ROOT/inc"
declare -r TCLI_LINUX_PACKAGEMANAGER_PATH_INC_CONFIG="$TCLI_LINUX_PACKAGEMANAGER_PATH_INC/config"

## @brief Check if the TCLI_PATH_VENDOR variable is not set or is empty.
## If it is, create the vendor directory relative to the package manager root path.
## Then, set the TCLI_PATH_VENDOR variable to the absolute path of the vendor directory.
if  [ -z "$TCLI_PATH_VENDOR" ]; then
	mkdir -p "$TCLI_LINUX_PACKAGEMANAGER_PATH_ROOT/../vendor"
	declare -r TCLI_PATH_VENDOR="$(realpath "$TCLI_LINUX_PACKAGEMANAGER_PATH_ROOT/../vendor")"
fi

# This script checks if the TCLI_LINUX_LOGGER environment variable is set.
# If it is not set, it loads the dependencies for the Linux.Logger module,
# sources the Logger.sh script, and initializes the logger with a specified
# log file path.
#
# Variables:
#   TCLI_LINUX_LOGGER - Environment variable to check if the logger is already initialized.
#   TCLI_PATH_VENDOR - Path to the vendor directory containing the Logger module.
#   TCLI_LINUX_PACKAGEMANAGER_PATH_ROOT - Root path for the package manager, used to specify the log file location.
#
# Functions:
#   download_dependencies - Function to load required dependencies.
#   tcli_linux_logger_init - Function to initialize the logger with the specified log file.
. "$TCLI_LINUX_PACKAGEMANAGER_PATH_ROOT/inc/DownloadDependencies/DownloadDependencies.sh"
if [ -z "$TCLI_LINUX_LOGGER" ]; then
	download_dependencies "Linux.Logger" "Logger"
	. "$TCLI_PATH_VENDOR/Logger/Logger.sh"
	tcli_linux_logger_init "${TCLI_LINUX_PACKAGEMANAGER_PATH_ROOT}/logfile.log"
fi

# Check if the environment variable TCLI_LINUX_DISTRIBUTION is not set.
# If it is not set, load the dependencies for "Linux.Distribution" and source the Distribution.sh script.
# This ensures that the necessary distribution-specific functions and variables are available.
if [ -z "$TCLI_LINUX_DISTRIBUTION" ]; then
	download_dependencies "Linux.Distribution" "Distribution"
	. "$TCLI_PATH_VENDOR/Distribution/Distribution.sh"
fi

#declare TCLI_LINUX_PACKAGEMANAGER_REMOTE_SERVER=0
#declare TCLI_LINUX_PACKAGEMANAGER_REMOTE_SERVER_IP=0
#declare TCLI_LINUX_PACKAGEMANAGER_REMOTE_SERVER_PORT=22
#declare TCLI_LINUX_PACKAGEMANAGER_TERMINAL_OUTPUT

# This script handles the inclusion of package management scripts based on the Linux distribution and its release version.
# 
# It uses the environment variables:
# - TCLI_LINUX_DISTRIBUTION_ID: The ID of the Linux distribution (e.g., "Debian GNU/Linux", "Ubuntu").
# - TCLI_LINUX_DISTRIBUTION_RELEASE: The release version of the Linux distribution (e.g., "10", "11", "12").
# - TCLI_LINUX_PACKAGEMANAGER_PATH_ROOT: The root path where the package management scripts are located.
#
# For Debian GNU/Linux:
# - Includes specific package management scripts for Debian releases 10, 11, and 12.
# - Outputs an error message and exits if the release version is unsupported.
#
# For Ubuntu:
# - Includes the package management script for Ubuntu 22.10.
#
# For unsupported distributions:
# - Outputs an error message with the unsupported distribution ID and release version, then exits.
case $TCLI_LINUX_DISTRIBUTION_ID in
    "Debian GNU/Linux")
        case $TCLI_LINUX_DISTRIBUTION_RELEASE in
            "10")
                . $TCLI_LINUX_PACKAGEMANAGER_PATH_INC_CONFIG/packagesDebian10.sh
                ;;
            "11")
                . $TCLI_LINUX_PACKAGEMANAGER_PATH_INC_CONFIG/packagesDebian11.sh
                ;;
            "12")
                . $TCLI_LINUX_PACKAGEMANAGER_PATH_INC_CONFIG/packagesDebian12.sh
                ;;
            *)
                echo "Unsupported Debian release: $TCLI_LINUX_DISTRIBUTION_RELEASE"
                exit 1
                ;;
        esac
        ;;
    "Ubuntu")
        . $TCLI_LINUX_PACKAGEMANAGER_PATH_INC_CONFIG/packagesUbuntu2210.sh
        ;;
    *)
        echo "Unsupported distribution: $TCLI_LINUX_DISTRIBUTION_ID"
        echo "release: $TCLI_LINUX_DISTRIBUTION_RELEASE"
        exit 1
        ;;
esac



exec 3>&-  # Close the screen descriptor