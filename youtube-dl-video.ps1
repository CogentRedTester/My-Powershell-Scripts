if (!$args) {
    $URL = Read-Host -Prompt 'Enter URL'
    $URL = $URL.split(" ")
} else {
    $URL = $args
}

#use bestvideo[width<=1920][height<=1080]+bestaudio to limit to fullHD video
youtube-dl $URL -f bestvideo+bestaudio -i -o "$home\Videos\%(title)s.%(ext)s"

""
"Press any key to exit..."
$Host.UI.RawUI.ReadKey("NoEcho, IncludeKeyDown") | OUT-NULL
$Host.UI.RawUI.FlushInputbuffer()