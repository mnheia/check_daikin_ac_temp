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

power_state=$(printf '%s\n' "$result" | grep -o -P '(?<=pow=).*(?=,mode=)' | head -n 1)

if [ -z "$power_state" ]; then
        echo "UNKNOWN: Unable to read AC power state."
        exit $STATE_UNKNOWN
fi

if [ "$power_state" = "1" ]; then
        echo "CRITICAL: Air Conditioner is running."
        exit $STATE_CRITICAL
else
        echo "OK: Air Conditioner is on standby."
        exit $STATE_OK
fi
