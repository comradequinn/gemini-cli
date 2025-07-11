# gemini-cli

This repository provides a `docker image` that allows the `gemini-cli` to be run via `docker`. 

It is configured for use with `gcp`'s `vertex ai`, by default, and has a number of developer utilties installed to support common agentic actions. In addition to `gnu utils` and other common utilities, these include `docker-cli`, `g++`, `gcloud-cli`, `git`, `go`, `kubectl` and `python`

Running the `gemini-cli` via `docker` removes the need for the host system to have `npm`, `node` or the `gemini-cli` npm package itself installed. Nor does the host need access to the `npm repos` that host that package either. 

Similarly, as development tools are included in the utility, the host machine does not require those either.

## Prerequisites

Firsly, ensure the following are installed on the host machine

* [gcloud cli](https://cloud.google.com/sdk/docs/install): for authentication with `gcp` and `vertex ai`
* [docker](https://docs.docker.com/engine/install/): to run containers based on this `gemini-cli` image

Then, ensure that `gcp` `application-default-credentials` are configured. To do this, run the below, and follow the prompts:

```bash
gcloud auth application-default login --disable-quota-project
```

## Usage

The following command runs a `container` based on the `gemini-cli` as the current host user. Replace the `GOOGLE_CLOUD_PROJECT` and `GOOGLE_CLOUD_LOCATION` envars with appropriate values for the required `gcp` account.

```bash
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
    ghcr.io/comradequinn/gemini-cli:latest
```

The above maps the user's `home` directory and current `working directory` to the equivalent locations in the `container`. This allows the `gemini-cli` and the user to work with, and refer to, the contents of the user's `home` directory as if it were running natively; including accessing `docker`, `gcloud-cli` and `kubectl` credentials and configuration.

### Alias

For ease of use, the above command can be aliased to `gemini`, as shown below. Typically this alias would be added to the `~/.bashrc` file to ensure it is always available.

```bash
#file: ~/.bashrc

alias gemini='docker pull ghcr.io/comradequinn/gemini-cli:latest && \
    docker run -it --rm \
    $(id -G | sed "s/\</--group-add /g") \
    -v "${HOME}:${HOME}" \
    -v /etc/passwd:/etc/passwd:ro \
    -v /etc/group:/etc/group:ro \
    -v /etc/gshadow:/etc/gshadow:ro \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -e GOOGLE_CLOUD_PROJECT="comradequinn" \
    -e GOOGLE_CLOUD_LOCATION="europe-west1" \
    -u "$(id -u):$(id -g)" \
    -w "${PWD}" \
    ghcr.io/comradequinn/gemini-cli:latest'
```

You can then run the tool simply by typing `gemini`. As the image is pulled before running, the latest published version will always be used (as opposed to the latest local version)

