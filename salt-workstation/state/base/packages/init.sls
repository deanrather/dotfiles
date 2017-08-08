{%- set name             = 'packges' %}
{%- set ns               = '/base/' + name %}

{# Install base packges #}
{{ ns }}/installed/apt:
  pkg.latest:
    - install_recommends: False
    - pkgs:
      - htop
      - pssh
      - php
      - etherape
      - gparted
      - redshift
      - redshift-gtk
      - terminator
      - wireshark
      - xclip
      - xdotool
      - autossh
      - build-essential
      - curl
      - figlet
      - fortune-mod
      - git
      - git-flow
      - htop
      - lolcat
      - lsyncd
      - ncdu
      - nload
      - nmap
      - python-pip
      - sendip
      - ssh
      - tig
      - tmux
      - toilet
      - tree
      - uuid
      - vim
      - wget
      - nload
      - arp-scan
      - bash-completion
      - dnstop
      - tig
      - iotop
      - tmux
      - etckeeper
      - wget
      - openssl
      - libssl-dev
      - python-pip
      - python-dev
      - python-apt
      - adduser
      - alsa-utils
      - automake
      - bash-completion
      - bc
      - bridge-utils
      - bzip2
      - cmake
      - coreutils
      - curl
      - dnsutils
      - file
      - findutils
      - fortune-mod
      - fortunes-off
      - gcc
      - git
      - grep
      - gzip
      - hostname
      - indent
      - iptables
      - jq
      - less
      - libc6-dev
      - libltdl-dev
      - libnotify-bin
      - locales
      - lsof
      - make
      - mercurial
      - mount
      - net-tools
      - nfs-common
      - openvpn
      - rxvt-unicode-256color
      - s3cmd
      - scdaemon
      - silversearcher-ag
      - ssh
      - strace
      - sudo
      - tar
      - tree
      - tzdata
      - unzip
      - xclip
      - xcompmgr
      - xz-utils
      - zip
      - virtualbox
      - vagrant
      - screen
      - rdesktop
      {%- if grains['testingtravis'] is defined %}{% else %}
      - cgroupfs-mount
      {%- endif %}

