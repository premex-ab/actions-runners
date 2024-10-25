# Use the latest GitHub Actions runner image as the base image
FROM ghcr.io/actions/actions-runner:latest

# Switch to root to install dependencies
USER root

# Install Git LFS and other dependencies, excluding architecture-specific ones initially
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && \
    apt-get update && \
    apt-get install -y git-lfs bridge-utils xz-utils cpu-checker && \
    git lfs install

# Install QEMU and KVM only if on platforms that support it
ARG TARGETARCH
RUN if [ "$TARGETARCH" = "amd64" ]; then \
        apt-get install -y qemu-kvm libvirt-daemon-system libvirt-clients; \
    fi

# Add the 'runner' user to the 'kvm' and 'libvirt' groups to enable KVM access, only if relevant
RUN if [ "$TARGETARCH" = "amd64" ]; then \
        usermod -aG kvm runner && usermod -aG libvirt runner; \
        chgrp kvm /dev/kvm && chmod 660 /dev/kvm; \
    fi

# Switch back to the non-root runner user
USER runner
