DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

mkdir -p ${DIR}/build
docker volume create wine-build-disco-ccache

docker build . -t wine-build-disco 

echo "Starting build..."
docker run -it \
    -v wine-build-disco-ccache:/var/tmp/ccache \
    -v ${DIR}/build:/usr/src/build \
wine-build-disco 