$refresh=$args[2]
$refresh=[math]::floor($refresh)

nircmd setdisplay monitor:1 $args[0] $args[1] 32 $refresh