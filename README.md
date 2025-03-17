# homelab
Setup scripts to easily spin up new modules of my personal homelab

---

## Run via
`wget -O install.sh https://raw.githubusercontent.com/rettoph/homelab/refs/heads/main/install.sh && chmod +x ./install.sh && ./install.sh`

## After running
- Copy the generated ssh key to your local machine
- Disable ssh via password:
  - edit `/etc/ssh/sshd_config`
    - `PasswordAuthentication no`
    - `PubkeyAuthentication yes`
  - `service sshd restart`