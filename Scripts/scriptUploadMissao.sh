#!/bin/bash

source /home/claudio/drone_ws/devel/setup.bash
gnome-terminal -- /opt/ros/melodic/bin/rosrun mavros mavwp load $1
	
#Matheus Vinicius G de Godoi
