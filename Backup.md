# Automatic Ripping Machine
Guid to setting up Automatic Ripping machine for DVD ripping and such

## Prerequisites
- [Setup](/Setup.md)
- [RAID](/RAID.md)
- [Docker](/Docker.md)

## Steps
1. Install & Configure backup storage device
    - I just have a dedicated flashdrive at `/dev/sdh`
    - `echo "/dev/sdh1 /backups exfat defaults,nofail 0 2" | tee -a /etc/fstab`
    - `rebot`
    - Ensure `/backups` exists
1. Save backup
    ```sh
    tar -czvf /backups/backup_$(date +"%Y-%m-%d_%H-%M").tar.gz \
        --exclude=dev \
        --exclude=mnt \
        --exclude=proc \
        --exclude=sys \
        --exclude=tmp \
        --exclude=media \
        --exclude=lost+found \
        --exclude=raid \
        --exclude=backups \
        -C / .
    ```

# Restore Backup
Guide to backing system up. Mostly stolen from https://askubuntu.com/questions/7809/how-to-back-up-my-entire-system

## Prerequisites
- [Create Backup](#create-backup)

## Steps
1. Boot via USB, mount the bad system under /mnt and then run
    ```sh
    tar xf /path/to/drive/with/backup.tar.gz -C /mnt
    ```
