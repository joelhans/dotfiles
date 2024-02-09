#!/bin/bash

# Unfortunately, the sink numbers are randomly hardcoded, but seem stable after
# many reboots.
sink_headphones="47"
sink_speakers="51"
state_headphones=$(wpctl status | grep "$sink_headphones\.")
state_speakers=$(wpctl status | grep "$sink_speakers\.")

# Get the sink number currently active.
# aka, which line has a `*` in it?
state=$(echo -e "$state_speakers\n$state_headphones" | grep '*' | awk '{ print $3}' | tr -d '.')

# Switch sink based on which is currently the default.
case $state in
  47)
    wpctl set-default $sink_speakers
    ;;
  
  51)
    wpctl set-default $sink_headphones
    ;;

  *)
    echo -e "Whoops—unknown sink state!"
    ;;
esac
