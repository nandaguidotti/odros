#!/bin/bash

cd ~/src/Firmware/ && export PX4_HOME_LAT=-22.002178 && export PX4_HOME_LON=-47.932588 && export PX4_HOME_ALT=847.142652 && export NAV_RCL_ACT=0 && make px4_sitl jmavsim

#Matheus Vinicius G de Godoi

