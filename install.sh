environmentFile="/etc/profile.d/environment.g.sh"
environmentFileExists=false

# Begin Define Helper Methods
update_or_add_line_matching_pattern()
{
    local pattern="$1"
    local new="$1$2"
    local file="$3"

    echo $pattern
    echo $new
    echo $file

    if grep -q "$pattern" "$file"; then # Find and replace the line
        sed -i "/$pattern/c\\$new" "$file"
    else # Add a new line if the pattern is not found
        echo "$new" >> "$file"
    fi
}

write_if_false()
{
    if [ "$3" = false ]; then
        echo "$1" >> "$2"
    fi
}

# End Define Helper MEthods

beep

# Create environmentFile if it does not exist
if [[ -f $environmentFile ]]; then
    echo "'$environmentFile' already exists."
    environmentFileExists=true
else
    echo "'$environmentFile' not found. Creating..."
    echo "# Generated via https://github.com/rettoph/homelab/blob/main/install.sh" >> $environmentFile
    echo "# DO NOT EDIT DIRECTLY. This file will be overwritten next time the installer is ran." >> $environmentFile
    echo "" >> $environmentFile
fi

# Download and configure nano
echo "Installing nano..."
apk add nano
write_if_false "# Set nano as default text editor" $environmentFile $environmentFileExists
update_or_add_line_matching_pattern "export EDITOR=" "/usr/bin/nano" $environmentFile