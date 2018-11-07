Copyright (c) 2018, Mitja Sovec <mitja@sovec.si>

# check_temp
A Nagios plugin to check inside and outside temperature on Daikin AC

# Example
## Server Side
```
define service{
        use service-name
        host_name hostname
        service_description OUTSIDE-TEMPERATURE
        check_command check_outside_temp!http://daikin-ac-ip/aircon/get_sensor_info
}

define service{
        use service-name
        host_name hostname
        service_description INSIDE-TEMPERATURE
        check_command check_inside_temp!http://daikin-ac-ip/aircon/get_sensor_info
}
```
Where 'daikin-ac-ip' should be replaced with your Daikin AC IP

#Requirements
- curl

# Bugs
Please report any bugs or feature requests through the web interface at https://github.com/mnheia/check_running_vms/issues
