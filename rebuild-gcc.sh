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
	echo "    --arch=<i686|x86_64>       - specifies the architecture"
    echo "    --do-not-reinstall         - stop if package is already installed"
	echo "    --add-depend-pkg           - add dependend packages"
	echo "    --define-build-order       - automatically define build order"
	echo "    --simulate                 - do not build"
	echo "    --check-recipe-quality     - check recipe quality"
	exit 0
}

# **************************************************************************
PKGROOT=${TOP_DIR}
BUILD_ARCHITECTURE="x86_64"
[[ ${MINGW_INSTALLS} == mingw32 ]] && {
	BUILD_ARCHITECTURE="i686"
}
while [[ $# > 0 ]]; do
	case $1 in
		--arch=*)
			BUILD_ARCHITECTURE=${1/--arch=/}
			case $BUILD_ARCHITECTURE in
				i686)
				export MINGW_INSTALLS=mingw32
				;;
				x86_64)
				export MINGW_INSTALLS=mingw64
				;;
				*) die "Unsupported architecture: \"$BUILD_ARCHITECTURE\". terminate."  ;;
			esac
		;;
		--pkgroot=*)
			PKGROOT=$(realpath ${1/--pkgroot=/})
		;;
		--do-not-reinstall) NOT_REINSTALL=yes ;;
		--add-depend-pkg) ADD_DEPEND_PKG=yes ;;
		--define-build-order) DEFINE_BUILD_ORDER=yes ;;
		--simulate) SIMULATE=yes ;;
		--check-recipe-quality) CHECK_RECIPE_QUALITY=yes ;;
		*)	die "Unsupported line"  ;;
	esac
	shift
done

message 'Package root' "${PKGROOT}"


packages=()
#packages+=("gcc")

packages+=("libiconv")
packages+=("gettext")
packages+=("ncurses")
packages+=("bash")
packages+=("bash-completion")
packages+=("bzip2")
packages+=("zlib")
packages+=("openssl")
packages+=("findutils")
packages+=("gmp")
packages+=("coreutils")
packages+=("sed")
packages+=("libtasn1")
packages+=("libffi")
packages+=("p11-kit")
packages+=("readline")
packages+=("pcre")
packages+=("grep")
packages+=("ca-certificates")
packages+=("catgets")
packages+=("db")
packages+=("libcrypt")
packages+=("msys2-runtime")
packages+=("make")
packages+=("ed")
packages+=("patch")
packages+=("libedit")
packages+=("icu")
packages+=("sqlite")
packages+=("heimdal")
packages+=("expat")
packages+=("xz")
packages+=("libxml2")
packages+=("libmetalink")
packages+=("libssh2")
packages+=("curl")
packages+=("filesystem")
packages+=("dash")
packages+=("file")
packages+=("m4")
packages+=("flex")
packages+=("mpfr")
packages+=("gawk")
packages+=("gnupg")
packages+=("less")
packages+=("gzip")
packages+=("tftp-hpa")
packages+=("inetutils")
packages+=("lzo2")
packages+=("nettle")
packages+=("libarchive")
packages+=("libgpg-error")
packages+=("libassuan")
packages+=("gpgme")
packages+=("libidn")
packages+=("util-linux")
packages+=("lndir")
packages+=("mintty")
packages+=("msys2-keyring")
packages+=("msys2-launcher-git")
packages+=("pacman-mirrors")
packages+=("which")
packages+=("pacman")
packages+=("pkgfile")
packages+=("wget")
packages+=("pactoys-git")
packages+=("pax-git")
packages+=("rebase")
packages+=("time")
packages+=("ttyrec")
packages+=("tzcode")

packages+=("binutils")

packages+=("gdbm")
packages+=("python2")
packages+=("libgcrypt")

packages+=("libxslt")
packages+=("docbook-xml")
packages+=("docbook-xsl")
packages+=("asciidoc")
packages+=("diffutils")
packages+=("autoconf")

packages+=("autoconf2.13")
packages+=("gc")
packages+=("libunistring")
packages+=("guile")
packages+=("db")
packages+=("perl")
packages+=("automake1.6")
packages+=("automake1.7")
packages+=("automake1.8")
packages+=("automake1.9")
packages+=("automake1.10")
packages+=("automake1.11")
packages+=("automake1.12")
packages+=("automake1.13")
packages+=("automake1.14")
packages+=("automake1.15")
packages+=("automake-wrapper")

packages+=("bison")
packages+=("diffstat")
packages+=("dos2unix")
packages+=("expat")

packages+=("gdb")
packages+=("libiconv")
packages+=("gperf")
packages+=("groff")
packages+=("perl-Locale-Gettext")
packages+=("help2man")
packages+=("perl-XML-Parser")
packages+=("intltool")
packages+=("lemon")
packages+=("tar")
packages+=("unrar")
packages+=("make")
packages+=("libpipeline")
packages+=("man-db")
packages+=("pactoys-git")
packages+=("patchutils")
packages+=("glib2")
packages+=("pkg-config")
packages+=("quilt")
packages+=("rcs")
packages+=("scons")
packages+=("swig")
packages+=("texinfo")
packages+=("ttyrec")
packages+=("perl-YAML-Syck")
packages+=("perl-Module-Build")
packages+=("xmlto")
packages+=("libtool")

message 'Processing changes' "${commits[@]}"

[[ $ADD_DEPEND_PKG == yes ]] && {
	add_dependencies
}


[[ $NOT_REINSTALL == yes ]] && {
	execute 'Check for installed packages' check_for_installed_packages "${BUILD_ARCHITECTURE}"
}


test -z "${packages}" && success 'No changes in package recipes'

[[ $DEFINE_BUILD_ORDER == yes ]] && {
	define_build_order || failure 'Could not determine build order'
}


#export MINGW_INSTALLS=mingw64

# Build
message 'Building packages' "${packages[@]}"
#execute 'Updating system' update_system
[[ $CHECK_RECIPE_QUALITY == yes ]] && {
	execute 'Approving recipe quality' check_recipe_quality
}
[[ $SIMULATE == yes ]] && {
	success 'Simulate only'
}

for package in "${packages[@]}"; do
	execute 'Delete pkg' rm -rf "${PKGROOT}/${package}"/pkg
    execute 'Delete src' rm -rf "${PKGROOT}/${package}"/src

	deploy_enabled &&  mv "${PKGROOT}/${package}"/*.pkg.tar.xz $TOP_DIR/artifacts
    execute 'Building binary' makepkg --log --force --noprogressbar --skippgpcheck --nocheck --syncdeps --cleanbuild
    execute 'Building source' makepkg --noconfirm --force --noprogressbar --skippgpcheck --allsource 
    execute 'Installing' pacman --noprogressbar --noconfirm --upgrade *.pkg.tar.xz
    deploy_enabled && mv "${PKGROOT}/${package}"/*.pkg.tar.xz $TOP_DIR/artifacts
    deploy_enabled && mv "${PKGROOT}/${package}"/*.src.tar.gz $TOP_DIR/artifacts_src
    unset package
done

# Deploy
#deploy_enabled && cd artifacts || success 'All packages built successfully'
#execute 'Generating pacman repository' create_pacman_repository "${PACMAN_REPOSITORY_NAME:-ci-build}"
#execute 'Generating build references'  create_build_references  "${PACMAN_REPOSITORY_NAME:-ci-build}"
#execute 'SHA-256 checksums' sha256sum *
success 'All artifacts built successfully'
