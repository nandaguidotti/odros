#!/bin/bash

sleep 60
source /home/claudio/drone_ws/devel/setup.bash
gnome-terminal -- python3 /home/claudio/drone_ws/src/drone_system/scripts/request_path.py --pathplanning

#Matheus Vinicius G de Godoi
