# Open-LWS-Bon-Printer
Bei diesem Projekt handelt es sich um eine Anwenung welche für das Open Lehrwerkstatt Event der Swarz IT entwickelt wurde. Die Idee/Aufgabe besteht darin einen Kassenzettel-Drucker Zitate ausdrucken zu lassen. Als Print Event sollten externe Sensoren verwendet werden (z.B. Annäherungssensor, normaler Taster/Schalter, etc.).

### OpenLWS.sh
Es wurde sich für einen Raspberry Pi entschieden, welcher via USB-Kabel mit dem Bon-Drucker verbunden wird. Der Raspberry Pi kann dann mit Hilfe von wget und einer API (https://api.zitat-service.de/v1/quote) ein Zitat aus dem Internet laden. Anschließend kann das Zitat über einen Seriellen Print mit echo -e an den Seriellen Port des Drucker versendet werden.

### OpenLWS.py
Um diesen Print mit Sensoren zu triggern, wurde ein Python Script geschrieben, welches Sensordaten ausliest und das Shell Skript OpneLWS.sh dementsprechen ausführt.

## Installieren der Bon-Drucker Software auf einem Raspberry PI
1. Download des Repositorys
    ```
    git clone https://github.com/JonasSchmalzhaf/Open-LWS-Bon-Printer.git
    ```

2. In Open-LWS-Bon-Printer Verzeichnis wechseln
    ```
    cd Open-LWS-Bon-Printer
    ```

3. Rechte für install.sh vergeben
    ```
    sudo chmod 775 install.sh
    ```

4. Ausführen von install.sh
    ```
    sudo ./install.sh
    ```

## Erläuterungen für evtl. Anpassungen
### Aufbau der Software
Installation:

Im ersten Schritt der Installation wird in /etc ein OpenLWS Ordner erstellt, welcher alle Datein beinhaltet welche für den Betrieb des Bon Druckers benötigt werden (OpenLWS.sh, OpenLWS.py, OpenLWS-Welcome.sh). Anschließend werden alle diese Dateien richtig berechtigt und der Raspberry wird geupdated und upgegraded.
Als nächstes werden alle benötigten Programme/Bibliotheken installiert und das I2C Module des Raspberrys via rapi-config aktiviert.
Abschließend wird ein System Service erstellt welcher für das starten des Python-Skripts verantwortlich ist und in der /boot/firmware/config.txt wird der Button zum Shutdown hinzugefügt.
Danach folgt nur noch der reboot um alle Änderungen zu aktivieren.

Programmablauf:

Die zentrale Logik befindet sich in der OpenLWS.py Datei, diese wird vom OpenLWS System Service am laufen gehalten. Beim start des Python Scripts wird das OpenLWS-Welcome.sh ausgeführt um dem Nutzer zu signalisieren das der Bon Drucker an ist und ab jetzt Einsatzfähig ist. Dazu wird ein Druckauftrag gesendet mit der Ausgabe:
    Druckers Status: läuft
Anschließend frägt das Script den Sensor ab, bis dieser getriggert wird und darauf hin wird das OpenLWS.sh script aufgerufen. Dieses frägt dann automatisch ein neues Zitat von der API an und druckt es im richtigen Format auf den Kassenzettel.

Programm Änderungen:

Sollen Änderungen am laufendne Programm vorgenommen werden müssen die Dateien in /etc/OpenLWS angepasst werden und der Serivce via
```
service OpenLWS restart
```
neugestartet werden.

Sollen diese Änderungen auch für Zukünftige Installationen übernommen werden, müssen die Datein auch hier im Git angepasst werden.

### Anpassung des Kassen Bons
Die [Bixolon Command Page](https://www.bixolon.com/_upload/manual/Manual_Command_Thermal_POS_Printer_ENG_V1.00[9].pdf) beinhaltet verschiedene Command zur allgemeinen Steuerung und Konfiguration des Druckers, wie z.B. Schrifftgröße, Auswahl der Code Tables, Text Ausrichtung, etc. Diesen Funktionen werden Hex-Werte zugeordnet um sie aus zu führen.

Die [Bixolon Code Page](https://www.bixolon.com/_upload/manual/Manual_Code_Page_Thermal_Label_ENG_V1.03[4].pdf) beinhaltet verschiedene Code Tabelen. Diese Code Tabellen ordnen verschiedenen Zeischen Hex-Werte zu.

Hex-Werte lassen sich unter Linux und in Shell Scripts folgendermaßen an den Drucker senden:
  ```
  echo -e "\x0A\x0F" > /dev/usb/lp0
  ```

Dabei ist wichtig das für **/dev/usb/lp0** der richtige USB Port gewählt wird, über welchen der Drucker erreichbar ist.
Mit **echo -e** können jedoch auch "normale" Strings versendet werden. Dabei ist zu beachten das sonder Zeichen (ä, ö, ü, ß) vom Drucker nicht richtig gedurckt werden. Also muss für diese Zeichen der entsprechende Code aus der Code Page eingefügt werden.

Außerdem ist beim Drucken zu beachten, dass der Drucker maximal 24 Zeichen breit drucken kann (bei doppelter Schrifftgröße). Nach diesen 24 Zeichen bricht der Drucker die Zeile automatisch um.

Das Layouts des Kassenzettels ist im **OpenLWS.sh** Skript anzupassen (siehe auch Code Kommentare).
