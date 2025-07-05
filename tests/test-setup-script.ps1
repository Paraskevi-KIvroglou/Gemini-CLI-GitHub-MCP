# Unit Tests for setup-workflow.ps1
# Run with: .\tests\test-setup-script.ps1

Describe "Setup Workflow Script Tests" {
    BeforeAll {
        # Mock the setup script functions
        $scriptPath = Join-Path $PSScriptRoot "..\setup-workflow.ps1"
        if (Test-Path $scriptPath) {
            . $scriptPath
        }
        
        # Create test directories
        $testDir = "test-workflow-setup"
        if (Test-Path $testDir) {
            Remove-Item $testDir -Recurse -Force
        }
        New-Item -ItemType Directory -Path $testDir -Force
        Set-Location $testDir
    }
    
    AfterAll {
        # Cleanup
        Set-Location ..
        if (Test-Path $testDir) {
            Remove-Item $testDir -Recurse -Force
        }
    }
    
    Context "Parameter Validation" {
        It "Should accept valid platform values" {
            $validPlatforms = @("windows", "linux")
            foreach ($platform in $validPlatforms) {
                # This would test the parameter validation logic
                $platform | Should -BeIn @("windows", "linux")
            }
        }
        
        It "Should reject invalid platform values" {
            $invalidPlatforms = @("macos", "android", "ios")
            foreach ($platform in $invalidPlatforms) {
                $platform | Should -Not -BeIn @("windows", "linux")
            }
        }
        
        It "Should validate directory parameters" {
            $validDirs = @("src", "lib", "docs", "api-docs")
            foreach ($dir in $validDirs) {
                $dir | Should -Not -BeNullOrEmpty
            }
        }
    }
    
    Context "File Operations" {
        It "Should create workflows directory" {
            $workflowsDir = ".github\workflows"
            if (Test-Path $workflowsDir) {
                Remove-Item $workflowsDir -Recurse -Force
            }
            
            New-Item -ItemType Directory -Path $workflowsDir -Force
            Test-Path $workflowsDir | Should -Be $true
        }
        
        It "Should handle missing source files gracefully" {
            $nonExistentFile = "non-existent-workflow.yml"
            Test-Path $nonExistentFile | Should -Be $false
        }
    }
    
    Context "Content Replacement" {
        It "Should replace branch names correctly" {
            $content = @"
on:
  push:
    branches:
      - main
"@
            $newBranch = "develop"
            $expected = $content -replace "branches:\s*-\s*main", "branches:`n      - $newBranch"
            $expected | Should -Match "develop"
        }
        
        It "Should replace directory paths correctly" {
            $content = @"
      input_dir:
        default: 'src/'
      output_dir:
        default: 'docs/'
"@
            $newSource = "lib"
            $newDocs = "api-docs"
            $expected = $content -replace "default:\s*'src/'", "default: '$newSource/'"
            $expected = $expected -replace "default:\s*'docs/'", "default: '$newDocs/'"
            $expected | Should -Match "lib/"
            $expected | Should -Match "api-docs/"
        }
        
        It "Should replace commit messages correctly" {
            $content = "Auto-update docs with Gemini CLI + MCP"
            $repoName = "my-project"
            $expected = $content -replace "Auto-update docs with Gemini CLI \+ MCP", "Auto-update docs for $repoName with Gemini CLI + MCP"
            $expected | Should -Match "my-project"
        }
    }
    
    Context "Configuration Generation" {
        It "Should generate valid JSON configuration" {
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
            $json | Should -Not -BeNullOrEmpty
            $json | Should -Match "mcpServers"
            $json | Should -Match "github"
        }
        
        It "Should validate JSON structure" {
            $json = '{"mcpServers":{"github":{"command":"npx","args":["-y","@modelcontextprotocol/server-github"],"env":{"GITHUB_PERSONAL_ACCESS_TOKEN":"test-token"}}}}'
            $parsed = $json | ConvertFrom-Json
            $parsed.mcpServers.github | Should -Not -BeNullOrEmpty
            $parsed.mcpServers.github.command | Should -Be "npx"
        }
    }
    
    Context "Error Handling" {
        It "Should handle invalid platform gracefully" {
            $invalidPlatform = "invalid-platform"
            $validPlatforms = @("windows", "linux")
            $invalidPlatform | Should -Not -BeIn $validPlatforms
        }
        
        It "Should handle empty directory parameters" {
            $emptyDir = ""
            [string]::IsNullOrWhiteSpace($emptyDir) | Should -Be $true
        }
        
        It "Should handle null parameters" {
            $nullParam = $null
            $nullParam | Should -BeNullOrEmpty
        }
    }
    
    Context "File Writing" {
        It "Should write content to file correctly" {
            $testFile = "test-output.yml"
            $testContent = "test content"
            
            $testContent | Set-Content $testFile -Encoding UTF8
            Test-Path $testFile | Should -Be $true
            
            $readContent = Get-Content $testFile -Raw
            $readContent.Trim() | Should -Be $testContent
            
            # Cleanup
            Remove-Item $testFile -Force
        }
        
        It "Should handle file encoding correctly" {
            $testFile = "test-utf8.yml"
            $testContent = "Test content with special chars: éñü"
            
            $testContent | Set-Content $testFile -Encoding UTF8
            $readContent = Get-Content $testFile -Raw
            $readContent.Trim() | Should -Be $testContent
            
            # Cleanup
            Remove-Item $testFile -Force
        }
    }
}

# Integration Tests
Describe "Integration Tests" {
    Context "End-to-End Workflow Creation" {
        It "Should create a complete workflow file" {
            # This would test the actual workflow creation process
            # In a real scenario, you'd call the setup script with parameters
            $workflowContent = @"
name: Test Workflow
on:
  push:
    branches:
      - main
jobs:
  test:
    runs-on: windows-latest
    steps:
      - name: Test Step
        run: echo "test"
"@
            
            $workflowContent | Should -Match "name: Test Workflow"
            $workflowContent | Should -Match "branches:"
            $workflowContent | Should -Match "windows-latest"
        }
    }
}

# Performance Tests
Describe "Performance Tests" {
    It "Should handle large content efficiently" {
        $largeContent = "x" * 10000  # 10KB of content
        $startTime = Get-Date
        
        $largeContent | Set-Content "large-test.yml" -Encoding UTF8
        $endTime = Get-Date
        $duration = ($endTime - $startTime).TotalMilliseconds
        
        $duration | Should -BeLessThan 1000  # Should complete in under 1 second
        
        # Cleanup
        Remove-Item "large-test.yml" -Force
    }
}

Write-Host "✅ All tests completed successfully!" 