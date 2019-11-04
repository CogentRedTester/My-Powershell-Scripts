# Code adapted from: https://stackoverflow.com/questions/41785413/use-powershell-to-get-device-names-and-their-ipaddress-on-a-home-network/41797841#41797841

$localhost = [System.Net.Dns]::GetHostName()

$localComputer = Get-CimInstance win32_networkadapterconfiguration `
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

#test if the DNS resolver is working
#the first Computer will be the default gateway, so it should return almost immediately
$DNSQuery = [System.Net.Dns]::GetHostEntryAsync($Computers[0].ipv4)
Start-Sleep(3)

#if the query has completed in 3 seconds then the DNS resolver is working and the other hostnames are searched for
if ($DNSQuery.IsCompleted){
	# for each found device, lookup names
	ForEach ($Computer in $Computers){
		Try{
			$Computer.Computername = [System.Net.Dns]::GetHostEntry($Computer.ipv4).Hostname
			
		} Catch{
			"error finding hostname: " + $Computer.ipv4
		}
	}
} else {
	"DNS timeout - cannot find hostnames"
}



$Computers += New-Object PsObject -Property @{ Computername = "------------" ; IPv4 = "--------------"; MAC = "-----------------" }
$Computers += New-Object PsObject -Property @{ Computername = $localhost ; IPv4 = $localComputer.IPAddress; MAC = $localComputer.MacAddress }

$Computers