#! /usr/bin/env bash
set -euvxo pipefail
#(( UID ))
(( ! $# ))
# TODO comprehensive list of artifacts
cd out

#  precomposed-apple-touch-icon.png \
#  bio-photo.jpg \
#  apple-touch-icon.png \

err=0
for k in \
  android-chrome-144x144.png \
  android-chrome-192x192.png \
  android-chrome-256x256.png \
  android-chrome-36x36.png \
  android-chrome-384x384.png \
  android-chrome-48x48.png \
  android-chrome-72x72.png \
  android-chrome-96x96.png \
  apple-touch-icon-114x114.png \
  apple-touch-icon-120x120.png \
  apple-touch-icon-144x144.png \
  apple-touch-icon-152x152.png \
  apple-touch-icon-180x180.png \
  apple-touch-icon-57x57.png \
  apple-touch-icon-60x60.png \
  apple-touch-icon-72x72.png \
  apple-touch-icon-76x76.png \
  favicon-16x16.png \
  favicon-194x194.png \
  favicon-32x32.png \
  favicon.ico \
  mstile-144x144.png \
  mstile-150x150.png \
  mstile-310x150.png \
  mstile-310x310.png \
  mstile-70x70.png \
  safari-pinned-tab.svg \
  precomposed-apple-touch-icon-114x114.png \
  precomposed-apple-touch-icon-120x120.png \
  precomposed-apple-touch-icon-144x144.png \
  precomposed-apple-touch-icon-152x152.png \
  precomposed-apple-touch-icon-180x180.png \
  precomposed-apple-touch-icon-57x57.png \
  precomposed-apple-touch-icon-60x60.png \
  precomposed-apple-touch-icon-72x72.png \
  precomposed-apple-touch-icon-76x76.png
do
  [[ -f "$k" ]] ||
  err=$((err + 1))
done
(( ! err ))

