# Windows Terminal with PowerShell and Oh My Posh

The primary purpose of this guide is to provide step-by-step instructions on how to set up Windows Terminal with PowerShell and Oh My Posh. Although tailored to personal preferences, this setup can help enhance productivity when working with a cloud-native tech stack or any modern development environment.

By installing and configuring a curated set of tools, fonts, and PowerShell modules, you’ll achieve a productive, visually rich, and efficient terminal experience.

## Table of Contents

- [Alphabetical Tool List](#alphabetical-tool-list)
- [Pre-requisite: Windows Package Manager (WinGet)](#pre-requisite-windows-package-manager-winget)
- [Core Steps](#core-steps)
  - [Step 1: Install Windows Terminal](#step-1-install-windows-terminal)
  - [Step 2: Install PowerShell](#step-2-install-powershell)
  - [Step 3: Install Git CLI](#step-3-install-git-cli)
  - [Step 4: Install Azure CLI](#step-4-install-azure-cli)
  - [Step 5: Install Kubernetes CLI](#step-5-install-kubernetes-cli)
  - [Step 6: Install Terraform CLI](#step-6-install-terraform-cli)
  - [Step 7: Install Nerd Font](#step-7-install-nerd-font)
  - [Step 8: Install Oh My Posh](#step-8-install-oh-my-posh)
- [Optional Steps](#optional-steps)
  - [Install OpenSSL](#install-openssl)
  - [Install Terminal Icons](#install-terminal-icons)
  - [Install PSReadLine - Predictive IntelliSense](#install-psreadline---predictive-intellisense)
  - [Install C# REPL - Write C# inside Terminal](#install-c-repl---write-c-inside-terminal)
- [Optional Parameter/Tab Completion](#optional-parametertab-completion)
  - [Add dotnet CLI parameter completion](#add-dotnet-cli-parameter-completion)
  - [Add WinGet parameter completion](#add-winget-parameter-completion)
  - [Add Azure CLI parameter completion](#add-azure-cli-parameter-completion)
  - [Add kubectl parameter completion](#add-kubectl-parameter-completion)
  - [Install Posh-Git - Git CLI parameter completion](#install-posh-git---git-cli-parameter-completion)
- [Reference Configuration Files](#reference-configuration-files)
- [All Done!](#all-done)

## Alphabetical Tool List

| Tool | Description |
|------|-------------|
| **Azure CLI** | Manage Azure resources directly from the terminal |
| **C# REPL** | Interactive C# scripting |
| **Git CLI** | Distributed version control |
| **Kubernetes CLI (kubectl)** | Interact with Kubernetes clusters |
| **Nerd Font** | Icon-enhanced fonts for terminals |
| **Oh My Posh** | Customizable prompt engine |
| **OpenSSL** | Toolkit for SSL/TLS and crypto |
| **Posh-Git** | Git enhancements for PowerShell |
| **PowerShell** | Cross-platform shell environment |
| **PSReadLine** | Command-line editing + IntelliSense |
| **Terminal Icons** | Adds icons to directory listings |
| **Terraform** | Infrastructure-as-Code tool |
| **Windows Terminal** | Modern GPU-accelerated terminal |
| **WinGet** | Windows package manager |

## Pre-requisite: Windows Package Manager (WinGet)

Most steps use **WinGet**. It is usually preinstalled.

If not, install it manually:

1. Download the latest release:  
   https://github.com/microsoft/winget-cli/releases/latest
2. Install via PowerShell:

   ```powershell
   Add-AppxPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
   ```

## Core Steps

### Step 1: Install Windows Terminal

📘 https://github.com/microsoft/terminal

```powershell
winget install Microsoft.WindowsTerminal -s winget
```

### Step 2: Install PowerShell

📘 https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows

```powershell
winget install Microsoft.PowerShell -s winget
```

### Step 3: Install Git CLI

📘 https://git-scm.com/

```powershell
winget install Git.Git -e -s winget
```

### Step 4: Install Azure CLI

📘 https://learn.microsoft.com/en-us/cli/azure/install-azure-cli

```powershell
winget install Microsoft.AzureCLI -s winget
```

### Step 5: Install Kubernetes CLI

📘 https://kubernetes.io/docs/reference/kubectl/

```powershell
winget install --id Kubernetes.kubectl -e
winget install --id Microsoft.Azure.Kubelogin -e
```

#### Mandatory configuration

Follow the BIP onboarding setup instructions: [Riverty Kubernetes Developer Setup](https://riverty.atlassian.net/wiki/spaces/BIP/pages/104677999277/Capability+onboarding+guide+to+BIP#Setup-developer-environment-for-Kubernetes-(K8S)).

#### Additional configuration **(optional)**

If you frequently work with Kubernetes, consider adding this convenient alias for `kubectl`:

1. Open your PowerShell profile in Notepad:

   ```powershell
   notepad $PROFILE
   ```

2. Add the following lines:

   ```powershell
   # Register an alias for kubectl
   Set-Alias -Name k -Value kubectl.exe
   ```

### Step 6: Install Terraform CLI

📘 https://developer.hashicorp.com/terraform

```powershell
winget install Hashicorp.Terraform -e -s winget
```

### Step 7: Install Nerd Font

📘 https://www.nerdfonts.com/

Recommended: [CaskaydiaCove Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/CascadiaCode.zip)

1. Download and install the fonts
2. Set `CaskaydiaCove Nerd Font` as the font in your Terminal profile settings

### Step 8: Install Oh My Posh

📘 https://ohmyposh.dev/docs/installation/windows

```powershell
winget install JanDeDobbeleer.OhMyPosh -s winget
```

1. Restart Terminal to reload the updated PATH
2. Open your PowerShell profile:

   ```powershell
   notepad $PROFILE
   ```

3. Add the following line to automatically start Oh My Posh with new Terminal windows:

   ```powershell
   oh-my-posh init pwsh --config "$([Environment]::GetFolderPath("MyDocuments"))/Oh My Posh/v3RUz.omp.json" | Invoke-Expression
   ```

> [!TIP]
> By using the `My Documents` special folder for the Oh My Posh configuration file, you ensure that the configuration is backed up to the cloud via OneDrive and as a bonus you can share the configuration between multiple PC’s.

#### Additional customization options **(optional)**

- https://ohmyposh.dev/docs/installation/customize
- https://www.hanselman.com/blog/my-ultimate-powershell-prompt-with-oh-my-posh-and-the-windows-terminal

## Optional Steps

### Install OpenSSL

📘 https://slproweb.com/products/Win32OpenSSL.html

```powershell
winget install ShiningLight.OpenSSL.Light -s winget
```

### Install Terminal Icons

```powershell
Install-Module -Name Terminal-Icons -Repository PSGallery
```

1. Open your PowerShell profile:

   ```powershell
   notepad $PROFILE
   ```

2. Add the following line:

   ```powershell
   Import-Module -Name Terminal-Icons
   ```

### Install PSReadLine - Predictive IntelliSense

📘 https://learn.microsoft.com/en-us/powershell/module/psreadline/about/about_psreadline

```powershell
Install-Module PSReadLine -AllowPrerelease -Force
```

1. Open your PowerShell profile:

   ```powershell
   notepad $PROFILE
   ```

2. Add the following lines:

   ```powershell
   Import-Module PSReadLine
   Set-PSReadLineOption -PredictionSource History
   Set-PSReadLineOption -PredictionViewStyle ListView
   Set-PSReadLineOption -EditMode Windows
   ```

> [!NOTE]
> The history data file is stored in “$env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine”.

### Install C# REPL - Write C# inside Terminal

📘 https://github.com/waf/CSharpRepl

```powershell
dotnet tool install -g csharprepl
```

## Optional Parameter/Tab Completion

The following steps have command snippets that needs to be added to your PowerShell profile.

1. Open your PowerShell profile:

   ```powershell
   notepad $PROFILE
   ```

2. Add the PowerShell command snippet from the corresponding step below.

### Add dotnet CLI parameter completion

📘 https://www.hanselman.com/blog/how-to-use-autocomplete-at-the-command-line-for-dotnet-git-winget-and-more

```powershell
# PowerShell parameter completion shim for the dotnet CLI
Register-ArgumentCompleter -Native -CommandName dotnet -ScriptBlock {
  param($commandName, $wordToComplete, $cursorPosition)
  dotnet complete --position $cursorPosition "$wordToComplete" |
    ForEach-Object {
      [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}
```

### Add WinGet parameter completion

📘 https://github.com/microsoft/winget-cli/blob/master/doc/Completion.md

```powershell
# PowerShell parameter completion shim for winget
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

### Add Azure CLI parameter completion

📘 https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli#enable-tab-completion-in-powershell

```powershell
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
  Get-Content $completion_file | Sort-Object |
    ForEach-Object {
      [System.Management.Automation.CompletionResult]::new($_, $_, "ParameterValue", $_)
    }
  Remove-Item $completion_file
}
```

### Add kubectl parameter completion

📘 https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/#optional-kubectl-configurations-and-plugins

```powershell
# Generate parameter completion script for kubectl (replace command with the alias created above)
k completion powershell | Out-String | %{$_ -replace("'kubectl'", "'k'")} | Invoke-Expression
```

> [!NOTE]
> If you added the optional `kubectl` PowerShell alias in [Core Step 5](#additional-configuration-optional), make sure to reflect that in this script.

### Install Posh-Git - Git CLI parameter completion

📘 https://github.com/dahlbyk/posh-git

```powershell
Install-Module Posh-Git
```
1. Open your PowerShell profile:

   ```powershell
   notepad $PROFILE
   ```

2. Add the following line:

   ```powershell
   Import-Module Posh-Git
   ```

## Reference Configuration Files

- **Terminal configuration:** [settings.json](settings.json)  
  _Located at: `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json`_

- **Terminal background image:** [2020-mercy-overwatch-4k-rp-1920x1200.jpg](2020-mercy-overwatch-4k-rp-1920x1200.jpg)  
  _Can be placed anywhere; reference the path in settings.json under `backgroundImage`_

- **Oh My Posh configuration:** [v3RUz.omp.json](v3RUz.omp.json)  
  _Typically stored in: `%USERPROFILE%\Documents\Oh My Posh\` or referenced via the profile script_

- **PowerShell profile:** [Microsoft.PowerShell_profile.ps1](Microsoft.PowerShell_profile.ps1)  
  _Located at: `%USERPROFILE%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1` (or find path via `$PROFILE`)_

## All Done!

You now have a functional and visually polished terminal environment tailored for cloud-native development.