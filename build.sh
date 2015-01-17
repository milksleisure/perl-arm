#!/bin/bash
ANDROID_NDK=/opt/android-ndk
ARCH=arm-linux-androideabi
TOOLCHAIN=/tmp/standalone-$ARCH
SYSROOT=$TOOLCHAIN/sysroot
TARGET=/data/local/tmp/perl
PATH=$ANDROID_NDK/toolchains/$ARCH-4.8/prebuilt/linux-x86_64/bin:$PATH

function toolchain {
    $ANDROID_NDK/build/tools/make-standalone-toolchain.sh \
        --platform=android-9 \
        --install-dir=$TOOLCHAIN \
        --system=linux-x86_64 \
        --toolchain=$ARCH-4.8
}

function config {
    ./Configure \
        -des \
        -Dusedevel \
        -Dusecrosscompile \
        -Dtargetrun=adb \
        -Dcc=arm-linux-androideabi-gcc \
        -Dsysroot=$SYSROOT \
        -Dtargetdir=$TARGET \
        -Dtargethost=$DEVICE
}

function build {
    make -j7
}

function test_install {
    make test
}

function install {
    make install
}

function main {
    if [ "$1" == "all" ]; then
        toolchain
    elif [ "$1" == "toolchain" ]; then
        toolchain
    elif [ "$1" == "config" ]; then
        config
    elif [ "$1" == "build" ]; then
        build
    elif [ "$1" == "test_install" ]; then
        test_install
    else
        echo "build.sh [all | toolchain | config | build | test_install]"
    fi
}

main $*
