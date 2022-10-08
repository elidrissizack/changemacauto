#!/bin/bash
lanip=$(echo "192.168.1.1")
newmac=$(echo "2c:33:7a:b5:68:7b") #7c:01:91:56:59:68")
route=$(echo $(route -n | grep -i "^0.0.0.0" | cut -c17-29))
mymac=$(echo $(ifconfig wlp2s0 | grep ether | cut -c15-31))
ap=$(echo $(ps aux | grep sudo | grep "^r" | cut -c73-81))
ping=$(echo $(ping -c1 google.com | grep -i received | cut -c24-25))

while [ 1 ]
do
	if [[ "$mymac" != "$newmac" ]]
		then
		echo "Changement de l'adresse MAC"
			sudo ifconfig wlp2s0 down
			sudo macchanger -m $newmac wlp2s0
			sudo ifconfig wlp2s0 up
			sleep 3s
	else 
		echo "########################################" 
		echo "#  Mac Actuelle ===>" $mymac "#"
		echo "########################################" 
		echo ""
	fi
	
	if [[ "ping" != "1" ]] 
		then
		echo "Pas de connexion"
		break
	fi
		
	if [[ "$route" == "$lanip" ]]
		then 
			echo "########################################" 
			echo "#  Routage OK:                         #"
			echo "#  Routage Actuel:" $route "        #"
			echo "########################################" 
			echo ""
	else
			echo "L'adresse Route n'est pas la meme"
			sudo route del default 
			sudo route add default gw 192.168.1.1 dev wlp2s0
			sleep 5s
	fi
	
	if [[ "$ap" == "create_ap" ]]
		then 
			echo "########################################" 
			echo "#  Hotspot Active                      #"
			echo "########################################" 
			echo ""
	else 
			cd /opt/create_ap/
			sudo ./create_ap wlp2s0 wlp2s0 HotspotDelll jesuisziko &

		fi
#	sleep 2s
	exit
done
