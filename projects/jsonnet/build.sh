#!/bin/bash -eu
# Copyright 2018 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
################################################################################

mkdir jsonnet/build
pushd jsonnet/build
cmake -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=$WORK \
  -DBUILD_SHARED_LIBS=OFF -DOPENCV_GENERATE_PKGCONFIG=ON \
  -DOPENCV_GENERATE_PKGCONFIG=ON -DOPENCV_FORCE_3RDPARTY_BUILD=ON ..
make CC=clang CXX=clang++ -j$(nproc)
popd

INSTALL_DIR="$SRC/jsonnet"

for fuzzer in convert_jsonnet_fuzzer; do
  $CXX $CXXFLAGS -I${INSTALL_DIR}/include \
    -lFuzzingEngine $fuzzer.cc \
    -o $OUT/$fuzzer
done
