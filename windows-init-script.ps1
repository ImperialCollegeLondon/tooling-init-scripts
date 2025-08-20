# Windows Server VM Init Script for CI/CD Agent Setup
# Installs required tools non-interactively with error handling and logging

try {
    Write-Host "Setting timezone..."
    Set-TimeZone -Name 'GMT Standard Time'

    Write-Host "Setting execution policy..."
    Set-ExecutionPolicy Bypass -Scope Process -Force

    Write-Host "Ensuring TLS 1.2 is enabled..."
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072

    # Check if Chocolatey is installed
    if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-Host "Installing Chocolatey..."
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    } else {
        Write-Host "Chocolatey already installed."
    }

    Write-Host "Installing JDK 17..."
    choco install -y temurin17
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    java --version

    Write-Host "Installing Git..."
    choco install -y git
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    git --version
    git config --system --unset credential.helper

    Write-Host "Installing Python..."
    choco install -y python
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    python --version

    Write-Host "Installing GitHub CLI..."
    choco install -y gh
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    gh --version

    Write-Host "Enabling RSAT..."
    Enable-WindowsOptionalFeature -Online -All -FeatureName ActiveDirectory-PowerShell

    Write-Host "Init script completed successfully."
} catch {
    Write-Error "An error occurred: $_"
    exit 1
}