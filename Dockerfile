FROM innovanon/logo-builder as builder
WORKDIR /src/
COPY ./ ./
#ARG GPG_KEY
 #&& echo -e "$GPG_KEY" | gpg --import \
RUN sleep 31 \
 && make "-j$(nproc)"

RUN find /src/out

FROM innovanon/builder as signer
WORKDIR        /tmp/logo
COPY --from=builder /src/out/* ./

RUN find .

COPY ./sign.sh /tmp/
ARG GPG_KEY
RUN sleep 31                \
 && echo -e "$GPG_KEY"      \
  | gpg --import            \
 &&            /tmp/sign.sh \
 && rm -v      /tmp/sign.sh \
 && cd         /tmp         \
 && tar acf    /tmp/logo{.txz,}

FROM scratch as final
COPY --from=signer /tmp/logo.txz /tmp/

# TODO separate dockerfile
FROM innovanon/logo-builder as test
COPY --from=signer /tmp/logo/archive.tar /tmp/
RUN sleep 31 \
 && /tmp/archive.tar

FROM final
