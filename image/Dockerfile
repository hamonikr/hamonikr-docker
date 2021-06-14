ARG BASE_IMAGE=ubuntu:20.04
FROM $BASE_IMAGE

ARG QEMU_ARCH
ADD x86_64_qemu-${QEMU_ARCH}-static.tar.gz /usr/bin

RUN mkdir -p /etc/my_init.d
COPY 01_run_glances.sh /etc/my_init.d/
RUN chmod +x /etc/my_init.d/01_run_glances.sh

COPY . /bd_build

RUN /bd_build/prepare.sh && \
	/bd_build/system_services.sh && \
	/bd_build/utilities.sh && \
	/bd_build/cleanup.sh

ENV DEBIAN_FRONTEND="teletype" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_ALL="en_US.UTF-8"

CMD ["/sbin/my_init"]
