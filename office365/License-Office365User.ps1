# Assigns licenses to users that are on AD
param( [string]$UserList="none", [string]$UserPrincipalName="none", [string]$Type=$null )

$singleUser=$False
if($UserList -eq "none"){
	if($UserPrincipalName -eq "none") {
		write-error "Please, specify a list of users or a single user"
		Exit
	} else {
		$singleUser=$True
	}
}
if($Type -eq "none") {
	# no type set, raise error
	write-error "Please, specify the type: Staff or Student"
	Exit	
}
if($Type -notlike "staff" -and $Type -notlike "student"){
	# no type selected, need to raise error
	write-error "Invalid license type specified, please enter either Staff or Student"
	Exit
}
$O365Sku = $null
if($Type -like "staff" -or $Type -like "faculty") {
	# create the license type -- staff/faculty
	$staff = New-MsolLicenseOptions -AccountSkuId DOMAIN:STANDARDWOFFPACK_FACULTY -DisabledPlans MCOSTANDARD
	$O365Sku = $staff
}
if($Type -like "student") {
	# create the license type -- student
	$student = New-MsolLicenseOptions -AccountSkuId DOMAIN:STANDARDWOFFPACK_STUDENT -DisabledPlans MCOSTANDARD
	$O365Sku = $student
}
if(-not $O365Sku){
	# no license option set, stop the script
	write-error "No license option set, please set type to Student or Staff"
}

function licenseUser ($Email, $LicenseOption, $Type) {
	$msol = Get-MsolUser -UserPrincipalName $Email
	if($msol.IsLicensed -eq $False){
		# user is not licensed, let's set up their account:
		$msol | set-msoluser -usagelocation "US"
		$license = $null
		if($Type -like "staff") {
			$license = "DOMAIN:STANDARDWOFFPACK_FACULTY"
		}
		if($Type -like "student") {
			$license = "DOMAIN:STANDARDWOFFPACK_STUDENT"
		}
		if($license){
			# user is not licensed, let's license them
			$msol | set-MsolUserLicense -AddLicenses $license -licenseoptions $LicenseOption
		}
	}
}

if ($singleUser -eq $True) {
	licenseUser $UserPrincipalName $O365Sku $Type
} else {
	$file = Import-CSV $UserList
	clear-host
	$i = 1
	foreach ($r in $file) {
		write-progress -activity "Processing $UserList" -status 'Progress' -currentoperation $r.mail -percentcomplete ($i/$file.count * 100)
		licenseUser $r.mail $O365Sku $Type
		$i = $i + 1
	}
}
write-host "Done!"