# -------- Update Telephone Attribute  --------
# Sets the telephoneNumber attribute to the value of extensionAttribute5
#                                              
# $users = import-csv .\telephones\testPhones.csv
$elapsed = [System.Diagnostics.Stopwatch]::StartNew()
# -------- Get data  --------
$users = get-aduser -Filter {extensionAttribute5 -like "*"} -properties samaccountname, userprincipalname,extensionAttribute5,telephoneNumber,extensionAttribute11 | select samaccountname, userprincipalname,extensionAttribute5,telephoneNumber,extensionAttribute11

# $users | out-gridview -title "All Users (Dirty)"
$OutputCSV = [string]::Concat($env:temp, "\\Telephone_users-", (Get-Date -format yyyyMMdd_HHmmss), ".csv")
$users | export-csv $OutputCSV
# -------- Clean and exclude data  --------
#
$excluded = @()
$usersNew = @()
foreach($n in $users){
    if( $n.extensionAttribute5 -match("^\(9{1}5{1}6{1}\)8{2}2{1}-\d{4}$") -and $n.extensionAttribute5 -eq $n.telephoneNumber  -or $n.extensionAttribute5 -notmatch("^\(9{1}5{1}6{1}\)8{2}2{1}-\d{4}$") -or $n.extensionAttribute11 -eq "y"){
         $tmp = new-object System.Object
         $tmp | Add-Member -type NoteProperty -Name samaccountname -Value ($n.samaccountname)
         $tmp | Add-Member -type NoteProperty -Name userprincipalname -Value ($n.userprincipalname)
         $tmp | Add-Member -type NoteProperty -Name extensionAttribute5 -Value ($n.extensionAttribute5)
         $tmp | Add-Member -type NoteProperty -Name telephoneNumber -Value ($n.telephoneNumber)
         $tmp | Add-Member -type NoteProperty -Name extensionAttribute11 -Value ($n.extensionAttribute11)
         $excluded += $tmp
    }
    else{
         $tmp = new-object System.Object
         $tmp | Add-Member -type NoteProperty -Name samaccountname -Value ($n.samaccountname)
         $tmp | Add-Member -type NoteProperty -Name userprincipalname -Value ($n.userprincipalname)
         $tmp | Add-Member -type NoteProperty -Name extensionAttribute5 -Value ($n.extensionAttribute5)
         $tmp | Add-Member -type NoteProperty -Name telephoneNumber -Value ($n.telephoneNumber)
         $tmp | Add-Member -type NoteProperty -Name extensionAttribute11 -Value ($n.extensionAttribute11)
         $usersNew += $tmp
    }
}
# $usersNew | out-gridview -title "Users (Cleaned)"
# $excluded | out-gridview -title "Users (Excluded)"
$OutputCSV = [string]::Concat($env:temp, "\\Telephone_excluded-", (Get-Date -format yyyyMMdd_HHmmss), ".csv")
$excluded | export-csv $OutputCSV
# -------- Set in AD --------
#
$usersUpdated = @()
foreach($n in $usersNew){
    # clear any existing set attribute
    set-aduser -identity $n.samaccountname -clear telephoneNumber
    # copy extensionAttribute5 to telephoneNumber
    set-aduser -identity $n.samaccountname -add @{telephoneNumber=$n.extensionAttribute5}
    write-host "Updating telephoneNumber for" $n.userprincipalname "[" $n.telephoneNumber "] to [" $n.extensionAttribute5 "] from extensionAttribute5"
    # new list
    $tmp = new-object System.Object
    $tmp = get-aduser -identity $n.samaccountname -properties samaccountname, userprincipalname,extensionAttribute5,telephoneNumber | select samaccountname, userprincipalname,extensionAttribute5,telephoneNumber
    $usersUpdated += $tmp
}
# $usersUpdated | out-gridview -title "Users (Updated)"
$OutputCSV = [string]::Concat($env:temp, "\\Telephone_usersUpdated-", (Get-Date -format yyyyMMdd_HHmmss), ".csv")
$usersUpdated | export-csv -notypeinformation $OutputCSV
write-host "Total Elapsed Time: $($elapsed.Elapsed.ToString())"