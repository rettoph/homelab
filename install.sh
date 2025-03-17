environmentFile="/etc/profile.d/environment.g.sh"
sshKeyPath="~/.ssh/id_ed25519"
sshKeyPhrase=""

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

# Generate ssh keys
echo "Generating SSH Key..."
ssh-keygen -t ed25519 -C "$(whoami)@$(hostname)" -f $sshKeyPath -N $sshKeyPhrase

# Copy new key to authorized_keys file
cat "$sshKeyPath.pub >> ~/.ssh/authorized_keys
