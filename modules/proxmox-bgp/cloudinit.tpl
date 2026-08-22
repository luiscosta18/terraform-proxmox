#cloud-config

preserve_hostname: false

hostname: ${hostname}

users:
  - name: ${user}
    groups:
      - sudo
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    lock_passwd: false
    plain_text_passwd: ${password}

ssh_pwauth: true

package_update: true

packages:
  - qemu-guest-agent

runcmd:
  - systemctl enable qemu-guest-agent
  - systemctl start qemu-guest-agent
  - [sh, -c, "echo 'cloud-init finished for ${hostname}' > /var/log/cloud-init-complete"]
