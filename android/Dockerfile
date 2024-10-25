# Use the latest GitHub Actions runner image as the base image
FROM ghcr.io/actions/actions-runner:latest

# Switch to root to install dependencies
USER root

# Install Git LFS and other dependencies
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && \
    apt-get update && \
    apt-get install -y git-lfs bridge-utils xz-utils cpu-checker && \
    git lfs install

# Conditionally prepare for KVM, apply changes to /dev/kvm only if it exists
ARG TARGETARCH
RUN if [ "$TARGETARCH" = "amd64" ]; then \
        apt-get install -y qemu-kvm libvirt-daemon-system libvirt-clients; \
        usermod -aG kvm runner && usermod -aG libvirt runner; \
        if [ -e /dev/kvm ]; then \
            chgrp kvm /dev/kvm && chmod 660 /dev/kvm; \
        fi; \
    fi

# Switch back to the non-root runner user
USER runner
