# Dotfiles Dockerfile
# For creating a development environment inside a docker container.

FROM ubuntu:16.04

# Install Sudo
RUN set -ex && \
  echo 'deb mirror://mirrors.ubuntu.com/mirrors.txt precise main restricted universe multiverse' >> /etc/apt/sources.list && \
  echo 'deb mirror://mirrors.ubuntu.com/mirrors.txt precise-updates main restricted universe multiverse' >> /etc/apt/sources.list && \
  echo 'deb mirror://mirrors.ubuntu.com/mirrors.txt precise-backports main restricted universe multiverse' >> /etc/apt/sources.list && \
  echo 'deb mirror://mirrors.ubuntu.com/mirrors.txt precise-security main restricted universe multiverse' >> /etc/apt/sources.list
RUN set -ex && apt-get update && apt-get install -y sudo

# Create dev user
RUN set -ex \
  && adduser --quiet --gecos '' --disabled-password dev \
  && echo "dev ALL=(ALL) NOPASSWD: ALL" | tee /etc/sudoers.d/dev-sudo-nopasswd \
  && sudo chmod 0440 /etc/sudoers.d/dev-sudo-nopasswd

# Create a shared data volume
# We need to create an empty file, otherwise the volume will
# belong to root.
# This is probably a Docker bug.
RUN mkdir /var/shared/
RUN touch /var/shared/placeholder
RUN chown -R dev:dev /var/shared
VOLUME /var/shared

WORKDIR /home/dev
ENV HOME /home/dev
COPY . /home/dev/dotfiles
RUN chown dev:dev /home/dev
USER dev


# Setup dotfiles
RUN set -ex && /home/dev/dotfiles/setup.sh --anon

