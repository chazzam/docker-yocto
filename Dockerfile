FROM ubuntu:bionic

ARG IMAGE=chazzam/yocto:bionic
ARG VCS_URL=https://github.com/chazzam/docker-yocto

ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 LANGUAGE=en_US.UTF-8 \
    LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH" \
    GOSU_VERSION=1.10 \
    DEFAULT_DOCKCROSS_IMAGE=$IMAGE

RUN true \
 && apt-get update \
 && LANG=C.UTF-8 LC_ALL=C.UTF-8 LANGUAGE=C.UTF-8 \
    apt-get install -y --no-install-recommends \
        locales \
        software-properties-common \
 && locale-gen en_US en_US.UTF-8 \
 && update-locale LANG=$LANG LC_ALL=$LANG \
 && apt-get install -y --no-install-recommends \
    libboost-dev \
    build-essential \
    ca-certificates \
    chrpath \
    cmake \
    coreutils \
    curl \
    cpio \
    diffstat \
    file \
    gawk \
    gcc-multilib \
    git \
    gnupg \
    libx11-dev \
    make \
    procps \
    python2.7 \
    python3 \
    python3-bsddb3 \
    python3-git \
    python3-pexpect \
    python3-pip \
    #socat \#yocto
    sqlite3 \
    subversion \
    texinfo \
    uncrustify \
    unzip \
    wget \
    #xterm \#yocto
 && (cd /tmp; git clone https://github.com/dockcross/dockcross.git) \
 && wget -qO /tmp/dockcross/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64" \
 && wget -qO /tmp/dockcross/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64.asc" \
 && mkdir -p /dockcross \
 && cp -ap \
        /tmp/dockcross/imagefiles/entrypoint.sh \
        /tmp/dockcross/imagefiles/dockcross \
      /dockcross/ \
# && sed -i -e "s#DEFAULT_DOCKCROSS_IMAGE=dockcross/base#DEFAULT_DOCKCROSS_IMAGE=$IMAGE#" /dockcross/dockcross \
 && cp -ap /tmp/dockcross/imagefiles/cmake.sh /usr/local/bin/cmake \
 && cp -ap /tmp/dockcross/imagefiles/ccmake.sh /usr/local/bin/ccmake \
 && echo "#!/bin/sh" > /usr/bin/sudo \
 && echo 'exec gosu root:root "\$@"' >> /usr/bin/sudo \
 && chmod +x /usr/bin/sudo \
 && echo "root:root"|chpasswd \
 && cp /tmp/dockcross/gosu /usr/local/bin \
 && chmod +x /usr/local/bin/gosu \
 && gosu nobody true \
 && ln -s /usr/bin/env /bin/env \
 && echo "dash dash/sh boolean false" | debconf-set-selections \
 && dpkg-reconfigure -p critical dash \
 && apt-get autoremove -y \
 && apt-get clean -y && apt-get autoclean -y \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /work

ENTRYPOINT ["/dockcross/entrypoint.sh"]

LABEL org.label-schema.name=$IMAGE \
      org.label-schema.build-date=$BUILD_DATE \ 
      org.label-schema.vcs-url=$VCS_URL \
      org.label-schema.schema-version="1.0"

