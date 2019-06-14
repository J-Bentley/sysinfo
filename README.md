# SYSINFO
Summarizes Ubuntu 16.04 system metrics via shell script or Windows via powershell script using default commands with formatted stdout & error.     

*Lists info on ...*
* hostname
* ip
* os
* cpu
* ram
* disks
* devices
* software

[Screenshot](https://i.imgur.com/ZjLpSMU.png)
## Usage
```bash systeminfo.sh [-h|help, -n|name, -i|ip, -o|os, -c|cpu, -m|ram, -d|disks, -de|devices, -s|software]``` 

## Setup
* Requires Ubuntu 16.04 and these bundled commands
	* tput
	* hostname
	* netstat
	* lsb_release
	* df
	* lshw
	* lsusb
	* dpkg

## Caveats
* Only 1 argument can be called at a time

## TODO
* SMS/email upon success/error via twilio
* better error handling
* formatt error ouput
