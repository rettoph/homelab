environmentFile="/etc/profile.d/environment.g.sh"

beep

# Remove any existing generated file
rm $environmentFile
echo "# Generated via https://github.com/rettoph/homelab/blob/main/install.sh" >> $environmentFile
echo "# DO NOT EDIT DIRECTLY. This file will be overwritten next time the installer is ran." >> $environmentFile
echo "" >> $environmentFile

# Update and upgrade apk
apk update
apk upgrade

# Download and configure nano
echo "Installing nano..."
apk add nano
echo "# Set nano as default text editor" >> $environmentFile
echo "export EDITOR=" "/usr/bin/nano" >> $environmentFile
echo "" >> $environmentFile

beep