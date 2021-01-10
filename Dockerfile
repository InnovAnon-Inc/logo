FROM innovanon/builder as builder
WORKDIR /src/
COPY ./ ./
ARG GPG_KEY

 #&& echo -e "$GPG_KEY" | gpg --import \
RUN apt update \
 && apt full-upgrade \
 && apt install bc imagemagick caca-utils  zpaq lrzip makeself shellcheck git ca-certificates \
 && sed -i 's#^\( *<policy domain="resource" name="disk" value="\).*\("/>\)$#\110GiB\1#'  /etc/ImageMagick-6/policy.xml \
 && sed -i 's#^\( *<policy domain="resource" name="memory" value="\).*\("/>\)$#\11GiB\1#' /etc/ImageMagick-6/policy.xml \
 && make -j$(nproc)
#RUN ./dist.sh

FROM innovanon/builder as signer
WORKDIR /tmp/logo
COPY --from=builder /src/out/* /tmp/logo/
ARG GPG_KEY
#RUN echo -e "$GPG_KEY" | gpg --import \
      #gpg --local-user 53F31F9711F06089\! --sign $k || exit 2 ; \
RUN for k in * ; do \
      gpg --sign $k || exit 2 ; \
    done \
 && cd /tmp && tar acf /tmp/logo.txz logo

FROM scratch
COPY --from=signer /tmp/logo.txz /tmp/

