#!/usr/bin/env bash

# script for https://wiki.winehq.org/Building_Wine#Shared_WoW64

# exit on errors
set -e
set -o pipefail

# configuration
NUMTHREADS=8
OPTIONS="" # --enable-vulkan --enable-vkd3d"

WINEREPO="https://source.winehq.org/git/wine.git/"
WINESTAGINGREPO="https://github.com/wine-staging/wine-staging.git"
WINETRICKSREPO="https://github.com/Winetricks/winetricks.git"

# prefer english command output
export LC_ALL="C"

# enable ccache
export PATH="/usr/lib/ccache:$PATH"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"/../build

# get fresh wine sources
SRCDIR=${DIR}/source
git -C ${SRCDIR} pull || git clone --verbose ${WINEREPO} ${SRCDIR}
cd ${SRCDIR}

# get wine-staging
DIRSTAGING=${DIR}/staging
git -C ${DIRSTAGING} pull || git clone ${WINESTAGINGREPO} ${DIRSTAGING}
cd ${DIRSTAGING}/patches
./patchinstall.sh DESTDIR=${SRCDIR} --all

# build 64 bit wine
DIR64=${DIR}/64
mkdir -p ${DIR64}
OPTIONS64="--enable-win64 ${OPTIONS}"
cd ${DIR64}
${SRCDIR}/configure ${OPTIONS64} && make -j${NUMTHREADS} -l${NUMTHREADS}

# build 32 bit libs for wine 64
DIR32=${DIR}/32
mkdir -p ${DIR64}
OPTIONS64="${OPTIONS} --with-wine64="${DIR64}
cd ${DIR32}
PKG_CONFIG_PATH=/usr/lib/i386-linux-gnu/pkgconfig ${SRCDIR}/configure ${OPTIONS32} && make -j${NUMTHREADS} -l${NUMTHREADS}


# install wine 32 bit first
cd ${DIR32}
sudo make install

# install wine 64 bit
cd ${DIR64}
sudo make install


# get fresh winetricks sources
WTDIR=${DIR}/winetricks
git -C ${WTDIR} pull || git clone ${WINEREPO} ${WTDIR}
cd ${WTDIR}
sudo cp src/winetricks /usr/local/bin/winetricks
sudo chmod a+x /usr/local/bin/winetricks