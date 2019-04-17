#!/usr/bin/env bash
set -e
set -o pipefail

# prefer english command output
export LC_ALL="C"

# script for https://wiki.winehq.org/Building_Wine#Shared_WoW64

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

DIR64=${DIR}/64
cd ${DIR64}
sudo make uninstall
make clean

DIR32=${DIR}/32
cd ${DIR32}
sudo make uninstall
make clean