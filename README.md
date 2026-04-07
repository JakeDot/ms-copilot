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

## Getting Started

### Prerequisites

- GitHub repository with Actions enabled
- MS Copilot API access (set `COPILOT_API_KEY` secret)

### Setup

1. Copy the `.github` directory to your repository
2. Set up required secrets in your GitHub repository:
   - `COPILOT_API_KEY`: Your MS Copilot API key
3. The workflows will automatically trigger on pull requests and pushes

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
