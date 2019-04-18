FROM ubuntu:disco

RUN dpkg --add-architecture i386 && \
    apt update && \
    apt full-upgrade -y && \
    apt install -y apt-utils && \
    apt install -y \
        bash \
        git \
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
        libgssglue-dev && \
    apt-get clean

COPY . /usr/src
WORKDIR /usr/src
CMD ["bash", "scripts/build.sh"]

