{%- set name             = 'base' %}
{%- set ns               = '/' + name %}

{# Include base applications and it's configs #}
include:
  - .packages
  - .ntp
  - .make
  - .sshd
  - .vim
  - .rsyslog
  - .tlp
  - .dropbox
  - .fswatch
  - .node
