FROM debian:stable-slim AS base
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && \
    apt upgrade -y && \
    apt install -y software-properties-common curl git ansible build-essential \
      sudo && \
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

# Setup environment variables
ENV USER=mx

USER mx
CMD bash
