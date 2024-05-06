#!/bin/bash

# Improved command with optional port configuration
if [ -z "$1" ]
  then
    echo "Starting TensorBoard on the default port (6006)"
    tensorboard --logdir "/home/ajmalrasi/hiba/train/" --host 0.0.0.0 --port 6006
  else
    echo "Starting TensorBoard on port: $1"
    tensorboard --logdir "/home/ajmalrasi/hiba/train/" --host 0.0.0.0 --port=$1
fi