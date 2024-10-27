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
    apt-get install -y wget git-lfs unzip && \
    git lfs install

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

# Set JAVA_HOME and add Java to PATH
ENV JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto
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

# Accept Android SDK licenses and install platform tools
RUN yes | sdkmanager --sdk_root=$ANDROID_HOME --licenses && \
    sdkmanager --sdk_root=$ANDROID_HOME "platform-tools" "platforms;android-34" "platforms;android-35"

# Query and install the latest and second-latest build tools
RUN LATEST_BUILD_TOOLS=$(sdkmanager --list | grep "build-tools;" | awk -F';' '{print $2}' | sort -Vr | head -n 2) && \
    for VERSION in $LATEST_BUILD_TOOLS; do sdkmanager --sdk_root=$ANDROID_HOME "build-tools;$VERSION"; done

# Switch back to the non-root runner user
USER runner
