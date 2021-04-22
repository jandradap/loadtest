FROM node:lts-alpine3.13

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
			org.label-schema.name="ocp-utils" \
			org.label-schema.description="Generates table of contents for markdown files inside local git repository." \
			org.label-schema.url="http://andradaprieto.es" \
			org.label-schema.vcs-ref=$VCS_REF \
			org.label-schema.vcs-url="https://github.com/jandradap/ocp-utils" \
			org.label-schema.vendor="Jorge Andrada Prieto" \
			org.label-schema.version=$VERSION \
			org.label-schema.schema-version="1.0" \
			maintainer="Jorge Andrada Prieto <jandradap@gmail.com>"

# BASE
RUN apk --update --clean-protected --no-cache add \
  drill \
  htop \
  bind-tools \
  wget \
  curl \
  nmap \
  vim \
  openssl \
  bash \
  jq \
  iputils \
  busybox-extras \
  nfs-utils \
  zip \
  p7zip \
  unzip \
  rsync \
  strace \
  tree \
  apache2-utils \
  git \
  tar \
  gzip \
  curl \
  ca-certificates \
  gettext \
  openssh-client \
  && rm -rf /var/cache/apk/*

# loadtest
RUN npm install -g loadtest

# Vegeta
RUN VERSIONVEGETA=$(curl --silent "https://api.github.com/repos/tsenart/vegeta/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/') \
  && cd /tmp && wget https://github.com/tsenart/vegeta/releases/download/${VERSIONVEGETA}/vegeta_$(echo ${VERSIONVEGETA} | sed "s/v//")_linux_amd64.tar.gz \
  && tar -xvf vegeta_$(echo ${VERSIONVEGETA} | sed "s/v//")_linux_amd64.tar.gz \
  && mv vegeta /usr/local/bin \
  && chmod +x /usr/local/bin/vegeta \
  && rm -rf vegeta_$(echo ${VERSIONVEGETA} | sed "s/v//")_linux_amd64.tar.gz

ADD assets/*.sh /bin/

RUN chmod +x /bin/*.sh

USER 1001

ENTRYPOINT ["/bin/entrypoint.sh"]
