#!/bin/bash

# Run privileged actions as root
if [ "$(uname -m)" = "x86_64" ] && [ -e /dev/kvm ]; then
    echo "Configuring KVM permissions..."
    chgrp kvm /dev/kvm
    chmod 660 /dev/kvm
else
    echo "KVM not found or not on amd64; skipping KVM configuration"
fi

# Switch to runner user and continue with CMD
exec su - runner -c "$@"
