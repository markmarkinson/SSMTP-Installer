#!/bin/bash

# app_variables
appPath="/etc/ubi-software"
pluginPath=${appPath}"/ssmtp"

# intro
clear && echo "" && echo "    ::: UBI said welcome.... Let's install ssmtp - an alternative sendmail client :::" && echo ""

# need to run as root
if [ "$EUID" -ne 0 ]; then echo "Please run this script as root or using sudo!"; exit; fi

# run update and install ssmtp
apt-get -qq update 2> /dev/null && apt-get -qq install ssmtp -y 2> /dev/null

# create working directory 
if [ -d "${pluginPath}" ]; then echo "old version removed"; rm -R "${pluginPath}"; mkdir -p ${pluginPath}; fi

# insert and confirm input settings
while true; do
    [[ $c -eq 3 ]] && echo "Too many failed attempts. Exiting" && exit # break loop

    read -p "SMTP host (without port): " smtp_host
    read -p "SMTP port (without host): " smtp_port
    read -p "SMTP user: " smtp_user
    read -p "SMTP pass: " smtp_pass

    # confirmation
    read -p "Is the data you entered correct? [${smtp_user}:${smtp_pass}@${smtp_host}:${smtp_port}] (Y/N): " confirm
    if [[ "${confirm}" == "[nN]" || "${confirm}" == "[nN][oO]" ]]; then ((c++)); echo "okay then we'll try again (attemp ${c})"; continue; fi

    break
done

# generate config file (/etc/ssmtp/ssmtp.conf)
    touch ${pluginPath}/ssmtp.conf.example
    cat << EOF > ${pluginPath}/ssmtp.conf.example
    AuthUser=${smtp_user}@${smtp_host}
    AuthPass=${smtp_pass}
    mailhub=${smtp_host}:${smtp_port}
    rewriteDomain=${smtp_host}
    
    UseTLS=Yes
    UseSTARTTLS=Yes
    hostname=$(hostname)
    FromLineOverride=yes
    root=no-reply@$(hostname)
.
EOF

echo "done"
