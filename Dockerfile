#############################################################
#     Dockerfile to create CentOS 7 image with FFMPEG
#############################################################

FROM centos

MAINTAINER "supermasita"

ENV USRLOCAL /usr/local


RUN yum install -y epel-release

RUN yum -y install autoconf automake cmake freetype-devel gcc gcc-c++ git libtool make mercurial nasm pkgconfig zlib-devel tar which opus-devel

RUN mkdir /usr/local/src/ffmpeg_sources

RUN cd /usr/local/src/ffmpeg_sources && git clone --depth 1 git://github.com/yasm/yasm.git && cd yasm && autoreconf -fiv && ./configure --prefix="$USRLOCAL/ffmpeg_build" --bindir="$USRLOCAL/bin" && make && make install && make distclean

RUN cd /usr/local/src/ffmpeg_sources && git clone --depth 1 git://git.videolan.org/x264 && cd x264 && PKG_CONFIG_PATH="$USRLOCAL/ffmpeg_build/lib/pkgconfig" ./configure --prefix="$USRLOCAL/ffmpeg_build" --bindir="$USRLOCAL/bin" --enable-static && make && make install && make distclean

RUN cd /usr/local/src/ffmpeg_sources && hg clone https://bitbucket.org/multicoreware/x265 && cd /usr/local/src/ffmpeg_sources/x265/build/linux && cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$USRLOCAL/ffmpeg_build" -DENABLE_SHARED:bool=off ../../source && make && make install

RUN cd /usr/local/src/ffmpeg_sources && git clone --depth 1 git://git.code.sf.net/p/opencore-amr/fdk-aac && cd fdk-aac && autoreconf -fiv && ./configure --prefix="$USRLOCAL/ffmpeg_build" --disable-shared && make && make install && make distclean

RUN cd /usr/local/src/ffmpeg_sources && curl -L -O http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz && tar xzvf lame-3.99.5.tar.gz && cd lame-3.99.5 && ./configure --prefix="$USRLOCAL/ffmpeg_build" --bindir="$USRLOCAL/bin" --disable-shared --enable-nasm && make && make install && make distclean

RUN cd /usr/local/src/ffmpeg_sources && git clone git://git.opus-codec.org/opus.git && cd opus && autoreconf -fiv && ./configure --prefix="$USRLOCAL/ffmpeg_build" --disable-shared && make && make install && make distclean

RUN cd /usr/local/src/ffmpeg_sources && curl -O http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.gz && tar xzvf libogg-1.3.2.tar.gz && cd libogg-1.3.2 && ./configure --prefix="$USRLOCAL/ffmpeg_build" --disable-shared && make && make install && make distclean

RUN cd /usr/local/src/ffmpeg_sources && curl -O http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.4.tar.gz && tar xzvf libvorbis-1.3.4.tar.gz && cd libvorbis-1.3.4 && LDFLAGS="-L$USRLOCAL/ffmeg_build/lib" CPPFLAGS="-I$USRLOCAL/ffmpeg_build/include" ./configure --prefix="$USRLOCAL/ffmpeg_build" --with-ogg="$USRLOCAL/ffmpeg_build" --disable-shared && make && make install && make distclean

RUN cd /usr/local/src/ffmpeg_sources && git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git && cd libvpx && ./configure --prefix="$USRLOCAL/ffmpeg_build" --disable-examples && make && make install && make clean


RUN cd /usr/local/src/ffmpeg_sources && git clone --depth 1 git://source.ffmpeg.org/ffmpeg && cd ffmpeg && PKG_CONFIG_PATH="$USRLOCAL/ffmpeg_build/lib/pkgconfig" ./configure --prefix="$USRLOCAL/ffmpeg_build" --extra-cflags="-I$USRLOCAL/ffmpeg_build/include" --extra-ldflags="-L$USRLOCAL/ffmpeg_build/lib" --bindir="$USRLOCAL/bin" --pkg-config-flags="--static" --enable-gpl --enable-nonfree --enable-libfdk-aac --enable-libfreetype --enable-libmp3lame --enable-libopus --enable-libvorbis --enable-libvpx --enable-libx264 --enable-libx265 && make && make install && make distclean && hash -r
