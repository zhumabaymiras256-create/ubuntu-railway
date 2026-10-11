FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    openssh-server sudo ca-certificates curl nano vim-tiny iproute2 iputils-ping \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /var/run/sshd

# Railway provides PORT. This image exposes an SSH server on that port.
# Set SSH_PASSWORD in Railway Variables before deploying.
RUN useradd -m -s /bin/bash railway     && echo 'railway ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/railway     && chmod 0440 /etc/sudoers.d/railway

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 22
CMD ["/start.sh"]
