# Technical Context

## Development Environment
- Flutter/Dart SDK
- Cross-platform development (Windows, macOS, Linux)
- IDE: VS Code/Cursor

## Project Dependencies
- Flutter framework
- Standard Dart libraries
- No external dependencies required for core functionality

## Code Organization
### Core Module (`lib/core.dart`)
- Pomodoro timer implementation
- Blink reminder system
- Timer state management
- Callback system for UI updates

### Main Module (`lib/main.dart`)
- Application entry point
- Initial setup and configuration
- Platform-specific initialization

### GUI Module (`lib/gui.dart`)
- User interface components
- Timer display
- Settings management
- Visual feedback for blink reminders

## Technical Constraints
- Minimal external dependencies
- Focus on native Flutter widgets
- Simple state management approach
- Cross-platform compatibility requirements

## Development Guidelines
1. Keep core logic separate from UI
2. Use clear, descriptive variable names
3. Document public APIs
4. Maintain consistent code style
5. Write unit tests for core functionality 