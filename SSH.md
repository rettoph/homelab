# Generating and Consuming SSH Keys
Generate a new SSH Key on the system and walk through on how to require SSH login.

## Prerequisites
- [Setup](/SETUP.md)

## Steps
1. On the Server run:
    ```sh
    {
        # Read SSH Key inputs
        echo "Generating SSH Key..."
        default_ssh_key_comment="$(whoami)@$(hostname)"
        default_ssh_key_file=~/.ssh/id_ed25519

        read -p "Enter SSH Key comment [$default_ssh_key_comment]: " ssh_key_comment
        ssh_key_comment=${name:-$default_ssh_key_comment}

        read -p "Enter SSH Key file [$default_ssh_key_file]: " ssh_key_file
        ssh_key_file=${name:-$default_ssh_key_file}

        read -p "Enter SSH Key phrase []: " ssh_key_phrase

        # Generate SSH Key
        ssh-keygen -t ed25519 -C $ssh_key_comment -f $ssh_key_file -N "$ssh_key_phrase"

        # Add SSH Key to authorized_keys file
        cat $ssh_key_file.pub >> ~/.ssh/authorized_keys

        echo "SSH Key has been generated. Copy '$ssh_key_file' to your local machine."
    }
    ```
2. Copy your SSH Key from the server to your local machine

3. Edit `~/.ssh/config` on the client and add config
    ```markup
    Host soraka
        HostName soraka.retto.ph
        User root
        IdentityFile ~/.ssh/id_ed25519
    ```

4. Edit `/etc/ssh/sshd_config` on the server
    - `PasswordAuthentication no`
    - `PubkeyAuthentication yes`

6. Reboot server

7. Wait for `beep` then log back on via `ssh soraka`