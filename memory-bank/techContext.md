# Technical Context

## Development Environment
- Flutter SDK
- Dart SDK
- Windows 10 development environment
- Visual Studio Code / Cursor IDE

## Dependencies
- `window_manager: ^0.3.8` - For desktop window management
- Flutter Material Design 3

## Project Structure
```
lib/
├── core.dart      # Core timer and blink logic
├── gui.dart       # User interface implementation
├── prepWnd.dart   # Configuration window
└── main.dart      # Application entry point
```

## Key Technical Decisions
1. Window Management
   - Using `window_manager` package for desktop window control
   - Fixed window size (400x600) for optimal user experience
   - Window centering and focus management

2. State Management
   - Using Flutter's built-in StatefulWidget for local state
   - Timer state tracking with boolean flags
   - Clean separation of UI and business logic
   - Configuration state management in prepWnd.dart

3. UI Architecture
   - Material Design 3 for consistent theming
   - Responsive layout with centered content
   - Clear visual hierarchy for timer and controls
   - Separate configuration window for settings

4. Configuration System
   - Internal storage in seconds for consistency
   - User-friendly display in preferred units
   - Toggle between seconds and minutes
   - Persistent storage of settings

## Development Workflow
1. Code organization
   - Core logic in `core.dart`
   - UI components in `gui.dart`
   - Configuration in `prepWnd.dart`
   - App configuration in `main.dart`

2. Testing
   - Unit tests for core functionality
   - Widget tests for UI components
   - Configuration validation tests
   - Pre-commit hooks for test automation

3. Version Control
   - Git for source control
   - Pre-commit hooks for test validation
   - Branch-based development workflow

## Development Guidelines
1. Keep core logic separate from UI
2. Use clear, descriptive variable names
3. Document public APIs
4. Maintain consistent code style
5. Write unit tests for core functionality
6. Validate configuration values
7. Handle unit conversions consistently 