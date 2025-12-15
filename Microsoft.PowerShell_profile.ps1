oh-my-posh init pwsh --config "$([Environment]::GetFolderPath("MyDocuments"))/Oh My Posh/v3RUz.omp.json" | Invoke-Expression

Import-Module -Name Terminal-Icons
Import-Module -Name Posh-Git

# https://learn.microsoft.com/en-us/powershell/module/psreadline/about/about_psreadline (History file is stored in $env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine)
Import-Module -Name PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows

# Register an alias for kubectl
Set-Alias -Name k -Value kubectl.exe

# Generate parameter completion script for kubectl (replace command with the alias created above)
k completion powershell | Out-String | ForEach-Object {$_ -replace("'kubectl'", "'k'")} | Invoke-Expression

# PowerShell parameter completion shim for the dotnet CLI
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
    param($commandName, $wordToComplete, $cursorPosition)
        dotnet complete --position $cursorPosition "$wordToComplete" | ForEach-Object {
			[System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
        }
}

# PowerShell parameter completion shim for winget
Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
	param($wordToComplete, $commandAst, $cursorPosition)
		[Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
		$Local:word = $wordToComplete.Replace('"', '""')
		$Local:ast = $commandAst.ToString().Replace('"', '""')
		winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
			[System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
		}
}

# PowerShell parameter completion shim for the Azure CLI
Register-ArgumentCompleter -Native -CommandName az -ScriptBlock {
    param($commandName, $wordToComplete, $cursorPosition)
		$completion_file = New-TemporaryFile
		$env:ARGCOMPLETE_USE_TEMPFILES = 1
		$env:_ARGCOMPLETE_STDOUT_FILENAME = $completion_file
		$env:COMP_LINE = $wordToComplete
		$env:COMP_POINT = $cursorPosition
		$env:_ARGCOMPLETE = 1
		$env:_ARGCOMPLETE_SUPPRESS_SPACE = 0
		$env:_ARGCOMPLETE_IFS = "`n"
		$env:_ARGCOMPLETE_SHELL = 'powershell'
		az 2>&1 | Out-Null
		Get-Content $completion_file | Sort-Object | ForEach-Object {
			[System.Management.Automation.CompletionResult]::new($_, $_, "ParameterValue", $_)
		}
		Remove-Item $completion_file, Env:\_ARGCOMPLETE_STDOUT_FILENAME, Env:\ARGCOMPLETE_USE_TEMPFILES, Env:\COMP_LINE, Env:\COMP_POINT, Env:\_ARGCOMPLETE, Env:\_ARGCOMPLETE_SUPPRESS_SPACE, Env:\_ARGCOMPLETE_IFS, Env:\_ARGCOMPLETE_SHELL
}
