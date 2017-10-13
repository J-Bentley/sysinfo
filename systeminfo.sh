#!/bin/bash
# COMP 2101: A Systems report to console & file on system names, os, version, disks, ram, network, software installed & printers. 
# Works best on a Debian based distro.

#KNOWN BUGS
# "No LSB Modules" echoed on EVERY instance of startup :( Reason: line 81; gathering distro info aswell as kernel version... worth it.
# If no printer connected, "lpstat" echoes error. Reason: line 91; lpstat -a to get list and 'cut' to format to new lines.
# Even though line 16 directs STDERR to file, prints above to console?
# Outputs STDOUT to file & terminal, file has ugly formatting codes inclded, oops.

# Declare variables
runindefaultmode="yes"

# Proper usage w/ aliases to be called on error or -h/--help
function displayusage {
  echo "Usage: $0 [-h | --help] [-n | --name] [-o | --os] [-i | --ip ] [-v | --version] [-c | --cpu] [-m | --ram] [-d | --disk] [-p | --printer] [-s | --software]"
}

function errormessage {
  echo "$@" 2>> systeminfo_error.txt
}

### Checks via iteration for arguments called, sets infowanted variable to yes, if so.
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help)
      displayusage
      exit 0
      ;;
    -s|--software)
      softwareinfowanted="yes"
      runindefaultmode="no"
      ;;
    -p|--printer)
      printerinfowanted="yes"
      runindefaultmode="no"
      ;;
    -d|--disk)
      diskinfowanted="yes"
      runindefaultmode="no"
      ;;
    -m|--ram)
      raminfowanted="yes"
      runindefaultmode="no"
      ;;
    -c|--cpu)
      cpuinfowanted="yes"
      runindefaultmode="no"
      ;;
    -v|--version)
      versioninfowanted="yes"
      runindefaultmode="no"
      ;;
    -i|--ip)
      ipinfowanted="yes"
      runindefaultmode="no"
      ;;
    -n|--name)
      namesinfowanted="yes"
      runindefaultmode="no"
      ;;
    -o|--os)
      osinfowanted="yes"
      runindefaultmode="no"
      ;;
    *)
      errormessage "Invalid argument: "$1
      errormessage "$(displayusage)"
      exit 1
      ;;
  esac
  shift
done

### Gather the RAW data requested by the args, save to info variable.
# OS, system & domain data
osinfo="$(grep PRETTY /etc/os-release |sed -e 's/.*=//' -e 's/"//g')"
systemname="$(hostname)"
domainname="$(domainname)"

# Networking data
ipinfo="$(hostname -I)"
dginfo="$(hostname -i)" 

# Version data
versioninfo="$(uname -a)"
distroinfo="$(lsb_release -a)" 

# CPU data (-m 1 greps for first instance of occurance)
cpuinfo="$(grep -m 1 "model name" /proc/cpuinfo)"
cpuinfo_mhz="$(grep -m 1 "cpu MHz" /proc/cpuinfo)"
cpuinfo_cores="$(grep -m 1 "cpu cores" /proc/cpuinfo)"

# RAM data
raminfo_total="$(grep "MemTotal" /proc/meminfo)"
raminfo_free="$(grep "MemFree" /proc/meminfo)"

# Disk data
diskinfo="$(df -h)"

# Printer data
printerinfo="$(lpstat -a | cut -f1 -d ' ')"

# Software data
softwareinfo="$(dpkg --get-selections)"

### Put RAW data in formatted text to make it pretty & save to formatted variable.

osinfoformatted="
\033[1mOperating System Information\033[0m
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
$osinfo
"

nameinfoformatted="
\033[1mSystem Names\033[0m
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Hostname: $systemname
Domainname: $domainname
"

ipinfoformatted="
\033[1mNetwork\033[0m
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
IP Address: $ipinfo
Default Gateway: $dginfo
"

versioninfoformatted="
\033[1mVersions\033[0m
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
Kernel Version: $versioninfo
$distroinfo
"

cpuinfoformatted="
\033[1mProcessor\033[0m
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
$cpuinfo
$cpuinfo_mhz
$cpuinfo_cores
"^

raminfoformatted="
\033[1mRAM\033[0m
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
$raminfo_total
$raminfo_free
"

diskinfoformatted="
\033[1mDisks\033[0m
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
$diskinfo
"

printerinfoformatted="
\033[1mPrinters\033[0m
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
$printerinfo
"
softwareinfoformatted="
\033[1mSoftware\033[0m (verbose)
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
$softwareinfo
"

### Checks infowanted variable up top for "yes" and prints the respective pretty variable, if so.
# Uses formatting codes (\033[1m) to bold the titles
# STDOUT is piped to to tee -a, appending to file & terminal. File located in script dir as Systeminfo_out.
# echo -e allows the formatting codes.

echo -e "\033[1mBash System Report\033[0m - Jordan Bentley"

if [ "$runindefaultmode" = "yes" -o "$namesinfowanted" = "yes" ]; then
  echo -e "$nameinfoformatted" | tee -a systeminfo_out.txt 
fi

if [ "$runindefaultmode" = "yes" -o  "$osinfowanted" = "yes" ]; then
  echo -e "$osinfoformatted" | tee -a systeminfo_out.txt 
fi

if [ "$runindefaultmode" = "yes" -o "$ipinfowanted" = "yes" ]; then
  echo -e "$ipinfoformatted" | tee -a systeminfo_out.txt 
fi

if [ "$runindefaultmode" = "yes" -o "$versioninfowanted" = "yes" ]; then
  echo -e "$versioninfoformatted" | tee -a systeminfo_out.txt 
fi

if [ "$runindefaultmode" = "yes" -o "$cpuinfowanted" = "yes" ]; then
  echo -e "$cpuinfoformatted" | tee -a systeminfo_out.txt 
fi

if [ "$runindefaultmode" = "yes" -o "$raminfowanted" = "yes" ]; then
  echo -e "$raminfoformatted" | tee -a systeminfo_out.txt 
fi

if [ "$runindefaultmode" = "yes" -o "$diskinfowanted" = "yes" ]; then
  echo -e "$diskinfoformatted" | tee -a systeminfo_out.txt 
fi

if [ "$runindefaultmode" = "yes" -o "$printerinfowanted" = "yes" ]; then
  echo -e "$printerinfoformatted" | tee -a systeminfo_out.txt 
fi

if [ "$runindefaultmode" = "yes" -o "$softwareinfowanted" = "yes" ]; then
  echo -e "$softwareinfoformatted" | tee -a systeminfo_out.txt | more 
fi

# Remove STDOUT & STDERR text files.
#rm systeminfo_out
#rm systeminfo_error
