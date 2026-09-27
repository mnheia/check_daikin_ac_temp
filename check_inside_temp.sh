#!/bin/bash

# check_daikin_ac_temp is a Nagios plugin to check inside and outside temperature on Daikin AC
#
# Copyright (c) 2018, Mnheia <mnheia@gmail.com>
#
# This module is free software; you can redistribute it and/or modify it
# under the terms of GNU general public license (gpl) version 3.
# See the LICENSE file for details.

export LC_ALL=en_US.UTF-8

STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3

CURL="$(command -v curl)"
PROGNAME="$(basename "$0")"

if [ -z "$CURL" ]; then
        echo "UNKNOWN: curl is not installed."
        exit $STATE_UNKNOWN
fi

if [ -z "${1:-}" ]; then
        echo "Usage: $PROGNAME <URL>"
        exit $STATE_UNKNOWN
fi

if ! result=$("$CURL" --insecure --silent --show-error --fail --user-agent "check-daikin-ac-nagios-plugin" "$1" 2>&1); then
        echo "UNKNOWN: Unable to query Daikin AC: $result"
        exit $STATE_UNKNOWN
fi

real_temp=$(printf '%s\n' "$result" | grep -o -P '(?<=htemp=).*(?=,hhum=)' | head -n 1)

if [ -z "$real_temp" ]; then
        echo "UNKNOWN: Unable to read inside temperature."
        exit $STATE_UNKNOWN
fi

calc_temp=$(awk -v t="$real_temp" 'BEGIN { printf "%.0f", t * 10 }')

if (( calc_temp <= 160 )); then
        echo "CRITICAL: Inside temperature $real_temp °C|temp=$real_temp"
        exit $STATE_CRITICAL
elif (( calc_temp >= 400 )); then
        echo "CRITICAL: Inside temperature $real_temp °C|temp=$real_temp"
        exit $STATE_CRITICAL
elif (( calc_temp >= 300 )); then
        echo "WARNING: Inside temperature $real_temp °C|temp=$real_temp"
        exit $STATE_WARNING
else
        echo "OK: Inside temperature $real_temp °C|temp=$real_temp"
        exit $STATE_OK
fi
