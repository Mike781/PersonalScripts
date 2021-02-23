@echo off
echo ---------------------------------------------------------------------------------
echo NOTE: This is to reset a password for a single user
echo ---------------------------------------------------------------------------------
set /p UserName= "Enter username: "
echo Checking if user exists:
echo -------------------------------------------------------------
net user %UserName% /domain | findstr /R /C:"User name"
net user %UserName% /domain | findstr /R /C:"Full Name"
net user %UserName% /domain | findstr /R /C:"Password expires"
net user %UserName% /domain | findstr /R /C:"Password last set"
echo -------------------------------------------------------------
:ConfirmBox
 set /P c= Would you like to continue (y/n)?
 if /I "%c%" EQU "Y" (
    goto :FnYes
    ) else if /I "%c%" EQU "N" (
    goto :FnNo
    ) else (
    goto :InValid
    )
:FnYes
net user %UserName% PASSWORD /domain  > nul
echo ----------------------------------------------------------
echo %UserName% password has been changed!
net user %UserName% /domain | findstr /R /C:"Password last set"
echo ----------------------------------------------------------
goto :END

:FnNO
 echo ------------------------
 echo Thanks! Have a nice day!
 echo ------------------------
 goto :END

:InValid
 echo --------------------------------------------
 echo This selection is Invalid! Enter Y or N ONLY
 echo --------------------------------------------
 goto :ConfirmBox

:END
pause
