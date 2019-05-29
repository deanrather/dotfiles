{%- set name             = 'base' %}
{%- set ns               = '/' + name %}

{# Include base applications and it's configs #}
include:
  - .virtualbox
  - .chrome
  - .atom
