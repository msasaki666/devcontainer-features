#!/bin/sh
set -eu

# Function to install Claude Code CLI
install_claude_code() {
    echo "Installing Claude Code CLI..."

    curl -fsSL https://claude.ai/install.sh | bash

    if command -v claude >/dev/null; then
        echo "Claude Code CLI installed successfully!"
        claude --version
        return 0
    else
        # Check common installation paths first
        BINARY_PATH=""
        for dir in "$HOME/.local/bin" "$HOME/bin" "$HOME/.claude/bin"; do
            if [ -x "$dir/claude" ]; then
                BINARY_PATH="$dir/claude"
                break
            fi
        done

        # Fallback to full search if not found
        if [ -z "$BINARY_PATH" ]; then
            BINARY_PATH=$(find "$HOME"/ -type f -executable -name claude 2>/dev/null | head -n 1)
        fi

        if [ -n "$BINARY_PATH" ] && "$BINARY_PATH" --version >/dev/null 2>&1; then
        echo "Claude Code CLI installed successfully!"
        "$BINARY_PATH" --version
        return 0
      else
        echo "ERROR: Claude Code CLI installation failed!"
        echo "The 'claude' command was not found in PATH or common installation directories."
        return 1
      fi
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
