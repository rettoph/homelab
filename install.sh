environmentFile="/etc/profile.d/custom.g.sh"

beep

# Remove custom profile config if it exists
rm /etc/profile.d/environment.g.sh
echo "# Generated via https://github.com/rettoph/homelab/blob/main/install.sh on $(date +%Y%m%d)" >> $environmentFile
echo "# DO NOT EDIT DIRECTLY. This file will be overwritten next time the installer is ran." >> $environmentFile
echo "" >> $environmentFile

# Download nano & configure to be default editor
echo "Installing nano..."
apk add nano
echo "# Set nano as default text editor" >> $environmentFile
echo "export EDITOR=/usr/bin/nano" >> $environmentFile