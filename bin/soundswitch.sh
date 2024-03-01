#!/bin/bash

# First, figure out what devices are on what sink # based on their static names.
headphones="SteelSeries Arctis 7 Game"
speakers="Family 17h/19h HD Audio Controller Analog Stereo"
headphones_sink=$(wpctl status | grep "$headphones" | sed 's@^[^0-9]*\([0-9]\+\).*@\1@')
speakers_sink=$(wpctl status | grep "$speakers" | head -1 | sed 's@^[^0-9]*\([0-9]\+\).*@\1@')

# Then use those numbers to get the line that shows their state.
headphones_state=$(wpctl status | grep "$headphones_sink\.")
speakers_state=$(wpctl status | grep "$speakers_sink\.")

# Get the sink number currently active, aka, which line has a `*` in it?
state=$(echo -e "$headphones_state\n$speakers_state=" | grep '*' | awk '{ print $3}' | tr -d '.')

# Switch sink based on which is currently the default.
case $state in
  $headphones_sink)
    wpctl set-default $speakers_sink
    ;;
  
  $speakers_sink)
    wpctl set-default $headphones_sink
    ;;

  *)
    echo -e "Whoops—unknown sink state!"
    ;;
esac
