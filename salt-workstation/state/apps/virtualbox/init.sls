repo:
  pkgrepo.managed:
    - human_name: VirtalBox 
    - name: deb http://download.virtualbox.org/virtualbox/debian zesty non-free contrib
    - file: /etc/apt/sources.list.d/virtualbox.org.list
    - key_url: http://download.virtualbox.org/virtualbox/debian/oracle_vbox_2016.asc

package:
  pkg.installed:
    - pkgs:
      - virtualbox-5.1
    - require:
      - pkgrepo: repo
