#!/bin/bash
CROSSTOOL=/opt/gcc-linaro-4.9-2014.11-x86_64_aarch64-linux-gnu
PATH=${CROSSTOOL}/bin/:$PATH

function config {
    ./configure \
        --target=aarch64-linux-gnu \
        -Dusethreads -Duse64bitall \
        -Doptimize=-O2 \
        --all-static \
        --no-dynaloader
}

function build {
    make -j7
}

function install {
    mkdir -p ./out
    make DESTDIR=./out install
}

function main {
    if [ "$1" == "all" ]; then
        config
        build
        install
    elif [ "$1" == "config" ]; then
        config
    elif [ "$1" == "build" ]; then
        build
    elif [ "$1" == "install" ]; then
        install
    else
        echo "build.sh [all | toolchain | config | build | install]"
    fi
}

main $*
