Start-Process pwsh -Verb runAs -WorkingDirectory $pwd -ArgumentList "-command Elevate-Terminal.ps1"
