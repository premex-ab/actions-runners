# Use the latest GitHub Actions runner image as the base image
FROM ghcr.io/actions/actions-runner:latest

# Set the target architecture argument
ARG TARGETARCH

# Switch to root to install dependencies
USER root

# Configure APT sources and architectures based on TARGETARCH
RUN if [ "$TARGETARCH" = "amd64" ]; then \
        dpkg --remove-architecture arm64 && \
        rm -f /etc/apt/sources.list.d/ubuntu-arm64.list; \
    else \
        dpkg --add-architecture arm64 && \
        echo "deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports mantic main restricted" > /etc/apt/sources.list.d/ubuntu-arm64.list; \
    fi && \
    echo "deb [arch=amd64] http://archive.ubuntu.com/ubuntu mantic main restricted" > /etc/apt/sources.list.d/ubuntu-amd64.list

# Update package lists and install dependencies
RUN apt-get update && \
    apt-get install -y wget git-lfs bridge-utils xz-utils cpu-checker unzip libgl1 libxcb1 libpulse0 libnss3 libx11-6 && \
    git lfs install

# Download and install Java 21 based on architecture
RUN if [ "$TARGETARCH" = "amd64" ]; then \
        wget https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.tar.gz -O /tmp/openjdk-21.tar.gz; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        wget https://download.oracle.com/java/21/latest/jdk-21_linux-aarch64_bin.tar.gz -O /tmp/openjdk-21.tar.gz; \
    else \
        echo "Unsupported architecture: $TARGETARCH" && exit 1; \
    fi && \
    mkdir -p /usr/lib/jvm && \
    tar -xzf /tmp/openjdk-21.tar.gz -C /usr/lib/jvm && \
    rm /tmp/openjdk-21.tar.gz && \
    mv /usr/lib/jvm/jdk-21* /usr/lib/jvm/java-21

# Set JAVA_HOME and add Java to PATH
ENV JAVA_HOME=/usr/lib/jvm/java-21
ENV PATH="$JAVA_HOME/bin:$PATH"

# Install Android SDK command line tools
RUN mkdir -p /usr/lib/android-sdk && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O /usr/lib/android-sdk/commandlinetools.zip && \
    unzip /usr/lib/android-sdk/commandlinetools.zip -d /usr/lib/android-sdk/cmdline-tools && \
    rm /usr/lib/android-sdk/commandlinetools.zip && \
    mv /usr/lib/android-sdk/cmdline-tools/cmdline-tools /usr/lib/android-sdk/cmdline-tools/latest

# Set ANDROID_HOME and ANDROID_SDK_ROOT
ENV ANDROID_HOME=/usr/lib/android-sdk
ENV ANDROID_SDK_ROOT=$ANDROID_HOME
ENV PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"


# Accept Android SDK licenses and install essential packages
RUN yes | sdkmanager --sdk_root=$ANDROID_HOME --licenses && \
    sdkmanager --sdk_root=$ANDROID_HOME "platform-tools" "emulator" "build-tools;34.0.0" "platforms;android-34" "platforms;android-35" && \
    sdkmanager --sdk_root=$ANDROID_HOME "system-images;android-30;google_apis;x86" "system-images;android-30;google_apis_playstore;x86_64"

RUN apt-get update && apt-get install -y xvfb

RUN apt-get install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils

# Switch back to the non-root runner user
USER runner

# Start XVFB before any other commands in the container
ENTRYPOINT ["/bin/bash", "-c", "Xvfb :99 -screen 0 1280x1024x24 & exec \"$@\"", "--"]
