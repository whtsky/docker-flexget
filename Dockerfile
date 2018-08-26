FROM lsiobase/alpine.python:3.7

# Set python to use utf-8 rather than ascii.
ENV PYTHONIOENCODING="UTF-8"

# Add edge/testing repositories.
RUN printf "\
@edge http://nl.alpinelinux.org/alpine/edge/main\n\
@testing http://nl.alpinelinux.org/alpine/edge/testing\n\
" >> /etc/apk/repositories

# Copy local files.
COPY etc/ /etc
RUN chmod -v +x \
    /etc/cont-init.d/*  \
    /etc/services.d/*/run

# Install libtorrent-rasterbar, a dependency for both
# flexget plugin `convert_magnet`. as well as deluge.
RUN apk add --update --no-cache --virtual=build-dependencies \
    apk-tools

# Dependency for libtorrent-rasterbar.
RUN apk add --no-cache \
    boost-python@edge \
    boost-system@edge \
    libressl-dev@edge

# libtorrent-rasterbar contains the python bindings libtorrent.
RUN apk add --no-cache \
    libtorrent-rasterbar@testing

RUN pip install -U pip setuptools>=36 urllib3[socks] flexget

# Ports and volumes.
EXPOSE 5050/tcp
VOLUME /config
