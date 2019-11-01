youtube-dl -U

$URL = Read-Host -Prompt 'Enter Audio URL: '

youtube-dl $URL -f bestaudio --extract-audio --audio-format mp3 -o "$home\Music\%(title)s.%(ext)s"