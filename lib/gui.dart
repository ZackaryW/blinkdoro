import 'package:flutter/material.dart';
import 'core.dart';
import 'prep_wnd.dart';

class BlinkDoroGUI extends StatefulWidget {
  const BlinkDoroGUI({super.key});

  @override
  State<BlinkDoroGUI> createState() => _BlinkDoroGUIState();
}

class _BlinkDoroGUIState extends State<BlinkDoroGUI> {
  late BlinkDoro _blinkDoro;
  String _timeString = '90:00';
  bool _isRunning = false;
  bool _hasStarted = false;

  // Default configuration
  final Map<String, int> _config = {
    'workDuration': 90 * 60, // 90 minutes
    'shortBreak': 25 * 60,   // 25 minutes
    'longBreak': 60 * 60,    // 60 minutes
    'sessionsUntilLongBreak': 4,
    'minBlinkInterval': 5 * 60,  // 5 minutes
    'maxBlinkInterval': 10 * 60, // 10 minutes
    'blinkDuration': 10,         // 10 seconds
  };

  @override
  void initState() {
    super.initState();
    _blinkDoro = BlinkDoro(
      onTick: (seconds) {
        setState(() {
          final minutes = seconds ~/ 60;
          final remainingSeconds = seconds % 60;
          _timeString = '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
        });
      },
    );
  }

  void _showSettings() {
    showDialog(
      context: context,
      builder: (context) => PrepWnd(
        config: _config,
        onConfigChanged: (newConfig) {
          setState(() {
            _config.addAll(newConfig);
            // Update BlinkDoro with new configuration
            _blinkDoro.updateConfig(newConfig);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BlinkDoro'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettings,
            tooltip: 'Settings',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Timer Display
            Text(
              _timeString,
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 40),
            
            // Control Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_hasStarted)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _blinkDoro.start();
                        _isRunning = true;
                        _hasStarted = true;
                      });
                    },
                    child: const Text('Start'),
                  )
                else if (_isRunning)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _blinkDoro.pause();
                        _isRunning = false;
                      });
                    },
                    child: const Text('Pause'),
                  )
                else
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _blinkDoro.resume();
                        _isRunning = true;
                      });
                    },
                    child: const Text('Resume'),
                  ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _blinkDoro.reset();
                      _isRunning = false;
                      _hasStarted = false;
                      _timeString = '90:00';
                    });
                  },
                  child: const Text('Reset'),
                ),
                const SizedBox(width: 10),
                if (_blinkDoro.currentRunType != 0)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _blinkDoro.skipBreak();
                      });
                    },
                    child: const Text('Skip'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _blinkDoro.dispose();
    super.dispose();
  }
}
