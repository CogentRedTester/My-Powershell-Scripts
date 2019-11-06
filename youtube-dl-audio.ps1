youtube-dl -U
""

if (!$args) {
    $URL = Read-Host -Prompt 'Enter Audio URL'
    $URL = $URL.split(" ")
} else {
    $URL = $args
}

youtube-dl $URL -f bestaudio -i --extract-audio --audio-format mp3 -o "$home\Music\%(title)s.%(ext)s"