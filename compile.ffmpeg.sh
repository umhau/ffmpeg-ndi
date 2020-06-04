#!/bin/sh

set -e                                                           # stop on error
set -x                                              # say everything as its done
# set -v

mkdir -p ~/ffmpeg_sources/ndi ~/bin; cd ~/ffmpeg_sources    # use ~/ as the base

# install dependencies (needed for compiling) (ubuntu)
sudo apt-get update -qq && sudo apt-get -y install \
  autoconf automake build-essential cmake git-core libass-dev libfreetype6-dev \
  libgnutls28-dev libsdl2-dev libtool libva-dev libvdpau-dev libvorbis-dev \
  libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev pkg-config texinfo wget yasm \
  zlib1g-dev

# install specific ffmpeg dependencies
sudo apt-get install nasm                  # An assembler used by some libraries
sudo apt-get install libx264-dev                           # H.264 video encoder
sudo apt-get install libx265-dev libnuma-dev          # H.265/HEVC video encoder
sudo apt-get install xz-utils                                # to extract tar.xz

# download NDI SDK (this may or may not work - looks like a temporary link)
wget http://514f211588de67e4fdcf-437b8dd50f60b69cf0974b538e50585b.r63.cf1.rackcdn.com/Utilities/SDK/NDI_SDK_Linux_v2/InstallNDISDK_v4_Linux.tar.gz

# extract NDI SDK
tar -xf InstallNDISDK_v4_Linux.tar.gz; bash InstallNDISDK_v4_Linux.sh

# move ./bin and ./include folders from NDI SDK
mv ~/ffmpeg_sources/NDI\ SDK\ for\ Linux/{bin,include} ~/ffmpeg_sources/ndi/

# download FFMPEG version that includes NDI support
cd ~/ffmpeg_sources
wget -O ffmpeg-3.4.6.tar.xz http://ffmpeg.org/releases/ffmpeg-3.4.6.tar.xz
tar xjvf ffmpeg-3.4.6.tar.xz
mv ffmpeg-3.4.6 ffmpeg; cd ffmpeg

# configure ffmpeg
PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" \
  ./configure --prefix="$HOME/ffmpeg_build" --pkg-config-flags="--static" \
  --extra-cflags="-I$HOME/ffmpeg_build/include -I$HOME/ffmpeg_sources/ndi/include" \
  --extra-ldflags="-L$HOME/ffmpeg_build/lib -L$HOME/ffmpeg_sources/ndi/lib/x86_64-linux-gnu" \
  --extra-libs="-lpthread -lm" --bindir="$HOME/bin" --enable-gpl \
  --enable-libass --enable-libfreetype --enable-libvorbis --enable-libx264 \
  --enable-libndi_newtek --enable-nonfree

# build ffmpeg
PATH="$HOME/bin:$PATH" make -j4 && make install && hash -r

