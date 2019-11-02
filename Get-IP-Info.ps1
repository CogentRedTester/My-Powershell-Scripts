#This code is adapted from: https://gallery.technet.microsoft.com/scriptcenter/Get-ExternalPublic-IP-c1b601bb

""
"-----External IP Info -----"
""
$ipinfo = Invoke-RestMethod http://ipinfo.io/json 
"IP:                        " + $ipinfo.ip
"Hostname:                  " + $ipinfo.hostname 
"City:                      " + $ipinfo.city 
"Region:                    " + $ipinfo.region 
"Country:                   " + $ipinfo.country 
"Location:                  " + $ipinfo.loc 
"Organisation:              " + $ipinfo.org

""