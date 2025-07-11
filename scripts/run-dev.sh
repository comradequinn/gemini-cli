#! /bin/bash

CMD=$1

docker run -it --rm \
    $(id -G | sed 's/\</--group-add /g') \
    -v "${HOME}:${HOME}" \
    -v /etc/passwd:/etc/passwd:ro \
    -v /etc/group:/etc/group:ro \
    -v /etc/gshadow:/etc/gshadow:ro \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -e GOOGLE_CLOUD_PROJECT="comradequinn" \
    -e GOOGLE_CLOUD_LOCATION="europe-west1" \
    -u "$(id -u):$(id -g)" \
    -w "${PWD}" \
    ghcr.io/comradequinn/gemini-cli:dev \
    $CMD