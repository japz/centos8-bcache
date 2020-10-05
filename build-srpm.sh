#!/usr/bin/env bash
set -x

if [ "$1" == "" ]; then
    REF=c8
else
    REF=$1
fi

git clone -b $REF --single-branch https://git.centos.org/rpms/kernel.git ; cd kernel
~/bin/get_sources.sh

sed -i 's/# CONFIG_BCACHE is not set/CONFIG_BCACHE=m/g' SOURCES/kernel-x86_64.config
sed -i 's/# define buildid .local/%define buildid .bcache/' SPECS/kernel.spec


rpmbuild -bs --target=`uname -m` --define "%_topdir `pwd`" SPECS/kernel.spec
rpmname=$(basename $(ls SRPMS/*.src.rpm))

if [ "$COPR_TOKEN" != "" ]; then
    mkdir ~/.config
    cat > ~/.config/copr << EOF
$COPR_TOKEN
EOF
fi

if [ -f ~/.config/copr ]; then
    if ! copr-cli list-packages bcache | grep $rpmname; then
        copr-cli build bcache SRPMS/$rpmname
    else
        echo "Build already exists on COPR, skipping"
    fi
fi
