#!/bin/bash

# Need to edit /usr/bin/start-pulseaudio-x11 to comment out the following:
# if [ x"$KDE_FULL_SESSION" = x"true" ]; then
#   /usr/bin/pactl load-module module-device-manager "do_routing=1" > /dev/null
# fi

headphones="alsa_output.usb-SteelSeries_SteelSeries_Arctis_7-00.stereo-game"
speakers="alsa_output.pci-0000_2a_00.3.analog-stereo"

state=`pacmd list-sinks | grep "state:"`

stateHeadphones=$(pacmd list-sinks | grep "state:" | awk '{ print $2}' | awk 'NR==3')
stateSpeakers=$(pacmd list-sinks | grep "state:" | awk '{ print $2}' | awk 'NR==1')

if [[ $stateSpeakers = "SUSPENDED" ]] || [[ $stateSpeakers = "IDLE" ]]; then
    echo "Switching to speakers by default."
    
    pacmd set-default-sink "$speakers"
    
    pactl list short sink-inputs|while read stream; do
        streamId=$(echo $stream|cut '-d ' -f1)
        pactl move-sink-input "$streamId" "$speakers" &> /dev/null
    done

elif [[ $stateSpeakers = "RUNNING" ]] && [[ $stateHeadphones = "SUSPENDED" ]] || [[ $stateHeadphones = "IDLE" ]]; then
    echo "Switching to headphones."
    
    pacmd set-default-sink "$headphones"
    
    pactl list short sink-inputs|while read stream; do
        streamId=$(echo $stream|cut '-d ' -f1)
        pactl move-sink-input "$streamId" "$headphones" &> /dev/null
    done
    
fi
    

# if [ $stateHeadphones = "RUNNING" ]; then
#     echo "Headphones active, switching to speakers."
#     
#     pacmd set-default-sink "$speakers"
#     
#     pactl list short sink-inputs|while read stream; do
#         streamId=$(echo $stream|cut '-d ' -f1)
#         pactl move-sink-input "$streamId" "$speakers" &> /dev/null
#     done
# 
# elif [ $stateSpeakers = "RUNNING" ]; then
#     echo "Speakers active, switching to headphones."
#     
#     pacmd set-default-sink "$headphones"
#     
#     pactl list short sink-inputs|while read stream; do
#         streamId=$(echo $stream|cut '-d ' -f1)
#         pactl move-sink-input "$streamId" "$headphones" &> /dev/null
#     done
#     
# fi
