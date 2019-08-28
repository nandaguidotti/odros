#!/bin/bash

source /home/claudio/drone_ws/devel/setup.bash
gnome-terminal -- /opt/ros/melodic/bin/roslaunch mavros px4.launch fcu_url:="udp://:14540@127.0.0.1:14557"
#/opt/ros/melodic/bin/roslaunch mavros px4.launch fcu_url:="$URL"

#Matheus Vinicius G de Godoi


