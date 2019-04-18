docker volume create wine-build-disco-ccache
docker build . -t wine-build-disco && docker run --rm -it --mount source=wine-build-disco-ccache,target=/var/tmp/ccache wine-build-disco 