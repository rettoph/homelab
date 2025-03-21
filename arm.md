# Automatic Ripping Machine
Guid to setting up Automatic Ripping machine for DVD ripping and such

THIS IS NOT A COMPLETED GUIDE FOLLOW AT YOUR OWN RISK

## Prerequisites
- [Setup](/Setup.md)
- [RAID](/RAID.md)
- [Docker](/Docker.md)

## Steps
1. Verify sudo
    - I already had sudo installed at this point in time but i dont think it comes with alpine by default. Instal it (and others) to be safe
    - `apk add sudo lscpu`
    
2. Add `wheel` user group to sudoers
    `echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/wheel`

3. Create `arm` user and add to `wheel` group
    ```sh
    adduser arm
    adduser arm wheel
    adduser arm docker
    adduser arm mediagroup
    ```

4. Switch to `arm` user
    - `su arm && cd ~`

5. Download `start_arm_container.sh`
    ```sh
    wget https://raw.githubusercontent.com/automatic-ripping-machine/automatic-ripping-machine/main/scripts/docker/start_arm_container.sh
    chmod +x start_arm_container.sh
    ```

6. Edit `start_arm_container.sh`
    - `nano start_arm_container.sh`
    - Change the `#!/bin/bash` to `#!/bin/sh`
    - Get and update the uid and gid
    - Update paths (replace `<path_to_xxxx_folder>`) - Ensure inserted paths exist. It might look like `/raid/media/Music:/home/arm/music`
    - List all `cd/dvd` drives with `lsscsi` and update the `--device` list
    - Update image name `automaticrippingmachine/automatic-ripping-machine:latest`

7. Run `./start_arm_container.sh`

8. Get port via `docker ps`

9. Go to address on local device to complete setup

10. From here on I highly recommend following along with [this video](https://www.youtube.com/watch?v=wPWx6GISIhY).
    - They used Debian based for a simpler setup. Follow along after [9:45](https://youtu.be/wPWx6GISIhY?si=uZGc5ShIYzZplKFx&t=585)
    - Graphics card too old :'(

11. As of 2025-03-20 [there is an error](https://github.com/automatic-ripping-machine/automatic-ripping-machine/issues/1324#issuecomment-2700144609) with an out dated version of MakeMKV in the docker file. Here is a non persistent fix (you will have to do this after every reboot or restart of the docker container)
    - `docker exec -it arm-rippers /bin/bash`
    - `cd / && ./install_makemkv.sh`

    makemkvcon -r info disc:9999
    makemkvcon reg M-9@CnzqkHeuO8cxJu12mXCe9UfpASWUhvE_zfZZf3JyyQNmpi5G4LoWSGEtGjouJis1