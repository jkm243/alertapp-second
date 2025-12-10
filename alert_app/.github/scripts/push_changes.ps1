<#
Simple script to stage, commit and push changes to a remote.
Run this script from the repository root in PowerShell v5.1

Usage:
  powershell -ExecutionPolicy Bypass -File .github/scripts/push_changes.ps1 -RemoteUrl <https://git-url> -Branch <branch-name> -CommitMessage <message>

If you don't supply a branch, the script creates a branch named feature/role-split-<timestamp>.
#>
param(
  [Parameter(Mandatory=$false)]
  [string]$RemoteUrl = 'https://github.com/jkm243/alertapp-second.git',

  [Parameter(Mandatory=$false)]
  [string]$Branch = '',

  [Parameter(Mandatory=$false)]
  [string]$CommitMessage = 'Add role apps, RoleGuard, Supervisor functionality, CI workflow and docs updates'
)

function Die($msg){ Write-Error $msg; exit 1 }

if (-not (Get-Command git -ErrorAction SilentlyContinue)){
  Die 'Git is not installed or not in PATH. Install Git (https://git-scm.com/) and re-run this script.'
}

if (-not (Test-Path .git)){
  Die 'This folder is not a git repository. Initialize one with `git init` or run this script from the repository root.'
}

if ([string]::IsNullOrEmpty($Branch)){
  $ts = Get-Date -Format "yyyyMMdd-HHmm"
  $Branch = "feature/role-split-$ts"
}

# Detect remote origin
$originUrl = (git remote get-url origin 2>$null) -join ''
if (-not $originUrl){
  Write-Host "Adding origin: $RemoteUrl"
  git remote add origin $RemoteUrl
} else {
  Write-Host "Remote origin already set: $originUrl"
  if ($originUrl -ne $RemoteUrl){
    Write-Host "Updating origin to: $RemoteUrl"
    git remote set-url origin $RemoteUrl
  }
}

# Create and checkout branch
Write-Host "Creating and checking out branch: $Branch"
git checkout -b $Branch

# Stage all changes
Write-Host 'Staging changes...'
git add -A

# Commit
Write-Host 'Committing changes...'
$commitResult = git commit -m "$CommitMessage"
if ($LASTEXITCODE -ne 0){
  Write-Host 'No changes to commit or commit failed. Proceeding to push anyway.'
}

# Push
Write-Host "Pushing to origin $Branch..."
git push --set-upstream origin $Branch

Write-Host "Done. Branch pushed to origin/$Branch"