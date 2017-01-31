#!/usr/bin/perl

# usage : weather.pl [location-code-of-weather.com]
# default loc: FRXX0068:1:FR => Montpellier

use strict;
use warnings;

use XML::Simple;
use LWP::Simple;
#use Data::Dumper;

my $loc="FRXX0068:1:FR";

if(@ARGV >= 1){$loc=$ARGV[0];}

#Get xml
my $url="http://wxdata.weather.com/wxdata/weather/local/$loc?cc=*&unit=m&dayf=2";

my $xml = XML::Simple->new();
my $data = $xml->XMLin(get($url));

#Parse infos
my %unit;
$unit{temp} = $data->{head}{ut};
$unit{ppcp} = $data->{head}{ur};
$unit{speed} = $data->{head}{us};
$unit{dist} = $data->{head}{ud};
$unit{press} = $data->{head}{up};


my $time = $data->{loc}{tm};
my $city = $data->{loc}{dnam};

my $temp=$data->{cc}{tmp};

my @days;
for(my $d=0; $d < 2; $d++){ #for today and tomorrow
	$days[$d]{name} = $data->{dayf}{day}[$d]{t};
	$days[$d]{day_weather} = $data->{dayf}{day}[$d]{part}[0]{t};
	if($days[$d]{day_weather}=~m/HASH/){$days[$d]{day_weather}="over";}
	$days[$d]{night_weather} = $data->{dayf}{day}[$d]{part}[1]{t};
	if($days[$d]{night_weather}=~m/HASH/){$days[$d]{night_weather}="over";}
	$days[$d]{day_ppcp} = $data->{dayf}{day}[$d]{part}[0]{ppcp};
	$days[$d]{night_ppcp} = $data->{dayf}{day}[$d]{part}[1]{ppcp};
}


#Tests
#print "Units:\n";
#foreach my $key (keys %unit){
#	print "\t$key:\t$unit{$key}\n";
#}
#print "Time:\t$time\n";
#print "City:\t$city\n";
#print "Temp:\t$temp\n";
#print "Today:\n";
#foreach my $key (keys %{$days[0]}){
#	print "\t$key:\t$days[0]{$key}\n";
#}
#print "Tomorrow:\n";
#foreach my $key (keys %{$days[1]}){
#	print "\t$key:\t$days[1]{$key}\n";
#}
#print "\n";
#print Dumper($data);

# Conky report
	# General infos
print '${color0}'."Weather - $city ".'${hr 2}'."\n";
print '${color1}'."\t$temp °$unit{temp}".'${alignr}'."$time\t\t\n";
	#Today
print '${color2}'."Today - $days[0]{name} ".'${hr 2}'."\n".'${color1}';
print "\tday $days[0]{day_weather}".'${alignr}'."night $days[0]{night_weather}     \n";
print "\t$days[0]{day_ppcp} $unit{ppcp}".'${alignr}'."$days[0]{night_ppcp} $unit{ppcp}     \n";
	#Tomorrow
print '${color2}'."Today - $days[1]{name} ".'${hr 2}'."\n".'${color1}';
print "\tday $days[1]{day_weather}".'${alignr}'."night $days[1]{night_weather}     \n";
print "\t$days[1]{day_ppcp} $unit{ppcp}".'${alignr}'."$days[1]{night_ppcp} $unit{ppcp}     \n";
