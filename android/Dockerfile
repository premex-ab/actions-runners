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

# Update package lists and install essential dependencies
RUN apt-get update && \
    apt-get install -y wget git-lfs unzip cpu-checker libx11-6 libx11-dev gosu && \
    git lfs install

# Install KVM dependencies if on amd64
RUN if [ "$TARGETARCH" = "amd64" ]; then \
        apt-get install -y libvirt-daemon-system libvirt-clients bridge-utils qemu-kvm; \
    fi

# Download and install Amazon Corretto 17 based on architecture
RUN if [ "$TARGETARCH" = "amd64" ]; then \
        wget https://corretto.aws/downloads/latest/amazon-corretto-17-x64-linux-jdk.deb -O /tmp/amazon-corretto-17.deb; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
        wget https://corretto.aws/downloads/latest/amazon-corretto-17-aarch64-linux-jdk.deb -O /tmp/amazon-corretto-17.deb; \
    else \
        echo "Unsupported architecture: $TARGETARCH" && exit 1; \
    fi && \
    apt-get install -y /tmp/amazon-corretto-17.deb && \
    rm /tmp/amazon-corretto-17.deb

# Create a symbolic link for JAVA_HOME
RUN ln -s /usr/lib/jvm/java-17-amazon-corretto /usr/lib/jvm/default-java

# Set JAVA_HOME and add Java to PATH
ENV JAVA_HOME=/usr/lib/jvm/default-java
ENV PATH="$JAVA_HOME/bin:$PATH"

# Verify Java installation
RUN java -version

# Set Android SDK installation paths in runner's home directory
ENV ANDROID_HOME=/home/runner/android-sdk
ENV ANDROID_SDK_ROOT=$ANDROID_HOME
ENV PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"

# Install Android SDK command line tools
RUN mkdir -p $ANDROID_HOME && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O $ANDROID_HOME/commandlinetools.zip && \
    unzip $ANDROID_HOME/commandlinetools.zip -d $ANDROID_HOME/cmdline-tools && \
    rm $ANDROID_HOME/commandlinetools.zip && \
    mv $ANDROID_HOME/cmdline-tools/cmdline-tools $ANDROID_HOME/cmdline-tools/latest

# Accept Android SDK licenses and install essential packages
RUN yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --licenses && \
    $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager "platform-tools"

# Install emulator and configure KVM only on amd64 architecture
RUN if [ "$TARGETARCH" = "amd64" ]; then \
        $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager "emulator" && \
        $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager "system-images;android-30;google_apis_playstore;x86_64"; \
    fi

# Ensure runner has ownership of Android SDK directory
RUN chown -R runner:runner /home/runner/android-sdk

# Set permissions and create start script for KVM if on amd64
RUN if [ "$TARGETARCH" = "amd64" ]; then \
        usermod -aG libvirt runner && \
        usermod -aG kvm runner && \
        echo '#!/bin/bash\nchmod 660 /dev/kvm\nexec gosu runner "$@"' > /home/runner/start.sh && \
        chmod +x /home/runner/start.sh; \
    else \
        echo '#!/bin/bash\nexec gosu runner "$@"' > /home/runner/start.sh && \
        chmod +x /home/runner/start.sh; \
    fi

# Clean up apt cache and lists to reduce image size
RUN apt-get autoclean && rm -rf /var/lib/apt/lists/*

ENV RUNTIME_ARCH=$TARGETARCH

# Set entrypoint
ENTRYPOINT ["/home/runner/start.sh"]

# Set default user to runner
USER runner
