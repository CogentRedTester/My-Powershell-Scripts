youtube-dl -U

$URL = Read-Host -Prompt 'Enter URL: '

youtube-dl $URL -f bestvideo+bestaudio -o "$home\Videos\%(title)s.%(ext)s"