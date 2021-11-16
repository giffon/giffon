VERSION 0.5
FROM busybox:1.34
ARG DEVCONTAINER_IMAGE_NAME=giffon/giffon_devcontainer
WORKDIR /tmp

image:
    ARG IMAGE
    FROM ${IMAGE}

devcontainer:
    COPY .devcontainer/docker-compose.yml docker-compose.yml
    RUN grep -oE "$DEVCONTAINER_IMAGE_NAME:[a-z0-9]+" docker-compose.yml | tee IMAGE
    FROM \
        --build-arg IMAGE="$(cat IMAGE)" \
        +image

devcontainer-build:
    ARG TARGETARCH

    FROM mcr.microsoft.com/vscode/devcontainers/base:0-focal

    # Avoid warnings by switching to noninteractive
    ENV DEBIAN_FRONTEND=noninteractive

    ARG INSTALL_ZSH="false"
    ARG UPGRADE_PACKAGES="false"
    ARG ENABLE_NONROOT_DOCKER="true"
    ARG USE_MOBY="true"
    ENV DOCKER_BUILDKIT=1
    ARG USERNAME=vscode
    ARG USER_UID=1000
    ARG USER_GID=$USER_UID
    COPY ./.devcontainer/library-scripts/*.sh /tmp/library-scripts/
    RUN apt-get update \
        && /bin/bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true" \
        # Use Docker script from script library to set things up
        && /bin/bash /tmp/library-scripts/docker-debian.sh "${ENABLE_NONROOT_DOCKER}" "/var/run/docker-host.sock" "/var/run/docker.sock" "${USERNAME}" "${USE_MOBY}" \
        # Clean up
        && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts/

    # Setting the ENTRYPOINT to docker-init.sh will configure non-root access 
    # to the Docker socket. The script will also execute CMD as needed.
    ENTRYPOINT [ "/usr/local/share/docker-init.sh" ]
    CMD [ "sleep", "infinity" ]

    RUN apt-get update \
        && apt-get -y install --no-install-recommends \
            sudo \
            git \
            bash-completion \
            software-properties-common \
            make \
            build-essential \
            python3-pip \
            python3-setuptools \
            python3-wheel \
            python3-dev \
        # Install haxe
        && add-apt-repository ppa:haxe/haxe4.1 \
        && apt-get -y install --no-install-recommends haxe=1:4.1.* \
        # Install node
        && curl -sL https://deb.nodesource.com/setup_12.x | bash - \
        && apt-get install -y nodejs=12.* \
        #
        # Clean up
        && apt-get autoremove -y \
        && apt-get clean -y \
        && rm -rf /var/lib/apt/lists/*

    # Install earthly
    RUN curl -fsSL https://github.com/earthly/earthly/releases/download/v0.5.24/earthly-linux-${TARGETARCH} -o /usr/local/bin/earthly \
        && chmod +x /usr/local/bin/earthly
    RUN earthly bootstrap --no-buildkit --with-autocomplete

    # Install test dependencies
    RUN pip3 install html5validator
    COPY src/test/requirements.txt /tmp/requirements.txt
    RUN pip3 install -r /tmp/requirements.txt

    ENV YARN_CACHE_FOLDER=/yarn
    RUN mkdir -m 777 "$YARN_CACHE_FOLDER"
    RUN mkdir -m 777 "/workspace"
    USER $USERNAME
    WORKDIR /workspace

    # Install node deps
    COPY package.json package-lock.json .
    RUN npm install
    VOLUME /workspace/node_modules

    # Install haxelibs
    COPY *.hxml .
    RUN haxe install-haxelibs.hxml
    VOLUME /workspace/.haxelib

    USER root

    # Switch back to dialog for any ad-hoc use of apt-get
    ENV DEBIAN_FRONTEND=

    ARG DEVCONTAINER_IMAGE_TAG
    SAVE IMAGE --push $DEVCONTAINER_IMAGE_NAME:$DEVCONTAINER_IMAGE_TAG

devcontainer-rebuild:
    RUN --no-cache date +%Y%m%d%H%M%S | tee buildtime
    BUILD \
        --platform=linux/amd64 \
        --build-arg DEVCONTAINER_IMAGE_TAG="$(cat buildtime)" \
        +devcontainer-build
    BUILD \
        --build-arg DEVCONTAINER_IMAGE_TAG="$(cat buildtime)" \
        +devcontainer-update-refs

devcontainer-update-refs:
    ARG DEVCONTAINER_IMAGE_TAG
    BUILD \
        --build-arg DEVCONTAINER_IMAGE_TAG="$DEVCONTAINER_IMAGE_TAG" \
        --build-arg FILE='./.devcontainer/docker-compose.yml' \
        +devcontainer-update-ref

devcontainer-update-ref:
    ARG DEVCONTAINER_IMAGE_TAG
    ARG FILE
    COPY "$FILE" file.src
    RUN sed -e "s#$DEVCONTAINER_IMAGE_NAME:[a-z0-9]*#$DEVCONTAINER_IMAGE_NAME:$DEVCONTAINER_IMAGE_TAG#g" file.src > file.out
    SAVE ARTIFACT file.out $FILE AS LOCAL $FILE