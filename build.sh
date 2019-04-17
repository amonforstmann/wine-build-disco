#!/usr/bin/env bash

# script for https://wiki.winehq.org/Building_Wine#Shared_WoW64

# exit on errors
set -e
set -o pipefail

# configuration
NUMTHREADS=8
OPTIONS="" # --enable-vulkan --enable-vkd3d"

WINEREPO="git://source.winehq.org/git/wine.git"
WINESTAGINGREPO="git@github.com:wine-staging/wine-staging.git"
WINETRICKSREPO="git@github.com:Winetricks/winetricks.git"

# prefer english command output
export LC_ALL="C"

# prepare ubuntu
sudo apt install -y \
    gcc-multilib \
    ccache \
    \
    libxcursor-dev \
    libxcursor-dev:i386 \
    libxi-dev \
    libxi-dev:i386 \
    libxrandr-dev \
    libxrandr-dev:i386 \
    libxinerama-dev \
    libxinerama-dev:i386 \
    libxcomposite-dev \
    libxcomposite-dev:i386 \
    libglu1-mesa-dev \
    libglu1-mesa-dev:i386 \
    libosmesa6-dev \
    libosmesa6-dev:i386 \
    ocl-icd-opencl-dev \
    ocl-icd-opencl-dev:i386 \
    libpcap-dev \
    libpcap-dev:i386 \
    libdbus-1-dev \
    libdbus-1-dev:i386 \
    libgnutls28-dev \
    libgnutls28-dev:i386 \
    libncursesw5-dev \
    libncursesw5-dev:i386 \
    libpulse-dev \
    libpulse-dev:i386 \
    libudev-dev \
    libudev-dev:i386 \
    libsdl2-dev \
    libfontconfig1-dev \
    libfontconfig1-dev:i386 \
    libldap2-dev \
    libldap2-dev:i386 \
    libfreetype6-dev \
    libfreetype6-dev:i386 \
    libvkd3d-dev \
    libvkd3d-dev:i386 \
    libvulkan-dev \
    libvulkan-dev:i386 \
    libopenal-dev \
    libopenal-dev:i386 \
    libmpg123-dev \
    libmpg123-dev:i386 \
    libcups2-dev \
    libcups2-dev:i386 \
    libcapi20-dev \
    libcapi20-dev:i386 \
    libxslt1-dev \
    libxslt1-dev:i386 \
    libsane-dev \
    libsane-dev:i386 \
    libgphoto2-dev \
    libgphoto2-dev:i386 \
    libv4l-dev \
    libv4l-dev:i386 \
    libgsm1-dev \
    libgsm1-dev:i386 \
    libkrb5-dev \
    libkrb5-dev:i386 \
    libgstreamer1.0-dev \
    libgstreamer1.0-dev:i386 \
    libgstreamer-plugins-base1.0-dev \
    libgstreamer-plugins-base1.0-dev:i386 \
    libgssglue-dev

# enable ccache
export PATH="/usr/lib/ccache:$PATH"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# get fresh wine sources
SRCDIR=${DIR}/source
git -C ${SRCDIR} pull || git clone ${WINEREPO} ${SRCDIR}
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