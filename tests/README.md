# Test Suite Documentation

This directory contains comprehensive tests for the Gemini CLI + MCP Workflow system.

## Test Structure

```
tests/
├── README.md                    # This documentation
├── test-workflow.yml           # GitHub Actions test workflow
├── test-setup-script.ps1      # Unit tests for setup script
└── run-tests.ps1              # Test runner script
```

## Test Types

### 1. Unit Tests (`test-setup-script.ps1`)
Tests individual components and functions:
- **Parameter validation**: Ensures script accepts valid inputs
- **File operations**: Tests directory creation and file writing
- **Content replacement**: Validates text replacement logic
- **Configuration generation**: Tests MCP configuration creation
- **Error handling**: Ensures graceful failure handling
- **Performance**: Tests file operation efficiency

### 2. Integration Tests (`run-tests.ps1`)
Tests complete workflows and interactions:
- **Workflow creation**: Tests end-to-end workflow file generation
- **Setup script execution**: Validates script functionality
- **Configuration validation**: Tests MCP server configuration
- **File system operations**: Tests directory and file management

### 3. Workflow Tests (`test-workflow.yml`)
GitHub Actions workflow tests:
- **Validation tests**: Directory and file existence
- **MCP configuration**: Server setup and configuration
- **Gemini CLI installation**: Package installation and verification
- **Full workflow simulation**: Complete workflow execution (dry run)

### 4. GitHub Actions Tests (`test-workflow.yml`)
Automated CI/CD tests:
- **Workflow validation**: YAML syntax and structure
- **Setup script testing**: Automated script execution
- **Documentation validation**: README and template verification
- **Test summary generation**: Comprehensive test reporting

## Running Tests

### Local Testing

#### Run All Tests
```powershell
.\tests\run-tests.ps1
```

#### Run Specific Test Types
```powershell
# Unit tests only
.\tests\run-tests.ps1 -TestType unit

# Integration tests only
.\tests\run-tests.ps1 -TestType integration

# Workflow validation only
.\tests\run-tests.ps1 -TestType workflow
```

#### Run with Verbose Output
```powershell
.\tests\run-tests.ps1 -Verbose
```

### GitHub Actions Testing

The test suite runs automatically on:
- **Push to main/develop**: Full test suite
- **Pull requests**: Validation tests
- **Manual dispatch**: Custom test selection

#### Manual Test Execution
1. Go to Actions → Test Suite
2. Click "Run workflow"
3. Select test type (all, unit, integration, workflow)
4. Click "Run workflow"

## Test Coverage

### Setup Script Tests
- ✅ Parameter validation (platform, directories, branch)
- ✅ File operations (directory creation, file writing)
- ✅ Content replacement (branch names, paths, messages)
- ✅ Configuration generation (MCP JSON structure)
- ✅ Error handling (invalid inputs, missing files)
- ✅ Performance (large file operations)

### Workflow Tests
- ✅ Input directory validation
- ✅ Output directory creation
- ✅ MCP configuration setup
- ✅ Gemini CLI installation
- ✅ Documentation generation simulation
- ✅ Git operations (commit, push)

### Integration Tests
- ✅ End-to-end workflow creation
- ✅ Setup script execution
- ✅ Configuration validation
- ✅ File system operations
- ✅ Error handling scenarios

### GitHub Actions Tests
- ✅ Workflow YAML validation
- ✅ Setup script functionality
- ✅ Documentation completeness
- ✅ Test result reporting

## Test Dependencies

### Required Software
- **PowerShell 7.0+**: For script execution
- **Pester**: For unit testing (auto-installed)
- **Node.js 20+**: For Gemini CLI testing
- **Git**: For repository operations

### Required Secrets (GitHub Actions)
- `GITHUB_TOKEN`: Automatically provided
- `PERSONAL_ACCESS_TOKEN`: For MCP server testing

## Test Results

### Local Test Output
```
🧪 Starting Gemini CLI + MCP Workflow Tests

[14:30:15] [INFO] Running unit tests...
[14:30:16] [PASS] Unit tests completed: 15 passed, 0 failed
[14:30:17] [INFO] Running integration tests...
[14:30:18] [PASS] Integration test passed: Workflow file created successfully
[14:30:19] [INFO] Running workflow validation tests...
[14:30:20] [PASS] Workflow validation passed: Found name:
[14:30:21] [PASS] Configuration validation passed: MCP config structure is valid

============================================================
TEST SUMMARY
============================================================
Total Tests: 20
Passed: 20
Failed: 0
Skipped: 0
Duration: 6.5s
============================================================
🎉 All tests passed!
```

### GitHub Actions Output
- **Test Results**: Available in Actions tab
- **Artifacts**: Test logs and results uploaded
- **Summary**: Step-by-step test results
- **Coverage Report**: Detailed test coverage information

## Troubleshooting

### Common Issues

#### 1. Pester Not Found
```powershell
# Install Pester manually
Install-Module -Name Pester -Force -Scope CurrentUser
```

#### 2. PowerShell Version Issues
```powershell
# Check PowerShell version
$PSVersionTable.PSVersion

# Update to PowerShell 7+
winget install Microsoft.PowerShell
```

#### 3. Test Failures
- Check file permissions
- Verify directory structure
- Ensure all dependencies are installed
- Review test logs for specific error messages

#### 4. GitHub Actions Failures
- Verify secrets are configured
- Check workflow YAML syntax
- Review action logs for detailed errors
- Ensure repository has proper permissions

### Debug Mode
```powershell
# Run tests with detailed output
.\tests\run-tests.ps1 -Verbose -TestType all
```

## Adding New Tests

### Unit Tests
1. Add test cases to `test-setup-script.ps1`
2. Follow Pester syntax: `Describe`, `Context`, `It`
3. Test both success and failure scenarios
4. Include performance benchmarks

### Integration Tests
1. Add test functions to `run-tests.ps1`
2. Test complete workflows
3. Validate file system operations
4. Test error conditions

### Workflow Tests
1. Add steps to `test-workflow.yml`
2. Test GitHub Actions functionality
3. Validate YAML syntax
4. Test environment variables

## Test Maintenance

### Regular Tasks
- **Weekly**: Run full test suite
- **Monthly**: Update test dependencies
- **Quarterly**: Review test coverage
- **As needed**: Add tests for new features

### Test Updates
- Update tests when workflow changes
- Add tests for new functionality
- Remove obsolete tests
- Update documentation

## Performance Benchmarks

### Expected Performance
- **Unit tests**: < 30 seconds
- **Integration tests**: < 60 seconds
- **Full test suite**: < 120 seconds
- **GitHub Actions**: < 300 seconds

### Performance Monitoring
- Track test execution times
- Monitor resource usage
- Identify slow tests
- Optimize test performance

## Contributing to Tests

### Guidelines
1. **Test everything**: Cover all code paths
2. **Test edge cases**: Include error scenarios
3. **Keep tests fast**: Optimize for speed
4. **Document tests**: Explain test purpose
5. **Maintain tests**: Keep tests up to date

### Test Standards
- Use descriptive test names
- Include setup and teardown
- Test both positive and negative cases
- Provide clear error messages
- Follow consistent formatting

## Support

For test-related issues:
1. Check this documentation
2. Review test logs
3. Run tests in debug mode
4. Create issue with test details
5. Include test output and error messages 