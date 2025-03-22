# Generating and Consuming SSH Keys
Generate a new SSH Key on the system and walk through on how to require SSH login.

## Prerequisites
- [Setup](/Setup.md)

## Steps
1. The default server setup has a few settings that disable password authentication. With the physical device edit `/etc/ssh/sshd_config`
    - `PasswordAuthentication yes`
    - `PubkeyAuthentication no`
    - `PermitRootLogin yes` - Only if you want to use root
    - `# UsePAM yes`

2. SSH into the server with your local device and run
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

3. Copy your SSH Key from the server to your local machine. If you are copy/pasting the key content manually make sure you have a new line at the end.
    - Forgetting the new line may cause a `invalid format` when you attempt to connect

4. Edit `~/.ssh/config` on the client and add config
    ```markup
    Host soraka
        HostName soraka.retto.ph
        User root
        IdentityFile ~/.ssh/id_ed25519
    ```

5. Edit `/etc/ssh/sshd_config` on the server
    - `PasswordAuthentication no`
    - `PubkeyAuthentication yes`

6. Reboot ssh service
    - `systemctl restart ssh.service`

8. Recommended Next Steps: [RAID](./RAID.md)