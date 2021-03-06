#asks the user to install the module if it does not exist on the system
$clip = Get-Clipboard

#if a parameter is not entered, then ask for one
#if there is no parameter and the clipboard contains a onedrive shortened url then uses that without asking
if (!$args) {
    if (!($null -eq $clip) -and $clip.contains("1drv.ms")) {
        $URL = $clip

        Write-Host "found url in clipboard: " -ForegroundColor cyan -NoNewline
        Write-Host $URL -ForegroundColor green
        Write-Host
    } else {
        $URL = Read-Host -Prompt 'Enter Onedrive URL'
    }
} else {
    $URL = $args[0]
}

#tries to expand the link
Try {
    $LongURL = [System.Net.HttpWebRequest]::Create($URL).GetResponse().ResponseUri.AbsoluteUri
} Catch {
    "ERROR: invalid URL"
}

#if anything went wrong with the web request then $LongURL will equal null
#if so run error message, and if not convert the expanded link into a direct download and print to console and clipboard
if (!$null -eq $LongURL) {
    $DirectLink = $LongURL -replace "redir", "download"

    Write-Host "Direct Link: " -ForegroundColor Cyan -NoNewline
    Write-Host $DirectLink -ForegroundColor Green

    #The normal clip.exe adds a newline to the end of the string
    $DirectLink | Set-Clipboard
    Write-Host "Direct Link copied to clipboard" -ForegroundColor Magenta
} else {
    ""
    "ERROR: could not find Direct Link"
}
