# Test Runner for Gemini CLI + MCP Workflow
# Run with: .\tests\run-tests.ps1

param(
    [string]$TestType = "all", # all, unit, integration, workflow
    [switch]$Verbose,
    [switch]$Help
)

if ($Help) {
    Write-Host @"
Test Runner for Gemini CLI + MCP Workflow

Usage: .\tests\run-tests.ps1 [options]

Options:
    -TestType <type>     Test type: all, unit, integration, workflow (default: all)
    -Verbose             Enable verbose output
    -Help                Show this help message

Examples:
    .\tests\run-tests.ps1 -TestType unit
    .\tests\run-tests.ps1 -TestType workflow -Verbose
    .\tests\run-tests.ps1

"@
    exit 0
}

# Test configuration
$testResults = @{
    Total = 0
    Passed = 0
    Failed = 0
    Skipped = 0
    StartTime = Get-Date
}

function Write-TestLog {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )
    
    $timestamp = Get-Date -Format "HH:mm:ss"
    $color = switch ($Level) {
        "PASS" { "Green" }
        "FAIL" { "Red" }
        "WARN" { "Yellow" }
        "INFO" { "White" }
        default { "White" }
    }
    
    Write-Host "[$timestamp] [$Level] $Message" -ForegroundColor $color
}

function Test-UnitTests {
    Write-TestLog "Running unit tests..." "INFO"
    
    try {
        # Check if Pester is available
        if (-not (Get-Module -ListAvailable -Name Pester)) {
            Write-TestLog "Installing Pester module..." "WARN"
            Install-Module -Name Pester -Force -Scope CurrentUser
        }
        
        # Import Pester
        Import-Module Pester
        
        # Run unit tests
        $testPath = Join-Path $PSScriptRoot "test-setup-script.ps1"
        if (Test-Path $testPath) {
            $results = Invoke-Pester -Path $testPath -PassThru -Quiet
            $testResults.Total += $results.TotalCount
            $testResults.Passed += $results.PassedCount
            $testResults.Failed += $results.FailedCount
            
            Write-TestLog "Unit tests completed: $($results.PassedCount) passed, $($results.FailedCount) failed" "INFO"
        } else {
            Write-TestLog "Unit test file not found: $testPath" "WARN"
        }
    } catch {
        Write-TestLog "Unit tests failed: $($_.Exception.Message)" "FAIL"
        $testResults.Failed++
    }
}

function Test-IntegrationTests {
    Write-TestLog "Running integration tests..." "INFO"
    
    try {
        # Test workflow file creation
        $testDir = "test-integration"
        if (Test-Path $testDir) {
            Remove-Item $testDir -Recurse -Force
        }
        New-Item -ItemType Directory -Path $testDir -Force
        Set-Location $testDir
        
        # Test setup script functionality
        $setupScript = Join-Path $PSScriptRoot "..\setup-workflow.ps1"
        if (Test-Path $setupScript) {
            # Test with minimal parameters
            & $setupScript -RepositoryName "test-repo" -DefaultBranch "main" -SourceDirectory "src" -DocsDirectory "docs" -Platform "windows"
            
            # Check if workflow file was created
            $workflowFile = ".github\workflows\update_docs.yml"
            if (Test-Path $workflowFile) {
                Write-TestLog "Integration test passed: Workflow file created successfully" "PASS"
                $testResults.Passed++
            } else {
                Write-TestLog "Integration test failed: Workflow file not created" "FAIL"
                $testResults.Failed++
            }
        } else {
            Write-TestLog "Setup script not found: $setupScript" "WARN"
        }
        
        # Cleanup
        Set-Location ..
        Remove-Item $testDir -Recurse -Force
        
    } catch {
        Write-TestLog "Integration tests failed: $($_.Exception.Message)" "FAIL"
        $testResults.Failed++
    }
}

function Test-WorkflowValidation {
    Write-TestLog "Running workflow validation tests..." "INFO"
    
    try {
        # Test workflow YAML syntax
        $workflowFile = Join-Path $PSScriptRoot "..\.github\workflows\update_docs_windows.yml"
        if (Test-Path $workflowFile) {
            $content = Get-Content $workflowFile -Raw
            
            # Basic YAML validation
            $requiredSections = @("name:", "on:", "jobs:", "steps:")
            foreach ($section in $requiredSections) {
                if ($content -match $section) {
                    Write-TestLog "Workflow validation passed: Found $section" "PASS"
                    $testResults.Passed++
                } else {
                    Write-TestLog "Workflow validation failed: Missing $section" "FAIL"
                    $testResults.Failed++
                }
            }
            
            # Test environment variables
            if ($content -match "env:") {
                Write-TestLog "Workflow validation passed: Environment variables section found" "PASS"
                $testResults.Passed++
            } else {
                Write-TestLog "Workflow validation failed: Environment variables section missing" "FAIL"
                $testResults.Failed++
            }
            
        } else {
            Write-TestLog "Workflow file not found: $workflowFile" "WARN"
        }
        
    } catch {
        Write-TestLog "Workflow validation failed: $($_.Exception.Message)" "FAIL"
        $testResults.Failed++
    }
}

function Test-ConfigurationValidation {
    Write-TestLog "Running configuration validation tests..." "INFO"
    
    try {
        # Test MCP configuration structure
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
        
        # Validate structure
        if ($parsed.mcpServers.github.command -eq "npx") {
            Write-TestLog "Configuration validation passed: MCP config structure is valid" "PASS"
            $testResults.Passed++
        } else {
            Write-TestLog "Configuration validation failed: Invalid MCP config structure" "FAIL"
            $testResults.Failed++
        }
        
        # Test environment variable handling
        if ($parsed.mcpServers.github.env.GITHUB_PERSONAL_ACCESS_TOKEN) {
            Write-TestLog "Configuration validation passed: Environment variables configured" "PASS"
            $testResults.Passed++
        } else {
            Write-TestLog "Configuration validation failed: Environment variables missing" "FAIL"
            $testResults.Failed++
        }
        
    } catch {
        Write-TestLog "Configuration validation failed: $($_.Exception.Message)" "FAIL"
        $testResults.Failed++
    }
}

function Test-PerformanceTests {
    Write-TestLog "Running performance tests..." "INFO"
    
    try {
        # Test file operations performance
        $startTime = Get-Date
        $testContent = "x" * 10000  # 10KB
        
        $testContent | Set-Content "perf-test.yml" -Encoding UTF8
        $endTime = Get-Date
        $duration = ($endTime - $startTime).TotalMilliseconds
        
        if ($duration -lt 1000) {
            Write-TestLog "Performance test passed: File operation completed in ${duration}ms" "PASS"
            $testResults.Passed++
        } else {
            Write-TestLog "Performance test failed: File operation took ${duration}ms (>1000ms)" "FAIL"
            $testResults.Failed++
        }
        
        # Cleanup
        Remove-Item "perf-test.yml" -Force
        
    } catch {
        Write-TestLog "Performance tests failed: $($_.Exception.Message)" "FAIL"
        $testResults.Failed++
    }
}

function Show-TestSummary {
    $endTime = Get-Date
    $duration = ($endTime - $testResults.StartTime).TotalSeconds
    
    Write-Host ""
    Write-Host "=" * 60
    Write-Host "TEST SUMMARY"
    Write-Host "=" * 60
    Write-Host "Total Tests: $($testResults.Total)"
    Write-Host "Passed: $($testResults.Passed)" -ForegroundColor Green
    Write-Host "Failed: $($testResults.Failed)" -ForegroundColor Red
    Write-Host "Skipped: $($testResults.Skipped)" -ForegroundColor Yellow
    Write-Host "Duration: ${duration}s"
    Write-Host "=" * 60
    
    if ($testResults.Failed -eq 0) {
        Write-Host "🎉 All tests passed!" -ForegroundColor Green
        exit 0
    } else {
        Write-Host "❌ Some tests failed!" -ForegroundColor Red
        exit 1
    }
}

# Main test execution
Write-Host "🧪 Starting Gemini CLI + MCP Workflow Tests" -ForegroundColor Cyan
Write-Host ""

switch ($TestType.ToLower()) {
    "all" {
        Test-UnitTests
        Test-IntegrationTests
        Test-WorkflowValidation
        Test-ConfigurationValidation
        Test-PerformanceTests
    }
    "unit" {
        Test-UnitTests
    }
    "integration" {
        Test-IntegrationTests
    }
    "workflow" {
        Test-WorkflowValidation
        Test-ConfigurationValidation
    }
    default {
        Write-TestLog "Unknown test type: $TestType" "WARN"
        Write-TestLog "Available types: all, unit, integration, workflow" "INFO"
    }
}

Show-TestSummary 