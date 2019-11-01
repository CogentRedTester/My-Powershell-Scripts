$URL = Read-Host -Prompt 'Enter Onedrive URL: '

$LongURL = (Invoke-WebRequest -Uri $URL -MaximumRedirection 0 -ErrorAction Ignore).Headers.Location

$DirectLink = $LongURL -replace "redir", "download"

$DirectLink
$DirectLink | clip

"Direct Link copied to clipboard"