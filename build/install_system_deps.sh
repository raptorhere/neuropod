#!/bin/bash
set -e

# Default to python 2 if not set
NEUROPOD_PYTHON_BINARY="${NEUROPOD_PYTHON_BINARY:-python}"

if [[ $(uname -s) == 'Darwin' ]]; then
    # Install bazel
    tmpdir=$(mktemp -d)
    pushd $tmpdir
    curl -sSL -o bazel.sh https://github.com/bazelbuild/bazel/releases/download/0.28.1/bazel-0.28.1-installer-darwin-x86_64.sh
    chmod +x ./bazel.sh
    ./bazel.sh
    popd
    rm -rf $tmpdir

    # Install libomp
    export HOMEBREW_NO_AUTO_UPDATE=1
    brew install libomp
else
    # Install bazel deps, pip, and python dev
    # Install g++-4.8 for TensorFlow custom op builds
    sudo apt-get update
    sudo apt-get install -y pkg-config zip g++ zlib1g-dev unzip python3 curl wget ${NEUROPOD_PYTHON_BINARY}-dev ${NEUROPOD_PYTHON_BINARY}-pip g++-4.8

    # Install bazel
    tmpdir=$(mktemp -d)
    pushd $tmpdir
    curl -sSL -o bazel.sh https://github.com/bazelbuild/bazel/releases/download/0.28.1/bazel-0.28.1-installer-linux-x86_64.sh
    chmod +x ./bazel.sh
    sudo ./bazel.sh
    popd
    rm -rf $tmpdir
fi

# Run a bazel command to extract the bazel installation
bazel version
