# -*- coding: utf-8 -*-
# vim: ft=sls
---
{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/jinja/map.jinja" import mapdata with context %}

{%- set _mapdata = {
      "values": mapdata,
    } %}
{%- do salt["log.debug"]("### MAP.JINJA DUMP ###\n" ~ _mapdata | yaml(False)) %}

{%- set output_dir = "/temp" if grains.os_family == "Windows" else "/tmp" %}
{%- set output_file = output_dir ~ "/salt_mapdata_dump.yaml" %}

{{ tplroot }}-mapdata-dump:
  file.managed:
    - name: {{ output_file }}
    - source: salt://{{ tplroot }}/_mapdata/_mapdata.jinja
    - template: jinja
    - context:
        map: {{ _mapdata | yaml }}
