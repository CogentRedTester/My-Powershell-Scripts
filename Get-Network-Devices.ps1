# Code adapted from: https://stackoverflow.com/questions/41785413/use-powershell-to-get-device-names-and-their-ipaddress-on-a-home-network/41797841#41797841

$localhost = [System.Net.Dns]::GetHostName()

$localComputer = Get-WmiObject win32_networkadapterconfiguration `
	| Select-Object -Property @{name='IPAddress';Expression={($_.IPAddress[0])}},MacAddress `
	| Where IPAddress -NE $null

# Ping subnet to find connected devices
Try {
	$SubNet = $localComputer.IPAddress.Substring(0, $localComputer.IPAddress.lastIndexOf('.') + 1)
} Catch {
	$SubNet = $localComputer.IPAddress[0].Substring(0, $localComputer.IPAddress[0].lastIndexOf('.') + 1)
}
1..254|ForEach-Object{
    Start-Process -WindowStyle Hidden ping.exe -Argumentlist "-n 1 -l 0 -f -i 2 -w 1 -4 $SubNet$_"
}
$Computers =(arp.exe -a | Select-String "$SubNet.*dynam") -replace ' +',','|
  ConvertFrom-Csv -Header Computername,IPv4,MAC,x,Vendor|
                   Select Computername,IPv4,MAC

""				   
"-----------Local Network Devices-----------"

# for each found device, lookup names
ForEach ($Computer in $Computers){
	Try{
		#starts an asyncronous DNS query
		$DNSQuery = [System.Net.Dns]::GetHostEntryAsync($Computer.ipv4)
		$AlreadyFound = 0
		$msecs = 0.0
		
		#checks if the query has completed every 0.5 seconds. After 3 seconds it timeouts 
		while ((!$AlreadyFound) -and ($msecs -lt 3000)){
			Start-Sleep -Milliseconds 500
			if ($DNSQuery.IsCompleted){
				$Computer.Computername = [System.Net.Dns]::GetHostEntry($Computer.ipv4).Hostname
				$AlreadyFound = 1
			}
			$msecs += 500
		}
		if ($msecs -eq 3000){
			"DNS Timeout: " + $Computer.ipv4
		}
	}
	Catch{
		"error finding hostname: " + $Computer.ipv4
	}
}

$Computers

New-Object PsObject -Property @{ Computername = "------------" ; IPv4 = "--------------"; MAC = "-----------------" }
New-Object PsObject -Property @{ Computername = $localhost ; IPv4 = $localComputer.IPAddress; MAC = $localComputer.MacAddress }