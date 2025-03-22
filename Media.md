https://www.reddit.com/r/Piracy/comments/ma1hlm/the_complete_guide_to_building_your_own_personal/

How to connect the RAID server to the Download server?

We have to mount it. Raid should already have SMB (Samba) so we just need a client on the download server

1. Setup the client
2. Mount the network drive
3. Set network drive as download location

```sh

sudo apt update
sudo apt install cifs-utils

sudo mkdir -p /mnt/media

sudo mount -t cifs //soraka.retto.ph/media /mnt/media -o username={USER},password={PASSWORD}

# TO be persistend edit /etc/fstab and add
//192.168.x.x/sharename /mnt/media cifs username={USER},password={PASSWORD} 0 0
```

If we create folders elsewhere we will likely run into a perms issue on the system
chown -R 1000:1000 /mnt/media
chmod -R 750 /mnt/media