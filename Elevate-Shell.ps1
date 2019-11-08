Start-Process pwsh -Verb runAs -WorkingDirectory $pwd
Stop-Process -Id $PID