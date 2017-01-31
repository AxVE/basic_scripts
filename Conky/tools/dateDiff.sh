#!/bin/bash

if [ $# -ne 3 ]; then
	echo "3 parameters intended : hours minutes seconds" >&2;
	exit 1;
fi

read hours minutes seconds <<<$(date +"%H %M %S");

# Compare date
current=$((hours*3600+$minutes*60+$seconds));
given=$(($1*3600+$2*60+$3));
diff_s=0;

#If previous time > current, we add the time tot 0:00:00
if (($current < $given )); then
	diff_s=$((86400-$given));
	given=0;
fi

diff_s=$(($diff_s+$current-$given));

diff_h=$(($diff_s/3600));
diff_s=$(($diff_s%3600));

diff_m=$(($diff_s/60));
diff_s=$(($diff_s%60));

output="";

# Generate output line
if (($diff_h > 0)); then
	output="$diff_h h $diff_m m $diff_s s";
elif (($diff_m > 0)); then
	output="$diff_m m $diff_s s";
else
	output="$diff_s s";
fi

echo "$output";

exit 0;

