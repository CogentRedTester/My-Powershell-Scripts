Start-Process pwsh -Verb runAs -WorkingDirectory $pwd -WindowStyle Hidden -ArgumentList "-command wt -d $pwd ; exit"