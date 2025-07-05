# Setup Script for Gemini CLI + MCP Documentation Workflow
# This script helps you quickly configure the workflow for your repository

param(
    [string]$RepositoryName = "",
    [string]$DefaultBranch = "main",
    [string]$SourceDirectory = "src",
    [string]$DocsDirectory = "docs",
    [string]$Platform = "windows", # windows or linux
    [switch]$Help
)

if ($Help) {
    Write-Host @"
Gemini CLI + MCP Workflow Setup Script

Usage: .\setup-workflow.ps1 [options]

Options:
    -RepositoryName <name>     Your repository name (for commit messages)
    -DefaultBranch <branch>    Your default branch (default: main)
    -SourceDirectory <dir>     Source code directory (default: src)
    -DocsDirectory <dir>       Documentation output directory (default: docs)
    -Platform <platform>       Platform: windows or linux (default: windows)
    -Help                      Show this help message

Examples:
    .\setup-workflow.ps1 -RepositoryName "my-project" -DefaultBranch "develop"
    .\setup-workflow.ps1 -SourceDirectory "lib" -DocsDirectory "api-docs" -Platform "linux"

"@
    exit 0
}

# Validate inputs
if ($Platform -notin @("windows", "linux")) {
    Write-Error "Platform must be 'windows' or 'linux'"
    exit 1
}

if ([string]::IsNullOrWhiteSpace($SourceDirectory) -or [string]::IsNullOrWhiteSpace($DocsDirectory)) {
    Write-Error "Source and docs directories cannot be empty"
    exit 1
}

# Create .github/workflows directory if it doesn't exist
$workflowsDir = ".github\workflows"
if (!(Test-Path $workflowsDir)) {
    New-Item -ItemType Directory -Path $workflowsDir -Force
    Write-Host "Created $workflowsDir directory"
}

# Determine source workflow file
$sourceFile = if ($Platform -eq "windows") { "update_docs_windows.yml" } else { "update_docs_linux.yml" }
$targetFile = "$workflowsDir\update_docs.yml"

# Check if source file exists
if (!(Test-Path $sourceFile)) {
    Write-Error "Source workflow file '$sourceFile' not found. Make sure you're running this script from the repository root."
    exit 1
}

# Copy and customize the workflow
Write-Host "Setting up workflow for $Platform platform..."

$content = Get-Content $sourceFile -Raw

# Customize the workflow content
$content = $content -replace "branches:\s*-\s*main", "branches:`n      - $DefaultBranch"
$content = $content -replace "default:\s*'src/'", "default: '$SourceDirectory/'"
$content = $content -replace "default:\s*'docs/'", "default: '$DocsDirectory/'"
$content = $content -replace "default:\s*'main'", "default: '$DefaultBranch'"

# Customize commit message if repository name is provided
if (![string]::IsNullOrWhiteSpace($RepositoryName)) {
    $customMessage = "Auto-update docs for $RepositoryName with Gemini CLI + MCP"
    $content = $content -replace "Auto-update docs with Gemini CLI \+ MCP", $customMessage
}

# Write the customized workflow
$content | Set-Content $targetFile -Encoding UTF8

Write-Host "✅ Workflow created: $targetFile"
Write-Host ""
Write-Host "📋 Next steps:"
Write-Host "1. Add required secrets to your repository:"
Write-Host "   - PERSONAL_ACCESS_TOKEN (GitHub token with repo permissions)"
Write-Host "   - GITHUB_TOKEN (automatically provided)"
Write-Host ""
Write-Host "2. Verify your configuration:"
Write-Host "   - Default branch: $DefaultBranch"
Write-Host "   - Source directory: $SourceDirectory/"
Write-Host "   - Docs directory: $DocsDirectory/"
Write-Host "   - Platform: $Platform"
Write-Host ""
Write-Host "3. Test the workflow:"
Write-Host "   - Go to Actions tab in your repository"
Write-Host "   - Click 'Run workflow' to test manually"
Write-Host ""
Write-Host "4. Optional: Set repository variables for further customization:"
Write-Host "   - INPUT_DIR: $SourceDirectory/"
Write-Host "   - OUTPUT_DIR: $DocsDirectory/"
Write-Host "   - COMMIT_MESSAGE: Custom commit message"
Write-Host ""

# Create a summary file
$summary = @"
# Workflow Configuration Summary

Repository: $RepositoryName
Platform: $Platform
Default Branch: $DefaultBranch
Source Directory: $SourceDirectory/
Documentation Directory: $DocsDirectory/

## Required Secrets:
- PERSONAL_ACCESS_TOKEN: GitHub Personal Access Token with repo permissions
- GITHUB_TOKEN: Automatically provided by GitHub Actions

## Optional Repository Variables:
- INPUT_DIR: $SourceDirectory/
- OUTPUT_DIR: $DocsDirectory/
- COMMIT_MESSAGE: Custom commit message
- ENABLE_AUTO_PUSH: true/false
- CLEAN_CACHE: true/false

## Files Created:
- $targetFile

## Next Steps:
1. Add the required secrets to your repository
2. Test the workflow manually
3. Push to your default branch to trigger automatic runs
"@

$summary | Set-Content "workflow-setup-summary.md" -Encoding UTF8
Write-Host "📄 Created workflow-setup-summary.md with configuration details" 