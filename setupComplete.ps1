# These commands are all pretty much copied and pasted straight
# out of Matt Wrock's blog post: http://www.hurryupandwait.io/blog/in-search-of-a-light-weight-windows-vagrant-box

# We run them in this file to make sure everything's configured
# properly post-sysprep.

Set-ExecutionPolicy Unrestricted -Force

$obj = Get-WmiObject -Class "Win32_TerminalServiceSetting" -Namespace root\cimv2\terminalservices
$obj.SetAllowTsConnections(1,1)

Enable-WSManCredSSP -Force -Role Server

Set-NetFirewallRule -Name WINRM-HTTP-In-TCP-PUBLIC -RemoteAddress Any
Set-NetFirewallRule -Name RemoteDesktop-UserMode-In-TCP -Enabled True

$admin=[adsi]"WinNT://./Administrator,user"
$admin.psbase.rename("vagrant")
$admin.SetPassword("vagrant")
$admin.UserFlags.value = $admin.UserFlags.value -bor 0x10000
$admin.CommitChanges()

winrm set winrm/config/client/auth '@{Basic="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'

