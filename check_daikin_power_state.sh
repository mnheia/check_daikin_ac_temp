#!/bin/bash

# check_daikin_ac_temp is a Nagios plugin to check inside and outside temperature on Daikin AC
#
# Copyright (c) 2018, Mnheia <mnheia@gmail.com>
#
# This module is free software; you can redistribute it and/or modify it
# under the terms of GNU general public license (gpl) version 3.
# See the LICENSE file for details.

export LC_ALL=en_US.UTF-8

CURL=`which curl`
CURL_OPTS='--insecure --user-agent check-inside-temp-nagios-plugin'
BASENAME=`which basename`
PROGNAME=`$BASENAME $0`

# Exit codes
STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3

function print_usage
{
        echo "Usage: $PROGNAME <URL>"
}

if [ ! $1 ]; then
        print_usage
        exit $STATE_CRITICAL
fi

result=`$CURL $CURL_OPTS -s $1`

if [ $? != 0 ]; then
        echo 'CRITICAL - Check plugin does not work. Maybe you need to install curl.'
        exit $STATE_CRITICAL
else
        NOT_FOUND=$(echo $result | grep -i "Not Found")
        if [ -n "${NOT_FOUND}" ]; then
                status="CRITICAL";
                text="Not Found";
        else
                power_state=`echo $result | grep -o -P '(?<=pow=).*(?=,mode=)'`
        fi


        if [ $power_state == 1 ]; then
                echo "CRITICAL: Air Conditioner is running."
                exit $STATE_CRITICAL
        else
                echo "INFO: Air Conditioner is on standby."
                exit $STATE_OK
        fi
fi
