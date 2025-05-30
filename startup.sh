#!/bin/bash
sudo chmod o+rw /dev/usb/lp0

ssid=$(iwgetid)
mac=$(ifconfig wlan0 | grep -Eo ..\(\:..\){5})
ip=$(hostname -I)
timeout=6

echo -e "Connecting...\x0a" > /dev/usb/lp0

counter=0
while [ $(wget -q --spider http://google.com; echo $?) != 0 ]
do
	if (($counter > $timeout))
	then
		echo -e "Timeout.\x0a" > /dev/usb/lp0
		break
	fi

	(($counter++))

	sleep 1
	echo -e ".\x0a" > /dev/usb/lp0
done

echo -e "\x0a" > /dev/usb/lp0

if [ $(wget -q --spider http://google.com; echo $?) == 0 ]
then
	echo -e "Connected.\x0a" > /dev/usb/lp0
	echo -e "IP: $(hostname -I)\x0a" > /dev/usb/lp0
fi

sleep 30

echo -e "\x0a SSID: \x0a" > /dev/usb/lp0
echo -e "$(iwgetid)\x0a\x0a" > /dev/usb/lp0
echo -e "Mac: $(ifconfig wlan0 | grep -Eo ..\(\:..\){5})" > /dev/usb/lp0



#echo -e "\x0a\x0a\x0a\x0a" > /dev/usb/lp0
#echo -e $(ifconfig eth0 | grep -Eo ..\(\:..\){5}) > /dev/usb/lp0
echo -e "\x0a\x0a\x0a\x0a\x1d\x56\x42\x00" > /dev/usb/lp0
