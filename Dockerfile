ARG ALPINE_VERSION=3.12
ARG DEBIAN_VERSION=buster-slim

FROM debian:${DEBIAN_VERSION} AS chktex
ARG CHKTEX_VERSION=1.7.6
WORKDIR /tmp/workdir
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends g++ make wget
RUN wget -qO- http://download.savannah.gnu.org/releases/chktex/chktex-${CHKTEX_VERSION}.tar.gz | \
    tar -xz --strip-components=1
RUN ./configure && \
    make && \
    mv chktex /tmp && \
    rm -r *

FROM qmcgaw/basedevcontainer:debian
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
ARG SCHEME=scheme-basic
ARG DOCFILES=0
ARG SRCFILES=0
ARG TEXLIVE_VERSION=2020
ARG TEXLIVE_MIRROR=http://ctan.math.utah.edu/ctan/tex-archive/systems/texlive/tlnet
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends wget gnupg cpanminus && \
    wget -qO- ${TEXLIVE_MIRROR}/install-tl-unx.tar.gz | \
    tar -xz --strip-components=1 && \
    export TEXLIVE_INSTALL_NO_CONTEXT_CACHE=1 && \
    export TEXLIVE_INSTALL_NO_WELCOME=1 && \
    printf "selected_scheme ${SCHEME}\ninstopt_letter 0\ntlpdbopt_autobackup 0\ntlpdbopt_desktop_integration 0\ntlpdbopt_file_assocs 0\ntlpdbopt_install_docfiles ${DOCFILES}\ntlpdbopt_install_srcfiles ${SRCFILES}" > profile.txt && \
    perl install-tl -profile profile.txt --location ${TEXLIVE_MIRROR} && \
    chown -R ${USER_UID}:${USER_GID} /usr/local/texlive && \
    # Cleanup
    cd && \
    apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ /tmp/texlive /usr/local/texlive/${TEXLIVE_VERSION}/*.log
ENV PATH="${PATH}:/usr/local/texlive/${TEXLIVE_VERSION}/bin/x86_64-linux"
WORKDIR /workspace
# Latexindent dependencies
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends cpanminus make gcc libc6-dev && \
    cpanm -n -q Log::Log4perl && \
    cpanm -n -q XString && \
    cpanm -n -q Log::Dispatch::File && \
    cpanm -n -q YAML::Tiny && \
    cpanm -n -q File::HomeDir && \
    cpanm -n -q Unicode::GCString && \
    apt-get remove -y cpanminus make gcc libc6-dev && \
    apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/
RUN tlmgr install latexindent latexmk && \
    texhash && \
    rm /usr/local/texlive/${TEXLIVE_VERSION}/texmf-var/web2c/*.log && \
    chown ${USER_UID}:${USER_GID} /usr/local/texlive/${TEXLIVE_VERSION}/bin/x86_64-linux/latexindent && \
    chown ${USER_UID}:${USER_GID} /usr/local/texlive/${TEXLIVE_VERSION}/bin/x86_64-linux/latexmk
COPY --from=chktex --chown=${USER_UID}:${USER_GID} /tmp/chktex /usr/local/bin/chktex
COPY --chown=${USER_UID}:${USER_GID} shell/.zshrc-specific shell/.welcome.sh /home/${USERNAME}/
COPY shell/.zshrc-specific shell/.welcome.sh /root/
USER ${USERNAME}
# Verify binaries work and have the right permissions
RUN tlmgr version && \
    latexmk -version && \
    texhash --version && \
    chktex --version
