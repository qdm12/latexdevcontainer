ARG ALPINE_VERSION=3.12

FROM alpine:${ALPINE_VERSION} AS chktex
WORKDIR /tmp/workdir
RUN apk add -q --update --progress --no-cache g++ make
RUN wget -q -O chktex.tar.gz http://download.savannah.gnu.org/releases/chktex/chktex-1.7.6.tar.gz && \
    tar -xf chktex.tar.gz --strip-components=1 && \
    rm chktex.tar.gz
RUN ./configure && \
    make && \
    mv chktex /tmp && \
    rm -r *

FROM qmcgaw/basedevcontainer:alpine
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION=local
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=1000
LABEL \
    org.opencontainers.image.authors="quentin.mcgaw@gmail.com" \
    org.opencontainers.image.created=$BUILD_DATE \
    org.opencontainers.image.version=$VERSION \
    org.opencontainers.image.revision=$VCS_REF \
    org.opencontainers.image.url="https://github.com/qdm12/latexdevcontainer" \
    org.opencontainers.image.documentation="https://github.com/qdm12/latexdevcontainer" \
    org.opencontainers.image.source="https://github.com/qdm12/latexdevcontainer" \
    org.opencontainers.image.title="Latex Dev container Alpine" \
    org.opencontainers.image.description="Latex development container for Visual Studio Code Remote Containers development"
USER root
WORKDIR /tmp/texlive
RUN apk add -q --update --progress --no-cache perl wget gnupg
ARG SCHEME=scheme-basic
ARG DOCFILES=0
ARG SRCFILES=0
RUN wget -q -O texlive.tar.gz http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz && \
    tar -xf texlive.tar.gz --strip-components=1 && \
    export TEXLIVE_INSTALL_NO_CONTEXT_CACHE=1 && \
    export TEXLIVE_INSTALL_NO_WELCOME=1 && \
    printf "selected_scheme ${SCHEME}\ninstopt_letter 0\ntlpdbopt_autobackup 0\ntlpdbopt_desktop_integration 0\ntlpdbopt_file_assocs 0\ntlpdbopt_install_docfiles ${DOCFILES}\ntlpdbopt_install_srcfiles ${SRCFILES}" > profile.txt && \
    ./install-tl -profile profile.txt && \
    cd && \
    rm -r /tmp/texlive && \
    chown -R ${USER_UID}:${USER_GID} /usr/local/texlive
ENV PATH="${PATH}:/usr/local/texlive/2020/bin/x86_64-linuxmusl"
WORKDIR /workspace
RUN apk add -q --update --progress --no-cache --virtual deps perl-app-cpanminus perl-dev build-base && \
    cpanm -n -q Log::Log4perl && \
    cpanm -n -q Log::Dispatch::File && \
    cpanm -n -q YAML::Tiny && \
    cpanm -n -q File::HomeDir && \
    cpanm -n -q Unicode::GCString && \
    apk del deps
USER ${USERNAME}
RUN tlmgr install latexindent latexmk && \
    texhash
COPY --from=chktex --chown=${USER_UID}:${USER_GID} /tmp/chktex /usr/local/bin/chktex
COPY --chown=${USER_UID}:${USER_GID} shell/.zshrc-specific shell/.welcome.sh /home/${USERNAME}/
COPY shell/.zshrc-specific shell/.welcome.sh /root/
USER ${USERNAME}
