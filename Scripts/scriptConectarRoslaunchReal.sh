#!/bin/bash

source /home/claudio/drone_ws/devel/setup.bash
gnome-terminal -- /opt/ros/melodic/bin/roslaunch mavros px4.launch fcu_url:=$1:57600
sleep 5
gnome-terminal -- /opt/ros/melodic/bin/rosservice call /mavros/set_stream_rate 0 10 1
#/dev/ttyUSB0

#Matheus Vinicius G de Godoi
