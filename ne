---
- name: Install node_exporter on remote servers
  hosts: remote_servers
  become: true
  vars:
    node_exporter_version: "1.2.0" # Change this to the desired version

  tasks:
    - name: Download node_exporter
      get_url:
        url: "https://github.com/prometheus/node_exporter/releases/download/v{{ node_exporter_version }}/node_exporter-{{ node_exporter_version }}.linux-amd64.tar.gz"
        dest: /tmp/node_exporter.tar.gz

    - name: Extract node_exporter
      ansible.builtin.unarchive:
        src: /tmp/node_exporter.tar.gz
        dest: /opt
        remote_src: true
        creates: "/opt/node_exporter-{{ node_exporter_version }}"

    - name: Create node_exporter user and group
      ansible.builtin.group:
        name: node_exporter
        state: present
        system: true

    - name: Create node_exporter user
      ansible.builtin.user:
        name: node_exporter
        state: present
        system: true
        group: node_exporter
        shell: /sbin/nologin

    - name: Set ownership of node_exporter directory
      ansible.builtin.file:
        path: "/opt/node_exporter-{{ node_exporter_version }}"
        owner: node_exporter
        group: node_exporter
        state: directory
        recurse: yes

    - name: Create node_exporter systemd service
      ansible.builtin.template:
        src: node_exporter.service.j2
        dest: /etc/systemd/system/node_exporter.service

    - name: Reload systemd daemon
      ansible.builtin.systemd:
        daemon_reload: yes

    - name: Start and enable node_exporter service
      ansible.builtin.service:
        name: node_exporter
        state: started
        enabled: yes
