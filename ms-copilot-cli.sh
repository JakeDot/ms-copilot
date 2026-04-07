#!/usr/bin/env bash
#
# ms-copilot-cli.sh
# Main CLI wrapper for MS Copilot automation
#

set -e

VERSION="1.0.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print usage information
usage() {
    cat << EOF
MS Copilot CLI v${VERSION}

A wrapper for MS Copilot GitHub Actions automation.

USAGE:
    ms-copilot [COMMAND] [OPTIONS]

COMMANDS:
    help            Show this help message
    version         Show version information
    setup           Run the setup script to configure the alias
    validate        Validate the GitHub Actions workflows
    test-workflow   Test the workflow configuration locally

OPTIONS:
    -h, --help      Show help
    -v, --version   Show version

EXAMPLES:
    ms-copilot help
    ms-copilot validate
    ms-copilot test-workflow

For more information, visit: https://github.com/JakeDot/ms-copilot
EOF
}

# Print version information
version() {
    echo "MS Copilot CLI v${VERSION}"
}

# Validate GitHub Actions workflows
validate_workflows() {
    echo -e "${BLUE}Validating GitHub Actions workflows...${NC}"

    if [ ! -d "${SCRIPT_DIR}/.github/workflows" ]; then
        echo -e "${RED}Error: .github/workflows directory not found${NC}"
        exit 1
    fi

    local workflow_count=0
    for workflow in "${SCRIPT_DIR}/.github/workflows"/*.yml; do
        if [ -f "$workflow" ]; then
            echo -e "${GREEN}✓${NC} Found: $(basename "$workflow")"
            workflow_count=$((workflow_count + 1))
        fi
    done

    if [ $workflow_count -eq 0 ]; then
        echo -e "${RED}Error: No workflow files found${NC}"
        exit 1
    fi

    echo -e "${GREEN}Success: Found ${workflow_count} workflow(s)${NC}"
}

# Test workflow configuration
test_workflow() {
    echo -e "${BLUE}Testing workflow configuration...${NC}"
    echo -e "${YELLOW}Note: Full testing requires GitHub Actions environment${NC}"

    # Check for required secrets documentation
    if grep -q "COPILOT_API_KEY" "${SCRIPT_DIR}/README.md" 2>/dev/null; then
        echo -e "${GREEN}✓${NC} Documentation mentions required secrets"
    else
        echo -e "${YELLOW}⚠${NC} Warning: COPILOT_API_KEY not documented in README"
    fi

    # Check memory files
    if [ -d "${SCRIPT_DIR}/.github/agents/memory" ]; then
        echo -e "${GREEN}✓${NC} Agent memory directory exists"
        for mem_file in coding-conventions.yml security-best-practices.yml false-positives.yml; do
            if [ -f "${SCRIPT_DIR}/.github/agents/memory/${mem_file}" ]; then
                echo -e "${GREEN}  ✓${NC} Found: ${mem_file}"
            else
                echo -e "${YELLOW}  ⚠${NC} Missing: ${mem_file}"
            fi
        done
    else
        echo -e "${YELLOW}⚠${NC} Warning: Agent memory directory not found"
    fi
}

# Main command dispatcher
main() {
    if [ $# -eq 0 ]; then
        usage
        exit 0
    fi

    case "$1" in
        help|--help|-h)
            usage
            ;;
        version|--version|-v)
            version
            ;;
        setup)
            if [ -f "${SCRIPT_DIR}/setup-ms-copilot.sh" ]; then
                exec "${SCRIPT_DIR}/setup-ms-copilot.sh"
            else
                echo -e "${RED}Error: setup-ms-copilot.sh not found${NC}"
                exit 1
            fi
            ;;
        validate)
            validate_workflows
            ;;
        test-workflow)
            test_workflow
            ;;
        *)
            echo -e "${RED}Error: Unknown command '$1'${NC}"
            echo ""
            usage
            exit 1
            ;;
    esac
}

main "$@"
