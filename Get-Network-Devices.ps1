# Code adapted from: https://stackoverflow.com/questions/41785413/use-powershell-to-get-device-names-and-their-ipaddress-on-a-home-network/41797841#41797841


# Ping subnet to find connected devices
$Subnet = "192.168.20."
1..254|ForEach-Object{
    Start-Process -WindowStyle Hidden ping.exe -Argumentlist "-n 1 -l 0 -f -i 2 -w 1 -4 $SubNet$_"
}
$Computers =(arp.exe -a | Select-String "$SubNet.*dynam") -replace ' +',','|
  ConvertFrom-Csv -Header Computername,IPv4,MAC,x,Vendor|
                   Select Computername,IPv4,MAC

# for each found device, lookup names
ForEach ($Computer in $Computers){
	Try{
		$Computer.Computername = [System.Net.Dns]::GetHostEntry($Computer.ipv4).Hostname
	}
	Catch{
		"Could not get Hostname for " + $Computer.ipv4
	}
}

""				   
"-----------Local Network Devices-----------"
$Computers

#""
#"--------------Current Machine--------------"
#""

$localhost = [System.Net.Dns]::GetHostName()

$localComputer = Get-WmiObject win32_networkadapterconfiguration `
	| Select-Object -Property @{name='IPAddress';Expression={($_.IPAddress[0])}},MacAddress `
	| Where IPAddress -NE $null

#New-Object PsObject -Property @{ Computername = "Computername" ; IPv4 = "IPv4"; MAC = "MAC" }
New-Object PsObject -Property @{ Computername = "------------" ; IPv4 = "--------------"; MAC = "-----------------" }
New-Object PsObject -Property @{ Computername = $localhost ; IPv4 = $localComputer.IPAddress; MAC = $localComputer.MacAddress }