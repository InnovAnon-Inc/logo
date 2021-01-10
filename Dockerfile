FROM innovanon/builder as builder
WORKDIR /src/
COPY ./ ./
ARG GPG_KEY

RUN apt update
RUN apt install bc imagemagick caca-utils  zpaq lrzip makeself shellcheck
RUN echo -e "$GPG_KEY" | gpg --import
RUN sed -i 's#^\( *<policy domain="resource" name="disk" value="\).*\("/>\)$#\110GiB\1#'  /etc/ImageMagick-6/policy.xml
RUN sed -i 's#^\( *<policy domain="resource" name="memory" value="\).*\("/>\)$#\11GiB\1#' /etc/ImageMagick-6/policy.xml
#RUN ./dist.sh
RUN make -j$(nproc)

FROM innovanon/builder as signer
WORKDIR /tmp/logo
COPY --from=builder /src/out/* /tmp/logo/
ARG GPG_KEY
RUN echo -e "$GPG_KEY" | gpg --import
RUN for k in * ; do \
      gpg --local-user 53F31F9711F06089\! --sign $k || exit 2 ; \
    done
RUN cd /tmp && tar acf /tmp/logo.txz logo

FROM scratch
COPY --from=signer /tmp/logo.txz /tmp/

