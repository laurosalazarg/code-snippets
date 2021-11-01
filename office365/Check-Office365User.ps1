# Displays the users that are not licensed on Office 365
#
# Usage:
#	checkOffice365User.ps1 -UserList myusers.csv
#		- or -
#	checkOffice365User.ps1 -UserPrincipalName john.test@domain.com
#
param( [string]$UserList="none", [string]$UserPrincipalName="none" )

$singleUser=$False
if($UserList -eq "none"){
	if($UserPrincipalName -eq "none") {
		write-error "Please, specify a list of users or a single user"
		Exit
	} else {
		$singleUser=$True
	}
}
function checkUser {
	param([string]$user = "")
	
	trap { write-host -ForegroundColor "yellow" "$user is not synchronized"; return }
	$msol = Get-MsolUser -UserPrincipalName $user -EA Stop
	
	if($msol.IsLicensed -eq $False) {
		write-host -ForegroundColor "Cyan" "$user is not licensed"
		#$user >> "stu_notready.txt"
	} else {
		#write-host $user "is licensed!"
	}
}

# run the appropriate query
if ($singleUser -eq $True) {
	checkUser $UserPrincipalName
} else {
	$file = Import-CSV $UserList

	foreach ($r in $file) {
		checkUser $r.mail
	}
}
write-host "Done!"