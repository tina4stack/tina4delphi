[CmdletBinding()]
param(
    [ValidateSet('all', 'codex', 'claude', 'cursor')]
    [string[]]$Client = @('all')
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repositoryRoot = Split-Path -Parent $PSScriptRoot
$skillRoot = Join-Path $repositoryRoot 'skills'
$skillNames = @('rad-studio-delphi', 'rad-studio-maintainer')

$codexRoot = if ($env:CODEX_HOME) {
    Join-Path $env:CODEX_HOME 'skills'
} else {
    Join-Path $HOME '.codex\skills'
}

$destinations = [ordered]@{
    codex = $codexRoot
    claude = Join-Path $HOME '.claude\skills'
    cursor = Join-Path $HOME '.cursor\skills'
}

$selectedClients = if ($Client -contains 'all') {
    @('codex', 'claude', 'cursor')
} else {
    $Client | Select-Object -Unique
}

foreach ($clientName in $selectedClients) {
    $destinationRoot = $destinations[$clientName]
    New-Item -ItemType Directory -Path $destinationRoot -Force | Out-Null

    foreach ($skillName in $skillNames) {
        $source = Join-Path $skillRoot $skillName
        $destination = Join-Path $destinationRoot $skillName

        if (-not (Test-Path -LiteralPath $source)) {
            throw "Skill source not found: $source"
        }

        if (Test-Path -LiteralPath $destination) {
            $destinationItem = Get-Item -LiteralPath $destination -Force
            $linkTargets = if ($destinationItem.PSObject.Properties.Name -contains 'Target') {
                @($destinationItem.Target)
            } else {
                @()
            }

            if ($linkTargets -contains $source) {
                Write-Host "Already linked $skillName for $clientName at $destination"
                continue
            }

            Copy-Item -Path (Join-Path $source '*') -Destination $destination -Recurse -Force
        } else {
            Copy-Item -LiteralPath $source -Destination $destinationRoot -Recurse -Force
        }

        Write-Host "Installed $skillName for $clientName at $destination"
    }
}

Write-Host 'Restart clients that were open before the skills were installed.'
