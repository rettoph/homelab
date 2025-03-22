# Configure docker
Create a brand new RAID device

## Prerequisites
- [Setup](/Setup.md) - Docker requires community packages

## Steps
1. Install
    ```sh
    # Add Docker's official GPG key:
    sudo apt-get update
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    ```

    ```sh
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    ```

2. Ensure docker restarts on boot
    - TODO: Insert this

2. To reset all docker data
    ```sh
    {
        docker rm -vf $(docker ps -aq) # Remove containers
        docker system prune -af # Remove everything else
    }
    ```

4. To watch logs
    - `docker logs --tail 50 --follow --timestamps container-name`
