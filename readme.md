# PX-Autopilot DockerScript
- Ubuntu: Bionic
- ROS: Melodic
- PX4: 1.13.0

### Build a docker image
```
sh build.sh
```
### Run a container
```
sh run.sh
```


### Move to the PX4 directory
```
cd /root/PX4-Autopilot
```
### Set environment variables
```
export LANG=C.UTF-8
export LC_ALL=C.UTF-8
```
### Make a default iris model
```
make px4_sitl_default gazebo
```
