#This will change the "password last set" attribute to be today for a single user
#This will extend the password expiration date
#This is helpful when a password reset is currently impossible

#Prompt for username to edit
$username = Read-Host -Prompt 'Enter username to extend:'

#Get the current PwdLastSet value.
$User = Get-ADUser $username  -properties pwdlastset

#Display the current password last set date converted to human readable:
$olddate = [datetime]::fromFileTime($user.pwdlastset)

#Display the original date the password was set on
Write-host "The password for $username was originally set on" -ForegroundColor Magenta $olddate

#Change the user's pwdlastset attribute to 0
$User.pwdlastset = 0

#Apply the changes against the object
Set-ADUser -Instance $User

#Change the user's pwdlastset attribute to -1
$user.pwdlastset = -1

#Apply the changes against the object
Set-ADUser -instance $User

#Read the new last set date value from AD
$User = Get-ADUser $username  -properties pwdlastset

#Current password last set date converted to human readable:
$newdate = [datetime]::fromFileTime($user.pwdlastset)

#Display the new last set date (should always be the current date and time!)
Write-host "The new last set date is" -ForegroundColor Green $newdate

#Get new expiration date
$expdate = (Get-ADUser -Identity $User -Properties msDS-UserPasswordExpiryTimeComputed).'msDS-UserPasswordExpiryTimeComputed' |ForEach-Object -Process {[datetime]::FromFileTime($_)}

#Display new password expiration date

Write-host "The password for $username will now expire on" -ForegroundColor Red $expdate
