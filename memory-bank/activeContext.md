# Active Context

## Current Focus
- Implementing core Pomodoro timer functionality
- Setting up basic blink reminder system
- Establishing project structure
- Designing UI components

## Recent Changes
- Created initial project structure
- Implemented basic timer properties in `core.dart`
- Added blink reminder configuration
- Set up callback system for UI updates
- Defined UI requirements and patterns

## Active Decisions
1. Timer Configuration
   - Default work time: 90 minutes
   - Default break time: 25 minutes
   - Default long break time: 60 minutes
   - Long break interval: Every 4 sessions
   - Time display format: HH:MM:SS

2. Blink System
   - Random intervals: 5-10 minutes
   - Blink duration: 10 seconds
   - Full-screen overlay with eye symbol
   - Sound notifications
   - Auto-dismissing reminders

3. UI Design
   - Centered timer display
   - Basic control buttons (Pause/Resume, Reset, Skip Break)
   - Full-screen blink reminders
   - Session type indicators

## Next Steps
1. Complete core timer implementation
   - Implement start/stop functionality
   - Add session transition logic
   - Handle timer state management
   - Format time display (HH:MM:SS)

2. Develop blink reminder system
   - Implement random interval generation
   - Create full-screen overlay
   - Add sound notification system
   - Handle auto-dismiss functionality

3. Create basic UI
   - Timer display component
   - Control button panel
   - Blink reminder overlay
   - Session indicators

## Current Challenges
- Ensuring accurate timer functionality
- Implementing non-blocking blink reminders
- Managing full-screen overlays
- Handling sound notifications
- Maintaining clean separation between core logic and UI

## Project Insights
- Simple architecture is key to maintainability
- Clear separation between timer and blink systems
- Focus on user experience in notification design
- Importance of non-intrusive but noticeable reminders 