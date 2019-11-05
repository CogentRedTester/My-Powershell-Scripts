$URL = Read-Host -Prompt 'Enter Onedrive URL: '

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
$DirectLink | clip

"Direct Link copied to clipboard"