oh-my-posh init pwsh --config "$([Environment]::GetFolderPath("MyDocuments"))/Oh My Posh/v3RUz.omp.json" | Invoke-Expression

# Ensure UTF-8 so Nerd Font glyphs (PUA codepoints) survive the console encoding path used by PSReadLine and child-process stdin/stdout
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()
[Console]::InputEncoding  = [System.Text.UTF8Encoding]::new()
$OutputEncoding           = [System.Text.UTF8Encoding]::new()

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

# PowerShell parameter completion using PSReadLineKeyHandler for generating git commit messages with copilot based on staged changes.
#   Intercepts Tab when the buffer ends with `git commit ... -m `.
#   Shows an hourglass glyph immediately as visual feedback, then swaps it with the Copilot-generated commit message.
#   All other Tab presses fall through to the default completion (posh-git, etc).
$script:CopilotCommitCache = @{}

function Get-CopilotCommitMessage {
    param([string]$Diff)

    $sha = [System.BitConverter]::ToString([System.Security.Cryptography.SHA1]::Create().ComputeHash([System.Text.Encoding]::UTF8.GetBytes($Diff))).Replace('-','')
    if ($script:CopilotCommitCache.ContainsKey($sha)) {
        return $script:CopilotCommitCache[$sha]
    }

    $files = git diff --cached --name-status 2>$null | Out-String

    $prompt = @'
You will receive a git staged diff below. Output EXACTLY ONE
Conventional Commit message describing the change.

Rules:
- Single line only, no newlines.
- Aim for 50 characters. Hard maximum 72 characters.
- Imperative mood ("add", "fix", "refactor", not "added"/"adds").
- No surrounding quotes, no trailing period, no markdown, no code fences.
- No preamble or explanation — output ONLY the commit message text.
'@

    # Copilot CLI always persists a session, so run it with a throwaway COPILOT_HOME
    # (keeps it out of ~/.copilot, the session picker and VS Code), from %TEMP% instead of the repo,
    # with remote sync off, and delete the session folder afterwards.
    $previousHome = $env:COPILOT_HOME
    $mainHome     = if ($previousHome) { $previousHome } else { Join-Path $env:USERPROFILE '.copilot' }
    $copilotHome  = Join-Path $env:LOCALAPPDATA 'copilot-commitmsg'
    $configPath   = Join-Path $copilotHome 'config.json'
    $null = New-Item -ItemType Directory -Path $copilotHome -Force
    # The auth token lives in Credential Manager; the CLI only needs to know which user to use.
    $mainConfig = Get-Content (Join-Path $mainHome 'config.json') -Raw -ErrorAction SilentlyContinue | ConvertFrom-Json -ErrorAction SilentlyContinue
    if ($mainConfig.lastLoggedInUser) {
        $config = Get-Content $configPath -Raw -ErrorAction SilentlyContinue | ConvertFrom-Json -ErrorAction SilentlyContinue
        if (-not $config) { $config = [pscustomobject]@{} }
        $config | Add-Member lastLoggedInUser $mainConfig.lastLoggedInUser -Force
        $config | Add-Member loggedInUsers $mainConfig.loggedInUsers -Force
        $config | ConvertTo-Json -Depth 10 | Set-Content $configPath
    }

    $sessionId = [guid]::NewGuid().ToString()
    $env:COPILOT_HOME = $copilotHome
    try {
        # Piped stdin is ignored when -p is given, so send instructions + diff together as the prompt via stdin.
        $stdin = "$prompt`n`nFiles changed:`n$files`nDiff:`n$Diff"
        $msg = $stdin |
            & copilot -C $env:TEMP --session-id $sessionId --sync-session=off --disable-builtin-mcps --no-custom-instructions --no-ask-user -s --log-level none 2>$null |
            Where-Object { $_ -and $_.Trim() } |
            Select-Object -Last 1
    }
    finally {
        $env:COPILOT_HOME = $previousHome
        Remove-Item (Join-Path $copilotHome "session-state\$sessionId") -Recurse -Force -ErrorAction SilentlyContinue
    }

    if (-not $msg) { return $null }

    $msg = $msg.Trim().Trim('"', "'", '`')
    if ($msg.Length -gt 72) { $msg = $msg.Substring(0, 72).TrimEnd() }

    $script:CopilotCommitCache[$sha] = $msg

    return $msg
}

Set-PSReadLineKeyHandler -Chord Tab -ScriptBlock {
    param($key, $arg)

    $line = $null
    $cursor = 0
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    # Only intercept when the text before the cursor looks like:
    #   git commit ... -m <space>
    # If the user has already started typing a quote (or anything else) after -m, respect their intent and fall through to default completion.
    $before = $line.Substring(0, $cursor)
    if ($before -notmatch '\bgit\s+commit\b.*\s-m\s+$') {
        [Microsoft.PowerShell.PSConsoleReadLine]::TabCompleteNext($key, $arg)
        return
    }

    # Nothing staged? Let default completion handle it.
    $diff = git diff --cached 2>$null | Out-String
    if ([string]::IsNullOrWhiteSpace($diff)) {
        [Microsoft.PowerShell.PSConsoleReadLine]::TabCompleteNext($key, $arg)
        return
    }

    # Insert an instant Nerd Font hourglass as visual "working..." feedback.
    $placeholder = [string][char]0xF252   # nf-fa-hourglass_half
    $insertStart = $cursor
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert($placeholder)

    # Blocking Copilot call (cache-hits are instant).
    $msg = Get-CopilotCommitMessage -Diff $diff

    if (-not $msg) {
        [Microsoft.PowerShell.PSConsoleReadLine]::Replace($insertStart, $placeholder.Length, '')
        return
    }

    [Microsoft.PowerShell.PSConsoleReadLine]::Replace($insertStart, $placeholder.Length, "`"$msg`"")
}
