#!/bin/bash

## @file DownloadDependencies.sh
## @brief Download dependencies for the project.
## @date January 2025

## @fn download_dependencies()
## @brief Loads dependencies for the package manager.
##
## @param $1 The name of the dependency to download from GitHub.
## @param $2 The name of the directory and script to source after downloading.
##
## @code
## download_dependencies <dependency_name> <script_name>
## @endcode
##
## @example
## @code
## download_dependencies "some-dependency" "some-script"
## @endcode
##
## @note
## - The function changes the directory to the vendor path specified by the TCLI_PATH_VENDOR variable.
## - It downloads the dependency tarball from GitHub and extracts it.
## - It checks if the specified script exists in the vendor directory.
## - If any step fails, the function prints an error message and exits with status 1.
download_dependencies() {
	if [ "$TCLI_LINUX_LOGGER_LOADED" == 1 ]; then
		tcli_linux_logger_infoscreen "INFO" "Loading dependencies ${1}.${2}"
	fi
	cd "$TCLI_PATH_VENDOR" || { echo "Failed to change directory to $TCLI_PATH_VENDOR"; exit 1; }

	# for testing
	curl --silent -L "https://github.com/Tirsvad/TirsvadCLI.${1}/tarball/master" -o /tmp/${1}.tar.gz || { echo "Failed to download $1"; exit 1; }
	# end for testing
	#curl -L "https://github.com/TirsvadCLI/${1}/tarball/master" -o /tmp/${1}.tar.gz || { echo "Failed to download $1"; exit 1; }
	tar xz --strip-components=2 --wildcards "*/src/${2}/*" -C "./${1}" -f /tmp/${1}.tar.gz

	rm /tmp/${1}.tar.gz
	if [ ! -f "$TCLI_PATH_VENDOR/${2}/${2}.sh" ]; then
		if [ "$TCLI_LINUX_LOGGER_LOADED" == 1 ]; then
			tcli_linux_logger_infoscreenFailedExit "Failed" " to find " "$TCLI_PATH_VENDOR/${2}/${2}.sh"
		else
			echo "File $TCLI_PATH_VENDOR/${2}/${2}.sh not found"
			exit 1
		fi
	fi
	cd "$TCLI_LINUX_PACKAGEMANAGER_PATH_ROOT"
	if [ "$TCLI_LINUX_LOGGER_LOADED" == 1 ]; then
		tcli_linux_logger_infoscreenDone
	fi
}
