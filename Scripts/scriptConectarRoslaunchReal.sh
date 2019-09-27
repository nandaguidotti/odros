#!/bin/bash

source /home/claudio/drone_ws/devel/setup.bash
gnome-terminal -- /opt/ros/melodic/bin/roslaunch mavros px4.launch fcu_url:=$1:57600
#/dev/ttyUSB0

#Matheus Vinicius G de Godoi
