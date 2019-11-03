# Code adapted from: https://stackoverflow.com/questions/41785413/use-powershell-to-get-device-names-and-their-ipaddress-on-a-home-network/41797841#41797841

$Comuters

# Ping subnet to find connected devices
$Subnet = "192.168.20."
1..254|ForEach-Object{
    Start-Process -WindowStyle Hidden ping.exe -Argumentlist "-n 1 -l 0 -f -i 2 -w 1 -4 $SubNet$_"
}
$Computers =(arp.exe -a | Select-String "$SubNet.*dynam") -replace ' +',','|
  ConvertFrom-Csv -Header Computername,IPv4,MAC,x,Vendor|
                   Select Computername,IPv4,MAC

""				   
"-----Local Network Devices-----"
""
				   
# for each found device, lookup names
ForEach ($Computer in $Computers){
	Try{
		$Computer.Computername = [System.Net.Dns]::GetHostByAddress($Computer.ipv4).Hostname
	}
	Catch{
		"Could not get Hostname for " + $Computer.ipv4
	}
}

$Computers
#$Computers | Out-Gridview