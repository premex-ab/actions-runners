# Use the latest GitHub Actions runner image as the base image
FROM ghcr.io/actions/actions-runner:latest

# Switch to root to install dependencies
USER root

# Install Git LFS (Git Large File Storage)
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && \
    apt-get install -y git-lfs && \
    git lfs install

# Switch back to the default non-root user for the rest of the operations (if needed)
USER runner

# Example: Install additional dependencies (optional)
# RUN apt-get update && apt-get install -y curl git jq

# Example: Copy your custom scripts or configuration
# COPY ./my-custom-script.sh /usr/local/bin/my-custom-script.sh
# RUN chmod +x /usr/local/bin/my-custom-script.sh

# Set environment variables or configurations (optional)
# ENV MY_CUSTOM_ENV_VAR=my_value

# Define the entry point, which can be customized based on your needs
# ENTRYPOINT ["/entrypoint.sh"]
