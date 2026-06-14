FROM ubuntu:latest

ENV LANG=ja_JP.UTF-8 \
    LANGUAGE=ja_JP:ja \
    LC_ALL=ja_JP.UTF-8 \
    TZ=Asia/Tokyo

RUN <<-EOF
apt-get update
apt-get install -y --no-install-recommends \
  sudo \
  bash \
  bash-completion \
  openssh-server \
  python3 \
  curl \
  locales \
  tzdata

  mkdir -p /run/sshd
  rm -rf /var/lib/apt/lists/*
EOF

RUN <<-EOF
echo "ja_JP.UTF-8 UTF-8" > /etc/locale.gen
locale-gen ja_JP.UTF-8
ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
dpkg-reconfigure -f noninteractive tzdata
EOF

RUN <<-EOF
  useradd -m -s /bin/bash ansible &&
  echo 'ansible ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers &&
  mkdir -p /home/ansible/.ssh &&
  chown ansible:ansible /home/ansible/.ssh &&
  chmod 700 /home/ansible/.ssh
EOF

COPY ansible_target/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D"]
