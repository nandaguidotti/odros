#!/bin/bash

sleep 5
source /home/claudio/drone_ws/devel/setup.bash
gnome-terminal --working-directory=/home/claudio/drone_ws/src/planners/scripts/genetic_pathplanning -- python3 ros_genetic_server.py

#Matheus Vinicius G de Godoi
