#! /bin/bash
set -euvxo pipefail
(( ! $# ))
#(( UID ))
find . -0      \
  \! -type d   |
xargs -I% -t   \
  "-P$(nproc)" \
gpg --sign %

