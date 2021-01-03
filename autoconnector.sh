#!/bin/bash

# check if the device is being connected
# return 'yes' or 'no'
function is_connected() {
  {
    printf "select $adapter\n\n"
    printf "info $device\n\n"
  } | bluetoothctl | grep "Connected: " | sed -e 's/Connected: //' | sed -e 's/^[[:blank:]]*//'
}

while read line
do
  # skip a comment line and a blank line
  if ! [[ $line =~ ^# ]] && ! [[ $line =~ ^([[:blank:]]+.*)*$ ]]; then
    # save Bluetooth adapter’s MAC address and device’s MAC address
    adapter=`echo "$line," | cut -d ',' -f 1`
    device=`echo "$line," | cut -d ',' -f 2`

    # connect the device if not connected
    if [[ $(is_connected) = "no" ]]; then
      {
        printf "select $adapter\n\n"
        printf "connect $device\n\n"
      } | bluetoothctl
    fi
  fi
done < $(dirname $0)/list
