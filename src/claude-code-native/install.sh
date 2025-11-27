#!/bin/sh
set -eu

# Function to install Claude Code CLI
install_claude_code() {
    echo "Installing Claude Code CLI..."
    # npm install -g @anthropic-ai/claude-code
    curl -fsSL https://claude.ai/install.sh | bash

    if command -v claude >/dev/null; then
        echo "Claude Code CLI installed successfully!"
        claude --version
        return 0
    else
        echo "ERROR: Claude Code CLI installation failed!"
        return 1
    fi
}


# Main script starts here
main() {
    echo "Activating feature 'claude-code'"

    if command -v claude >/dev/null; then
        echo "Claude Code CLI is already installed."
        echo "Installed version: $(claude --version)"
        exit 0
    fi

    # Install Claude Code CLI
    install_claude_code || exit 1
}

# Execute main function
main
