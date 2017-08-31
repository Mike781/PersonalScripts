#!/bin/bash

#Script to create new GSuite accounts and add users to default groups
#and invite users to Slack and Dropbox

#Script assumes you have GAM installed from https://github.com/jay0lee/GAM
#And it is located at ~/bin/gam/gam

#DONT FORGET TO add a default password, update group names, locations, and domain

#IMPORTANT: Review comments in each section to understand necessary replacements

#FIND AND RFEPLACE @domain.com with ACTAUL domain

# Collect User Details
read -p 'First Name: ' firstnamevar
read -p 'Last Name: ' lastnamevar
read -p 'Office: ' officevar
read -p 'Platform(mac, win): ' platformvar
read -p 'Dept: ' depvar
read -p 'GoToMeeting? (yes/no)' gtmvar

#Join first and last name and make lowercase to create username
tempvar=$firstnamevar.$lastnamevar
uservar=`echo "$tempvar" | tr '[:upper:]' '[:lower:]'`

#Create User - This creates a user with the temporary password
#Replace DEFAULTPASSWORD below
~/bin/gam/gam create user $uservar@domain.com firstname $firstnamevar lastname $lastnamevar password DEFAULTPASSWORD changepassword off

#Add user to main groups
#Replace DEFAULTGROUP1 and DEFAULTGROUP2 with generic "everyone" groups
~/bin/gam/gam update group DEFAULTGROUP1@domain.com add member $uservar@domain.com
~/bin/gam/gam update group DEFAULTGROUP2@domain.com add member $uservar@domain.com

#Add user to office location groups
#Replace LOC1, LOC2, LOC3, LOC4 with actual locations and groups
if [[ "$officevar" == *"LOC1"* ]]; then
~/bin/gam/gam update group LOC1GROUP@domain.com add member $uservar@domain.com
elif [[ "$officevar" == *"LOC2"* ]]; then
~/bin/gam/gam update group LOC2GROUP@domain.com add member $uservar@domain.com
elif [[ "$officevar" == *"LOC3"* ]]; then
~/bin/gam/gam update group LOC3GROUP@domain.com add member $uservar@domain.com
elif [[ "$officevar" == *"LOC4"* ]]; then
~/bin/gam/gam update group LOC4GROUP@domain.com add member $uservar@domain.com
fi

#Add user to platform groups
#Replace platforms and group names to suit needs
if [[ "$platformvar" == *"mac"* ]]; then
~/bin/gam/gam update group MACGROUP@domain.com add member $uservar@domain.com
elif [[ "$platformvar" == *"win"* ]]; then
~/bin/gam/gam update group WINGROUP@domain.com add member $uservar@domain.com
fi

#Add user to department groups
#Find and replace DEPTA, DEPTB, DEPTC, DEPTD with actual departments and email addresses
if [[ "$depvar" == *"DEPTA"* ]]; then
~/bin/gam/gam update group DEPTA1@domain.com add member $uservar@domain.com
~/bin/gam/gam update group DEPTA2@domain.com add member $uservar@domain.com
elif [[ "$depvar" == *"DEPTB"* ]]; then
~/bin/gam/gam update group DEPTB1@domain.com add member $uservar@domain.com
~/bin/gam/gam update group DEPTB2@domain.com add member $uservar@domain.com
elif [[ "$depvar" == *"DEPTC"* ]]; then
~/bin/gam/gam update group DEPTC1@domain.com add member $uservar@domain.com
~/bin/gam/gam update group DEPTC2@domain.com add member $uservar@domain.com
elif [[ "$depvar" == *"DEPTD"* ]]; then
~/bin/gam/gam update group DEPTD1@domain.com add member $uservar@domain.com
~/bin/gam/gam update group DEPTD2@domain.com add member $uservar@domain.com
elif [[ "$depvar" == *"other"* ]]; then
  :
fi

#Invite User to slack
#REPLACE <TOKEN> WITH SLACK API TOKEN
curl -X POST -F 'email='$uservar'@domain.com' -F 'token=<TOKEN>' https://slack.com/api/users.admin.invite

#Invite User to dropbox
#REPLACE <TOKEN> WITH DROPBOX API TOKEN
curl -X POST https://api.dropboxapi.com/2/team/members/add \
   --header "Authorization:Bearer <TOKEN>" \
   --header "Content-Type: application/json" \
   --data "{\"new_members\": [{\"member_email\": \"$uservar@domain.com\",\"member_given_name\": \"$firstnamevar\",\"member_surname\": \"$lastnamevar\",\"send_welcome_email\": true,\"role\": {\".tag\": \"member_only\"}}],\"force_async\": false}"

#If GoToMeeting needed then invite to GoToMeeting
#REPLACE <TOKEN> WITH GOTOMEETING API TOKEN
if [[ "$gtmvar" == *"yes"* ]]; then
curl -X POST https://api.citrixonline.com/G2M/rest/organizers \
  --header "Accept: application/vnd.citrix.g2wapi-v1.1+json" \
  --header "Content-Type: application/json" \
  --header "Authorization: OAuth oauth_token=<TOKEN>" \
  --data '{"firstName":"'$firstnamevar'", "lastName":"'$lastnamevar'", "organizerEmail":"'$uservar'@domain.com"}'
fi
