# Quick Test Script for Gemini CLI + MCP Workflow
# This script tests basic functionality without requiring Pester

Write-Host "🧪 Quick Test for Gemini CLI + MCP Workflow" -ForegroundColor Cyan
Write-Host ""

$testResults = @{
    Passed = 0
    Failed = 0
    Total = 0
}

function Test-Step {
    param(
        [string]$Name,
        [scriptblock]$Test
    )
    
    $testResults.Total++
    Write-Host "Testing: $Name" -NoNewline
    
    try {
        & $Test
        Write-Host " ✅ PASSED" -ForegroundColor Green
        $testResults.Passed++
    } catch {
        Write-Host " ❌ FAILED" -ForegroundColor Red
        Write-Host "   Error: $($_.Exception.Message)" -ForegroundColor Red
        $testResults.Failed++
    }
}

# Test 1: Check if required files exist
Test-Step "File Structure" {
    $requiredFiles = @(
        ".github\workflows\update_docs_windows.yml",
        ".github\workflows\update_docs_linux.yml",
        "setup-workflow.ps1",
        "workflow-template.yml",
        "README.md"
    )
    
    foreach ($file in $requiredFiles) {
        if (-not (Test-Path $file)) {
            throw "Missing required file: $file"
        }
    }
    Write-Host "   Found all required files"
}

# Test 2: Validate workflow YAML structure
Test-Step "Workflow YAML Structure" {
    $workflowFile = ".github\workflows\update_docs_windows.yml"
    $content = Get-Content $workflowFile -Raw
    
    $requiredSections = @("name:", "on:", "jobs:", "steps:")
    foreach ($section in $requiredSections) {
        if ($content -notmatch $section) {
            throw "Missing required section: $section"
        }
    }
    Write-Host "   Valid YAML structure found"
}

# Test 3: Test setup script parameters
Test-Step "Setup Script Parameters" {
    $scriptContent = Get-Content "setup-workflow.ps1" -Raw
    
    $requiredParams = @("RepositoryName", "DefaultBranch", "SourceDirectory", "DocsDirectory", "Platform")
    foreach ($param in $requiredParams) {
        if ($scriptContent -notmatch $param) {
            throw "Missing parameter: $param"
        }
    }
    Write-Host "   All required parameters found"
}

# Test 4: Test MCP configuration generation
Test-Step "MCP Configuration" {
    $config = @{
        mcpServers = @{
            github = @{
                command = "npx"
                args = @("-y", "@modelcontextprotocol/server-github")
                env = @{
                    GITHUB_PERSONAL_ACCESS_TOKEN = "test-token"
                }
            }
        }
    }
    
    $json = $config | ConvertTo-Json -Depth 10
    $parsed = $json | ConvertFrom-Json
    
    if (-not $parsed.mcpServers.github) {
        throw "Invalid MCP configuration structure"
    }
    
    if ($parsed.mcpServers.github.command -ne "npx") {
        throw "Invalid MCP command"
    }
    
    Write-Host "   MCP configuration is valid"
}

# Test 5: Test directory creation
Test-Step "Directory Operations" {
    $testDir = "test-quick-dir"
    
    # Create directory
    New-Item -Path $testDir -ItemType Directory -Force | Out-Null
    
    if (-not (Test-Path $testDir)) {
        throw "Failed to create test directory"
    }
    
    # Create test file
    "test content" | Set-Content "$testDir\test.txt"
    
    if (-not (Test-Path "$testDir\test.txt")) {
        throw "Failed to create test file"
    }
    
    # Cleanup
    Remove-Item $testDir -Recurse -Force
    
    Write-Host "   Directory operations work correctly"
}

# Test 6: Test content replacement
Test-Step "Content Replacement" {
    $originalContent = @"
on:
  push:
    branches:
      - main
"@
    
    $newBranch = "develop"
    $replacedContent = $originalContent -replace "branches:\s*-\s*main", "branches:`n      - $newBranch"
    
    if ($replacedContent -notmatch "develop") {
        throw "Content replacement failed"
    }
    
    Write-Host "   Content replacement works correctly"
}

# Test 7: Test JSON handling
Test-Step "JSON Operations" {
    $testData = @{
        name = "test"
        value = 123
        items = @("a", "b", "c")
    }
    
    $json = $testData | ConvertTo-Json -Depth 10
    $parsed = $json | ConvertFrom-Json
    
    if ($parsed.name -ne "test") {
        throw "JSON parsing failed"
    }
    
    Write-Host "   JSON operations work correctly"
}

# Test 8: Test environment variables
Test-Step "Environment Variables" {
    $env:TEST_VAR = "test_value"
    
    if ($env:TEST_VAR -ne "test_value") {
        throw "Environment variable setting failed"
    }
    
    Remove-Item Env:TEST_VAR -ErrorAction SilentlyContinue
    
    Write-Host "   Environment variables work correctly"
}

# Test 9: Test PowerShell version
Test-Step "PowerShell Version" {
    $version = $PSVersionTable.PSVersion
    $major = $version.Major
    
    if ($major -lt 5) {
        throw "PowerShell version too old: $version (need 5.0+)"
    }
    
    Write-Host "   PowerShell version: $version"
}

# Test 10: Test file encoding
Test-Step "File Encoding" {
    $testFile = "test-encoding.txt"
    $testContent = "Test content with special chars: éñü"
    
    $testContent | Set-Content $testFile -Encoding UTF8
    $readContent = Get-Content $testFile -Raw
    
    if ($readContent.Trim() -ne $testContent) {
        throw "File encoding test failed"
    }
    
    Remove-Item $testFile -Force
    
    Write-Host "   File encoding works correctly"
}

# Show results
Write-Host ""
Write-Host "=" * 50
Write-Host "QUICK TEST RESULTS"
Write-Host "=" * 50
Write-Host "Total Tests: $($testResults.Total)"
Write-Host "Passed: $($testResults.Passed)" -ForegroundColor Green
Write-Host "Failed: $($testResults.Failed)" -ForegroundColor Red
Write-Host "=" * 50

if ($testResults.Failed -eq 0) {
    Write-Host "🎉 All quick tests passed!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:"
    Write-Host "1. Run full test suite: .\tests\run-tests.ps1"
    Write-Host "2. Test workflow manually: Go to Actions → Test Suite"
    Write-Host "3. Test setup script: .\setup-workflow.ps1 -Help"
    exit 0
} else {
    Write-Host "❌ Some tests failed. Check the errors above." -ForegroundColor Red
    exit 1
} 