#!/bin/bash

readonly TOP_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Author: Holger Nahrstaedt <holger@nahrstaedt>

# Configure
cd "$(dirname "$0")"
source $TOP_DIR/rebuild-library.sh
#rm -rf artifacts_old
mkdir artifacts_old
mkdir artifacts
mv artifacts/* artifacts_old

#rm -rf artifacts_src_old
mkdir artifacts_src_old
mkdir artifacts_src
mv artifacts_src/* artifacts_src_old

pacman -S --noprogressbar --noconfirm git

git_config user.email 'ci@msys2.org'
git_config user.name  'MSYS2 Continuous Integration'
#git remote add upstream 'https://github.com/Alexpux/MINGW-packages'
#git fetch --quiet upstream

# Detect
#list_commits  || failure 'Could not detect added commits'
#list_packages || failure 'Could not detect changed files'

pacman --noconfirm -R $(pacman -Qq | grep mingw-w64)
pacman --noprogressbar --noconfirm -R -c git
pacman --noprogressbar --noconfirm -R -c perl
pacman --noprogressbar --noconfirm -R -c python2
pacman --noprogressbar --noconfirm -R -c gcc
pacman --noprogressbar --noconfirm -R -c binutils
pacman --noprogressbar --noconfirm -R -c zip
pacman --noprogressbar --noconfirm -R -c yasm
pacman --noprogressbar --noconfirm -R -c vim
pacman --noprogressbar --noconfirm -R -c subversion
pacman --noprogressbar --noconfirm -R -c make
pacman --noprogressbar --noconfirm -R -c winpty
pacman --noprogressbar --noconfirm -R -c nano

pacman -R -c apr
pacman -R -c autoconf
pacman -R -c autoconf-archive
pacman -R -c autogen
pacman -R -c bash-completion
pacman -R -c bison
pacman -R -c bsdcpio
pacman -R -c bsdtar
pacman -R -c catgets
pacman -R -c crypt
pacman -R -c dash
pacman -R -c db
pacman -R -c diffstat
pacman -R -c diffutils
pacman -R -c docbook-xml
pacman -R -c docbook-xsl
pacman -R -c dos2unix
pacman -R -c expat
pacman -R -c file
pacman -R -c filesystem
pacman -R -c flex
pacman -R -c gawk
pacman -R -c gdbm
pacman -R -c gettext-devel
pacman -R -c glib2


pacman -R -c gperf
pacman -R -c grep

pacman -R -c heimdal

pacman -R -c inetutils
pacman -R -c isl
pacman -R -c libarchive

pacman -R -c libassuan

pacman -R -c libcatgets
pacman -R -c libcrypt-devel

pacman -R -c libgc
pacman -R -c libgcrypt
pacman -R -c libgdbm


pacman -R -c libgpg-error

pacman -R -c libgpgme
pacman -R -c libguile
pacman -R -c libiconv-devel

pacman -R -c libltdl


pacman -R -c liblzo2

pacman -R -c libnettle

pacman -R -c libpcre16
pacman -R -c libpcre32

pacman -R -c libpcrecpp
pacman -R -c libpcreposix
pacman -R -c libpipeline
pacman -R -c libsasl
pacman -R -c libserf

pacman -R -c libtool
pacman -R -c libunistring
pacman -R -c libutil-linux



pacman -R -c libxml2-python

pacman -R -c libxslt
pacman -R -c lndir
pacman -R -c m4
pacman -R -c mintty
pacman -R -c mpc
pacman -R -c mpfr

pacman -R -c msys2-launcher-git

pacman -R -c msys2-runtime-devel
pacman -R -c msys2-w32api-headers
pacman -R -c msys2-w32api-runtime
pacman -R -c nano
pacman -R -c nasm
pacman -R -c openssh
pacman -R -c pactoys-git
pacman -R -c patch
pacman -R -c pax-git
pacman -R -c pcre
pacman -R -c perl-Net-SSLeay
pacman -R -c pkg-config
pacman -R -c pkgfile

pacman -R -c rarian
pacman -R -c rcs
pacman -R -c re2c
pacman -R -c rebase
pacman -R -c swig
pacman -R -c tar
pacman -R -c tftp-hpa
pacman -R -c time
pacman -R -c ttyrec
pacman -R -c tzcode
pacman -R -c unrar
pacman -R -c util-linux
pacman -R -c util-macros
pacman -R -c wget
pacman -R -c windows-default-manifest
pacman -R -c winpty
pacman -R -c yelp-xsl



pacman --noprogressbar --noconfirm -S  toolchain