# Use the official Ubuntu Bionic as a parent image
FROM ubuntu:bionic

# Set maintainer label
LABEL maintainer="godhj@unist.ac.kr"

# Set environment variables to non-interactive (this prevents some prompts)
ENV DEBIAN_FRONTEND=noninteractive

# Run package updates and install packages
RUN apt-get update \
    && apt-get install -y \
    curl \
    wget \
    git \
    vim \
    nano \
    lsb-release \
    lsb-core \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Add ROS repository and install ROS Melodic
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' \
    && curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add - \
    && apt-get update \
    && apt-get install -y ros-melodic-desktop

# Set up ROS environment and install additional tools
RUN echo "source /opt/ros/melodic/setup.bash" >> /root/.bashrc

RUN /bin/bash -c "source /opt/ros/melodic/setup.bash" \
    && apt-get install -y python-rosdep python-rosinstall python-rosinstall-generator python-wstool build-essential

RUN apt-get install -y python-rosdep

RUN rosdep init \
    && rosdep update

RUN apt-get update
RUN apt install -y ros-melodic-gazebo-ros
RUN apt upgrade -y libignition-math2
RUN apt install -y ros-melodic-mavros*
RUN apt install -y ros-melodic-serial
RUN apt install -y python3-catkin-tools
RUN /opt/ros/melodic/lib/mavros/install_geographiclib_datasets.sh


# Set the working directory in the container
WORKDIR /root/

# Clone PX4-Autopilot repository and run the setup script
RUN git clone -b v1.13.0 https://github.com/PX4/PX4-Autopilot.git --recursive
RUN /bin/bash /root/PX4-Autopilot/Tools/setup/ubuntu.sh

# Set environment variables for locale
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# Add the content to .bashrc
RUN echo "source /root/PX4-Autopilot/Tools/setup_gazebo.bash /root/PX4-Autopilot /root/PX4-Autopilot/build/px4_s$" >> /root/.bashrc \
    && echo "export ROS_PACKAGE_PATH=\$ROS_PACKAGE_PATH:/root/PX4-Autopilot:/root/PX4-Autopilot/Tools/sitl_gazebo" >> /root/.bashrc

# Specify the command to run on container start
CMD ["/bin/bash"]
