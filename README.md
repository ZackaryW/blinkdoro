# BlinkDoro

A Pomodoro timer app with blink reminders to help maintain eye health during long work sessions.

## Development Setup

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Set up Git hooks:

   **Windows:**
   ```powershell
   # Run the PowerShell setup script
   .\scripts\setup-hooks.ps1
   ```

   **Linux/Unix/MacOS:**
   ```bash
   # Make the setup script executable
   chmod +x scripts/setup-hooks.sh
   # Run the setup script
   ./scripts/setup-hooks.sh
   ```

The Git hooks will run tests automatically before each commit when you modify files in the `lib` or `test` directories.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
