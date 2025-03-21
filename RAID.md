# Creating a RAID Device
Create a brand new RAID device.

Here are some optional steps that might speed things up idk

https://baptiste-wicht.com/posts/2015/03/how-to-speed-up-raid-5-6-growing-with-mdadm.html

## Prerequisites
- [SSH](/SSH.md)

## Steps
1. Update and run the following
    ```sh
    # Download required packages
    apk add lsblk mdadm xfsprogs

    # Create the raid array
    # This is hard coded for my current computer hardware. If the 
    # drives are changed or moved remember to update the devices
    # list drives with `lsblk`
    mdadm --create --verbose /dev/md0 --level=5 --raid-devices=2 /dev/sda /dev/sdc /dev/sdh

    # Format the RAID array (xfs better for bigger files)
    mkfs.xfs -f /dev/md0

    # Mount to /raid
    mkdir -p /raid
    chown nobody:nogroup /raid
    chmod 775 /raid
    mount /dev/md0 /raid

    # Make RAID Persistend
    mdadm --detail --scan >> /etc/mdadm.conf
    echo "/dev/md0 /raid xfs defaults,nofail 0 2" | tee -a /etc/fstab

    # Ensure RAID is assembled on start
    rc-update add mdadm boot
    rc-update add mdadm-raid boot
    ```

2. **IMPORTANT** - Wait for the rebuild to complete before processing. This is a multi hour process.
    - Check progress with `mdadm --detail /dev/md0`
    - Watch progress with `watch cat /proc/mdstat`

3. Reboot then verify RAID setup
    - `mdadm -v --detail --scan`

4. At this point the mount fight fail. On boot you might see an error indicating `/dev/md0` not found. This is because `localmount` runs before `mdadm` on boot and i've not found a good way to change that. Here is my best solution...
    - Replace `/etc/init.d/mdadm` with
        ```sh
        #!/sbin/openrc-run

        NAME=mdadm
        DAEMON=/sbin/$NAME

        depend() {
                before localmount
        }

        start() {
                ebegin "Starting ${NAME}"
                        start-stop-daemon --start --quiet --background \
                                --exec ${DAEMON} -- \
                                --monitor --scan \
                                --daemonise ${OPTS}
                eend $?
        }
        ```
    - This adds localmount to the before script, ensuring raid is assembled before mounting.
    - This removes net and dns requirnments from mdadm. I dont use networking so i think thats okay.
    - So far, no issues and `/raid` is succesfully mounted on boot

4. Make the RAID mount point a valid shared network folder
    - `apk add samba`

5. Edit `/etc/samba/smb.conf`
    - Find `[global]` and update
        - Update `workgroup` (default for my windows machine seems to be `WORKGROUP`)
        - Add 
            ```
            logon home = /raid/users/%U
            security = user
            guest ok = no
            null passwords = no
            ```

    - Find `[homes]` and update
        - Add
            ```
            path = /raid/users/%U
            ```

    - Add a new share to the end of the file:
        ```
        [media]
           path = /raid/media
           valid users = @mediagroup
           read only = no
           guest ok = no
           force group = mediagroup
           create mask = 0770
           directory mask = 0770
           security = user
        ```

6. Start and enable samba by default
    ```sh
    {
        # Create media folder and set perms
        mkdir /raid/media
        addgroup mediagroup
        chown :mediagroup /raid/media
        chmod 770 /raid/media

        rc-service samba start
        rc-update add samba default
    }
    ```

7. Add a new user
    ```sh
    {
        echo "Enter new user's name:"
        read name

        # Create user
        adduser $name
        smbpasswd -a $name

        # Create folder and set permissions
        mkdir /raid/users/$name
        chown -R $name:$name /raid/users/$name
        adduser $name mediagroup
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

        rc-service samba restart
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