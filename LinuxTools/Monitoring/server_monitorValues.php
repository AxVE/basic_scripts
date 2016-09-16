<?php
	//Author:drahull(Axel Verdier)
	//Email:axel.l.verdier@free.fr

	//Prepare getting and printing values
	$nl="\n"; //Return line ("\n" to have a txt file, "<br>" to have a html)
		//If the user want a html output
	if(htmlspecialchars($_GET["outputType"])=="html"){$nl="<br>";}
		//Get refresh gap time
	$checkTime=microtime(true); //Get microtime as float (seconds)
	$oldTime=0;
	if(apcu_exists("oldTimeSystemCheck")){$oldTime=apcu_fetch("oldTimeSystemCheck");}//Get cache
	else{apcu_add("oldTimeSystemCheck", 0);} //Create cache
	$secDiff=$checkTime-$oldTime;
	apcu_store("oldTimeSystemCheck",$checkTime);//Set cache
	
	//=== Measures infos ===
	echo "[INFOS]$nl";
	echo "info_timePrevious=$oldTime$nl";
	echo "info_timeActual=$checkTime$nl";
	echo "info_timeGap=$secDiff$nl";

	//=== System ===
	echo "[SYSTEM]$nl";

	//Get system data
	$sys_hostname=gethostname();
	$sys_uptime=rtrim(preg_split("/\s+/",trim(shell_exec("uptime")))[2], ',');
	$sys_os=PHP_OS;

	//Print system data
	echo "system_hostname=$sys_hostname$nl";
	echo "system_os=$sys_os$nl";
	echo "system_uptime=$sys_uptime$nl";

	//=== CPU ===
	echo "[CPU]$nl";
	
	//Get cpu data
	$cpu_model="unknown";
	$cpu_modelFreq="unknown";
	$cpu_nbCores=-1;
	$fh = fopen('/proc/cpuinfo','r');
	while($line=fgets($fh)){
		$pieces=array();
		if(preg_match('/^model name\s+:\s+(.*)\s+@\s+(.*)$/', $line, $pieces)){
			$cpu_model=$pieces[1];
			$cpu_modelFreq=$pieces[2];
		}
		if(preg_match('/^siblings\s+:\s+(.*)$/', $line, $pieces)){
			$cpu_nbCores=$pieces[1];
			break; //End read of file
		}
	}
	$tmp_cpu_freqInfos=shell_exec('LANG=en lscpu | grep MHz');
	$cpu_freqInfos=explode("\n",$tmp_cpu_freqInfos);
	$cpu_unitFreq="MHz";
	$cpu_curFreq=-1;
	$cpu_minFreq=-1;
	$cpu_maxFreq=-1;
	foreach($cpu_freqInfos AS $info){
		$pieces=array();
		if(preg_match('/^CPU MHz:\s*(.*)$/', $info, $pieces)){
			$cpu_curFreq=$pieces[1];
		}
		if(preg_match('/^CPU max MHz:\s*(.*)$/', $info, $pieces)){
			$cpu_maxFreq=$pieces[1];
		}
		if(preg_match('/^CPU min MHz:\s*(.*)$/', $info, $pieces)){
			$cpu_minFreq=$pieces[1];
		}

	}
	$cpu_load=sys_getloadavg();
	$cpu_loadpercent=array($cpu_load[0]*100/4, $cpu_load[1]*100/4, $cpu_load[2]*100/4);
	
	//Print cpu data
	echo "cpu_model=$cpu_model$nl";
	echo "cpu_modelfreq=$cpu_modelFreq$nl";
	echo "cpu_nbcores=$cpu_nbCores$nl";
	echo "cpu_unitFreq=$cpu_unitFreq$nl";
	echo "cpu_minFreq=$cpu_minFreq$nl";
	echo "cpu_curFreq=$cpu_curFreq$nl";
	echo "cpu_maxFreq=$cpu_maxFreq$nl";
	echo "cpu_load_1min=$cpu_load[0]$nl";
	echo "cpu_load_5min=$cpu_load[1]$nl";
	echo "cpu_load_15min=$cpu_load[2]$nl";
	echo "cpu_loadpercent_1min=$cpu_loadpercent[0]$nl";
	echo "cpu_loadpercent_5min=$cpu_loadpercent[1]$nl";
	echo "cpu_loadpercent_15min=$cpu_loadpercent[2]$nl";

	//=== RAM ===
	echo "[RAM]$nl";
	
	//Get mem data
	$mem_format="unknown";
	$fh = fopen('/proc/meminfo','r');
	$mem_total=-1;
	$mem_free=0;
	$mem_buffer=0;
	$mem_cached=0;
	while($line = fgets($fh)){
		$pieces = array();
		if (preg_match('/^MemTotal:\s+(\d+)\s+(.*)$/', $line, $pieces)) {
			$mem_total = $pieces[1];
			$mem_format=$pieces[2];
		}
		if (preg_match('/^MemFree:\s+(\d+)\skB$/', $line, $pieces)) {
			$mem_free = $pieces[1];
		}
		if (preg_match('/^Buffers:\s+(\d+)\skB$/', $line, $pieces)) {
			$mem_buffer = $pieces[1];
		}
		if (preg_match('/^Cached:\s+(\d+)\skB$/', $line, $pieces)) {
			$mem_cached = $pieces[1];
			break;
		}
	}
	fclose($fh);
	$mem_used=$mem_total-$mem_free-$mem_buffer-$mem_cached;
	$mem_usedpercent=round($mem_used*100/$mem_total,2);

	//Print mem data
	echo "mem_unit=$mem_format$nl";
	echo "mem_total=$mem_total$nl";
	echo "mem_free=$mem_free$nl";
	echo "mem_buffer=$mem_buffer$nl";
	echo "mem_cached=$mem_cached$nl";
	echo "mem_used=$mem_used$nl";
	echo "mem_usedpercent=$mem_usedpercent$nl";

	//=== Disks ===
	echo "[DISKS]$nl";

	//=== Network ===
	echo "[NETWORK]$nl";

	//Get network data
	$ethline=preg_split('/\s+/',trim(shell_exec('cat /proc/net/dev | grep enp4s0')));
	if(!apcu_exists("oldBytesInSystemCheck") OR !apcu_exists("oldBytesOutSystemCheck")){
		apcu_add("oldBytesInSystemCheck",0);
		apcu_add("oldBytesOutSystemCheck",0);
	}
	$network_speedIN = ($ethline[1]-apcu_fetch("oldBytesInSystemCheck"))/$secDiff/1048576; //MB/s
	$network_speedOUT = ($ethline[9]-apcu_fetch("oldBytesOutSystemCheck"))/$secDiff/1048576; //MB/s
	apcu_store("oldBytesInSystemCheck", $ethline[1]);
	apcu_store("oldBytesOutSystemCheck", $ethline[9]);


	//Print network data
	echo "network_bytesIn=$ethline[1]$nl";
	echo "network_packetsIn=$ethline[2]$nl";
	echo "network_bytesInSpeed_MB/s=$network_speedIN$nl";
	echo "network_bytesOut=$ethline[9]$nl";
	echo "network_packetsOut=$ethline[10]$nl";
	echo "network_bytesOutSpeed_MB/s=$network_speedOUT$nl";


	//=== Services ==
	echo "[SERVICES]$nl";

	//Get services data
	$service_http=trim(shell_exec('systemctl show httpd --property=SubState --value'));
	$service_ssh=trim(shell_exec('systemctl show sshd --property=SubState --value'));
	$service_ts3=trim(shell_exec('systemctl show teamspeak3-server --property=SubState --value'));

	//print services data
	echo "service_http=$service_http$nl";
	echo "service_ssh=$service_ssh$nl";
	echo "service_teamspeak3=$service_ts3$nl";
?>
