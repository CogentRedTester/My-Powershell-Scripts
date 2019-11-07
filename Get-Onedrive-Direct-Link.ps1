#Get-ClipboardText & Set-ClipboardText from:
#https://www.powershellgallery.com/packages/ClipboardText/

#asks the user to install the module if it does not exist on the system
Try {
    $clip = Get-ClipboardText
} Catch [System.Management.Automation.CommandNotFoundException] {
    "Module ClipboardText not found - please install Module: "
    ""
    Install-Module -Name ClipboardText
    $clip = Get-ClipboardText
}

#if a parameter is not entered, then ask for one
#if there is no parameter and the clipboard contains a onedrive shortened url then uses that without asking
if (!$args) {
    if (!($null -eq $clip) -and $clip.contains("1drv.ms")) {
        $URL = $clip

        "found url in clipboard: " + $clip
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

    "Direct Link: " + $DirectLink

    #The normal clip.exe adds a newline to the end of the string
    $DirectLink | Set-ClipboardText

    "Direct Link copied to clipboard"
} else {
    ""
    "ERROR: could not find Direct Link"
}