#! /bin/bash
set -euvxo pipefail
(( ! $# ))
#(( UID ))
find .  \! -type d   -print0 |
xargs -I% -t "-P$(nproc)" -0 \
gpg --sign %

