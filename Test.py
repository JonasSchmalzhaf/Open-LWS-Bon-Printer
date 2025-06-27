from time import sleep
import RPi.GPIO as GPIO
import subprocess

GPIO.setmode(GPIO.BOARD)

button=12

GPIO.setup(button,GPIO.IN,pull_up_down=GPIO.PUD_UP)

while(1):
	if GPIO.input(button)==0:
		print("Button was Pressed -> shutdown!")
		subprocess.call(["shutdown", "-h", "now"])
		sleep(.1)
