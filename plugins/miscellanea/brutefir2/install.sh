#!/bin/bash

echo "Installing brutefir dependencies"
if ! grep -q snd_aloop "/etc/modules";
	then
		echo "adding snd_aloop to /etc/module"
		echo 'snd_aloop' | tee --append /etc/modules
		echo "loading module now..."
		sudo modprobe snd_aloop
	else
		echo "/etc/modules already contains snd_aloop, nothing to do..."
fi
sudo apt-get update
sudo apt-get -y install brutefir bs2b-ladspa
echo "checking if brutefir service exists"
if [ ! -f "/etc/systemd/system/brutefir.service" ];
	then
		echo "file brutefir.service doesn't exist, creating"
		cp /data/plugins/miscellanea/brutefir/brutefir.service.gz /
		cd /
		sudo tar -xvf brutefir.service.gz
		rm /brutefir.service.gz
	else
		echo "File brutefir.service already exists"
fi

echo "creating filters folder and copying demo filters"
mkdir -m 777 /data/INTERNAL/brutefirfilters
cp /data/plugins/miscellanea/brutefir/filters/* /data/INTERNAL/brutefirfilters/
echo "creating brutefir minimal config file"
#not really elegant....
mkdir -m 777 /data/configuration/miscellanea/brutefir
cp /data/plugins/miscellanea/brutefir/volumio-brutefir-config /data/configuration/miscellanea/brutefir/volumio-brutefir-config
sudo chown -R volumio /data/configuration/miscellanea/brutefir
sudo chgrp -R volumio /data/configuration/miscellanea/brutefir
#required to end the plugin install
echo "plugininstallend"
