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


# Detect
#list_commits  || failure 'Could not detect added commits'
#list_packages || failure 'Could not detect changed files'


pacman -R $(pacman -Qq | grep -ve "$(pacman -Qqg base)" -ve "$(pacman -Qqg base-devel)")


pacman --noprogressbar --noconfirm -S  toolchain


pacman -S --noprogressbar --noconfirm git

git_config user.email 'ci@msys2.org'
git_config user.name  'MSYS2 Continuous Integration'
#git remote add upstream 'https://github.com/Alexpux/MINGW-packages'
#git fetch --quiet upstream