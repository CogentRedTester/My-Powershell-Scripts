#Get-ClipboardText & Set-ClipboardText from:
#https://www.powershellgallery.com/packages/ClipboardText/

Try {
    $clip = Get-ClipboardText
} Catch {
    Install-Module -Name ClipboardText -Confirm
    $clip = Get-ClipboardText
}

#if a parameter is not entered, then ask for one
#if there is no parameter and the clipboard contains a onedrive shortened url then uses that without asking
if (!$args) {
    if ($clip.contains("1drv.ms")) {
        $URL = $clip
    } else {
        $URL = Read-Host -Prompt 'Enter Onedrive URL'
    }
} else {
    $URL = $args[0]
}

#tries to run using powershell 5 command, if that fails tries powershell 6 workaround
Try {
    $LongURL = (Invoke-WebRequest -uri $URL -MaximumRedirection 0 -ErrorAction Ignore).Headers.Location   
} Catch {
    Try {
        Invoke-WebRequest -uri $URL -MaximumRedirection 0
    } Catch {
        $LongURL = $_.Exception.Response.Headers.Location
    }
}

$DirectLink = $LongURL -replace "redir", "download"

$DirectLink

#The normal clip.exe adds a newline to the end of the string
$DirectLink | Set-ClipboardText

"Direct Link copied to clipboard"