youtube-dl -U

$URL = Read-Host -Prompt 'Enter Audio URL: '

cd $home\Music

youtube-dl $URL -f bestaudio --extract-audio --audio-format mp3