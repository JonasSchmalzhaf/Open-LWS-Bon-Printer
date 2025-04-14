#!/bin/bash

# Setzen der Berechtigungen für den Seriellen Drucker Port
sudo chmod o+rw /dev/usb/lp0 # Set Printer Serial Connectin Privilegs

# Konfiguration der Textausrichtung, Schrifftgröße, etc.
echo -e "\x1b\x74\x00\x1b\x61\x01\x1d\x21\x11" > /dev/usb/lp0
echo -e "SIT Lehrwerkstatt" > /dev/usb/lp0
#Druck leere Zeile
echo -e "\x0a" > /dev/usb/lp0
echo -e "Drucker Status: l\x84uft" > /dev/usb/lp0

echo -e "\x0a" > /dev/usb/lp0

# Druck: |e@rn t0gethe gr#w +ogeth<r
echo -e "\xb3e\x40rn" > /dev/usb/lp0
echo -e "t0gethe\xaa" > /dev/usb/lp0
echo -e "gr#w" > /dev/usb/lp0
echo -e "+ogeth<r" > /dev/usb/lp0
# Druck mehrere leerer Zeilen und schneiden des Papiers
echo -e "\x0a\x0a\x0a\x0a\x1d\x56\x42\x00" > /dev/usb/lp0
