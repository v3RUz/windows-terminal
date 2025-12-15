# Windows Terminal with PowerShell and Oh My Posh

The primary purpose of this guide is to provide step-by-step instructions on how to set up Windows Terminal with PowerShell and Oh My Posh. Although tailored to personal preferences, this setup can help enhance productivity when working with a cloud native tech stack or any modern development environment.

By installing and configuring a curated set of tools, fonts, and PowerShell modules, you’ll achieve a productive, visually rich, and efficient terminal experience.

---

## Table of Contents

- [Tool Overview](#tool-overview)
- [Pre-requisite: Windows Package Manager (WinGet)](#pre-requisite-windows-package-manager-winget)
- [Let’s Get Started](#lets-get-started)
  - Step 1: Install Windows Terminal
  - Step 2: Install PowerShell
  - Step 3: Install Git CLI
  - Step 4 (Optional): Install OpenSSL
  - Step 5: Install Microsoft Azure CLI
  - Step 6: Install Kubernetes CLI
  - Step 7: Install Terraform CLI
  - Step 8: Install Nerd Font
  - Step 9: Install Oh My Posh
  - Step 10: Install Terminal Icons (Optional)
  - Step 11: Install PSReadLine (Optional)
  - Step 12: Install C# REPL (Optional)
  - Step 13: Add dotnet CLI autocomplete (Optional)
  - Step 14: Add WinGet autocomplete (Optional)
  - Step 15: Add Azure CLI autocomplete (Optional)
  - Step 16: Install PoshGit (Optional)
  - Step 17: Add kubectl autocomplete (Optional)
- [Reference configuration files](#reference-configuration-files)
- [All Done!](#all-done)

---

## Tool Overview

| Tool | Description |
|------|-------------|
| **Azure CLI** | Manage Azure resources directly from the terminal |
| **C# REPL** | Interactive C# scripting |
| **Git CLI** | Distributed version control |
| **Kubernetes CLI (kubectl)** | Interact with Kubernetes clusters |
| **Nerd Font** | Icon-enhanced fonts for terminals |
| **Oh My Posh** | Customizable prompt engine |
| **OpenSSL** | Toolkit for SSL/TLS and crypto |
| **PoshGit** | Git enhancements for PowerShell |
| **PowerShell** | Cross-platform shell environment |
| **PSReadLine** | Command-line editing + IntelliSense |
| **Terminal Icons** | Adds icons to directory listings |
| **Terraform** | Infrastructure-as-Code tool |
| **Windows Terminal** | Modern GPU-accelerated terminal |
| **WinGet** | Windows package manager |

---

## Pre-requisite: Windows Package Manager (WinGet)

Most steps use **WinGet**. It is usually preinstalled.

If not, install it manually:

1. Download the latest release:  
   https://github.com/microsoft/winget-cli/releases/latest
2. Install via PowerShell:

```powershell
Add-AppxPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
```

---

## Let’s Get Started

### Step 1: Install Windows Terminal

```powershell
winget install Microsoft.WindowsTerminal -s winget
```

### Step 2: Install PowerShell

```powershell
winget install Microsoft.PowerShell -s winget
```

### Step 3: Install Git CLI

```powershell
winget install Git.Git -e -s winget
```

### Step 4 (Optional): Install OpenSSL

```powershell
winget install ShiningLight.OpenSSL.Light -s winget
```

### Step 5: Install Microsoft Azure CLI

```powershell
winget install Microsoft.AzureCLI -s winget
```

### Step 6: Install Kubernetes CLI

```powershell
winget install --id Kubernetes.kubectl -e
winget install --id Microsoft.Azure.Kubelogin -e
```

### Optional alias

```powershell
Set-Alias -Name k -Value kubectl.exe
```

### Step 7: Install Terraform CLI

```powershell
winget install Hashicorp.Terraform -e -s winget
```

### Step 8: Install Nerd Font

Recommended: CaskaydiaCove Nerd Font  
https://www.nerdfonts.com/

### Step 9: Install Oh My Posh

```powershell
winget install JanDeDobbeleer.OhMyPosh -s winget
```

Add to PowerShell profile:

```powershell
oh-my-posh init pwsh --config "$([Environment]::GetFolderPath("MyDocuments"))/Oh My Posh/v3RUz.omp.json" | Invoke-Expression
```

### Step 10 (Optional): Install Terminal Icons

```powershell
Install-Module -Name Terminal-Icons -Repository PSGallery
Import-Module Terminal-Icons
```

### Step 11 (Optional): Install PSReadLine

```powershell
Install-Module PSReadLine -AllowPrerelease -Force
Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows
```

### Step 12 (Optional): Install C# REPL

```powershell
dotnet tool install -g csharprepl
```

### Step 13 (Optional): Add dotnet CLI autocomplete

```powershell
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
  param($commandName, $wordToComplete, $cursorPosition)
  dotnet complete --position $cursorPosition "$wordToComplete" |
    ForEach-Object {
      [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}
```

### Step 14 (Optional): Add WinGet autocomplete

```powershell
Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
  param($wordToComplete, $commandAst, $cursorPosition)
  [Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
  $Local:word = $wordToComplete.Replace('"', '""')
  $Local:ast = $commandAst.ToString().Replace('"', '""')
  winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition |
    ForEach-Object {
      [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}
```

### Step 15 (Optional): Add Azure CLI autocomplete

```powershell
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
  Get-Content $completion_file | Sort-Object |
    ForEach-Object {
      [System.Management.Automation.CompletionResult]::new($_, $_, "ParameterValue", $_)
    }
  Remove-Item $completion_file
}
```

### Step 16 (Optional): Install PoshGit

```powershell
Install-Module Posh-Git
Import-Module Posh-Git
```

### Step 17 (Optional): Add kubectl autocomplete

```powershell
k completion powershell | Out-String | %{$_ -replace("'kubectl'", "'k'")} | Invoke-Expression
```

---

## Reference configuration files

- **Terminal configuration:** [settings.json](settings.json)  
  _Located at: `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json`_

- **Terminal background image:** [2020-mercy-overwatch-4k-rp-1920x1200.jpg](2020-mercy-overwatch-4k-rp-1920x1200.jpg)  
  _Can be placed anywhere; reference the path in settings.json under `backgroundImage`_

- **Oh My Posh configuration:** [v3RUz.omp.json](v3RUz.omp.json)  
  _Typically stored in: `%USERPROFILE%\Documents\Oh My Posh\` or referenced via the profile script_

- **PowerShell profile:** [Microsoft.PowerShell_profile.ps1](Microsoft.PowerShell_profile.ps1)  
  _Located at: `%USERPROFILE%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1` (or find path via `$PROFILE`)_

---

## All Done!

You now have a functional and visually polished terminal environment tailored for cloud-native development.