#!/bin/bash
set -e
source /bd_build/buildconfig
set -x

## Prevent initramfs updates from trying to run grub and lilo.
## https://journal.paul.querna.org/articles/2013/10/15/docker-ubuntu-on-rackspace/
## http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=594189
export INITRD=no
mkdir -p /etc/container_environment
echo -n no > /etc/container_environment/INITRD

## Enable Ubuntu Universe, Multiverse, and deb-src for main.
sed -i 's/^#\s*\(deb.*main restricted\)$/\1/g' /etc/apt/sources.list
sed -i 's/^#\s*\(deb.*universe\)$/\1/g' /etc/apt/sources.list
sed -i 's/^#\s*\(deb.*multiverse\)$/\1/g' /etc/apt/sources.list

## Change mirror for KR
sed -i 's/archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list

apt-get update

## Fix some issues with APT packages.
## See https://github.com/dotcloud/docker/issues/1024
dpkg-divert --local --rename --add /sbin/initctl
ln -sf /bin/true /sbin/initctl

## Replace the 'ischroot' tool to make it always return true.
## Prevent initscripts updates from breaking /dev/shm.
## https://journal.paul.querna.org/articles/2013/10/15/docker-ubuntu-on-rackspace/
## https://bugs.launchpad.net/launchpad/+bug/974584
dpkg-divert --local --rename --add /usr/bin/ischroot
ln -sf /bin/true /usr/bin/ischroot

# apt-utils fix for Ubuntu 16.04
$minimal_apt_get_install apt-utils

## Install HTTPS support for APT.
$minimal_apt_get_install apt-transport-https ca-certificates

## Install add-apt-repository
$minimal_apt_get_install software-properties-common

## Install HamoniKR OS APT and core packages
$minimal_apt_get_install wget gpg-agent locales net-tools
wget -qO- https://pkg.hamonikr.org/add-hamonikr-5.0-hanla.apt | bash -
$minimal_apt_get_install hamonikr-info
$minimal_apt_get_install base-files
$minimal_apt_get_install hamonikr-ff
$minimal_apt_get_install htop
# zsh
$minimal_apt_get_install git powerline fonts-powerline zsh-theme-powerlevel9k python3-powerline
echo "export TERM=xterm-256color"  >> "/root/.zshrc"
echo "source /usr/share/powerlevel9k/powerlevel9k.zsh-theme" >> "/root/.zshrc"
# $minimal_apt_get_install openssh-server
# $minimal_apt_get_install dpkg-sig make nginx-extras reprepro xz-utils 

# node exporter TCP/9100
# wget -O - https://raw.githubusercontent.com/hamonikr/hamonikr-docker/master/node_exporter/agent-setup.sh | bash

## Upgrade all packages.
apt-get dist-upgrade -y --no-install-recommends -o Dpkg::Options::="--force-confold"

## Fix locale.
case $(lsb_release -is) in
  Ubuntu|Hamonikr)
    $minimal_apt_get_install language-pack-en
    ;;
  Debian)
    $minimal_apt_get_install locales locales-all
    ;;
  *)
    ;;
esac
dpkg-reconfigure -f noninteractive locales
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "ko_KR.UTF-8 UTF-8" >> /etc/locale.gen
echo "en_US.UTF-8 UTF-8" > /etc/default/locale
locale-gen
echo -n en_US.UTF-8 > /etc/container_environment/LANG
echo -n en_US.UTF-8 > /etc/container_environment/LC_CTYPE
