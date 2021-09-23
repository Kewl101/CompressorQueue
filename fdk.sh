Skip to content
Sign in
Sign up
Instantly share code, notes, and snippets.

wimil/ffmpeg_build_ubuntu.sh
Last active 4 months ago
 Code
 Revisions 4
build ffmpeg in ubuntu 20.4
ffmpeg_build_ubuntu.sh
## Cleanup Old Junk
cleanupOld() {
    rm -rf ffmpeg_build
    rm -rf ffmpeg_sources
    yes | sudo apt-get remove -qq \
        nasm \
        libx264-dev \
        libx265-dev \
        libvpx-dev \
        libfdk-aac-dev \
        libopus-dev
}

## Install Prerequisites
installLibs() {
    yes | sudo apt-get update -qq && sudo apt-get upgrade -qq && sudo apt-get install -qq \
        autoconf \
        automake \
        build-essential \
        cmake \
        git \
        libass-dev \
        libfreetype6-dev \
        libtool \
        libvorbis-dev \
        pkg-config \
        texinfo \
        wget \
        zlib1g-dev \
        yasm \
        mercurial \
        libnuma-dev \
        openssl \
        libmp3lame-dev \
        libnuma-dev \
        libunistring-dev \
        libgnutls28-dev
}

## Compile nasm
compileNasm() {
    apt install nasm -y
}

## Compile libx264
compileLibx264() {
    apt install libx264-dev -y
}

## Compile libx265
compileLibx265() {
    apt install libx265-dev libnuma-dev -y
}

## Compile libvpx
compileLibvpx() {
    apt install libvpx-dev -y
}

## Compile libfdk-aac
compileLibfdkaac() {
    apt install libfdk-aac-dev -y
}

compileLibmp3lame() {
    apt install libopus-dev -y
}

## Compile libopus
compileLibOpus() {
    apt install libopus-dev -y
}

## Compile ffmpeg
compileFfmpeg() {
    cd ~/ffmpeg_sources &&
        wget -O ffmpeg-4.3.1.tar.bz2 https://ffmpeg.org/releases/ffmpeg-4.3.1.tar.bz2 &&
        tar xjvf ffmpeg-4.3.1.tar.bz2 &&
        cd ffmpeg-4.3.1 &&
        PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
            --prefix="$HOME/ffmpeg_build" \
            --pkg-config-flags="--static" \
            --extra-cflags="-I$HOME/ffmpeg_build/include" \
            --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
            --extra-libs="-lpthread -lm" \
            --bindir="$HOME/bin" \
            --enable-gpl \
            --enable-gnutls \
            --enable-libass \
            --enable-libfdk-aac \
            --enable-libfreetype \
            --enable-libmp3lame \
            --enable-libopus \
            --enable-libvorbis \
            --enable-libvpx \
            --enable-libx264 \
            --enable-libx265 \
            --enable-nonfree &&
        PATH="$HOME/bin:$PATH" make -j$(nproc) &&
        make -j$(nproc) install &&
        hash -r
}

## Cleanup
cleanupNew() {
    echo "Cleaning up files..."
    rm -rf ~/ffmpeg_sources
    rm -rf ~/ffmpeg_build
}

## The Process
cd ~
#echo -e "\e[91mNote: This script requires sudo access. Ctrl+C now if you do not have sudo access.\033[0m"
#echo -e "\e[91mNote: Some of these steps can take a very long time. Please be patient.\033[0m"
#echo "Removing old shit..."
cleanupOld
mkdir ffmpeg_sources

echo "Installing prerequisites..."
installLibs

echo "Installing nasm..."
compileNasm

echo "Installing libx264..."
compileLibx264

echo "Installing libx265..."
compileLibx265

echo "Installing libvpx..."
compileLibvpx

echo "Installing libfdk-aac..."
compileLibfdkaac

echo "Installing lLibmp3lame..."
compileLibmp3lame

echo "Installing libopus..."
compileLibOpus

echo "Compiling ffmpeg...buckle up!"
compileFfmpeg

cleanupNew
echo "Completed! Type 'ffmpeg' to verify."

# after install
apt install libass9 libvorbisenc2 fdkaac libmp3lame0 libopus0 libx264-155 libx265-179 libvpx6  -y
