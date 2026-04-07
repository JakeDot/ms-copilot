#!/usr/bin/env bash
#
# setup-ms-copilot.sh
# Setup script for MS Copilot CLI
# Creates an alias 'ms-copilot' and optionally persists it to shell configuration
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Get the absolute path to the CLI script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLI_SCRIPT="${SCRIPT_DIR}/ms-copilot-cli.sh"

# Detect the user's shell
detect_shell() {
    # Prefer login/interactive shell from SHELL when script runs under bash.
    case "$SHELL" in
        */bash)
            echo "bash"
            ;;
        */zsh)
            echo "zsh"
            ;;
        */fish)
            echo "fish"
            ;;
        *)
            if [ -n "$BASH_VERSION" ]; then
                echo "bash"
            elif [ -n "$ZSH_VERSION" ]; then
                echo "zsh"
            elif [ -n "$FISH_VERSION" ]; then
                echo "fish"
            else
                echo "unknown"
            fi
            ;;
    esac
}

# Get the appropriate RC file for the shell
get_rc_file() {
    local shell_type="$1"
    case "$shell_type" in
        bash)
            if [ -f "$HOME/.bashrc" ]; then
                echo "$HOME/.bashrc"
            else
                echo "$HOME/.bash_profile"
            fi
            ;;
        zsh)
            echo "$HOME/.zshrc"
            ;;
        fish)
            echo "$HOME/.config/fish/config.fish"
            ;;
        *)
            echo ""
            ;;
    esac
}

# Create alias command for the shell
get_alias_command() {
    local shell_type="$1"
    case "$shell_type" in
        fish)
            echo "alias ms-copilot '${CLI_SCRIPT}'"
            ;;
        *)
            echo "alias ms-copilot='${CLI_SCRIPT}'"
            ;;
    esac
}

# Check if alias already exists in RC file
alias_exists_in_file() {
    local rc_file="$1"
    if [ -f "$rc_file" ] && grep -Eq "alias[[:space:]]+ms-copilot(=|[[:space:]])" "$rc_file"; then
        return 0
    else
        return 1
    fi
}

# Add alias to RC file
add_alias_to_rc() {
    local rc_file="$1"
    local alias_cmd="$2"

    # Create directory if it doesn't exist (for fish)
    local rc_dir
    rc_dir="$(dirname "$rc_file")"
    if [ ! -d "$rc_dir" ]; then
        mkdir -p "$rc_dir"
    fi

    # Create RC file if it doesn't exist
    if [ ! -f "$rc_file" ]; then
        touch "$rc_file"
    fi

    # Add the alias with a comment section
    cat >> "$rc_file" << EOF

# ────────────────────────────────────────────────────────────────────────────
# MS Copilot CLI alias (added by setup-ms-copilot.sh)
# ────────────────────────────────────────────────────────────────────────────
${alias_cmd}

EOF

    echo -e "${GREEN}✓${NC} Alias added to ${rc_file}"
}

# Show immediate-use instructions for the parent shell
show_immediate_use_instructions() {
    local shell_type="$1"
    local alias_cmd
    alias_cmd=$(get_alias_command "$shell_type")
    echo -e "${BLUE}To use ms-copilot immediately in this shell, run:${NC}"
    echo -e "  ${BOLD}${alias_cmd}${NC}"
}

# Main setup function
main() {
    echo -e "${BOLD}${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${BLUE}║          MS Copilot CLI Setup Script                       ║${NC}"
    echo -e "${BOLD}${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    # Check if CLI script exists
    if [ ! -f "$CLI_SCRIPT" ]; then
        echo -e "${RED}Error: CLI script not found at ${CLI_SCRIPT}${NC}"
        exit 1
    fi

    # Make sure CLI script is executable
    if [ ! -x "$CLI_SCRIPT" ]; then
        chmod +x "$CLI_SCRIPT"
        echo -e "${GREEN}✓${NC} Made CLI script executable"
    fi

    # Detect shell
    local shell_type
    shell_type=$(detect_shell)
    echo -e "Detected shell: ${BOLD}${shell_type}${NC}"
    echo ""

    # Ask about persisting the alias
    if [ "$shell_type" != "unknown" ]; then
        local rc_file
        rc_file=$(get_rc_file "$shell_type")

        if [ -n "$rc_file" ]; then
            # Check if alias already exists
            if alias_exists_in_file "$rc_file"; then
                echo -e "${YELLOW}⚠${NC}  Alias already exists in ${rc_file}"
                echo -e "   No changes made to avoid duplication."
            else
                echo -e "${BLUE}Persist alias across shell sessions?${NC}"
                echo -e "This will add the alias to: ${BOLD}${rc_file}${NC}"
                echo ""
                read -p "Add to shell config? [Y/n] " -n 1 -r
                echo ""

                if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
                    local alias_cmd
                    alias_cmd=$(get_alias_command "$shell_type")
                    add_alias_to_rc "$rc_file" "$alias_cmd"
                    echo ""
                    echo -e "${GREEN}✓${NC} Setup complete!"
                    echo -e "  The alias will be available in new shell sessions."
                    echo -e "  To use it immediately in current session, run:"
                    echo -e "    ${BOLD}source ${rc_file}${NC}"
                else
                    echo -e "${YELLOW}⚠${NC}  Skipped persistence."
                    show_immediate_use_instructions "$shell_type"
                fi
            fi
        else
            echo -e "${YELLOW}⚠${NC}  Could not determine shell RC file location."
            show_immediate_use_instructions "$shell_type"
        fi
    else
        echo -e "${YELLOW}⚠${NC}  Unknown shell."
        echo -e "   To persist, manually add to your shell's RC file:"
        echo -e "     ${BOLD}alias ms-copilot='${CLI_SCRIPT}'${NC}"
        show_immediate_use_instructions "$shell_type"
    fi

    echo ""
    echo -e "${GREEN}${BOLD}Setup complete!${NC}"
    echo ""
    echo -e "After applying the alias in your shell, try: ${BOLD}ms-copilot help${NC}"
    echo ""
}

main "$@"
