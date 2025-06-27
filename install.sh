#!/bin/bash

directory=$(pwd)
echo "OpenLWS Ordner in /etc erstelln."
sudo mkdir /etc/OpenLWS

echo "Scripte nach /etc/OpenLWS kopieren"
cp $directory/OpenLWS.sh /etc/OpenLWS/OpenLWS.sh
cp $directory/OpenLWS.py /etc/OpenLWS/OpenLWS.py
cp $directory/OpenLWS-Welcome.sh /etc/OpenLWS/OpenLWS-Welcome.sh


echo "Print Script (/etc/OpenLWS/OpenLWS.sh) berechtigen."
sudo chmod 775 /etc/OpenLWS/OpenLWS.sh
echo "Python Script (etc/OpenLWS/OpenLWS.py) berechtigen."
sudo chmod 775 /etc/OpenLWS/OpenLWS.py
echo "Welcome Script (/etc/OpenLWS/OpenLWS-Welcome.sh) berechtigen."
sudo chmod 775 /etc/OpenLWS/OpenLWS-Welcome.sh

echo "Update & Upgrade"
sudo apt-get update && sudo apt-get upgrade -y

echo "Installation von Python3"
sudo apt -y install python3.13

echo "Installation von PIP"
sudo apt -y install python3-pip

echo "Installation raspi-config"
sudo apt -y install raspi-config

echo "Installation der Python Module"
sudo pip3 install adafruit-blinka --break-system-packages
sudo pip3 install adafruit-circuitpython-vl6180x --break-system-packages

echo "Aktivierung des I2C Moduls"
sudo raspi-config nonint do_i2c 0

sudo cp $directory/OpenLWS.service /etc/systemd/system/OpenLWS.service
sudo chmod 755 /etc/systemd/system/OpenLWS.service
sudo systemctl daemon-reload
sudo systemctl enable OpenLWS.service
sudo service OpenLWS start
sudo echo "dtoverlay=gpio-shutdown,gpio_pin=18 >> /boot/firmware/config.txt
echo "Installation abgeschlossen. Neustart"

sudo reboot
