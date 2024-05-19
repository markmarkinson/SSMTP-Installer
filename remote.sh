#!/bin/bash

# intro
clear && echo "" && echo "    ::: UBI said welcome.... Let's install ssmtp - a alternative sendmail client :::" && echo ""

# need to run as root
if [ "$EUID" -ne 0 ]
  then echo "Please run this script as root or using sudo!"
  exit
fi



# insert and confirm input settings
while true; do
  # if counter is equal to 2 exit
    [[ $c -eq 3 ]] && echo "Two failed attempts. Exiting" && exit

    # fullname="USER INPUT"
    read -p "Enter fullname: " fullname
    # user="USER INPUT"
    read -p "Enter user: " user
    # confirmation
    read -p "Is the data you entered correct? [${fullname} and ${user}] (Y/N): " confirm

    if [[ $confirm == [nN] || $confirm == [nN][oO] ]]; then
        ((c++)) # increment the counter
        echo "okay then we'll try again (attemp ${c})"
        continue
    fi

    break
done



echo "done"
#read -p "Continue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1