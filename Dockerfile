FROM innovanon/logo-builder as builder
COPY --from=innovanon/signer /etc/gnupg       /etc/gnupg
COPY --from=innovanon/signer /home/lfs/.gnupg /home/lfs/
COPY --from=innovanon/signer /app             /signer
COPY --chown=lfs ./ /src/
WORKDIR /src/
USER lfs
RUN sleep 91                            \
 && MODE=ed25519-cert /signer/genkey.sh \
 && MODE=ed25519-sign /signer/addkey.sh \
 && make "-j$(nproc)"                   \
 && rm -vrf "$HOME/.gnupg"              \
 &&     ./check.sh                      \
 && rm -v check.sh                      \
 && exec true || exec false

FROM innovanon/builder as signer
COPY --from=innovanon/signer /etc/gnupg       /etc/
COPY --from=innovanon/signer /home/lfs/.gnupg /home/lfs/
COPY --from=innovanon/signer /app             /signer
COPY --from=builder /src/out/* /tmp/logo
WORKDIR                        /tmp/logo
USER lfs
COPY ./sign.sh /tmp/
RUN sleep 91                        \
 && MODE=rsa-cert /signer/genkey.sh \
 && MODE=rsa-sign /signer/addkey.sh \
 &&            /tmp/sign.sh         \
 && rm -vrf "$HOME/.gnupg"          \
 && rm -v      /tmp/sign.sh         \
 && cd         /tmp                 \
 && tar  pacf    /tmp/logo{.txz,}     \
 && exec true || exec false

FROM scratch as final
COPY --from=signer /tmp/logo.txz /tmp/

# TODO separate dockerfile
FROM innovanon/logo-builder as test
COPY --from=signer /tmp/logo/archive.tar /tmp/
USER lfs
RUN sleep 91               \
 &&       /tmp/archive.tar \
 && rm -v /tmp/archive.tar \
 && exec true || exec false

FROM final
