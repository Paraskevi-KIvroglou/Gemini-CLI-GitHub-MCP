# Gemini CLI GitHub MCP

This repository contains the configuration and workflows for managing the Gemini CLI GitHub integration.

## 🚀 Overview

This project is set up to demonstrate and manage automated GitHub workflows using a CLI agent. It uses a `Gemini.md` configuration file to define how the agent should handle tasks like issue creation, pull request management, and documentation updates.

## ✨ Features

- **Automated Issue Creation**: Scan for `TODO` comments in the code and automatically create GitHub issues.
- **Streamlined Pull Requests**: Create, check the status of, and merge pull requests directly from the CLI.
- **Workflow-Driven Development**: All major repository actions are defined in `Gemini.md` to ensure consistency.

## ⚙️ Getting Started

This project is managed via the Gemini CLI. The primary configuration is located in the `Gemini.md` file at the root of this repository.

### Prerequisites

- A configured Gemini CLI environment.
- Access to the `Paraskevi-Klvroglou/Gemini-CLI-GitHub-MCP` repository.

## Usage

You can interact with this repository by giving high-level commands to the Gemini CLI.

### Example Commands

- **"Scan for TODOs and create issues"**: This will search the codebase for `// TODO:` or `# TODO:` comments and offer to create a GitHub issue for each one found.
- **"Create a new PR"**: This will initiate the process of creating a new pull request from your current branch to the `main` branch.
- **"Update the docs"**: This will trigger the workflow to update the `CHANGELOG.md` based on recent commits.

For more details on the available workflows, please see the `Gemini.md` file.
