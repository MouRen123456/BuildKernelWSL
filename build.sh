#/bin/bash
sudo apt update
sudo apt upgrade -y
sudo apt-get install git ccache automake flex lzop bison gperf build-essential zip curl zlib1g-dev g++-multilib libxml2-utils bzip2 libbz2-dev libbz2-1.0 libghc-bzlib-dev squashfs-tools pngcrush schedtool dpkg-dev liblz4-tool make optipng maven libssl-dev pwgen libswitch-perl policycoreutils minicom libxml-sax-base-perl libxml-simple-perl bc libc6-dev-i386 lib32ncurses5-dev libx11-dev lib32z-dev libgl1-mesa-dev xsltproc unzip device-tree-compiler python2 python3
cd ~
mkdir clang
curl "https://github.com/ZyCromerZ/Clang/releases?q=14&expanded=true" | grep 'https://github.com/ZyCromerZ/Clang/releases/expanded_assets/' | sed -n 1p | awk -F'"' '{print $6}' > clang_url.txt 
curl $(cat clang_url.txt) | grep ".tar.gz" | awk -F'"' '{print $2}' | sed -n 1p > url.txt && echo "https://github.com$(sed -n 1p url.txt)" > url.txt
aria2c -j10 $(sed -n 1p url.txt) -o clang.tar.gz
tar -C clang/ -zxf clang.tar.gz
rm -rf clang_url.txt url.txt
git clone --depth=1 https://github.com/XayahSuSuSu/kernel_redmi_mt6885 -b android-4.14-r-stable android-kernel
cd android-kernel
export CLANG_PATH=~/clang
export PATH=${CLANG_PATH}/bin:${PATH}
export CLANG_TRIPLE=aarch64-linux-gnu-
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_COMPILER_STRING="$(clang --version | head -n 1 )"
export KBUILD_BUILD_HOST=MouRen123456-PC
export KBUILD_BUILD_USER=MouRen123456
make O=out -j$(nproc --all) CC="ccache clang" CXX="ccache clang++" ARCH=arm64 CROSS_COMPILE=$CLANG_PATH/bin/aarch64-linux-gnu- CROSS_COMPILE_ARM32=$CLANG_PATH/bin/arm-linux-gnueabi- LD=ld.lld vendor/atom_user_defconfig
sed s/CONFIG_LOCALVERSION=".*"/'CONFIG_LOCALVERSION="-MouRen123456"'/g out/.config >>.config1
rm -rf out/.config
mv .config1 out/.config
make O=out -j$(nproc --all) CC="ccache clang" CXX="ccache clang++" ARCH=arm64 CROSS_COMPILE=$CLANG_PATH/bin/aarch64-linux-gnu- CROSS_COMPILE_ARM32=$CLANG_PATH/bin/arm-linux-gnueabi- LD=ld.lld
