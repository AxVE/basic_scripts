#!/bin/bash

#Launch conky files in background

#System
conky -d -c ~/.conky/conky-system &

#Server
conky -d -c ~/.conky/conky-server &

#Updates
conky -d -c ~/.conky/conky-archlinux &

#Weather
conky -d -c ~/.conky/conky-weather &

#News
conky -d -c ~/.conky/conky-news &

#Games
 #Warframe
#conky -d -c ~/.conky/conky-warframe &

exit 0;
