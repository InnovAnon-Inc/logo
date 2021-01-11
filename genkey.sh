#! /usr/bin/env bash
set -euvxo pipefail
cd
rm -rf .gnupg
mkdir -m 0700 .gnupg
touch .gnupg/gpg.conf
chmod 600 .gnupg/gpg.conf
#tail -n +4 /usr/share/gnupg2/gpg-conf.skel > .gnupg/gpg.conf

cd .gnupg
# I removed this line since these are created if a list key is done.
# touch .gnupg/{pub,sec}ring.gpg
gpg --list-keys


cat >keydetails <<EOF
    %echo Generating a basic OpenPGP key
    Key-Type: RSA
    Key-Length: 2048
    Subkey-Type: RSA
    Subkey-Length: 2048
    Subkey-Usage: sign, encrypt
    Name-Real: User 1
    Name-Comment: User 1
    Name-Email: user@1.com
    Expire-Date: 0
    %no-ask-passphrase
    %no-protection
    %pubring pubring.kbx
    %secring trustdb.gpg
    # Do a commit here, so that we can later print "done" :-)
    %commit
    %echo done
EOF

gpg --verbose --batch --gen-key keydetails

#SIGGY="$(gpg --quiet --list-keys   |
#         grep -A1 'pub[[:space:]]' |
#         awk '!(NR%2)')"

# Set trust to 5 for the key so we can encrypt without prompt.
#echo -e "5\ny\n" |  gpg --command-fd 0 --expert --edit-key "$SIGGY" trust;
echo -e "5\ny\n" |  gpg --command-fd 0 --expert --batch --edit-key user@1.com trust;

# Test that the key was created and the permission the trust was set.
gpg --list-keys

# Test the key can encrypt and decrypt.
#gpg -e -a -r "$SIGGY" keydetails
gpg -e -a -r user@1.com keydetails
#gpg -e -a keydetails

# Delete the options and decrypt the original to stdout.
rm keydetails
gpg -d keydetails.asc
rm keydetails.asc

