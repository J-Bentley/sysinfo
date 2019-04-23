# SYSINFO
A system report script written in bash for Ubuntu 16.04 with clean stdout/error and multiple instances in mind to quickly summarize important system info & metrics.
Lists info on ...
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
* Requires Ubuntu 16.04 & default prerequesties (nothing should require installation if using 16.04)
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
* more Ansible support