Copyright (c) 2018, Mnheia <mnheia@gmail.com>

# check_daikin_ac_temp
Nagios plugins to check inside temperature, outside temperature and power state on a Daikin AC.

# Example
## Server Side
```
define service {
        use service-name
        host_name hostname
        service_description OUTSIDE-TEMPERATURE
        check_command check_outside_temp!http://daikin-ac-ip/aircon/get_sensor_info
}

define service {
        use service-name
        host_name hostname
        service_description INSIDE-TEMPERATURE
        check_command check_inside_temp!http://daikin-ac-ip/aircon/get_sensor_info
}

define service {
        use service-name
        host_name hostname
        service_description POWER-STATE
        check_command check_daikin_power_state!http://daikin-ac-ip/aircon/get_control_info
}
```

Replace `daikin-ac-ip` with the address of your Daikin AC.

The scripts intentionally keep curl's `--insecure` option for compatibility with local Daikin endpoints using certificates that are not trusted by the monitoring host.

# Requirements
- Bash
- curl
- grep
- awk

# Bugs
Please report any bugs or feature requests through the web interface at https://github.com/mnheia/check_daikin_ac_temp/issues
