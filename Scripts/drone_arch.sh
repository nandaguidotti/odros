#Veronica Vannini - 03/25/2019
#Install PX4 - Firmeware for SITL
#Create basic structure to UAV System - Death Star base

#dependencies
#sudo apt-get install python-prettytable
#install ros
#http://wiki.ros.org/kinetic/Installation/Ubuntu
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
sudo apt-get update
sudo apt install ros-melodic-desktop-full
sudo rosdep init
rosdep update
echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
source ~/.bashrc
sudo apt install python-rosinstall python-rosinstall-generator python-wstool build-essential
sudo apt install rosbash



#MAVRos
sudo apt-get install ros-melodic-mavros ros-melodic-mavros-extras
wget https://raw.githubusercontent.com/mavlink/mavros/master/mavros/scripts/install_geographiclib_datasets.sh
chmod +x install_geographiclib_datasets.sh
sudo ./install_geographiclib_datasets.sh
sudo apt install python-prettytable


#Firmware
#git clone https://github.com/vvannini/Firmware.git
source ubuntu_sim.sh

sudo apt install openjdk-8-jdk
sudo update-alternatives --config java # choose 8
rm -rf Tools/jMAVSim/out
sudo sed -i -e '/^assistive_technologies=/s/^/#/' /etc/java-*-openjdk/accessibility.properties

#qgroundcontrol
sudo usermod -a -G dialout $USER
sudo apt-get remove modemmannger -y
sudo apt install gstreamer1.0-plugins-bad gstreamer1.0-libav -y
#download appimg


#init installation of the sistem
mkdir -p ~/DeathStar_ws/src
cd  ~/DeathStar_ws
source /opt/ros/kinetic/setup.bash
catkin_make
cd src
#tarkin is who takes the decisions on this motherfuncker ship
catkin_create_pkg tarkin roscpp rospy std_msgs mavlink mavros mavros_msgs sensor_msgs geometry_msgs
cd  ~/DeathStar_ws
catkin_make
source ~/DeathStar_ws/devel/setup.bash
roscd tarkin
cd src
#git clone or wget codes: fire_Alderaan.cpp target_Alderann.cpp
cd ..
#git clone right CMakeLists.txt
cd  ~/DeathStar_ws
catkin_make
