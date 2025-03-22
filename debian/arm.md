# Automatic Ripping Machine
Guid to setting up Automatic Ripping machine for DVD ripping and such
Essentially a copy of https://github.com/automatic-ripping-machine/automatic-ripping-machine/wiki/Docker-From-Source

THIS IS NOT A COMPLETED GUIDE FOLLOW AT YOUR OWN RISK

## Prerequisites
- [Setup](./Setup.md)
- [RAID](./RAID.md)
- [Docker](./Docker.md)

## Steps
1. Create arm user and setup groups [original](https://github.com/automatic-ripping-machine/automatic-ripping-machine/wiki/Docker-From-Source)
    - Do not switch to this user. Run everything as root.
    ```sh
    {
        # Create the arm group
        groupadd arm
        # Create the arm user
        useradd -m arm -g arm
        # Set the new arm users password
        passwd arm
        # Add the user to the cdrom,video groups
        usermod -aG cdrom,video arm
    }
    ```

2. Clone repo
    - `git clone https://github.com/automatic-ripping-machine/automatic-ripping-machine.git arm`
    - `cd arm`

3. Build container
    - `docker build -t local-automatic-ripping-machine .`

4. Create start script with the following
    - Update ARM_UID and ARM_GID with `id -u arm` and `id -g arm`
    - Add as many devices as you want
    - Update the paths to what you want
    - Update CPUs
    ```sh
    #!/bin/bash
    docker run -d \
        -p "8080:8080" \
        -e ARM_UID="1001" \
        -e ARM_GID="1001" \
        -v "/home/arm:/home/arm" \
        -v "/home/arm/music:/home/arm/music" \
        -v "/home/arm/logs:/home/arm/logs" \
        -v "/home/arm/media:/home/arm/media" \
        -v "/home/arm/config:/etc/arm/config" \
        --device="/dev/sr0:/dev/sr0" \
        --device="/dev/sr1:/dev/sr1" \
        --privileged \
        --restart "always" \
        --name "arm-rippers" \
        --cpuset-cpus="2-7" \
        automaticrippingmachine/automatic-ripping-machine:latest
    ```

5. After running you should be able to visit your server host ip at port 8080 to complete the web instalation
    - As of 2025-03-20 the settings page is a bit buggy and you may need to manually edit the `~/config/arm.yaml` file
        - `MAKEMKV_PERMA_KEY` => If you have one ($60). Worth it - beta key doesnt have 100% up time
        - `OMDB_API_KEY` => Also worth it ($1). Same thing - free key doesnt always work.
        - After updating the config file restart docker container `docker restart arm-rippers`

