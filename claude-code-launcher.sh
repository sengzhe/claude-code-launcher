#!/bin/bash

# Claude Code Configuration Switcher and Launcher
# This script helps you switch between different Anthropic API configurations

CONFIG_FILE="$HOME/.claude-code-profiles"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to create config file if it doesn't exist
create_config_template() {
    cat > "$CONFIG_FILE" << 'EOF'
# Claude Code Profiles Configuration
# Format: PROFILE_NAME|API_KEY|BASE_URL

# Example profiles (uncomment and modify):
# personal|sk-ant-api03-xxx|https://api.anthropic.com
# work|sk-ant-api03-yyy|https://api.anthropic.com
# custom|sk-ant-api03-zzz|https://custom-endpoint.example.com

# Add your profiles below:

EOF
    echo -e "${GREEN}Created config template at: $CONFIG_FILE${NC}"
    echo -e "${YELLOW}Please edit this file and add your profiles.${NC}"
    exit 0
}

# Function to list available profiles
list_profiles() {
    if [ ! -f "$CONFIG_FILE" ]; then
        echo -e "${RED}Config file not found. Creating template...${NC}"
        create_config_template
    fi

    echo -e "${BLUE}Available profiles:${NC}"
    echo ""
    echo -e "  ${GREEN}0)${NC} Default (use current environment/no changes)"
    echo -e "  ${GREEN}C)${NC} Claude.ai (use your logged-in account, clear API key)"
    echo ""
    
    local index=1
    while IFS='|' read -r profile_name api_key base_url; do
        # Skip comments and empty lines
        [[ "$profile_name" =~ ^#.*$ ]] && continue
        [[ -z "$profile_name" ]] && continue
        
        echo -e "  ${GREEN}$index)${NC} $profile_name"
        ((index++))
    done < "$CONFIG_FILE"
    
    if [ $index -eq 1 ]; then
        echo -e "${YELLOW}No profiles configured yet.${NC}"
        echo -e "Edit $CONFIG_FILE to add profiles or select option 0 for default."
    fi
}

# Function to load and use a profile
load_profile() {
    local selection=$1
    
    # Handle claude.ai option - unset API keys to use logged-in account
    if [ "$selection" = "c" ] || [ "$selection" = "C" ] || [ "$selection" = "claude.ai" ]; then
        echo -e "${GREEN}Using Claude.ai account (clearing API keys)${NC}"
        unset ANTHROPIC_API_KEY
        unset ANTHROPIC_BASE_URL
        echo -e "${BLUE}API keys cleared - will use your logged-in Claude.ai account${NC}"
        return 0
    fi
    
    # Handle default/skip option
    if [ "$selection" = "0" ] || [ "$selection" = "default" ]; then
        echo -e "${GREEN}Using default configuration (no changes)${NC}"
        if [ -n "$ANTHROPIC_API_KEY" ]; then
            echo -e "${BLUE}Using existing ANTHROPIC_API_KEY from environment${NC}"
        else
            echo -e "${YELLOW}No ANTHROPIC_API_KEY set in environment${NC}"
        fi
        if [ -n "$ANTHROPIC_BASE_URL" ]; then
            echo -e "${BLUE}Using existing ANTHROPIC_BASE_URL: $ANTHROPIC_BASE_URL${NC}"
        fi
        return 0
    fi
    
    if [ ! -f "$CONFIG_FILE" ]; then
        echo -e "${RED}Config file not found. Creating template...${NC}"
        create_config_template
    fi
    
    local index=1
    local found=false
    
    while IFS='|' read -r profile_name api_key base_url; do
        # Skip comments and empty lines
        [[ "$profile_name" =~ ^#.*$ ]] && continue
        [[ -z "$profile_name" ]] && continue
        
        if [ "$index" -eq "$selection" ] || [ "$profile_name" = "$selection" ]; then
            echo -e "${GREEN}Loading profile: $profile_name${NC}"
            echo -e "${BLUE}Base URL: $base_url${NC}"
            
            export ANTHROPIC_API_KEY="$api_key"
            export ANTHROPIC_BASE_URL="$base_url"
            
            found=true
            break
        fi
        ((index++))
    done < "$CONFIG_FILE"
    
    if [ "$found" = false ]; then
        echo -e "${RED}Profile not found: $selection${NC}"
        exit 1
    fi
}

# Function to launch Claude Code
launch_claude_code() {
    echo -e "${GREEN}Launching Claude Code...${NC}"
    echo ""
    
    # Check for claude command first (newer version)
    if command -v claude &> /dev/null; then
        CLAUDE_CMD="claude"
    # Fall back to claude-code (older version)
    elif command -v claude-code &> /dev/null; then
        CLAUDE_CMD="claude-code"
    else
        echo -e "${RED}Error: Neither 'claude' nor 'claude-code' command found${NC}"
        echo -e "${YELLOW}Please install Claude Code first.${NC}"
        echo -e "${YELLOW}Visit: https://docs.claude.com/en/docs/claude-code${NC}"
        exit 1
    fi
    
    # Launch with any additional arguments passed to the script
    $CLAUDE_CMD "$@"
}

# Main script logic
main() {
    echo -e "${BLUE}=== Claude Code Configuration Switcher ===${NC}"
    echo ""
    
    # Handle command line arguments
    case "${1:-}" in
        --init)
            create_config_template
            ;;
        --list|-l)
            list_profiles
            ;;
        --edit|-e)
            ${EDITOR:-nano} "$CONFIG_FILE"
            ;;
        --help|-h)
            echo "Usage: $0 [OPTION] [profile_selection] [claude args...]"
            echo ""
            echo "Options:"
            echo "  --init          Create configuration file template"
            echo "  --list, -l      List available profiles"
            echo "  --edit, -e      Edit configuration file"
            echo "  --help, -h      Show this help message"
            echo ""
            echo "Profile Selection:"
            echo "  C or 'claude.ai' Use your logged-in Claude.ai account (clears API keys)"
            echo "  0 or 'default'   Use current environment (no changes)"
            echo "  1, 2, 3...       Select profile by number"
            echo "  profile_name     Select profile by name"
            echo ""
            echo "If no option is provided, you'll be prompted to select a profile."
            echo ""
            echo "Examples:"
            echo "  $0                    # Interactive mode"
            echo "  $0 C                  # Use Claude.ai account (Claude Pro)"
            echo "  $0 0                  # Use default/current config"
            echo "  $0 1                  # Use profile #1 (API key)"
            echo "  $0 personal           # Use profile named 'personal'"
            echo "  $0 C /path/to/project # Use Claude.ai and open project"
            exit 0
            ;;
        "")
            # Interactive mode - show profiles and prompt for selection
            list_profiles
            echo ""
            read -p "Select a profile (C for claude.ai, 0 for default, or number): " selection
            
            # Allow C/c for claude.ai option
            if [[ "$selection" =~ ^[Cc]$ ]]; then
                load_profile "C"
            elif [[ "$selection" =~ ^[0-9]+$ ]]; then
                load_profile "$selection"
            else
                echo -e "${RED}Invalid selection${NC}"
                exit 1
            fi
            shift
            launch_claude_code "$@"
            ;;
        *)
            # Profile specified as argument
            load_profile "$1"
            shift
            launch_claude_code "$@"
            ;;
    esac
}

main "$@"
