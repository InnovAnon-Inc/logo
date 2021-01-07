#! /bin/bash
set -euxo pipefail
make -j$(nproc) distclean
make -j$(nproc) stego
make -j$(nproc) test

