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
