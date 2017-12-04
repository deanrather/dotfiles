{%- set name             = 'base' %}
{%- set ns               = '/' + name %}

{# Include base applications and it's configs #}
include:
  - .packages
  - .ntp
  - .make
  - .dropbox
  - .fswatch
  - .node
