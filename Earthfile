VERSION 0.5
FROM busybox:1.34
ARG DEVCONTAINER_IMAGE_NAME=registry.gitlab.com/giffon.io/giffon/devcontainer
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

devcontainer-rebuild:
    RUN --no-cache date +%Y%m%d%H%M%S | tee buildtime
    BUILD \
        --platform=linux/amd64 \
        --build-arg DEVCONTAINER_IMAGE_NAME="$DEVCONTAINER_IMAGE_NAME" \
        --build-arg DEVCONTAINER_IMAGE_TAG="$(cat buildtime)" \
        ./.devcontainer+devcontainer
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
