# Claude Code Configuration Switcher

A bash script that makes it easy to switch between different Anthropic API configurations and launch Claude Code.

## Features

- 🔄 Switch between multiple API profiles
- 🚀 Launch Claude Code with the selected configuration
- 💾 Store multiple API keys and base URLs
- 🎨 Color-coded, user-friendly interface
- ⚡ Interactive or command-line modes

## Installation

1. Download the `claude-code-launcher.sh` script

2. Make it executable:
```bash
chmod +x claude-code-launcher.sh
```

3. (Optional) Move it to a location in your PATH for easy access:
```bash
sudo mv claude-code-launcher.sh /usr/local/bin/claude-launcher
# Or for user-only installation:
mkdir -p ~/.local/bin
mv claude-code-launcher.sh ~/.local/bin/claude-launcher
# Make sure ~/.local/bin is in your PATH
```

## Setup

1. Initialize the configuration file:
```bash
./claude-code-launcher.sh --init
```

2. Edit the configuration file to add your profiles:
```bash
./claude-code-launcher.sh --edit
```

Or manually edit `~/.claude-code-profiles`:
```bash
nano ~/.claude-code-profiles
```

3. Add your profiles in this format:
```
profile_name|your-api-key|base-url
```

Example:
```
personal|sk-ant-api03-xxxxx|https://api.anthropic.com
work|sk-ant-api03-yyyyy|https://api.anthropic.com
testing|sk-ant-api03-zzzzz|https://custom-api.example.com
```

## Usage

### Interactive Mode
Simply run the script and select from the menu:
```bash
./claude-code-launcher.sh
```

### Quick Launch with Profile Number
```bash
./claude-code-launcher.sh 1
```

### Quick Launch with Profile Name
```bash
./claude-code-launcher.sh personal
```

### Launch with Project Path
```bash
./claude-code-launcher.sh 1 /path/to/your/project
```

### Additional Commands

List all available profiles:
```bash
./claude-code-launcher.sh --list
```

Edit configuration:
```bash
./claude-code-launcher.sh --edit
```

Show help:
```bash
./claude-code-launcher.sh --help
```

## Configuration File Location

The configuration file is stored at: `~/.claude-code-profiles`

## Security Notes

⚠️ **Important**: 
- The configuration file contains your API keys in plain text
- Make sure the file has appropriate permissions:
  ```bash
  chmod 600 ~/.claude-code-profiles
  ```
- Don't commit this file to version control
- Consider using environment variables or a secrets manager for production use

## Environment Variables Set

The script sets the following environment variables when launching Claude Code:
- `ANTHROPIC_API_KEY`: Your API key for the selected profile
- `ANTHROPIC_BASE_URL`: The base URL for the selected profile

## Troubleshooting

### "claude-code command not found"
Make sure Claude Code is installed and available in your PATH.

### "Config file not found"
Run `./claude-code-launcher.sh --init` to create the configuration file.

### "No profiles configured"
Edit the configuration file and add at least one profile.

## Examples

**Example 1: Quick switch to work profile**
```bash
claude-launcher work
```

**Example 2: Use personal profile with specific project**
```bash
claude-launcher personal ~/projects/my-app
```

**Example 3: Interactive mode (shows menu)**
```bash
claude-launcher
```

## Tips

- Use descriptive profile names like "personal", "work", "testing"
- You can have multiple profiles pointing to the same base URL with different API keys
- The script passes all additional arguments to Claude Code, so you can use any Claude Code flags after the profile selection

## License

Free to use and modify as needed.
