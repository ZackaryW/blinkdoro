# System Patterns

## Architecture Overview
1. Core Components
   - BlinkDoro: Main timer and blink management
   - BlinkDoroGUI: User interface implementation
   - ConfigService: Configuration persistence
   - PrepWnd: Settings management

2. File Structure
   - `lib/core.dart`: Core timer logic
   - `lib/gui.dart`: Main UI implementation
   - `lib/prep_wnd.dart`: Settings window
   - `lib/config_service.dart`: Configuration management

3. State Management
   - Timer state tracking
   - Session type management
   - Blink reminder scheduling
   - Configuration persistence

## Key Technical Decisions
1. File Organization
   - Snake case naming convention (e.g., `prep_wnd.dart`)
   - Clear separation of concerns
   - Modular component structure

2. UI Implementation
   - Material Design 3 components
   - Stack-based overlay system
   - Responsive layout structure
   - Consistent padding patterns

3. Configuration
   - Single config map for all settings
   - Persistent storage using ConfigService
   - Default values for all settings
   - Time unit preferences

## Component Relationships
1. Timer Flow
   ```
   BlinkDoroGUI
   ├── BlinkDoro (Timer Logic)
   │   ├── Timer State
   │   ├── Session Management
   │   └── Blink Scheduling
   └── ConfigService
       └── Settings Persistence
   ```

2. Configuration Flow
   ```
   PrepWnd
   ├── ConfigService
   │   └── Persistent Storage
   └── BlinkDoro
       └── Runtime Configuration
   ```

## Critical Implementation Paths
1. Timer Control
   ```
   Start → Timer Initialization → State Update → UI Refresh
   Pause → Timer Cancellation → State Update → UI Refresh
   Resume → Timer Restart → State Update → UI Refresh
   Reset → Timer Reset → State Reset → UI Refresh
   Skip → Session Change → Timer Reset → UI Refresh
   ```

2. Blink Reminder
   ```
   Schedule → Random Interval → Timer Setup
   Trigger → Visual Overlay → State Update
   Complete → Overlay Clear → Next Schedule
   ```

3. Configuration
   ```
   Load → Default Values → User Settings
   Update → Runtime Changes → Persistent Save
   Reset → Default Values → Runtime Update
   ```

## Design Patterns
1. State Management
   - Observer pattern for timer updates
   - State machine for session management
   - Callback system for UI updates

2. Configuration
   - Singleton pattern for ConfigService
   - Factory pattern for default values
   - Observer pattern for settings updates

3. UI Components
   - Composite pattern for layout
   - Observer pattern for state updates
   - Strategy pattern for time display

## UI Patterns
1. Layout Structure
   - Column-based main layout
   - Stack for overlay effects
   - Container for section management

2. Visual Feedback
   - Dimming effect during blinks
   - Consistent padding across sections
   - Responsive button positioning

3. Component Organization
   - Group count display
   - Timer display
   - Control buttons
   - Settings access

### Observer Pattern
- Used for timer and blink notifications
- Callbacks for UI updates:
  - `onTick`: Regular timer updates
  - `onComplete`: Session completion
  - `onBreakComplete`: Break completion
  - `onLongBreakComplete`: Long break completion
  - `onBlink`: Blink reminder triggers

### State Management
- Simple state tracking in core module
- Timer states:
  - Running/Stopped
  - Work/Break/Long Break
  - Blink reminder active/inactive

### UI Patterns
- Full-screen overlay for blink reminders
- Centered timer display (HH:MM:SS)
- Control button layout
- Session type indicators

### Component Structure
```
BlinkDoro (Core)
├── Timer Management
│   ├── Work Timer
│   ├── Break Timer
│   └── Long Break Timer
└── Blink System
    ├── Random Interval Generator
    └── Blink Reminder
        ├── Visual Overlay
        └── Sound Notification
```

## Implementation Patterns

### Timer Implementation
- Uses Dart's `Timer` class
- Maintains countdown state
- Handles session transitions
- Formats time display (HH:MM:SS)

### Blink System
- Random interval generation
- Non-blocking reminder system
- Configurable duration
- Full-screen overlay management
- Sound notification handling

### Error Handling
- Graceful timer management
- State recovery
- User feedback

## Code Organization
- Clear separation of concerns
- Modular component design
- Minimal coupling between modules

## UI Components
1. Timer Display
   - Large, centered text
   - HH:MM:SS format
   - Session type indicator

2. Control Panel
   - Pause/Resume button
   - Reset button
   - Skip Break button

3. Blink Reminder
   - Full-screen overlay
   - Eye symbol
   - Sound notification
   - Auto-dismiss 