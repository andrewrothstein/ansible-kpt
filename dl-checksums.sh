#!/usr/bin/env sh
set -e
DIR=~/Downloads
MIRROR=https://github.com/GoogleContainerTools/kpt/releases/download

# https://github.com/GoogleContainerTools/kpt/releases/download/v1.0.0-beta.9/checksums.txt
# https://github.com/GoogleContainerTools/kpt/releases/download/v1.0.0-beta.9/kpt_linux_amd64-1.0.0-beta.9.tar.gz

dl() {
    local ver=$1
    local lchecksums=$2
    local os=$3
    local arch=$4
    local archive_type=${5:-tar.gz}
    local platform="${os}_${arch}"
    local file="kpt_${platform}-${ver}.${archive_type}"
    local url=$MIRROR/v$ver/$file
    printf "    # %s\n" $url
    printf "    %s: sha256:%s\n" $platform $(grep $file $lchecksums | awk '{print $1}')
}

dl_ver() {
    local ver=$1
    local checksums="kpt_${ver}_checksums.txt"
    local url=$MIRROR/v$ver/checksums.txt
    local lchecksums=$DIR/$checksums
    if [ ! -e $lchecksums ];
    then
        curl -sSLf -o $lchecksums $url
    fi

    printf "  # %s\n" $url
    printf "  '%s':\n" $ver

    dl $ver $lchecksums linux amd64
    dl $ver $lchecksums linux arm64
    dl $ver $lchecksums darwin amd64
}

dl_ver ${1:-1.0.0-beta.54}
