@echo off
echo ---------------------------------------------------------------------------------
echo NOTE: This is a bulk password reset.
echo Please add/edit users in c:\PATH_TO\bulkreset.txt before moving forward! 
echo ONE USERNAME PER LINE
echo Please confirm users EXIST before moving forward
echo ---------------------------------------------------------------------------------
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
 for /f "tokens=*" %%s in (c:\PATH_TO\bulkreset.txt) do (
 net user %%s PASSWORD /domain > nul
 echo ---------------------------------------------------
 echo %%s password has been changed!
 net user %%s /domain | findstr /R /C:"Password last set"
 echo ---------------------------------------------------
 )
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
