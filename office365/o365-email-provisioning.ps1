# -------- Automatic Email Provisioning --------
# Generates emails from csv file or AD OU
#                                              
# - Includes -----------------------------------
# List of odd lastNames
$exceptions = import-csv .\exceptions.txt
. .\Convert-DiacriticCharacters.ps1
. .\sendNotification.ps1
# -----------------------------------------------
# Import users to create emails
$inputUsers = import-csv .\mailboxes.csv
# -----------------------------------------------
$elapsed = [System.Diagnostics.Stopwatch]::StartNew()
# -----------------------------------------------
# Get users in the OU for users that are students ( 2 ) and have no mail, mailnickname
# -----------------------------------------------
# $users = get-aduser -SearchBase "OU=users,DC=domain,DC=com" -Filter {extensionAttribute2 -eq 1 -and mail -notlike "*" -and mailnickname -notlike "*"} -properties samaccountname, whenCreated,givenName,sn | select givenName, sn,samaccountname, userprincipalname,whenCreated
# -----------------------------------------------
# Get from CSV 
# -----------------------------------------------
$users = @()
$usersExcl = @()
foreach($n in $inputUsers.samaccountname){
    $tmp = new-object System.Object
    $tmpAD = get-aduser -Filter {samaccountname -eq $n} -properties samaccountname, whenCreated,givenName,sn,extensionAttribute10 | select givenName, sn,samaccountname, userprincipalname,whenCreated,extensionAttribute10
    # exclude users with set userprincipalname to domain.com
    if($tmpAD.userprincipalname.ToLower() -match("@domain.com$") -eq $True -and $tmpAD.extensionAttribute10 -eq "Office365"){
        $tmp = new-object System.Object
        $tmp | Add-Member -type NoteProperty -Name samaccountname -Value ($tmpAD.samaccountname)
        $tmp | Add-Member -type NoteProperty -Name userprincipalname -Value ($tmpAD.userprincipalname)
        $tmp | Add-Member -type NoteProperty -Name whenCreated -Value ($tmpAD.whenCreated)
        $tmp | Add-Member -type NoteProperty -Name extensionAttribute10 -Value ($tmpAD.extensionAttribute10)
        $usersExcl += $tmp
    }
    else{
        $tmp | Add-Member -type NoteProperty -Name givenName -Value ($tmpAD.givenName)
        $tmp | Add-Member -type NoteProperty -Name sn -Value ($tmpAD.sn)
        $tmp | Add-Member -type NoteProperty -Name samaccountname -Value ($tmpAD.samaccountname)
        $tmp | Add-Member -type NoteProperty -Name userprincipalname -Value ($tmpAD.userprincipalname)
        $tmp | Add-Member -type NoteProperty -Name whenCreated -Value ($tmpAD.whenCreated)
        $users += $tmp
    }
}
# -----------------------------------------------
# saves to user's temporary folder, ex: C:\Users\User\AppData\Local\Temp
$OutputCSV = [string]::Concat($env:temp, "\\users-", (Get-Date -format yyyyMMdd_HHmmss), ".csv")
$users | export-csv -notypeinformation $OutputCSV
$users | out-gridview -title "All Users (Not Cleaned)"

$OutputCSV = [string]::Concat($env:temp, "\\usersWithUPN-", (Get-Date -format yyyyMMdd_HHmmss), ".csv")
$usersExcl | export-csv -notypeinformation $OutputCSV
$usersExcl | out-gridview -title "Users with existing UPN"
# -----------------------------------------------
# Clean up first and last names
# -----------------------------------------------
$statemt = $False
$users2 = $users | select @{N='givenName';E={ 
    # remove hyphens from first name
    $_.givenName = $_.givenName.Trim().ToLower()
    if($_.givenName -match("^([a-z]*)-([a-z]*)$") -eq $True -or $_.givenName -match("^([a-z]*)\s-([a-z]*)$") -eq $True -or $_.givenName -match("^([a-z]*)-\s([a-z]*)$") -eq $True -or $_.givenName -match("^([a-z]*)\s-\s([a-z]*)$") -eq $True){
            ($_.givenName -replace "[- ,]","")
             $statemt = $True
        }
        if($statemt -eq $False){
            $_.givenName.split(" ")[0]
        }
        $statemt = $False

    } }, 
    @{N='sn';E={
        $_.sn = $_.sn.Trim().ToLower()
        foreach($ln in $exceptions){
            # match from the list of exceptions plus space and a word, ex: "de la fuente"
            if($_.sn -match("^($($ln.lastnames))\s([a-z]*)$") -eq $True -and $statemt -eq $False){
                ($_.sn -replace "[ ,]","")
                $statemt = $True
            }
            # ex: "de la garza arias"
            if($_.sn -match("^($($ln.lastnames))\s([a-z]*)\s([a-z]*)$") -eq $True -and $statemt -eq $False){
                ($_.sn -replace "[ ,]","")
                $statemt = $True
                write-host "Check: " $_.sn
            }
             # a word then space then match from the list of exceptions plus space and a word, ex: "pena de lopez"
            if($_.sn -match("^([a-z]*)\s($($ln.lastnames))\s([a-z]*)$") -eq $True -and $statemt -eq $False){
                ($_.sn -replace "[ ,]","")
                $statemt = $True
            }
        }
        # looks for User I, User II, User III and the end of the sn, ex: jones II and removes the numeral
        if($_.sn -match("^([a-z]*)\sI{1,3}$") -eq $True){
                ($_.sn -replace "\sI{1,3}$","")
                $statemt = $True
        }# jones IV
        if($_.sn -match("^([a-z]*)\sI{1}V{1}$") -eq $True){
                ($_.sn -replace "\sI{1}V{1}$","")
                $statemt = $True
        } # jones V , Jones VI, Jones VII, Jones VIII
        if($_.sn -match("\sV{1}I{1,3}$") -eq $True){
                ($_.sn -replace "\sV{1}I{1,3}$","")
                $statemt = $True
        }
        # looks for jr or sr  at the end of the sn, ex:  jones jr,  jones sr
        if($_.sn -match("^([a-z]*)\s(jr|sr)$") -eq $True){
            ($_.sn -replace "\s(jr|sr)$","")
            $statemt = $True
        } # with a period
        if($_.sn -match("^([a-z]*)\s(jr|sr)[\.]$") -eq $True){
            ($_.sn -replace "\s(jr.|sr.)$","")
            $statemt = $True
        }
        # find strict sn with hyphens inbetween, and account for spaces, ex:  medellin-rodriguez
        if($_.sn  -match("([a-z]*)-([a-z]*)$") -eq $True -or $_.sn -match("([a-z]*)\s-([a-z]*)$") -eq $True -or $_.sn -match("([a-z]*)-\s([a-z]*)$") -eq $True -or $_.sn -match("([a-z]*)\s-\s([a-z]*)$") -eq $True){
            ($_.sn -replace "[- ,]","")
            $statemt = $True
        }
        # sn with letter followed by apostrophe and space, ex:  O' Hara, D' Alessio
        if($_.sn -match("^[a-z]'\s([a-z]*)$") -eq $True){
            ($_.sn -replace "[' ,]","")
            $statemt = $True
        }
        # word followed by space then sn with letter followed by apostrophe and space, ex:  Man O' Hara, Woman D' Alessio
        if($_.sn -match("^([a-z]*)\s[a-z]'\s([a-z]*)$") -eq $True){
            ($_.sn -replace "[' ,]","")
            $statemt = $True
        }
        # if none of the above return true, assume it is just word space word, ex: barrera suarez
        if($statemt -eq $False){
            $_.sn.split(" ")[0]
        }
        $statemt = $False
    
    }} ,samaccountname, userprincipalname,whenCreated
write-host ;"There are: " + $users2.Count +" students"
$OutputCSV = [string]::Concat($env:temp, "\\usersCleaned-", (Get-Date -format yyyyMMdd_HHmmss), ".csv")
$users2 | export-csv $OutputCSV
$users2 | out-gridview -title "All Users (Cleaned)"
# -----------------------------------------------
# Generate email 
# -----------------------------------------------
function newMailNick($nick,$suffixN,$arg3){
    $tmper = $nick + $suffixN + "@domain.com"
    if($arg3 -eq $null){
    return $tmper
    }
    else{
     if($arg3.mail -contains($tmper) ){
         #$tmper already exists
         return $tmper,$True
     }
     else{
         # doesn't exist
         return $tmper,$False
     }
    }
}
# -----------------------------------------------
# create mailnicknames
# -----------------------------------------------
$emails = @()
foreach($u in $users2){
    $tmp3 = new-object System.Object
    # clean up first for accent characters
    $tmpGN = Convert-DiacriticCharacters $u.givenName
    $tmpSN = Convert-DiacriticCharacters $u.sn
    $tmpnick = ($tmpGN + "." + $tmpSN)
    $tmp3 | Add-Member -type NoteProperty -Name mailnickname -Value ($tmpnick)
    $tmp3 | Add-Member -type NoteProperty -Name samaccountname -Value ($u.samaccountname)
    $tmp3 | Add-Member -type NoteProperty -Name whenCreated -Value ($u.whenCreated)
    $tmp3 | Add-Member -type NoteProperty -Name extensionAttribute10 -Value ($u.extensionAttribute10)
    $emails += $tmp3
}
write-host "Set up: " $emails.Count " proposed emails"
# $emails | out-gridview
# -----------------------------------------------
# check existing mailnicknames
# -----------------------------------------------
function checkExisting($usr){
    $tmp = @(get-aduser -filter {userprincipalname -eq $usr} -properties mailnickname,mail,samaccountname, whenCreated,extensionAttribute10,proxyAddresses | select mailnickname,mail,samaccountname,whenCreated,extensionAttribute10,proxyAddresses)
    if($tmp){
        return $True, $tmp.mailnickname.ToLower(), $tmp.mail.ToLower(), $tmp.samaccountname,$tmp.whenCreated,$tmp.extensionAttribute10
    }
}
$proposedEmails = @()
$suffx = 0
foreach($emn in $emails){
    $tmp = new-object System.Object
    $emnSam = $emn.samaccountname
    $emnNick = $emn.mailnickname
    $emnCreated = $emn.whenCreated
    $emnExt10 = $emn.extensionAttribute10
    do{
        $suffx++ 
        $newMail = newMailNick $emnNick $suffx
        $newMailstr = [string]$newMail
        $val,$emEx,$mailEx,$cSama,$cWhenCr,$cExt10 = checkExisting $newMailstr 

        if($val -eq $null){
            $newMail,$tVal = newMailNick $emnNick $suffx $proposedEmails
            # if it does not exist already in the list
            if($tVal -eq $False){
                $proxyAdr = $emnNick + $suffx
                $tmp | Add-Member -type NoteProperty -Name mail -Value ($newMail) 
                $tmp | Add-Member -type NoteProperty -Name samaccountname -Value ($emnSam)   
                $tmp | Add-Member -type NoteProperty -Name whenCreated -Value ($emnCreated)  
                $tmp | Add-Member -type NoteProperty -Name extensionAttribute10 -Value ($emnExt10) 
                $tmp | Add-Member -type NoteProperty -Name proxyAdr -Value ($proxyAdr) 
                $proposedEmails += $tmp
            }
            elseif($tVal -eq $True){ # if it does exist from the list
                do{
                    $suffx++
                    $newMail,$tval2 = newMailNick $emnNick $suffx $proposedEmails 
                    $newMailstr = [string]$newMail
                    $val,$emEx,$mailEx,$cSama,$cWhenCr,$cExt10 = checkExisting $newMailstr
                    if($tval2 -eq $False -and $val -eq $null){
                        $proxyAdr = $emnNick + $suffx
                        $tmp | Add-Member -type NoteProperty -Name mail -Value ($newMail) 
                        $tmp | Add-Member -type NoteProperty -Name samaccountname -Value ($emnSam)   
                        $tmp | Add-Member -type NoteProperty -Name whenCreated -Value ($emnCreated)  
                        $tmp | Add-Member -type NoteProperty -Name extensionAttribute10 -Value ($emnExt10) 
                        $tmp | Add-Member -type NoteProperty -Name proxyAdr -Value ($proxyAdr) 
                        $proposedEmails += $tmp
                    }
                }while($tval2 -eq $True)
                }
        }
    }while($val -eq $True)
    $suffx = 0
}# end big foreach
$OutputCSV = [string]::Concat($env:temp, "\\proposedEmailsAll-", (Get-Date -format yyyyMMdd_HHmmss), ".csv")
$proposedEmails | export-csv -NoTypeInformation $OutputCSV
write-host "Created: " $proposedEmails.Count " proposed emails"
$proposedEmails | out-gridview -title "Proposed Emails (Not Checked)"
# -----------------------------------------------
#  check proxyAddresses
# -----------------------------------------------
$excl = @()
$proposedMailChecked = @()
foreach($u in $proposedEmails) {
    $proposedProx = "*smtp:" + "$($u.proxyAdr)" + "@*"
    # check if a proxyAddress exists that is on Office365
    $exists = get-aduser -filter {proxyAddresses -like $proposedProx -and extensionAttribute10 -eq "Office365"} -properties mailnickname,mail,samaccountname,userprincipalname | select mailnickname,mail,samaccountname,userprincipalname 
    if($exists){
            $tmp = new-object System.Object
            $tmp | Add-Member -type NoteProperty -Name proxyAdr -Value ($u.proxyAdr)
            $excl += $tmp
            write-host "The user: " $u.proxyAdr " has been excluded from processing. The user's proxy addresss exists in AD or is a false positive."
    }
    else{
        $tmp = new-object System.Object
        $tmp | Add-Member -type NoteProperty -Name mail -Value ($u.mail)
        $tmp | Add-Member -type NoteProperty -Name samaccountname -Value ($u.samaccountname)
        $tmp | Add-Member -type NoteProperty -Name proxyAdr -Value ($u.proxyAdr)
        $proposedMailChecked += $tmp
    }
    $i++
    Write-Progress -Activity "Building the report. Please wait." -Status $proposedProx -PercentComplete ($i/$proposedEmails.count * 100)
}
# excluded
write-host "Excluded emails: " $excl.Count
$OutputCSV = [string]::Concat($env:temp, "\\excluded-", (Get-Date -format yyyyMMdd_HHmmss), ".csv")
$excl | export-csv -NoTypeInformation $OutputCSV
$excl | out-gridview -title "Excluded"
# Non-conflicting
$proposedCount = $proposedMailChecked.Count
write-host "Non-conflicting emails: " $proposedCount
$OutputCSV = [string]::Concat($env:temp, "\\proposedEmailsChecked-", (Get-Date -format yyyyMMdd_HHmmss), ".csv")
$proposedMailChecked | export-csv -NoTypeInformation $OutputCSV
$proposedMailChecked | out-gridview -title "Proposed Emails (Checked)"
# -----------------------------------------------
# Send notification email with attachment
#-----------------------------------------------
sendNotification "smtp.office365.com" "user@domain.com" $OutputCSV $proposedCount
write-host "Total Elapsed Time Setting up mails: $($elapsed.Elapsed.ToString())"
#-----------------------------------------------
# Then execute the following
# 1 prepare-office365 users
# 2 trigger dirsync
# 3 connect to office365
# 5 check-office365 users
# 6 license-office365 users
#-----------------------------------------------
