param($Directory = $pwd, $Type = "all", [Bool] $Recurse = $false, [int[]] $Range = @($null, $null))

Function Build-Playlist {
    param([string] $Directory, $Type = "all", [Bool] $Recurse = $false, $Range = @($null, $null))

    $outputFile = "$Directory\.folder.m3u"
    if (Test-Path -LiteralPath $outputFile) {
        Remove-Item -LiteralPath $outputFile
    }

    [array] $files = (Get-ChildItem -LiteralPath $Directory)
    if ($files.length -lt 1) {
        Write-Host "skipping $Directory because directory is empty" -ForegroundColor Red
        Write-Host $files
        return
    }
    Write-Host "Writing playlist in $Directory" -ForegroundColor Green

    For ($i = 0 ; $i -lt $files.Length ; $i++) {
        $file = $files[$i]
        Write-Host "Adding $file to playlist" -ForegroundColor Blue

        #if the path is a directory it recursively makes a playlist inside that directory
        if ($file.PSIsContainer -and $Recurse) {
            Build-Playlist -Directory "$file" -Type $Type -Recurse $Recurse -Range 0,0
        }

        Add-Content -LiteralPath $outputFile -Value $file.Name
    }
    Write-Host "Finished writing playlist in $directory" -ForegroundColor Magenta
}


Build-Playlist -Directory $Directory -Type $Type -Recurse $Recurse -Range $Range