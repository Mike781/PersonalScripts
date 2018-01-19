#!/bin/bash

#Script to remove users from G-Suite and Dropbox and create a custom group for email forwarding

#Warning
echo NOTE: This script offboards users that have
echo firstname.lastname as a primary email address
echo READ THE COMMENTS for syntax

#Script assumes you have GAM installed from https://github.com/jay0lee/GAM
#And it is located at ~/bin/gam/gam - update accordingly

#Find and replace DOMAIN.com with your domain name
#Replace <PASSWORD> (long!) for temporary suspended users
#Replace <DROPBOX TOKEN> with your Dropbox token or comment out Dropbox lines
read -p 'Would you like to continue? yes/no: ' contvar

if [[ "$contvar" == *"yes"* ]]; then
# Collect User Details
read -p 'First Name: ' firstnamevar
read -p 'Last Name: ' lastnamevar
read -p 'fwd to?(primary username): ' fwdvar
read -p 'Cancel GTM?: ' gtmvar

tempvar=$firstnamevar.$lastnamevar
uservar=`echo "$tempvar" | tr '[:upper:]' '[:lower:]'`

initial="$(echo $firstnamevar | head -c 1)"
tinitialvar=$initial$lastnamevar
initialvar=`echo "$tinitialvar" | tr '[:upper:]' '[:lower:]'`

Echo "Suspending User"
#suspend user
~/bin/gam/gam update user $uservar@DOMAIN.com suspended on

Echo "Changing PW and primary email"
#change password and change primary email
~/bin/gam/gam update user $uservar@DOMAIN.com password PASSWORD email x-$uservar@DOMAIN.com

Echo "Deleting alias"
#delete original alias to free it up for group fwd use
~/bin/gam/gam delete alias $uservar@DOMAIN.com
Echo "Deleting alias"
~/bin/gam/gam delete alias $initialvar@DOMAIN.com

Echo "Moving user to Retention OU"
#move user to retention OU
~/bin/gam/gam update user x-$uservar@DOMAIN.com org Retention

Echo "Creating group"
#Create group for forward
~/bin/gam/gam create group $uservar@DOMAIN.com name "'"'Ex '$firstnamevar' '$lastnamevar''"'"
Echo "Creating alias for group"
~/bin/gam/gam create alias $initialvar@DOMAIN.com group $uservar@DOMAIN.com
Echo "updating group permissions"
~/bin/gam/gam update group $uservar@DOMAIN.com who_can_post_message anyone_can_post
Echo "adding group members"
~/bin/gam/gam update group $uservar@DOMAIN.com add member $fwdvar@DOMAIN.com

#Echo "Removing user from 2FAExempt group"
#Remove user from 2faexempt group
#~/bin/gam/gam update group 2faexempt@DOMAIN.com remove member x-$uservar@DOMAIN.com

#Remove User from dropbox
curl -X POST https://api.dropboxapi.com/2/team/members/suspend \
  --header "Authorization:Bearer <DROPBOX TOKEN>" \
  --header "Content-Type: application/json" \
  --data "{\"user\": {\".tag\": \"email\",\"email\": \"$uservar@DOMAIN.com\"},\"wipe_data\": true}"
fi

elif [[ "$contvar" == *"no"* ]]; then
echo "Have a nice day!"
fi
