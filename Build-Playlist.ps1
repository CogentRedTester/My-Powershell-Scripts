param($Directory = $pwd, $Type = "all", [Bool] $Recurse = $true, [int[]] $Range = @($null, $null))

Function Build-Playlist {
    param([string] $Directory, $Type = "all", [Bool] $Recurse = $true, $Range = @($null, $null))

    $outputFile = "$Directory\playlist.pls"
    if (Test-Path -LiteralPath $outputFile) {
        Remove-Item -LiteralPath $outputFile
    }

    [string[]] $files = (Get-ChildItem -LiteralPath $Directory).name
    if ($files.length -lt 1) {
        Write-Host "skipping $Directory because directory is empty" -ForegroundColor Red
        Write-Host $files
        return
    }
    Write-Host "Writing playlist in $Directory" -ForegroundColor Green
    Set-Content -Value "[playlist]" -LiteralPath $outputFile

    #sets the range for the playlist
    if (0 -eq $Range[0]) {
        $Range[0] = 1
    }
    if (0 -eq $Range[1]) {
        $Range[1] = $files.length
    } elseif ($Range[1] -gt $files.length) {
        $Range[1] = $files.length
    }

    $playlistLength = ($Range[1] + 1) - $Range[0]
    $playlistNum = 1
    For ($i = $Range[0]; $i -lt $Range[1] + 1; $i++) {
        $file = $files[$i - 1]
        Write-Host "Adding $file to playlist" -ForegroundColor Blue

        #if the path is a directory it recursively makes a playlist inside that directory
        if ((Test-Path -LiteralPath "$directory\$file" -PathType container) -and $Recurse) {
            Build-Playlist -Directory "$directory\$file" -Type $Type -Recurse $Recurse -Range 0,0
        }

        Add-Content -LiteralPath $outputFile -Value "File$playlistNum=$file"
        $playlistNum ++
    }
    Add-Content -LiteralPath $outputFile -Value "NumberOfEntries=$playlistLength"
    Write-Host "Finished writing playlist in $directory" -ForegroundColor Magenta
}


Build-Playlist -Directory $Directory -Type $Type -Recurse $Recurse -Range $Range