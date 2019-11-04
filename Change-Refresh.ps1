#uses nircmd to change the refreshrate of the display, designed to be called from within mpv player and passing in video properties

#monitor can either be in the form of an integer, starting from 0
#or the system display names in the form '\\.\DISPLAY#' starting from 1
#mpv uses the system names
$monitor = $args[0]
$width = $args[1]
$height = $args[2]
$refresh = $args[3]

#rounds the framerate down to the nearest integer - nircmd does not like floats
$refresh=[math]::floor($refresh)

#sets the width and height to either 1080p or 2160p
if ($height -lt 1440) {
	$height = 1080
	$width = 1920
} else {
	$height = 2160
	$width = 3840
}

#calls nircmd with the corrrected parameters
nircmd setdisplay monitor:$monitor $width $height 32 $refresh