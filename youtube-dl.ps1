youtube-dl -U

$URL = Read-Host -Prompt 'Enter URL: '

cd $home\Videos

youtube-dl $URL -f bestvideo+bestaudio