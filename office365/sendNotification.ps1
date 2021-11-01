function sendNotification($server,$userName,$data,$proposed){
	# ToAdd: if parameters data, proposed, exist do or else
    $att = new-object net.mail.attachment($data)
    $msg = new-object Net.Mail.MailMessage
    $smtp = new-object Net.Mail.SmtpClient($server,587)
    $smtp.enablessl = $True
    $PlainPassword = "`$pass"
    $SecurePassword = $PlainPassword | ConvertTo-SecureString -AsPlainText -Force
    $creds = New-Object System.Management.Automation.PSCredential -ArgumentList $UserName, $SecurePassword
    $smtp.credentials = New-Object System.Net.NetworkCredential($creds.username, $creds.password);
    $msg.From = $userName # user@domain.com
    $msg.To.Add("monitor@domain.com")
    $msg.Subject = "Automatic Email Account Provisioning Report"
    $msg.Body = "Created " + $proposed + " mails."
    $msg.Attachments.Add($att)
    $smtp.Send($msg)
    $att.Dispose()
}