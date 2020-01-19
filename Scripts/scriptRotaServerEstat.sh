#!/bin/bash

sleep 5
source /home/claudio/drone_ws/devel/setup.bash
gnome-terminal --working-directory=/home/claudio/drone_ws/src/drone_system/scripts/static_pathplanning -- python3 main.py

#Matheus Vinicius G de Godoi
