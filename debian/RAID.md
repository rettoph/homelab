# Creating a RAID Device
Create a brand new RAID device.

Here are some optional steps that might speed things up idk

https://baptiste-wicht.com/posts/2015/03/how-to-speed-up-raid-5-6-growing-with-mdadm.html

## Prerequisites
- [SSH](./SSH.md)

## Steps
1. Update and run the following
    ```sh
    # Download required packages
    apt install mdadm xfsprogs

    # Create the raid array
    # This is hard coded for my current computer hardware. If the 
    # drives are changed or moved remember to update the devices
    # list drives with `lsblk`
    mdadm --create --verbose /dev/md0 --level=5 --raid-devices=3 /dev/sda /dev/sdb /dev/sdd
    ```
2. **IMPORTANT** - Wait for the rebuild to complete before processing. This is a multi hour process.
    - Check progress with `mdadm --detail /dev/md0`
    - Watch progress with `watch cat /proc/mdstat`
    ```sh
    # Format the RAID array (xfs better for bigger files)
    mkfs.xfs -f /dev/md0

    # Mount to /mnt/raid
    mkdir -p /mnt/raid
    chown nobody:nogroup /mnt/raid
    chmod 775 /mnt/raid
    mount /dev/md0 /mnt/raid

    # Make RAID Persistend
    mdadm --detail --scan >> /etc/mdadm.conf

    # Get the UUID 
    blkid /dev/md0

    echo "UUID={YOUR-DEVICE-UUID} /mnt/raid xfs defaults,nofail 0 2" | tee -a /etc/fstab
    ```

3. Reboot then verify RAID setup
    - `mdadm -v --detail --scan`

4. Make the RAID mount point a valid shared network folder
    - `apt install samba`

5. Edit `/etc/samba/smb.conf`
    - Find `[global]` and update
        - Update `workgroup` (default for my windows machine seems to be `WORKGROUP`)
        - Add 
            ```
            logon home = /mnt/raid/users/%U
            security = user
            guest ok = no
            null passwords = no
            read only = no
            ```

    - Find `[homes]` and update
        - Add
            ```
            path = /mnt/raid/users/%U
            ```

    - Add a new share to the end of the file:
        ```
        [media]
           path = /mnt/raid/media
           valid users = @media
           read only = no
           guest ok = no
           force group = media
           create mask = 0770
           directory mask = 0770
           security = user
        ```

6. Start and enable samba by default
    ```sh
    {
        # Create media folder and set perms
        mkdir /mnt/raid/media
        groupadd media
        chown :media /mnt/raid/media
        chmod 770 /mnt/raid/media

        systemctl enable samba
    }
    ```

7. Add a new user
    ```sh
    {
        echo "Enter new user's name:"
        read name

        # Create user
        useradd $name
        passwd $name
        smbpasswd -a $name

        # Create folder and set permissions
        mkdir /mnt/raid/users/$name
        chown -R $name:$name /mnt/raid/users/$name
        usermod -aG media $name
    }
    ```

8. Update user password
    ```sh
    {
        echo "Enter user's name:"
        read name

        passwd $name
        smbpasswd -x $name
        smbpasswd -a $name

        systemctl restart samba
    }
    ```
    - If updating the password does not work, try running `net use * /delete` on windows to clear your credentials.
    - If windows still wont connect try looking for a samba entry in credential manager and delete it

# Expanding an existing RAID Device
Add drives to an existing RAID device

## Prerequisites
- [Creating a RAID Device](#creating-a-raid-device)

## Steps
1. Add a new drive to existing RAID. Update `/dev/sbX` with your new drive(s) 
    ```sh
    {
        # Replace /dev/sdX with your drive
        mdadm --add /dev/md0 /dev/sdX

        # Replace XXX with the new total number of drives in the array.
        mdadm --grow --raid-devices=XXX /dev/md0
    }
    ```

2. **IMPORTANT** - Wait for the reshape to complete before processing. This is a multi hour process.
    - Check progress with `mdadm --detail /dev/md0`