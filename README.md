# ms-copilot

MS Copilot AI wrappers and GitHub Actions automation suite.

## Overview

This repository provides an intelligent GitHub Actions workflow system powered by MS Copilot for automated code review, security scanning, and continuous integration.

## Features

- **🤖 Intelligent Code Review**: Automated code review using MS Copilot AI
- **📝 Documentation Review**: Ensures documentation stays accurate and up-to-date
- **📦 Dependency Security**: Scans dependencies for vulnerabilities and license issues
- **🧠 Agent Memory**: Persistent knowledge base for consistent reviews
- **🔄 Multi-language Support**: Python, JavaScript, TypeScript, and more
- **⚡ CLI Tool**: Command-line interface for local development and workflow management

## Getting Started

### Prerequisites

- GitHub repository with Actions enabled
- MS Copilot API access (set `COPILOT_API_KEY` secret)

### Setup

#### For GitHub Actions (Automated Reviews)

1. Copy the `.github` directory to your repository
2. Set up required secrets in your GitHub repository:
   - `COPILOT_API_KEY`: Your MS Copilot API key
3. The workflows will automatically trigger on pull requests and pushes

#### For CLI Tool (Local Development)

1. Clone this repository:
   ```bash
   git clone https://github.com/JakeDot/ms-copilot.git
   cd ms-copilot
   ```

2. Run the setup script:
   ```bash
   ./setup-ms-copilot.sh
   ```

3. The setup script will:
   - Create an `ms-copilot` alias in your current shell session
   - Optionally add the alias to your shell configuration file (`.bashrc`, `.zshrc`, or `.config/fish/config.fish`)
   - Make the alias persistent across shell sessions

4. Verify the installation:
   ```bash
   ms-copilot help
   ```

## Workflows

### MS Copilot Orchestrator (`ms-copilot-orchestrate.yml`)

Main workflow that coordinates all review jobs:

- **Classify Changes**: Detects which files changed and routes to appropriate reviewers
- **Code Review**: Reviews code quality, security, performance, and test coverage
- **Documentation Review**: Ensures docs match code behavior
- **Dependency Review**: Scans for vulnerable or problematic dependencies

## Agent Memory

The system uses persistent memory files in `.github/agents/memory/` to maintain consistency:

- `coding-conventions.yml`: Project coding standards
- `security-best-practices.yml`: Security guidelines and requirements
- `false-positives.yml`: Known false positives to ignore

These memory files help the AI agents learn from past reviews and maintain consistent standards.

## Usage

### CLI Tool

After running the setup script, you can use the `ms-copilot` command:

```bash
# Show help and available commands
ms-copilot help

# Show version
ms-copilot version

# Validate GitHub Actions workflows
ms-copilot validate

# Test workflow configuration
ms-copilot test-workflow

# Re-run setup
ms-copilot setup
```

### Automatic Reviews

The workflow automatically triggers on:
- Pull requests (opened, synchronized, reopened)
- Pushes to main/master/develop branches

### Manual Trigger

You can manually trigger a review using workflow dispatch:

```bash
gh workflow run ms-copilot-orchestrate.yml
```

## Configuration

Customize the workflows by editing `.github/workflows/ms-copilot-orchestrate.yml`:

- Add or remove file type classifications
- Adjust review criteria
- Customize output formats
- Add new review jobs

## Contributing

Contributions welcome! Please:

1. Follow the coding conventions in `.github/agents/memory/coding-conventions.yml`
2. Add tests for new features
3. Update documentation as needed

## License

See [LICENSE](LICENSE) file for details.
