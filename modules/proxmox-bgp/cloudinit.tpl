#cloud-config
preserve_hostname: false
hostname: ${hostname}
users:
  - name: ${user}
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    ssh-authorized-keys:
%{ for key in ssh_keys }
      - ${key}
%{ endfor }
package_update: true
packages:
  - qemu-guest-agent
runcmd:
  - [ sh, -c, "echo 'cloud-init finished for ${hostname}' > /var/log/cloud-init-complete ]
