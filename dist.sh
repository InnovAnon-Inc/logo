#! /bin/bash
set -euxo pipefail
#make -j$(nproc) distclean
#rm -vf archive.tar
#make -j$(nproc) stego
make -j$(nproc) test

