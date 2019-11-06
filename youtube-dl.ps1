youtube-dl -U

if (!$args) {
    $URL = Read-Host -Prompt 'Enter URL'
    $URL = $URL.split(" ")
} else {
    $URL = $args
}

#use bestvideo[width<=1920][height<=1080]+bestaudio to limit to fullHD video
youtube-dl $URL -f bestvideo+bestaudio -o "$home\Videos\%(title)s.%(ext)s"