# Configure GPU Drivers
My hardware is running with a GTX 970. We need to install Nouveau drivers.

## Prerequisites
- [Setup](/Setup.md)

## Steps
1. Install drivers
    ```sh
    {
        # Download and install packages
        apk add mesa-dri-gallium xf86-video-nouveau mesa-utils

        # Load module
        modprobe nouveau

        # Ensure Nouveau loads on startup
        echo "nouveau" >> /etc/modules

        reboot
    }
    ```

2. Edit `/etc/default/grub`
    - Add `nomodeset nouveau.modeset=1 i915.modeset=0` to `GRUB_CMDLINE_LINUX_DEFAULT`. No comma, just space
        - The `nomodeset` kernel parameter tells the Linux kernel to disable the loading of display drivers
        - The `nouveau` driver is an open-source driver for NVIDIA graphics cards. The `modeset=1` parameter enables mode setting for the nouveau driver.
        - The `i915` driver is used for Intel integrated graphics. The `modeset=0` parameter disables the mode setting for the Intel GPU.
        - The final line might look something like:
            ```sh
            GRUB_CMDLINE_LINUX_DEFAULT="modules=sd-mod,usb-storage,ext4 quiet rootfstype=ext4 nomodeset nouveau.modeset=1 i915.modeset=0"
            ```

3. Verify module
    - `lsmod | grep nouveau`
    - `ls /dev/dri/` - We should see `card0`
    - `lspci | grep -i nvidia` - Should see the graphics card printed

4. *Not to self:* Be sure you connect power to the graphics card next time...

