FROM docker.io/library/node:20-slim

ENV GOOGLE_GENAI_USE_VERTEXAI=true

# install commonly used packages
RUN apt-get update && apt-get install -y --no-install-recommends \
  python3 \
  make \
  g++ \
  apt-transport-https \
  gnupg \
  man-db \
  curl \
  dnsutils \
  less \
  jq \
  bc \
  gh \
  git \
  unzip \
  rsync \
  ripgrep \
  procps \
  psmisc \
  lsof \
  socat \
  ca-certificates \
  golang

# install docker cli and tools (the host docker socket can be mounted when a container is run)
RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && apt-get install -y docker-ce-cli docker-buildx-plugin docker-compose-plugin

# install gcloud and kubectl 
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | \
        tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
        gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg && apt-get update -y && \
        apt-get install -y google-cloud-cli google-cloud-cli-gke-gcloud-auth-plugin kubectl

# clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# finally install gemini
RUN npm install -g @google/gemini-cli

CMD ["gemini"]
