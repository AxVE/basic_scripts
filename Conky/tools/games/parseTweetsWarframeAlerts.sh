#!/bin/bash
set -e

colordefault="color1";
colorCredit="#00afe2";
colorGift="#2ee532";


addr="https://twitter.com/warframealerts";
nb_alerts=5; #Number of alerts to output

#Parse tweets from $addr
OIFS=$IFS; #Save original IFS
IFS=$'\n'; #Set IFS to have a value each \n and not each space
#Store alerts of warframe from tweets into array
alerts=($(curl -s $addr | awk -F="" 'BEGIN{nbMatch=0} {
	#Parse the number of alerts asked
	if(nbMatch < '"$nb_alerts"'){
		#Get the timer info of an alert
		if(match($0,/tweet-timestamp/)){
			sub(/<\/span><\/a>/,"");
			sub(/.*>/,"");
			print;
		}
		#Get the alert infos
		else if(match($0,/TweetTextSize/)){
			sub(/<\/p>/,"");
			sub(/\s*<p.*>/,"");
			print;
			nbMatch++
		}
	}
}')); 

#Output (parse each value)
n=0;
while (($n < $nb_alerts))
do
	alert=${alerts[$(($n*2+1))]};
	timer=${alerts[$(($n*2))]};
	#echo -e "Alert: $alert\n\t$timer";

	infos=($(echo ${alerts[(($n*2+1))]} | awk '{split($0,a,/\s-\s/); for(e in a){print a[e]}}'));#Split infos
	nb_infos=${#infos[@]};#count nb infos
	output="${infos[0]} \${hr 1}\n";#Alert name
	output="$output${color1}\t${infos[1]} - ${alerts[(($n*2))]}\n";#Duration
	output="$output\${color $colorCredit}\t${infos[2]}\${color $colorGift}";#Credits
	#Other gains
	i=3
	while (($i < $nb_infos))
	do
		output="$output\n\t${infos[i]}";
		i=$i+1
	done
	output="$output\${$colordefault}\n\${hr 4}"
	echo -e $output; #Display tweet
	n=$(($n+1));
done

IFS=$OIFS; #reset IFS
exit 0;
