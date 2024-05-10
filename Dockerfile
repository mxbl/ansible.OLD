FROM debian:stable-slim AS base
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && \
    apt upgrade -y && \
    apt install -y software-properties-common curl git build-essential sudo \
      openssh-client ansible && \
    apt install -y python3 python3-pip && \
    apt clean autoclean && \
    apt autoremove --yes

# Allow sudo without password
RUN \
  sed -i 's/^%sudo.*$/%sudo   ALL=(ALL:ALL) NOPASSWD: ALL/g' \
  /etc/sudoers

FROM base AS mx
RUN addgroup --gid 1000 mx
RUN adduser           \
  --gecos mx          \
  --uid 1000          \
  --gid 1000          \
  --disabled-password \
  mx

RUN groupadd wheel
RUN usermod -aG wheel,sudo mx

WORKDIR /home/mx/ansible
COPY . .
RUN chown mx:mx -R .

USER mx

# Setup environment variables
ENV USER=mx
ENV TERM=screen-256color

# Download public key for github.com
RUN mkdir -p -m 0700 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

# Run ansible tags
#RUN --mount=type=ssh ansible-playbook local.yml -t dotfiles

CMD bash
