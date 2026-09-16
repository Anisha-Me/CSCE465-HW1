#!/bin/bash

if [ "$#" -ne 1 ] || [ "$1" != "course-marker" ]; then
    echo "Error: Wrong argument(s)" 
    exit 1
fi

MARKER_FILE="$HOME/csce465-agentsec/hw1/markers/marker.txt"
echo "course-marker" > "$MARKER_FILE"
echo "Marker written to $MARKER_FILE"
