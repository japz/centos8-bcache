FROM centos:8

RUN dnf -y install git epel-release rpm-build; \
    dnf -y install copr-cli
RUN useradd -u 1000 -m -d /rpmbuild rpmbuild

WORKDIR /rpmbuild
COPY --chown=rpmbuild:rpmbuild build-srpm.sh build-srpm.sh

USER rpmbuild
RUN git clone  https://git.centos.org/centos-git-common.git; \
    mkdir ~/bin; \
    ln -s ~/centos-git-common/get_sources.sh ~/bin/get_sources.sh;

CMD /bin/bash
