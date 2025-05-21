# Create .git/hooks directory if it doesn't exist
$hooksDir = ".git/hooks"
if (-not (Test-Path $hooksDir)) {
    New-Item -ItemType Directory -Path $hooksDir -Force
}

# Copy pre-commit hook
Copy-Item "scripts/git-hooks/pre-commit" "$hooksDir/pre-commit" -Force

# Make the hook executable
$acl = Get-Acl "$hooksDir/pre-commit"
$acl.SetAccessRuleProtection($false, $true)
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Everyone", "FullControl", "Allow")
$acl.AddAccessRule($rule)
Set-Acl "$hooksDir/pre-commit" $acl

Write-Host "✅ Git hooks installed successfully!" 