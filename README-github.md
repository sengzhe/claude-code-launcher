# Claude Code Launcher

🚀 A simple CLI tool to manage multiple Claude Code configurations and switch between Claude.ai (Pro) and API keys effortlessly.

## Features

- 🔄 **Easy Profile Switching** - Switch between multiple API keys/endpoints
- 🎯 **Claude.ai Support** - Use your Claude Pro subscription with one command
- 💾 **Multiple Profiles** - Store and manage unlimited API configurations
- ⚡ **Zero Config** - Works out of the box with your Claude.ai account
- 🎨 **Beautiful CLI** - Color-coded, user-friendly interface
- 🔒 **Secure** - Keeps your API keys in a local config file

## Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/claude-code-launcher/main/install.sh | bash
```

Or with wget:
```bash
wget -qO- https://raw.githubusercontent.com/YOUR_USERNAME/claude-code-launcher/main/install.sh | bash
```

## Usage

### Interactive Mode
Just run the command and select from the menu:
```bash
claude-launcher
```

### Quick Commands

Use your Claude Pro subscription (claude.ai):
```bash
claude-launcher C
```

Use API key profiles:
```bash
claude-launcher 1              # Use profile #1
claude-launcher work           # Use profile named "work"
claude-launcher personal ~/projects/my-app
```

### Available Options

```
C or 'claude.ai'  - Use your logged-in Claude.ai account (Claude Pro)
0 or 'default'    - Use current environment (no changes)
1, 2, 3...        - Select API profile by number
profile_name      - Select API profile by name
```

## Configuration

### Initialize Config (Optional)
If you want to use API keys, initialize the configuration:
```bash
claude-launcher --init
```

### Add API Profiles
Edit the configuration file:
```bash
claude-launcher --edit
```

Add profiles in this format:
```
profile_name|your-api-key|base-url
```

Example:
```
personal|sk-ant-api03-xxxxx|https://api.anthropic.com
work|sk-ant-api03-yyyyy|https://api.anthropic.com
testing|sk-ant-api03-zzzzz|https://custom-endpoint.example.com
```

### List Profiles
```bash
claude-launcher --list
```

## Common Use Cases

### Use Case 1: Claude Pro User (No API Key)
You're using Claude Code with your Claude Pro subscription:
```bash
claude-launcher C
```
That's it! No configuration needed.

### Use Case 2: Switching Between Personal and Work API Keys
```bash
# Setup (one time)
claude-launcher --init
claude-launcher --edit  # Add your profiles

# Daily use
claude-launcher personal  # Use personal API key
claude-launcher work      # Use work API key
```

### Use Case 3: Mix of Claude Pro and API Keys
```bash
claude-launcher C         # Use Claude Pro for personal projects
claude-launcher work      # Use work API key for client projects
```

## Commands

| Command | Description |
|---------|-------------|
| `claude-launcher` | Interactive mode - shows menu |
| `claude-launcher C` | Use Claude.ai (Pro subscription) |
| `claude-launcher 0` | Use default environment |
| `claude-launcher 1` | Use profile #1 |
| `claude-launcher work` | Use profile named "work" |
| `claude-launcher --list` | List all profiles |
| `claude-launcher --edit` | Edit configuration |
| `claude-launcher --init` | Create config template |
| `claude-launcher --help` | Show help |

## Configuration File

The configuration is stored at: `~/.claude-code-profiles`

### Security

⚠️ **Important**: The config file contains API keys in plain text.

Secure your config file:
```bash
chmod 600 ~/.claude-code-profiles
```

**Never commit this file to version control!**

## Troubleshooting

### "claude command not found"
Make sure Claude Code is installed:
- Visit: https://docs.claude.com/en/docs/claude-code
- The script works with both `claude` and `claude-code` commands

### "Auth conflict: Both a token and API key are set"
This happens when you have both Claude.ai login and an API key. Use:
```bash
claude-launcher C  # To use Claude.ai (clears API key)
claude-launcher 1  # To use API key profile
```

### Installation directory not in PATH
If you see a PATH warning during installation, add this to `~/.bashrc` or `~/.zshrc`:
```bash
export PATH="$PATH:$HOME/.local/bin"
```

Then reload:
```bash
source ~/.bashrc  # or source ~/.zshrc
```

## Manual Installation

If you prefer manual installation:

1. Download the script:
```bash
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/claude-code-launcher/main/claude-code-launcher.sh -o claude-launcher
```

2. Make it executable:
```bash
chmod +x claude-launcher
```

3. Move to a directory in your PATH:
```bash
sudo mv claude-launcher /usr/local/bin/
# or
mv claude-launcher ~/.local/bin/
```

## Uninstall

```bash
rm /usr/local/bin/claude-launcher
# or
rm ~/.local/bin/claude-launcher

# Optionally remove config
rm ~/.claude-code-profiles
```

## Requirements

- Bash shell
- Claude Code installed (`claude` or `claude-code` command)
- curl or wget (for installation)

## How It Works

The launcher manages your `ANTHROPIC_API_KEY` and `ANTHROPIC_BASE_URL` environment variables:

1. **Option C (Claude.ai)**: Unsets API key variables so Claude uses your logged-in account
2. **API Profiles**: Sets the appropriate API key and base URL from your config
3. **Default**: Keeps your current environment unchanged

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT License - Feel free to use and modify as needed.

## Support

- 📖 [Claude Code Documentation](https://docs.claude.com/en/docs/claude-code)
- 🐛 [Report Issues](https://github.com/YOUR_USERNAME/claude-code-launcher/issues)
- ⭐ Star this repo if you find it useful!

---

Made with ❤️ for the Claude Code community
