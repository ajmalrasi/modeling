#!/bin/bash

# Improved command with optional port configuration
if [ -z "$1" ]
  then
    echo "Starting Jupyter Notebook on the default port (8888)"
    jupyter lab --ip 0.0.0.0 --no-browser --allow-root 
  else
    echo "Starting Jupyter Notebook on port: $1"
    jupyter lab --ip 0.0.0.0 --no-browser --allow-root --port=$1
fi