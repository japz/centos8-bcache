#!/usr/bin/env bash

if [ "$1" == "" ]; then
    REF=c8
else
    REF=$1
fi

git clone -b $REF --single-branch https://git.centos.org/rpms/kernel.git ; cd kernel
get_sources.sh

cat > SPECS/config << EOF
%define with_debug 0
%define with_kabichk 0
%defile with_debuginfo 0
EOF
cat SPECS/config kernel/SPECS/kernel.spec > SPECS/kernel-bcache.spec
sed -i 's/# CONFIG_BCACHE is not set/CONFIG_BCACHE=m/g' SOURCES/kernel-x86_64.config
sed -i 's/# define buildid .local/%define buildid .bcache/' SPECS/kernel-bcache.spec

rpmbuild -bs --target=`uname -m` --define "%_topdir `pwd`" SPECS/kernel.spec
