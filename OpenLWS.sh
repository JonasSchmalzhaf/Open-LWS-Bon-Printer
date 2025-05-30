#!/bin/bash

# Setzen der Berechtigungen für den Seriellen Drucker Port
sudo chmod o+rw /dev/usb/lp0 # Set Printer Serial Connectin Privilegs

# Löschen des vorherigen Zitats
sudo rm /etc/OpenLWS/quote

# Speichern des neuen Zitats
cd /etc/OpenLWS/
sudo wget https://api.zitat-service.de/v1/quote

# Auslesen des Zitats und des Autors aus JSON Datensatz
quote=$(cat /etc/OpenLWS/quote | grep -oP '"quote":"\K[^"]+')
author=$(cat /etc/OpenLWS/quote | grep -oP '"authorName":"\K[^"]+')

echo "$quote"
echo "$author"

# Einfügen von Zeichen umbrüchen nach 24 Zeichen
for ((i=24; i < ${#quote}; i=i+24)); do
	if [[ ${quote:i:1} != " " ]]
	then
		for ((j=i-1; j > 0; j--)); do
			if [[ ${quote:j:1} == " " ]]; then
				echo "Line Break at Line $j"
				quote=$(echo ${quote:0:j}"#"${quote:j+1})
				i=$(( $j ))
				break
			fi
		done
	else
		quote=$(echo ${quote:0:i}"#"${quote:i+1})
	fi
done

# Ersetzen der Sonerzeichen durch entsprechende Hex-Codes
quote=$(echo "$quote" | sed 's/ä/\x84/g')
quote=$(echo "$quote" | sed 's/ü/\x81/g')
quote=$(echo "$quote" | sed 's/ö/\x94/g')
quote=$(echo "$quote" | sed 's/Ä/\x8E/g')
quote=$(echo "$quote" | sed 's/Ü/\x9A/g')
quote=$(echo "$quote" | sed 's/Ö/\x99/g')
quote=$(echo "$quote" | sed 's/ß/\xE1/g')
quote=$(echo "$quote" | sed 's/#/\x0A/g')

author=$(echo "$author" | sed 's/ä/\x84/g')
author=$(echo "$author" | sed 's/ü/\x81/g')
author=$(echo "$author" | sed 's/ö/\x94/g')
author=$(echo "$author" | sed 's/Ä/\x8E/g')
author=$(echo "$author" | sed 's/Ü/\x9A/g')
author=$(echo "$author" | sed 's/Ö/\x99/g')
author=$(echo "$author" | sed 's/ß/\xE1/g')
author=$(echo "$author" | sed 's/#/\x0A/g')
# Konfiguration der Textausrichtung, Schrifftgröße, etc.
echo -e "\x1b\x74\x00\x1b\x61\x01\x1d\x21\x11" > /dev/usb/lp0
echo -e "\x1b\x2d\x02" > /dev/usb/lp0
echo -e "SIT Lehrwerkstatt\x0a" > /dev/usb/lp0
echo -e "\x1b\x2d\x00" > /dev/usb/lp0
# Druck einer leeren Zeile bzw. eines Zeilenumbruchs
echo -e "\x0A" > /dev/usb/lp0
# Druck des Zitats (mit korrekten Zeilenumbrüchen und Sonderzeichen
echo -e "$quote" > /dev/usb/lp0
echo -e "\x0A" > /dev/usb/lp0
# Druck des Autors
echo "$author" >  /dev/usb/lp0
echo -e "\x0a" > /dev/usb/lp0
# Druck: |e@rn t0gethe gr#w +ogeth<r
echo -e "\xb3e\x40rn" > /dev/usb/lp0
echo -e "t0gethe\xaa" > /dev/usb/lp0
echo -e "gr#w" > /dev/usb/lp0
echo -e "+ogeth<r" > /dev/usb/lp0
# Druck mehrere leerer Zeilen und Schnitt des Papiers
echo -e "\x0a\x0a\x0a\x0a\x1d\x56\x42\x00" > /dev/usb/lp0
