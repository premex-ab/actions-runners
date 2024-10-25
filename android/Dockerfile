# Use the latest GitHub Actions runner image as the base image
FROM ghcr.io/actions/actions-runner:latest

# Switch to root to install dependencies
USER root

# Install Git LFS and other dependencies, excluding KVM-specific setup
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && \
    apt-get update && \
    apt-get install -y git-lfs bridge-utils xz-utils cpu-checker && \
    git lfs install

# Conditionally prepare for KVM, without applying changes to /dev/kvm
ARG TARGETARCH
RUN if [ "$TARGETARCH" = "amd64" ]; then \
        apt-get install -y qemu-kvm libvirt-daemon-system libvirt-clients; \
        usermod -aG kvm runner && usermod -aG libvirt runner; \
    fi

# Switch back to the non-root runner user
USER runner
