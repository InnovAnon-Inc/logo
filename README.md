# logo
Download artwork and use it to generate InnovAnon, Inc. (Ministries) branding

## Specifications
  - background: Kali Yantra,    for credits see  kali.url
  - foreground: Shiva Tandavam, for credits see shiva.url
  - steganographic executable

## Usage
  - normal usage: build all variants
    ```bash
    make [-j`nproc`] [-e QUALITY=30]
    ```
  - stego usage              (archive.tar             ==> logo-stego-animated.gif):
    ```bash
    [RECP=InnovAnon-Inc@protonmail.com] make [-j`nproc`] stego
    ```
  - extract steganologo data (logo-stego-animated.gif ==> archive.tar):
    ```bash
    make test
    ```
  - steganologo-quine:
    steganographically embedded, cryptographically signed, highly compressed self-extracting archive that rebuilds itself.
    ```bash
    [LOL=1] make release
    ```

## Issues
increase resource limits in /etc/ImageMagick-6/policy.xml:
  ```html
  <policy domain="resource" name="memory" value="4GiB"/>
  <policy domain="resource" name="disk"   value="10GiB"/>
  ```

[reference](http://www.newbienote.com/2019/07/imagemagick-memory-issue-convert-cache.html)
[reference](https://p-s.co.nz/wordpress/imagemagick-cache-resources-exhausted-resolved/)
----------

[![CircleCI](https://img.shields.io/circleci/build/github/InnovAnon-Inc/logo?color=%23FF1100&logo=InnovAnon%2C%20Inc.&logoColor=%23FF1133&style=plastic)](https://circleci.com/gh/InnovAnon-Inc/logo)
[![Repo Size](https://img.shields.io/github/repo-size/InnovAnon-Inc/logo?color=%23FF1100&logo=InnovAnon%2C%20Inc.&logoColor=%23FF1133&style=plastic)](https://github.com/InnovAnon-Inc/logo)
[![LoC](https://tokei.rs/b1/github/InnovAnon-Inc/logo?category=code)](https://github.com/InnovAnon-Inc/logo)
[![CodeFactor](https://www.codefactor.io/repository/github/InnovAnon-Inc/logo/badge)](https://www.codefactor.io/repository/github/InnovAnon-Inc/logo)

[![Latest Release](https://img.shields.io/github/commits-since/InnovAnon-Inc/logo/latest?color=%23FF1100&include_prereleases&logo=InnovAnon%2C%20Inc.&logoColor=%23FF1133&style=plastic)](https://github.com/InnovAnon-Inc/logo/releases/latest)
![Dependencies](https://img.shields.io/librariesio/github/InnovAnon-Inc/logo?color=%23FF1100&style=plastic)

[![License Summary](https://img.shields.io/github/license/InnovAnon-Inc/logo?color=%23FF1100&label=Free%20Code%20for%20a%20Free%20World%21&logo=InnovAnon%2C%20Inc.&logoColor=%23FF1133&style=plastic)](https://tldrlegal.com/license/unlicense#summary)

## Credits
  ```bash
  cat *.url
  ```

![Corporate Logo](https://innovanon-inc.github.io/assets/images/logo.gif)

