# Creating a RAID Device
Create a brand new RAID device

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
    mdadm --create --verbose /dev/md0 --level=5 --raid-devices=2 /dev/sda /dev/sdc

    # Format the RAID array (xfs better for bigger files)
    mkfs.xfs -f /dev/md0

    # Mount to /mnt/raid
    mkdir -p /raid
    mount /dev/md0 /raid

    # Make RAID Persistend
    mdadm --detail --scan >> /etc/mdadm.conf
    echo "/dev/md0 /raid xfs defaults,nofail 0 2" | tee -a /etc/fstab

    # Ensure RAID is assembled on start
    echo "mdadm --assemble --scan" | tee -a /etc/local.d/mdadm.start
    chmod +x /etc/local.d/mdadm.start
    rc-update add local default
    ```

2. **IMPORTANT** - Wait for the rebuild to complete before processing. This is a multi hour process.
    - Check progress with `mdadm --detail /dev/md0`

3. Reboot then verify RAID setup
    - `mdadm -v --detail --scan`

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