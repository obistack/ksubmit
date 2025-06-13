# Building ksubmit as a Single Executable with PyInstaller

This guide explains how to build ksubmit as a single executable that supports all shorthand commands (krun, kstat, etc.) on all major platforms.

## Prerequisites

Make sure you have PyInstaller installed:

```bash
pip install pyinstaller
```

## Building the Executable

1. Navigate to the ksubmit project directory:

```bash
cd /path/to/ksubmit
```

2. Build the executable using the provided spec file:

```bash
pyinstaller ksubmit.spec
```

This will create a single executable file in the `dist` directory.

## Setting Up Shorthand Commands

The build process creates platform-specific scripts to set up the shorthand commands:

### On Windows

Run the generated batch file:

```bash
dist\setup_shortcuts.bat
```

This will create copies of the main executable with names corresponding to each shorthand command (krun.exe, kstat.exe, etc.) in the `dist` directory.

### On macOS/Linux

Run the generated shell script:

```bash
./dist/setup_shortcuts.sh
```

This will create symlinks to the main executable with names corresponding to each shorthand command (krun, kstat, etc.) in the `dist/bin` directory.

Add the `dist/bin` directory to your PATH to use the shorthand commands:

```bash
# Temporary (for current session only)
export PATH="$PATH:/path/to/ksubmit/dist/bin"

# Permanent (add to your .bashrc, .zshrc, etc.)
echo 'export PATH="$PATH:/path/to/ksubmit/dist/bin"' >> ~/.bashrc
```

## How It Works

The spec file is configured to:

1. Use `shorthand.py` as the main entry point, which detects which command was invoked based on the script name.
2. Include all necessary dependencies and data files.
3. Enable argv emulation for cross-platform support.
4. Create platform-specific scripts to set up the shorthand commands.

## Troubleshooting

If you encounter any issues:

1. Make sure all dependencies are installed:

```bash
pip install -r requirements.txt
```

2. Try building with the `--clean` flag to start fresh:

```bash
pyinstaller --clean ksubmit.spec
```

3. Check the PyInstaller build logs for any errors:

```bash
cat build/ksubmit/warn-ksubmit.txt
```

## Distribution

To distribute the executable:

1. On Windows: Distribute the main executable and all shorthand command executables.
2. On macOS/Linux: Distribute the main executable and instruct users to create symlinks or use the provided setup script.