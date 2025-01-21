#!/bin/zsh

# Code Snipets


run_as_root(){
    # This is here for local testing upon the command line
    if [ "$(/usr/bin/id -u)" != "0" ]; then
        echo ""
        echo "ERROR: Script must be run as root or with sudo."
        echo ""
        exit 1
    fi
}


get_os_version(){
    os_version="$(/usr/bin/sudo /usr/bin/sw_vers | /usr/bin/awk -F: '/ProductVersion/ {print $2}' | /usr/bin/sed 's/^[[:space:]]*//g' | /usr/bin/cut -d. -f1)"
}


acquire_logged_in_user(){
	currentUser=$(/usr/bin/stat -f "%Su" "/dev/console")
}


get_processor_type_method_01(){
    processor_type="$(/usr/bin/sudo /usr/sbin/system_profiler SPHardwareDataType | /usr/bin/grep -e Chip | /usr/bin/awk '{print substr($1, 1, length($1)-1)}')"

    if [ -z "${processor_type}" ]; then
        processor_type="$(/usr/bin/sudo /usr/sbin/system_profiler SPHardwareDataType | /usr/bin/grep -e Intel)"
        
        if [ -z "${processor_type}" ]; then
            processor_type="UNKNOWN"
        else 
            processor_type="Intel"
        fi
    elif [ "${processor_type}" = "Chip" ]; then
        processor_type="ARM"
    else 
        processor_type="UNKNOWN"
    fi
}


get_processor_type_method_02(){
    # processor_type="$(/usr/sbin/sysctl -n machdep.cpu.brand_string | /usr/bin/grep -e Intel | /usr/bin/awk '{print substr($1, 1, length($1)-3)}')"

    processor_type="$(/usr/sbin/sysctl -n machdep.cpu.brand_string)"

    echo ${processor_type}

    if [[ ! -z $(/usr/sbin/sysctl -n machdep.cpu.brand_string | /usr/bin/grep -e Intel) ]]; then
        processor_type="Intel"
        echo ${processor_type}
    elif [[ ! -z $(/usr/sbin/sysctl -n machdep.cpu.brand_string | /usr/bin/grep -e Apple) ]]; then
        processor_type="ARM"
        echo ${processor_type}
    else 
        processor_type="UNKNOWN"
        echo ${processor_type}
    fi
}


convert_MobileConfig_to_XML(){
    # Convert macOS MobileConfig (JSON/Binary) to plist/XML
    /usr/bin/security cms -D -i filename.mobileconfig > filename.xml
}


convert_ugly_XML_to_Human_Readable(){
    # Convert XML to Human Readable Format
    /usr/bin/xmllint --format filename01.xml > filename02.xml
}