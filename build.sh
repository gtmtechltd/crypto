#!/bin/bash

set -x -e -o pipefail

gem uninstall gtmtech-crypto --executables
RAKE_OUT=$(rake build)
echo "${RAKE_OUT}"

VERSION=$(echo "${RAKE_OUT}" | awk '{print $2}')
echo "Installing version: ${VERSION} ..."

gem install pkg/gtmtech-crypto-${VERSION}.gem
crypto version
