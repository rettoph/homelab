# Setup
Default system configurations I like.

Note: Several blocks in this guide are wrapped with brackets `{}`. This is by design. Include them when copy/pasting to the terminal.

## Steps
1. Upgrade packages and add reboot `beep`:
    ```sh
    {
        # Update and upgrade packages
        # If you forget to grant internet access to your server before running this try clearing apt cache via
        # sudo rm /var/lib/apt/lists/*_*
        apt update && apt upgrade

        # Add beep on reboot
        echo "@reboot beep" | crontab -

        # Install nano and set as default editor
        echo "export EDITOR=/usr/bin/nano" >> "/etc/profile.d/environment.g.sh"
    }
    ```

2. Recommended Next Steps: [SSH](/SSH.md)

