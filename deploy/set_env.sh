#!/usr/bin/env bash

. /opt/ros/noetic/setup.bash
. /usr/home/ws/devel/setup.bash
roscore > /dev/null &
exec "$@"
