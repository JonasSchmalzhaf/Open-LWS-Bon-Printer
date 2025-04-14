#!/bin/bash

echo "Rechte für Scripte vergeben"
sudo chmod 775 ./OpenLWS.sh
sudo chmod 775 ./OpenLWS.py
sudo chmod 775 ./OpenLWS-Welcome.sh

sudo mv ./OpenLWS.service /etc/systemd/system/OpenLWS.service
sudo chmod 755 /etc/systemd/system/OpenLWS.service
sudo service OpenLWS start
echo "Installation abgeschlossen. Programm gestartet"
