#! /bin/bash
set -euvxo pipefail
(( ! $# ))
#(( UID ))
find .       \
  \! -type d |
xargs -I% -t \
  -P$(nproc) \
gpg --sign %

