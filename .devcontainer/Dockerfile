#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

FROM haxe:4.0.3-buster

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

ARG USERNAME=user
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Configure apt and install packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends apt-utils dialog 2>&1 \
    #
    # Verify git and needed tools are installed
    && apt-get install -y git iproute2 procps sudo bash-completion build-essential python3-pip \
    && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt-get install -y nodejs=10.* \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Install test dependencies
RUN pip3 install html5validator

# https://github.com/Luehang/react-paypal-button-v2/issues/27
RUN npm install -g rimraf

# Create a non-root user to use
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

RUN mkdir -p /workspace/.haxelib /workspace/node_modules
RUN chown $USER_UID:$USER_GID /workspace/.haxelib /workspace/node_modules
RUN chmod a+rwx /workspace/.haxelib /workspace/node_modules

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=
