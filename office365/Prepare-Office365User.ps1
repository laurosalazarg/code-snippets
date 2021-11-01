# script to update user information
param ( [string]$File="" );

if(-not (Test-Path $File)){
	# file not found
	write-host -foregroundcolor yellow "File not found '$File'. Please, make sure that the path is correct."
	Exit
}

# read a user from the file
$bulkusers = Import-CSV $File

foreach ($user in $bulkusers){
	$this_username = $user.username
	$this_emailaddress = $user.mail
	# determine if the user exists, if they don't then report error
	$aduser = get-aduser -filter { samaccountname -eq $this_username } -properties mail,mailnickname,proxyaddresses,targetaddress,extensionAttribute10,mail,userprincipalname
	if($aduser -eq $Null) {
		# user does not exists
		write-host -foregroundcolor yellow "$aduser does not exist in AD"
		continue
	} else {
		# user does exist, let's check if they have the appropriate attributes set
		# is the email address already in use?
		$otheruser = get-aduser -Filter { userprincipalname -eq $this_emailaddress}
		if($otheruser -eq $Null){
			# this email is not assigned, let's continue
		} else {
			# check if this is assigned to the current user
			if($otheruser.samaccountname -eq $this_username){
				# this is the same user it is OK to continue
			} else {
				# this email address is already assigned to another user
				write-host -foregroundcolor yellow $this_emailaddress "is already assigned to another user "$otheruser.samaccountname
				continue
			}
		}
		# check the data from the file
		if($this_emailaddress -notlike "*@domain.com"){
			# email address does not have the correct domain
			echo "$this_emailaddress does not have the expected domain: domain.com"
			continue
		}
		
		# get the expected values
		# getting the alias
		$newalias = ($this_emailaddress.split("@"))[0]	# john.doe@domain.com => ("john.doe", "domain.com")
		$newemail = $this_emailaddress
		$newproxyaddress="smtp:"+$newalias+"@domain.mail.onmicrosoft.com"
		$newprimaryproxyaddress="SMTP:"+$newalias+"@domain.com"
		$targetaddress = "SMTP:"+$newalias+"@domain.mail.onmicrosoft.com"
		$newuserprincipalname = $newemail
		$office365flag = "Office365"
		
		# is the mailnickname set in AD?
		if($aduser.mailnickname){
			# yes
			# does it match our email?
			if($newalias -eq $aduser.mailnickname){
				# no, let's configure it
				$aduser | set-aduser -clear mailnickname
				$aduser | set-aduser -add @{mailnickname=$newalias}
				echo "Replacing mailnickname for $this_username to $newalias"
			} # yes, do nothing because it is already configured
		} else {
			# no, it's not set, let's set it
			$aduser | set-aduser -add @{mailnickname=$newalias}
			echo "Setting mailnickname for $this_username to $newalias"
		}
		# check if the MSOL proxyaddress is configured
		if($aduser.proxyaddresses -like $newproxyaddress){
			# yes, it's already configured
			echo "Proxy address "$newproxyaddress" is already configured for user: "$this_username
		} else {
			# no, it's not configured
			$aduser | Set-ADUser -Add @{proxyaddresses=$newproxyaddress}
			echo "Adding proxyaddress $newproxyaddress on $this_username"
		}
		# check if the proxyaddress includes the user's primary email address e.g. SMTP:john.doe@domain.com
		if($aduser.proxyaddresses -like $newprimaryproxyaddress){
			# yes, it is already set, do nothing
			echo "proxyaddress already configured for $this_username"
		} else {
			# set the user's email address
			$aduser | Set-ADUser -Add @{proxyaddresses=$newprimaryproxyaddress}
			echo "Adding primary proxyAddress for $this_username to $newprimaryproxyaddress"
		}
		
		# configure the target address
		$aduser | Set-ADUser -Clear targetAddress
		$aduser | Set-ADUser -Add @{targetAddress=$targetaddress}
		echo "Setting targetAddress for $this_username to $targetAddress"
		
		# configure the user's email address
		$aduser | Set-ADUser -Clear mail
		$aduser | Set-ADUser -Add @{mail=$newemail}
		echo "Setting mail for $this_username to $newemail"
		
		# set the user's principal name
		$aduser | Set-ADUser -UserPrincipalName $newemail
		echo "Setting UPN for $this_username to $newemail"
		
		# configure the Office365 flag
		$aduser | Set-ADUser -Clear extensionAttribute10
		$aduser | Set-ADUser -Add @{extensionAttribute10=$office365flag}
		echo "Finished: $this_username, new email: $newemail"
	}
}