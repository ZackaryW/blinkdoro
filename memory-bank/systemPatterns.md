# System Patterns

## Architecture Overview
BlinkDoro follows a simple layered architecture:
1. Core Layer (Timer Logic)
2. UI Layer (User Interface)
3. Application Layer (Coordination)

## Design Patterns

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