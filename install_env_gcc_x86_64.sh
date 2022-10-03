#!/bin/bash
if [ -f /etc/redhat-release ]; then
  INSTALLER=yum
  $INSTALLER update
  $INSTALLER install -y epel-release
  $INSTALLER install -y redhat-lsb-core
elif [ -f /etc/lsb-release ]; then
  INSTALLER=apt-get
  $INSTALLER update
  $INSTALLER install -y lsb-core coreutils
else
  echo "Only CentOS and Ubuntu are supported here!"
  exit 33
fi
$INSTALLER install -y ccache python3
$INSTALLER install -y bzip2 wget git gcc-c++ libstdc++-static byacc flex automake libtool binutils-devel bison ncurses-devel make mlocate unzip patch which vim-common zip libcurl-devel updatedb
$INSTALLER -y clean all
rm -rf /var/cache/yum
rm -rf /var/lib/apt/lists

mkdir -p /var/local/gcc
curl -fsSL -o /tmp/gcc.tar.gz $1/gcc-$2.tar.gz
tar -xzf /tmp/gcc.tar.gz -C /var/local/gcc --strip-components=1
cd /var/local/gcc
sed -i 's/ftp:\/\/gcc.gnu.org\/pub\/gcc\/infrastructure\//http:\/\/mirror.linux-ia64.org\/gnu\/gcc\/infrastructure\//g' contrib/download_prerequisites
./contrib/download_prerequisites
./configure --disable-multilib --enable-languages=c,c++ --prefix=/usr
make -j$(($(nproc) / 4 + 1)) && make install
rm -rf /var/local/gcc
rm -f /tmp/gcc.tar.gz
