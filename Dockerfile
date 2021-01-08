FROM innovanon/poobuntu-ci as builder
WORKDIR /src/
COPY ./ ./
ARG GPG_KEY

RUN apt-fast update
RUN apt-fast install bc imagemagick caca-utils stegosuite zpaq lrzip makeself
RUN echo -e "$GPG_KEY" | gpg --import
RUN sed -i 's#^\( *<policy domain="resource" name="disk" value="\).*\("/>\)$#\110GiB\1#'  /etc/ImageMagick-6/policy.xml
RUN sed -i 's#^\( *<policy domain="resource" name="memory" value="\).*\("/>\)$#\11GiB\1#' /etc/ImageMagick-6/policy.xml
RUN ./dist.sh

FROM innovanon/poobuntu-ci as signer
WORKDIR /logo/
COPY --from=builder /tmp/logo.txz /tmp/
ARG GPG_KEY
RUN echo -e "$GPG_KEY" | gpg --import
RUN tar xvf /tmp/logo.txz
RUN rm -f   /tmp/logo.txz
RUN for k in * ; do \
      gpg --local-user 53F31F9711F06089\! --sign $k || exit 2 ; \
    done
RUN cd / && tar acf /tmp/logo.txz logo

FROM scratch
COPY --from=signer /tmp/logo.txz /tmp/

