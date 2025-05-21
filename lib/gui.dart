import 'package:flutter/material.dart';
import 'core.dart';
import 'prep_wnd.dart';
import 'config_service.dart';

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
  bool _isBlinkActive = false;
  Map<String, int> _config = {};

  @override
  void initState() {
    super.initState();
    _initializeBlinkDoro();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final config = await ConfigService.loadConfig();
    setState(() {
      _config = config;
      _blinkDoro.updateConfig(config);
    });
  }

  void _initializeBlinkDoro() {
    _blinkDoro = BlinkDoro(
      onTick: (seconds) {
        setState(() {
          final minutes = seconds ~/ 60;
          final remainingSeconds = seconds % 60;
          _timeString = '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
        });
      },
      onComplete: () {
        setState(() {
          _isRunning = false;
          _hasStarted = false;
        });
      },
      onBreakComplete: () {
        setState(() {
          _isRunning = false;
          _hasStarted = false;
        });
      },
      onLongBreakComplete: () {
        setState(() {
          _isRunning = false;
          _hasStarted = false;
        });
      },
      onBlink: (blinkDoro) {
        setState(() {
          _isBlinkActive = true;
        });
        // Schedule blink end
        Future.delayed(Duration(seconds: blinkDoro.blinkInterval), () {
          if (mounted) {
            setState(() {
              _isBlinkActive = false;
            });
          }
        });
      },
    );
  }

  void _showSettings() {
    showDialog(
      context: context,
      builder: (context) => PrepWnd(
        config: _config,
        onConfigChanged: (newConfig) async {
          await ConfigService.saveConfig(newConfig);
          setState(() {
            _config = newConfig;
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
      body: Column(
        children: [
          // Pomodoro count display
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 20),
            color: _isBlinkActive 
                ? Colors.black.withAlpha(179)
                : Theme.of(context).scaffoldBackgroundColor,
            child: Text(
              'Group ${_blinkDoro.currentPomodoroCount + 1}/${_blinkDoro.pomodoroLongBreakInterval}',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
          // Timer section
          Expanded(
            child: Stack(
              children: [
                Center(
                  child: Text(
                    _timeString,
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ),
                if (_isBlinkActive)
                  Container(
                    color: Colors.black.withOpacity(0.7),
                    child: const Center(
                      child: Icon(
                        Icons.visibility,
                        size: 100,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Buttons section
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            color: _isBlinkActive 
                ? Colors.black.withAlpha(179)
                : Theme.of(context).scaffoldBackgroundColor,
            child: Row(
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
                      final minutes = _blinkDoro.pomodoroWorkTime ~/ 60;
                      final seconds = _blinkDoro.pomodoroWorkTime % 60;
                      _timeString = '$minutes:${seconds.toString().padLeft(2, '0')}';
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
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _blinkDoro.dispose();
    super.dispose();
  }
}
