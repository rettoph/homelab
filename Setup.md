# Setup
Default system configurations I like.

Note: Several blocks in this guide are wrapped with brackets `{}`. This is by design. Include them when copy/pasting to the terminal.

## Steps
1. Upgrade packages and add reboot `beep`:
    ```sh
    {
        # Update and upgrade packages
        apk update && apk upgrade

        # Add beep on reboot
        echo "@reboot beep" | crontab -

        # Install nano and set as default editor
        apk add nano
        echo "export EDITOR=/usr/bin/nano" >> "/etc/profile.d/environment.g.sh"
    }
    ```

2. Edit `/etc/apk/repositories` and uncomment community packages

3. Recommended Next Steps: [SSH](/SSH.md)

