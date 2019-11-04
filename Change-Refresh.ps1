#uses nircmd to change the refreshrate of the display, designed to be called from within mpv player and passing in video properties

$monitor = $args[0]
$width = $args[1]
$height = $args[2]
$refresh = $args[3]

#finds the monitor from the display name which mpv player passes
#if the value is an int then the direct int is used - this would be for when manually running the script
#keep in mind that nircmd starts counting displays from 0 while the system display names start from 1
if ($monitor.GetType().name -eq ("String")) {
	Try {
		$monitor = $monitor.Substring($monitor.length - 1, 1)
		$monitor = [convert]::ToInt32($monitor, 10)
		$monitor --
	} Catch {
		"string is not a valid display name"
	}
}

#makes sure the display integer is not below 0
if ($monitor -lt 0) {
	$monitor = 0;
	"display number is less than 0, setting to 0"
	}

#rounds the framerate down to the nearest integer - nircmd does not like floats
$refresh=[math]::floor($refresh)

#sets the width and height to either 1080p or 2160p
if ($height -lt 1440) {
	$height = 1080
	$width = 1920
} else {
	$height = 3840
	$width = 2160
}

#calls nircmd with the 
nircmd setdisplay monitor:$monitor $width $height 32 $refresh