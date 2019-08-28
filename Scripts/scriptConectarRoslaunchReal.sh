#!/bin/bash

source /home/claudio/drone_ws/devel/setup.bash
gnome-terminal -- /opt/ros/melodic/bin/roslaunch mavros px4.launch fcu_url:=/dev/$1:57600
#ttyUSB0

#Matheus Vinicius G de Godoi
