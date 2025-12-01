#!/bin/bash

# Claude Code Launcher - Installation Script
# Usage: curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/claude-code-launcher/main/install.sh | bash

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Claude Code Launcher Installer ===${NC}"
echo ""

# Determine installation directory
if [ -w "/usr/local/bin" ]; then
    INSTALL_DIR="/usr/local/bin"
    NEEDS_SUDO=false
elif [ -d "$HOME/.local/bin" ]; then
    INSTALL_DIR="$HOME/.local/bin"
    NEEDS_SUDO=false
else
    # Create ~/.local/bin if it doesn't exist
    mkdir -p "$HOME/.local/bin"
    INSTALL_DIR="$HOME/.local/bin"
    NEEDS_SUDO=false
fi

SCRIPT_NAME="claude-launcher"
SCRIPT_URL="https://raw.githubusercontent.com/YOUR_USERNAME/claude-code-launcher/main/claude-code-launcher.sh"

echo -e "${BLUE}Installing to: ${GREEN}$INSTALL_DIR${NC}"
echo ""

# Download the script
echo -e "${BLUE}Downloading Claude Code Launcher...${NC}"
if command -v curl &> /dev/null; then
    if [ "$NEEDS_SUDO" = true ]; then
        curl -fsSL "$SCRIPT_URL" | sudo tee "$INSTALL_DIR/$SCRIPT_NAME" > /dev/null
    else
        curl -fsSL "$SCRIPT_URL" -o "$INSTALL_DIR/$SCRIPT_NAME"
    fi
elif command -v wget &> /dev/null; then
    if [ "$NEEDS_SUDO" = true ]; then
        wget -qO- "$SCRIPT_URL" | sudo tee "$INSTALL_DIR/$SCRIPT_NAME" > /dev/null
    else
        wget -qO "$INSTALL_DIR/$SCRIPT_NAME" "$SCRIPT_URL"
    fi
else
    echo -e "${RED}Error: Neither curl nor wget found. Please install one of them.${NC}"
    exit 1
fi

# Make it executable
echo -e "${BLUE}Making script executable...${NC}"
if [ "$NEEDS_SUDO" = true ]; then
    sudo chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
else
    chmod +x "$INSTALL_DIR/$SCRIPT_NAME"
fi

echo ""
echo -e "${GREEN}✓ Installation complete!${NC}"
echo ""

# Check if the installation directory is in PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo -e "${YELLOW}⚠ Warning: $INSTALL_DIR is not in your PATH${NC}"
    echo ""
    echo "Add this to your shell configuration file (~/.bashrc, ~/.zshrc, etc.):"
    echo -e "${BLUE}export PATH=\"\$PATH:$INSTALL_DIR\"${NC}"
    echo ""
    echo "Then reload your shell:"
    echo -e "${BLUE}source ~/.bashrc${NC}  # or source ~/.zshrc"
    echo ""
fi

# Show next steps
echo -e "${BLUE}=== Next Steps ===${NC}"
echo ""
echo "1. Initialize configuration (optional):"
echo -e "   ${GREEN}$SCRIPT_NAME --init${NC}"
echo ""
echo "2. Add your API profiles (optional):"
echo -e "   ${GREEN}$SCRIPT_NAME --edit${NC}"
echo ""
echo "3. Run Claude Code:"
echo -e "   ${GREEN}$SCRIPT_NAME${NC}          # Interactive mode"
echo -e "   ${GREEN}$SCRIPT_NAME C${NC}        # Use Claude.ai (Pro subscription)"
echo -e "   ${GREEN}$SCRIPT_NAME 1${NC}        # Use API profile #1"
echo ""
echo -e "${BLUE}For help:${NC} ${GREEN}$SCRIPT_NAME --help${NC}"
echo ""
echo -e "${GREEN}Happy coding with Claude! 🚀${NC}"
