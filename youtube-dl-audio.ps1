youtube-dl -U

if (!$args) {
    $URL = Read-Host -Prompt 'Enter URL'
} else {
    $URL = $args
}

youtube-dl $URL -f bestaudio --extract-audio --audio-format mp3 -o "$home\Music\%(title)s.%(ext)s"