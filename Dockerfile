FROM alpine as builder

RUN apk add --no-cache --virtual wxwidgets-build-dependencies \
    git \
    build-base \
    cmake \
    python3-dev \
    gtk+3.0-dev \
    tiff-dev \
    libnotify-dev \
    gstreamer-dev \
    libmspack-dev \
    sdl-dev \
    libsm-dev \
    glew-dev

RUN git clone --depth 1 --branch v3.0.3.1 https://gitlab.com/kicad/code/wxWidgets.git /wxwidgets

WORKDIR /wxwidgets

# https://docs.kicad-pcb.org/doxygen/md_Documentation_development_compiling.html#build_linux
RUN ./configure \
    --disable-shared \
    --disable-precomp-headers \
    --enable-monolithic \
    --prefix=/opt/wxwidgets/ \
    --with-opengl \
    --with-themes \
    --with-gtk \
    --enable-all-features
RUN make
RUN make install

FROM alpine

COPY --from=builder /opt/wxwidgets/ /opt/wxwidgets/

ENV PATH $PATH:/opt/wxwidgets/bin/

RUN apk add --no-cache --virtual wxwidgets-runtime-dependencies \
    gtk+3.0

