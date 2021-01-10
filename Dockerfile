FROM innovanon/logo-builder as builder
WORKDIR /src/
COPY ./ ./
#ARG GPG_KEY
 #&& echo -e "$GPG_KEY" | gpg --import \
RUN make -j$(nproc)

FROM innovanon/builder as signer
WORKDIR /tmp/logo
COPY --from=builder /src/out/* /tmp/logo/
COPY ./sign.sh /tmp/
ARG GPG_KEY
RUN       /tmp/sign.sh \
 && rm -v /tmp/sign.sh \
 && cd      /tmp         \
 && tar acf /tmp/logo{.txz,}
# for k in * ; do \
#      gpg --sign $k || exit 2 ; \
#    done \

FROM scratch as final
COPY --from=signer /tmp/logo.txz /tmp/

FROM innovanon/logo-builder as test
COPY --from=signer /tmp/logo/archive.tar /tmp/
RUN /tmp/archive.tar

FROM final
