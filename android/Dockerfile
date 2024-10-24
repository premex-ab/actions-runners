# Use the latest GitHub Actions runner image as the base image
FROM ghcr.io/actions/actions-runner:latest

# Switch to root to install dependencies
USER root

# Install Git LFS (Git Large File Storage) and QEMU for KVM
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && \
    apt-get install -y git-lfs qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils && \
    git lfs install

# Add the 'runner' user to the 'kvm' and 'libvirt' groups to enable KVM access
RUN usermod -aG kvm runner && usermod -aG libvirt runner

# Ensure /dev/kvm has the correct group ownership and permissions
RUN chgrp kvm /dev/kvm && chmod 660 /dev/kvm

# Switch back to the non-root runner user
USER runner
