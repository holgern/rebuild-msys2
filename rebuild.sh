#!/bin/bash

readonly TOP_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# AppVeyor and Drone Continuous Integration for MSYS2
# Author: Renato Silva <br.renatosilva@gmail.com>
# Author: Qian Hong <fracting@gmail.com>
# Author: Holger Nahrstaedt <holger@nahrstaedt>

# Configure
cd "$(dirname "$0")"
source $TOP_DIR/rebuild-library.sh
deploy_enabled && mkdir -p artifacts
deploy_enabled && mkdir -p artifacts_src
#git_config user.email 'ci@msys2.org'
#git_config user.name  'MSYS2 Continuous Integration'
#git remote add upstream 'https://github.com/Alexpux/MINGW-packages'
#git fetch --quiet upstream

# Detect
#list_commits  || failure 'Could not detect added commits'
#list_packages || failure 'Could not detect changed files'


readonly RUN_ARGS="$@"
[[ $# == 1 && $1 == --help || $[ $# == 0 ] == 1 ]] && {
	echo "usage:"
	echo "  ./${0##*/} --arch=<i686|x86_64> [OPTIONS] packagename"
	echo "  help:"
	echo "    --pkgroot=<path>           - specifies the packages root directory"
    echo "    --do-not-reinstall         - stop if package is already installed"
	echo "    --add_depend_pkg           - add dependend packages"
	echo "    --define_build_order       - automatically define build order"
	echo "    --simulate                 - do not build"
	exit 0
}

# **************************************************************************
PKGROOT=${TOP_DIR}
while [[ $# > 0 ]]; do
	case $1 in
		--pkgroot=*)
			PKGROOT=$(realpath ${1/--pkgroot=/})
		;;
		--do-not-reinstall) NOT_REINSTALL=yes ;;
		--add_depend_pkg) ADD_DEPEND_PKG=yes ;;
		--define_build_order) DEFINE_BUILD_ORDER=yes ;;
		--simulate) SIMULATE=yes ;;
		*)
			readonly PACKAGE=${1}
		;;
	esac
	shift
done

message 'Package root' "${PKGROOT}"


packages=()
packages+=("$PACKAGE")




message 'Processing changes' "${commits[@]}"

[[ $ADD_DEPEND_PKG == yes ]] && {
	add_dependencies
}

[[ $NOT_REINSTALL == yes ]] && {
	execute 'Check for installed packages' check_for_installed_packages  "${BUILD_ARCHITECTURE}"
}


test -z "${packages}" && success 'No changes in package recipes'

[[ $DEFINE_BUILD_ORDER == yes ]] && {
	define_build_order || failure 'Could not determine build order'
}


#export MINGW_INSTALLS=mingw64

# Build
message 'Building packages' "${packages[@]}"
#execute 'Updating system' update_system
execute 'Approving recipe quality' check_recipe_quality

[[ $SIMULATE == yes ]] && {
	success 'Simulate only'
}

for package in "${packages[@]}"; do
	execute 'Delete pkg' rm -rf "${PKGROOT}/${package}"/pkg
    execute 'Delete src' rm -rf "${PKGROOT}/${package}"/src
	deploy_enabled &&  mv "${PKGROOT}/${package}"/*.pkg.tar.xz $TOP_DIR/artifacts
    execute 'Building binary' makepkg  --log --force --noprogressbar --skippgpcheck --nocheck --syncdeps --cleanbuild
    execute 'Building source' makepkg --noconfirm --force --noprogressbar --skippgpcheck --allsource 
    execute 'Installing' pacman --noprogressbar --noconfirm --upgrade *.pkg.tar.xz
    deploy_enabled && mv "${package}"/*.pkg.tar.xz $TOP_DIR/artifacts
    deploy_enabled && mv "${package}"/*.src.tar.gz $TOP_DIR/artifacts
    unset package
done

# Deploy
#deploy_enabled && cd artifacts || success 'All packages built successfully'
#execute 'Generating pacman repository' create_pacman_repository "${PACMAN_REPOSITORY_NAME:-ci-build}"
#execute 'Generating build references'  create_build_references  "${PACMAN_REPOSITORY_NAME:-ci-build}"
#execute 'SHA-256 checksums' sha256sum *
success 'All artifacts built successfully'
