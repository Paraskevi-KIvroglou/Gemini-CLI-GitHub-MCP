# Gemini CLI + MCP Documentation Generator

This repository contains a versatile GitHub Actions workflow that automatically generates documentation using Google's Gemini CLI with Model Context Protocol (MCP) integration.

## Features

- **Cross-platform support**: Windows and Linux workflows
- **Configurable paths**: Customize input and output directories
- **Flexible triggers**: Manual dispatch or automatic on push
- **Error handling**: Comprehensive validation and error reporting
- **Customizable**: Easy to adapt for different repositories

## Quick Start

### 1. Copy the Workflow

Copy the appropriate workflow file to your repository:

- **Windows**: `.github/workflows/update_docs_windows.yml`
- **Linux**: `.github/workflows/update_docs_linux.yml`

### 2. Set Up Secrets

Add these secrets to your repository (Settings → Secrets and variables → Actions):

- `PERSONAL_ACCESS_TOKEN`: GitHub Personal Access Token with repo permissions
- `GITHUB_TOKEN`: Automatically provided by GitHub Actions

### 3. Configure Your Repository

The workflow is designed to work out of the box with these defaults:
- **Input directory**: `src/`
- **Output directory**: `docs/`
- **Branch**: `main`

## Customization Options

### Repository Variables (Optional)

You can set these variables in your repository settings (Settings → Secrets and variables → Actions → Variables):

- `INPUT_DIR`: Source directory for documentation generation (default: `src/`)
- `OUTPUT_DIR`: Output directory for generated docs (default: `docs/`)
- `COMMIT_MESSAGE`: Custom commit message (default: "Auto-update docs with Gemini CLI + MCP")
- `ENABLE_AUTO_PUSH`: Enable/disable automatic pushing (default: `true`)
- `CLEAN_CACHE`: Clean npm cache before running (default: `true`)

### Manual Trigger Options

When manually triggering the workflow, you can override:

- **Input Directory**: Specify custom source directory
- **Output Directory**: Specify custom output directory  
- **Branch Name**: Target branch for commits
- **Commit Message**: Custom commit message
- **Auto Push**: Enable/disable automatic pushing
- **Clean Cache**: Enable/disable npm cache cleaning

## Usage Examples

### Basic Usage

```yaml
# Copy the workflow file to your repository
# Set up the required secrets
# The workflow will run automatically on pushes to main
```

### Custom Directory Structure

If your project has a different structure:

```yaml
# Set repository variables:
INPUT_DIR: "source/"
OUTPUT_DIR: "documentation/"
```

### Different Branch

```yaml
# Set repository variables:
DEFAULT_BRANCH: "develop"
```

### Manual Trigger with Custom Settings

1. Go to Actions → Workflows → "Auto Update Docs with Gemini CLI + MCP"
2. Click "Run workflow"
3. Fill in custom parameters:
   - Input directory: `lib/`
   - Output directory: `api-docs/`
   - Commit message: "Update API documentation"

## Workflow Features

### Error Handling

- Validates input directory exists
- Verifies MCP configuration creation
- Checks documentation generation success
- Provides detailed error messages

### Performance Optimizations

- NPM caching for faster installations
- Conditional cache cleaning
- Efficient file operations

### Security

- Uses GitHub tokens for authentication
- Secure MCP server configuration
- No hardcoded credentials

## Troubleshooting

### Common Issues

1. **"Input directory does not exist"**
   - Ensure your source directory exists
   - Check the `INPUT_DIR` variable or workflow input

2. **"MCP configuration failed"**
   - Verify `PERSONAL_ACCESS_TOKEN` secret is set
   - Check token permissions

3. **"No changes to commit"**
   - This is normal if documentation hasn't changed
   - Check if source files were modified

4. **"Documentation generation failed"**
   - Verify Gemini CLI installation
   - Check source files are valid

### Debug Steps

1. Check workflow logs in Actions tab
2. Verify secrets are properly configured
3. Test with manual trigger first
4. Check file permissions and paths

## Advanced Configuration

### Multiple Documentation Sets

Create multiple workflow files for different documentation types:

```yaml
# api-docs.yml
INPUT_DIR: "api/"
OUTPUT_DIR: "api-docs/"

# user-guide.yml  
INPUT_DIR: "docs/"
OUTPUT_DIR: "user-guide/"
```

### Conditional Execution

Modify the workflow to run only on specific conditions:

```yaml
on:
  push:
    branches: [main, develop]
    paths: ['src/**', 'docs/**']
```

### Custom MCP Servers

Extend the MCP configuration for additional servers:

```yaml
mcpServers:
  github:
    command: "npx"
    args: ["-y", "@modelcontextprotocol/server-github"]
    env:
      GITHUB_PERSONAL_ACCESS_TOKEN: "${{ secrets.PERSONAL_ACCESS_TOKEN }}"
  custom:
    command: "npx"
    args: ["-y", "your-custom-mcp-server"]
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with different repository structures
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
