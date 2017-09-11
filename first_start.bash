#!/bin/bash

readonly TOP_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Author: Holger Nahrstaedt <holger@nahrstaedt>

# Configure
cd "$(dirname "$0")"
source $TOP_DIR/rebuild-library.sh
#rm -rf artifacts_old
mkdir artifacts_old
mkdir artifacts


# Detect
#list_commits  || failure 'Could not detect added commits'
#list_packages || failure 'Could not detect changed files'


pacman --noprogressbar --noconfirm -R $(pacman -Qq | grep -vxe "$(cat $TOP_DIR/pkg_list_base.txt)")
pacman -Syu --noprogressbar --noconfirm 
pacman -S --noprogressbar --noconfirm git

pacman -S --noprogressbar --noconfirm base-devel

git_config user.email 'ci@msys2.org'
git_config user.name  'MSYS2 Continuous Integration'
#git remote add upstream 'https://github.com/Alexpux/MINGW-packages'
#git fetch --quiet upstream