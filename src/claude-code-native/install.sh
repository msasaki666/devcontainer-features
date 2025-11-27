#!/bin/sh
set -eu

# Function to install Claude Code CLI
install_claude_code() {
    echo "Installing Claude Code CLI..."
    # npm install -g @anthropic-ai/claude-code
    curl -fsSL https://claude.ai/install.sh | bash

    # Determine the shell config file based on $SHELL
    SHELL_NAME=$(basename "$SHELL")
    case "$SHELL_NAME" in
        bash)
            # Use .bashrc on Linux, .bash_profile on macOS
            if [ "$(uname)" = "Darwin" ]; then
                SHELL_CONFIG="$HOME/.bash_profile"
            else
                SHELL_CONFIG="$HOME/.bashrc"
            fi
            ;;
        zsh)
            SHELL_CONFIG="$HOME/.zshrc"
            ;;
        fish)
            SHELL_CONFIG="$HOME/.config/fish/config.fish"
            # Create fish config directory if it doesn't exist
            mkdir -p "$(dirname "$SHELL_CONFIG")"
            ;;
        ksh)
            SHELL_CONFIG="$HOME/.kshrc"
            ;;
        tcsh)
            SHELL_CONFIG="$HOME/.tcshrc"
            ;;
        *)
            echo "WARNING: Unsupported shell: ${SHELL_NAME}"
            return 1
            ;;
    esac

    # Add PATH to shell config if not already present
    PATH_EXPORT='export PATH="$HOME/.local/bin:$PATH"'
    if [ -f "$SHELL_CONFIG" ] && grep -qF "$PATH_EXPORT" "$SHELL_CONFIG"; then
        echo "PATH already configured in $SHELL_CONFIG"
    else
        echo "$PATH_EXPORT" >> "$SHELL_CONFIG"
        echo "Added PATH configuration to $SHELL_CONFIG"
    fi

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
