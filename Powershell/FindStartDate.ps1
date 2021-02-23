$UserNamesList = get-content -path "c:\fakepath\file.csv"
$exportPath = "C:\fakepath\output_file.csv"

foreach ($name in $UserNamesList){

Get-ADUser $name -properties * | select DisplayName, SamAccountName, EmailAddress, Whencreated | Export-CSV $ExportPath -Append -NoTypeInformation

}
