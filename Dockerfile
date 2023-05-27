FROM --platform=linux/amd64 ubuntu:18.04 as base


# Create dongshanpi user
RUN apt-get update && \
    apt-get install --no-install-recommends -y sudo && \
    useradd -ms /bin/bash dongshanpi && \
    echo 'dongshanpi ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
    adduser dongshanpi sudo && \
    apt-get clean && \
    mkdir -p /home/dongshanpi && \
    sudo chown -R dongshanpi /home/dongshanpi && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
USER dongshanpi

RUN sudo apt update
RUN sudo apt install --no-install-recommends -y bsdmainutils
# reclaim ownership of /usr/local/bin
RUN sudo chown -R dongshanpi /usr/local/bin

# install basic packages
RUN sudo apt-get update && \
    sudo apt-get upgrade -y subversion && \
    sudo apt-get install  --no-install-recommends -y \
                          sed \
                          make \
                          binutils \
                          build-essential \
                          gcc \
                          g++ \
                          bash \
                          patch \
                          gzip \
                          bzip2 \
                          perl \
                          tar \
                          cpio \
                          unzip \
                          rsync \
                          file \
                          bc \
                          wget \
                          python \
                          cvs \
                          git \
                          mercurial \
                          rsync \
                          subversion \
                          android-tools-mkbootimg \
                          vim \
                          libssl-dev \
                          android-tools-fastboot && \
    sudo apt-get autoremove -y && \
    sudo apt-get clean && \
    sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


COPY ./IKAYAKI_SDK/arm-sigmastar-linux-uclibcgnueabihf-9.1.0 /home/dongshanpi/IKAYAKI_SDK/arm-sigmastar-linux-uclibcgnueabihf-9.1.0
COPY ./IKAYAKI_SDK/boot /home/dongshanpi/IKAYAKI_SDK/boot
COPY ./IKAYAKI_SDK/gcc-sigmastar-9.1.0-2020.07-x86_64_arm-linux-gnueabihf /home/dongshanpi/IKAYAKI_SDK/gcc-sigmastar-9.1.0-2020.07-x86_64_arm-linux-gnueabihf
COPY ./IKAYAKI_SDK/kernel /home/dongshanpi/IKAYAKI_SDK/kernel
COPY ./IKAYAKI_SDK/project /home/dongshanpi/IKAYAKI_SDK/project
COPY ./IKAYAKI_SDK/sdk /home/dongshanpi/IKAYAKI_SDK/sdk

# Patch Kernel Files
COPY ./patch/kernel/_makefile /home/dongshanpi/IKAYAKI_SDK/kernel/_makefile
COPY ./patch/kernel/Makefile /home/dongshanpi/IKAYAKI_SDK/kernel/Makefile
COPY ./patch/kernel/scripts/ms_bin_option_update_int.py /home/dongshanpi/IKAYAKI_SDK/kernel/scripts/ms_bin_option_update_int.py
COPY ./patch/kernel/scripts/ms_builtin_dtb_update.py /home/dongshanpi/IKAYAKI_SDK/kernel/scripts/ms_builtin_dtb_update.py


RUN sudo chown -R dongshanpi /home/dongshanpi/IKAYAKI_SDK/


# Env vars gcc

ENV ARCH="arm"
ENV CROSS_COMPILE="arm-linux-gnueabihf-"
ENV PATH="$PATH:/home/dongshanpi/IKAYAKI_SDK/gcc-sigmastar-9.1.0-2020.07-x86_64_arm-linux-gnueabihf/bin"


# Fix /bin/sh to point to /bin/bash
RUN sudo rm /bin/sh && \
    sudo ln -s /bin/bash /bin/sh
