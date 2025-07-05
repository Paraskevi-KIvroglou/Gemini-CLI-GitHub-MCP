# Gemini CLI GitHub MCP

This repository demonstrates how to use Google's official Gemini CLI with GitHub Actions and MCP (Model Context Protocol) integration.

## 🚀 Overview

This project showcases the integration of Google's Gemini CLI with GitHub workflows. **Important**: Google's Gemini CLI is primarily an interactive AI assistant, not a batch documentation generation tool.

## ✨ What is Google's Gemini CLI?

Google's Gemini CLI is an **open-source AI agent** that brings Gemini directly into your terminal. It provides:

- **Interactive AI assistance** for coding and problem-solving
- **File system integration** with `@file` and `@folder` commands
- **Shell command execution** with `!command` syntax
- **MCP (Model Context Protocol)** support for tool integration
- **Large codebase understanding** beyond typical token limits
- **Free usage** with Google account (60 requests/minute, 1,000/day)

## 📦 Installation

### Option 1: Global Installation
```bash
npm install -g @google/gemini-cli
gemini
```

### Option 2: Direct Execution
```bash
npx https://github.com/google-gemini/gemini-cli
```

### Option 3: With API Key
```bash
export GEMINI_API_KEY="your_api_key_here"
npm install -g @google/gemini-cli
gemini
```

## 🔧 Usage in GitHub Actions

### Important Notes:
1. **Gemini CLI is interactive** - it doesn't have batch commands like `gemini docs --input --output`
2. **Wrong package confusion** - `npx gemini docs` installs `gemini@7.5.2` (a testing framework), not Google's AI CLI
3. **For CI/CD** - You need custom scripting or API integration for automated tasks

### Correct GitHub Actions Setup:

```yaml
name: Gemini CLI Demo

on: [workflow_dispatch]

jobs:
  gemini-demo:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          
      - name: Install Gemini CLI
        run: npm install -g @google/gemini-cli
        
      - name: Generate Documentation
        run: node scripts/generate-docs.js
        env:
          GEMINI_API_KEY: ${{ secrets.GEMINI_API_KEY }}
```

## 🛠️ Alternative Approaches for Documentation Generation

Since Gemini CLI is interactive, consider these alternatives for automated documentation:

### 1. **Direct API Usage**
```javascript
const { GoogleGenerativeAI } = require("@google/generative-ai");

const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);
const model = genAI.getGenerativeModel({ model: "gemini-pro" });

async function generateDocs(sourceCode) {
  const prompt = `Generate documentation for this code:\n${sourceCode}`;
  const result = await model.generateContent(prompt);
  return result.response.text();
}
```

### 2. **Custom MCP Server**
```javascript
// Create a custom MCP server for documentation generation
// See: https://github.com/modelcontextprotocol/
```

### 3. **Traditional Tools**
- **JSDoc** for JavaScript
- **TypeDoc** for TypeScript  
- **Sphinx** for Python
- **Doxygen** for C++

## 🔐 Authentication

### With Personal Google Account (Free):
- 60 requests per minute
- 1,000 requests per day
- Access to Gemini 2.5 Pro

### With API Key:
- Usage-based billing
- Higher rate limits
- Enterprise features

## 📝 Interactive Commands

Once installed, Gemini CLI supports:

```bash
# File operations
@src/index.js          # Include file in prompt
@src/components/       # Include folder contents

# Shell commands  
!ls -la               # Execute shell commands
!git status           # Run git commands

# Session management
/chat save project1   # Save conversation
/chat resume project1 # Resume conversation
/help                 # Show all commands
```

## 🌟 Examples

### Interactive Development:
```bash
gemini
> @src/app.js Explain this code and suggest improvements
> !git log --oneline -10 
> Create a README for this project based on the code structure
```

### Automated Documentation (Custom Script):
```javascript
// scripts/generate-docs.js
const { execSync } = require('child_process');

// Since Gemini CLI is interactive, you'd need to:
// 1. Use the Gemini API directly
// 2. Create input/output files for interaction
// 3. Use a different documentation tool
```

## 🔗 MCP Integration

The MCP configuration in the workflows enables:
- **GitHub integration** via `@modelcontextprotocol/server-github`
- **Custom tool development** for specific workflows
- **Extensible architecture** for additional tools

## 🏗️ Project Structure

```
Gemini-CLI-GitHub-MCP/
├── .github/workflows/
│   ├── update_docs_linux.yml    # Linux workflow
│   └── update_docs_windows.yml  # Windows workflow
├── scripts/
│   └── generate-docs.js         # Documentation generation script
├── src/                         # Source code directory
├── docs/                        # Generated documentation
├── Gemini.md                    # Project configuration
└── README.md                    # This file
```

## 🎯 Usage Recommendations

### For Interactive Development:
```bash
# Install globally and use interactively
npm install -g @google/gemini-cli
cd your-project
gemini
```

### For CI/CD Automation:
```bash
# Use Gemini API directly or create custom MCP servers
# The CLI is not designed for batch/non-interactive use
```

### For Documentation Generation:
```bash
# Consider these alternatives:
npm install -g jsdoc        # For JavaScript
npm install -g typedoc      # For TypeScript
pip install sphinx          # For Python
```

## 📚 Resources

- **Official Gemini CLI**: https://github.com/google-gemini/gemini-cli
- **Google's Announcement**: https://blog.google/technology/developers/introducing-gemini-cli-open-source-ai-agent/
- **MCP Documentation**: https://modelcontextprotocol.io/
- **Gemini API**: https://ai.google.dev/

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## ⚠️ Important Notes

- **Gemini CLI is interactive** - not designed for batch processing
- **Authentication required** - Use Google account or API key
- **Rate limits apply** - 60 requests/minute, 1,000/day (free tier)
- **Consider alternatives** for automated documentation generation
