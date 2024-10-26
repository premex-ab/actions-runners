# Use the latest GitHub Actions runner image as the base image
FROM ghcr.io/actions/actions-runner:latest

# Switch to root to install dependencies
USER root

# Install Java 21, Git LFS, and other dependencies
RUN apt-get update && \
    apt-get install -y wget git-lfs bridge-utils xz-utils cpu-checker unzip && \
    git lfs install && \
    wget https://download.oracle.com/java/21/latest/jdk-21_linux-x64_bin.tar.gz -O /tmp/openjdk-21.tar.gz && \
    mkdir -p /usr/lib/jvm && \
    tar -xzf /tmp/openjdk-21.tar.gz -C /usr/lib/jvm && \
    rm /tmp/openjdk-21.tar.gz && \
    mv /usr/lib/jvm/jdk-21* /usr/lib/jvm/java-21

# Set JAVA_HOME and add Java to PATH
ENV JAVA_HOME=/usr/lib/jvm/java-21
ENV PATH="$JAVA_HOME/bin:$PATH"

# Install Android SDK command line tools
RUN mkdir -p /usr/lib/android-sdk && \
    cd /usr/lib/android-sdk && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O commandlinetools.zip && \
    unzip commandlinetools.zip -d /usr/lib/android-sdk/cmdline-tools && \
    rm commandlinetools.zip && \
    mv /usr/lib/android-sdk/cmdline-tools/cmdline-tools /usr/lib/android-sdk/cmdline-tools/latest

# Set ANDROID_HOME and add SDK tools to PATH
ENV ANDROID_HOME=/usr/lib/android-sdk
ENV PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"

# Accept Android SDK licenses and install essential packages
RUN yes | sdkmanager --sdk_root=$ANDROID_HOME --licenses && \
    sdkmanager --sdk_root=$ANDROID_HOME "platform-tools" "platforms;android-33" "build-tools;33.0.0"

# Switch back to the non-root runner user
USER runner
