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
  curl \
  locales

  mkdir -p /run/sshd
  rm -rf /var/lib/apt/lists/*
EOF

CMD ["/usr/sbin/sshd", "-D"]
