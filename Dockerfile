FROM ubuntu:22.04

USER root

# INSTALL SUDO
RUN apt update -y && \
    apt upgrade -y && \
    apt install sudo -y

# INSTALL WGET
RUN sudo apt update -y && \
    sudo apt install wget -y

# INSTALL UNZIP
RUN sudo apt update -y && \
    sudo apt install unzip -y

# INSTALL CURL
RUN sudo apt update -y && \
    sudo apt install curl -y && \
    curl --version

# INSTALL GIT
RUN sudo apt update -y && \
    sudo apt install git -y && \
    git --version

# INSTALL OPEN JDK
RUN sudo apt update -y && \
    sudo apt install openjdk-17-jdk -y

# INSTALL SSH
RUN sudo apt update -y && \
    sudo apt install openssh-client -y && \
    ssh -V && \
    eval $(ssh-agent)

RUN useradd -m fadlurahmanfdev
USER fadlurahmanfdev
WORKDIR /home/fadlurahmanfdev

#INSTALL ANDROID SDK
RUN mkdir -p Android/sdk
ENV ANDROID_SDK_ROOT="/home/fadlurahmanfdev/Android/sdk"
RUN mkdir -p .android && touch .android/repositories.cfg
RUN wget -O sdk-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip
RUN unzip sdk-tools.zip && rm sdk-tools.zip
RUN mv cmdline-tools Android/sdk
RUN cd Android/sdk/cmdline-tools/bin && yes | ./sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --licenses
RUN cd Android/sdk/cmdline-tools/bin && ./sdkmanager --sdk_root=${ANDROID_SDK_ROOT} "cmdline-tools;latest" "build-tools;33.0.2" "platform-tools" "platforms;android-33" "sources;android-33"
ENV PATH="$PATH:/home/fadlurahmanfdev/Android/sdk/cmdline-tools/bin"
ENV PATH="$PATH:/home/fadlurahmanfdev/Android/sdk/platform-tools"

# INSTALL FLUTTER
RUN git clone --branch 3.16.9 https://github.com/flutter/flutter.git
ENV PATH="$PATH:/home/fadlurahmanfdev/flutter"
ENV PATH="$PATH:/home/fadlurahmanfdev/flutter/bin"
ENV FLUTTER_HOME="/home/fadlurahmanfdev/flutter"
ENV FLUTTER_ROOT="/home/fadlurahmanfdev/flutter"

# FLUTTER DOCRTOR
RUN flutter doctor -v

# INSTALL MELOS
RUN flutter pub global activate melos
ENV PATH "$PATH:/home/fadlurahmanfdev/.pub-cache/bin"
RUN melos --version

WORKDIR /

CMD /bin/bash