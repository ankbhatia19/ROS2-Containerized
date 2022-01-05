FROM ros:foxy-ros-base-focal

# install ros2 foxy package group
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-foxy-desktop \
    && rm -rf /var/lib/apt/lists/*

# install nav2 dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-foxy-joint-state-publisher-gui \
    ros-foxy-xacro \
    ros-foxy-gazebo-ros-pkgs \
    ros-foxy-robot-localization \ 
    && rm -rf /var/lib/apt/lists/*

# install nav2 packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-foxy-navigation2 \
    ros-foxy-nav2-bringup \
    && rm -rf /var/lib/apt/lists/*

# install miscellaneous ros2 packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-foxy-joy-linux \
    ros-foxy-realsense2-camera \
    ros-foxy-cartographer-ros \
    && rm -rf /var/lib/apt/lists/*

# install some text editors
RUN apt-get update && apt-get install -y --no-install-recommends \
    vim \
    nano \
    gedit \
    && rm -rf /var/lib/apt/lists/*

# miscellaneous installs
RUN apt-get update && apt-get install -y --no-install-recommends \
    neofetch \
    && rm -rf /var/lib/apt/lists/*

# source setup.bash for each new terminal
RUN printf "\nsource /opt/ros/\$ROS_DISTRO/setup.bash\n" >> ~/.bashrc

# ummmmm
RUN printf "neofetch\n" >> ~/.bashrc

# print welcome message
RUN printf "printf \"Entered ROS2 container: Use <ros2 -h> to see available commands.\n\n\"" >> ~/.bashrc

# Enter workspace
WORKDIR /root/workspaces
