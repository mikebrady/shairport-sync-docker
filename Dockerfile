FROM alpine AS builder-base

RUN apk -U add \
        git \
        build-base \
        autoconf \
        automake \
        libtool \
        dbus \
        su-exec \
        alsa-lib-dev \
        libdaemon-dev \
        popt-dev \
        mbedtls-dev \
        soxr-dev \
        avahi-dev \
        libconfig-dev \
        libsndfile-dev \
        mosquitto-dev \
        xmltoman

FROM builder-base AS builder-alac

RUN 	git clone --recursive https://github.com/mikebrady/alac
WORKDIR alac
RUN 	autoreconf -fi
RUN 	./configure
RUN 	make
RUN 	make install

FROM 	builder-base AS builder-sps

COPY 	--from=builder-alac /usr/local/lib/libalac.* /usr/local/lib/
COPY 	--from=builder-alac /usr/local/lib/pkgconfig/alac.pc /usr/local/lib/pkgconfig/alac.pc
COPY 	--from=builder-alac /usr/local/include /usr/local/include

RUN 	git clone --recursive https://github.com/mikebrady/shairport-sync
WORKDIR shairport-sync
RUN 	git checkout development
RUN 	autoreconf -fi
RUN 	./configure \
              --with-alsa \
              --with-dummy \
              --with-pipe \
              --with-stdout \
              --with-avahi \
              --with-ssl=mbedtls \
              --with-soxr \
              --sysconfdir=/etc \
              --with-dbus-interface \
              --with-mpris-interface \
              --with-mqtt-client \
              --with-apple-alac \
              --with-convolution
RUN 	make -j $(nproc)
RUN 	make install

RUN 	addgroup shairport-sync 
RUN 	adduser -D shairport-sync -G shairport-sync

# Add the shairport-sync user to the pre-existing audio group, which has ID 29, for access to the ALSA stuff
RUN 	addgroup -g 29 docker_audio && addgroup shairport-sync docker_audio

COPY 	shairport-sync.conf /etc/shairport-sync.conf
COPY 	start.sh /start.sh

ENTRYPOINT [ "/start.sh" ]

