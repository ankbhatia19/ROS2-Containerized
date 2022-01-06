# ROS2: Containerized

Created for and primarily used by Triton Robotics, a UCSD competitive robotics team.

### Features

* Fully modularized: Can be installed onto any system with the appropriate prerequisites
* Includes all dependencies required for base ROS2 development using [ROS2 Foxy Fitzroy](https://docs.ros.org/en/foxy/Releases/Release-Foxy-Fitzroy.html)
* Automated install, powered by Docker
* Ease of accessibility, powered by a custom Makefile

### Prerequisites:

1. [Docker](https://docs.docker.com/get-docker/)
   1. Install Docker using above link
   2. Ensure Docker is enabled to run on startup and added to the `docker` group. Restart your computer after running these commands:

      ```bash
      sudo systemctl enable docker.service
      sudo systemctl enable containerd.service
      sudo usermod -aG docker $USER
      ```
2. Make, which can be installed using `sudo apt install build-essential` on most Debian based systems.

### Setup Guide:

1. Clone this repo.

```sh
git clone https://github.com/ankbhatia19/ROS2-Containerized.git
```

2. `cd` into the newly created folder. Run `make all`.

### Usage

`cd` inside the ROS2-Containerized folder (Where the Makefile and Dockerfile files are located). The Makefile provides a set of commands available for ease of accessibility.

* `make help`: Prints out all commands available to use.
* `make container`: Creates a container which runs Ubuntu 21.04 LTS and has ROS2 and all dependencies installed. The container will stop running whenever your computer is shut down. Hence, `make container` will have to be manuallly run after computer startup **once** before usage. Re-running `make container` while a container is already running will delete the previous, running container and replace it with a new one.
* `make terminal`: "Teleports" you inside the ROS2 container, allowing you to access all ROS2 commands. This command can be run from many different instances of a terminal to access the same container, allowing you to run multiple nodes inside the same container. Many terminals, one container.
* `make clean`: Stops the container, if it is running.
* `make status`: Indicates whether the container is running or not.

### Workspaces

* All source code and ROS2 workspaces should be stored inside the `workspaces` folder.
  * This folder is synced across your host system and the ROS2 container.
  * This allows you to edit your code using your host OS and preferred IDE, and prevents code from being deleted when the container stops running.
* See [this tutorial](https://docs.ros.org/en/foxy/Tutorials/Workspace/Creating-A-Workspace.html) for more information on workspace management.

### Issues

Issues can be reported using the corresponding GitHub tab, or by contacting the developer using Discord at `zesty#9999`

Tested on: Ubuntu 18.04, Ubuntu 21.04, Fedora 35, and Arch Linux
