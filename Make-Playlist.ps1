$files = (Get-ChildItem).Name

$outputFile = "$pwd\playlist.pls"

Set-Content -Value "[playlist]" -LiteralPath $outputFile -Include $outputFile

$fileLength = $files.length
For ($i = 1; $i -lt $fileLength + 1; $i ++) {
    $file = $files[$i-1]
    Add-Content -LiteralPath $outputFile -Value "File$i=$file"
}

Add-Content -LiteralPath $outputFile -Value "NumberOfEntries=$fileLength"