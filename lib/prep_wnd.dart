import 'package:flutter/material.dart';

class PrepWnd extends StatefulWidget {
  final Map<String, int> config;
  final Function(Map<String, int>) onConfigChanged;

  const PrepWnd({
    super.key,
    required this.config,
    required this.onConfigChanged,
  });

  @override
  State<PrepWnd> createState() => _PrepWndState();
}

class _PrepWndState extends State<PrepWnd> {
  late bool _showInMinutes;
  late Map<String, int> _localConfig;
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};

  // Default configuration values
  static final Map<String, int> _defaultConfig = {
    'workDuration': 90 * 60,
    'shortBreak': 25 * 60,
    'longBreak': 60 * 60,
    'sessionsUntilLongBreak': 4,
    'minBlinkInterval': 5 * 60,
    'maxBlinkInterval': 10 * 60,
    'blinkDuration': 10,
    'showInMinutes': 1, // 1 for true, 0 for false
  };

  @override
  void initState() {
    super.initState();
    _showInMinutes = widget.config['showInMinutes'] == 1;
    _localConfig = Map.from(widget.config);
    // Initialize controllers
    for (final key in _localConfig.keys) {
      if (key != 'showInMinutes') { // Skip showInMinutes for text controllers
        _controllers[key] = TextEditingController(
          text: _convertToDisplay(_localConfig[key]!).toString(),
        );
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  int _convertToDisplay(int seconds) {
    return _showInMinutes ? (seconds ~/ 60) : seconds;
  }

  int _convertToSeconds(int displayValue) {
    return _showInMinutes ? (displayValue * 60) : displayValue;
  }

  void _resetToDefaults() {
    setState(() {
      _localConfig = Map.from(_defaultConfig);
      _showInMinutes = _localConfig['showInMinutes'] == 1;
      // Update all controllers with default values
      for (final key in _localConfig.keys) {
        if (key != 'showInMinutes') { // Skip showInMinutes for text controllers
          _controllers[key]?.text = _convertToDisplay(_localConfig[key]!).toString();
        }
      }
    });
  }

  void _saveConfig() {
    if (_formKey.currentState!.validate()) {
      widget.onConfigChanged(_localConfig);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pomodoro Settings'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Show in Minutes'),
                  Switch(
                    value: _showInMinutes,
                    onChanged: (value) {
                      setState(() {
                        _showInMinutes = value;
                        _localConfig['showInMinutes'] = value ? 1 : 0;
                        // Update all form fields to reflect the new unit
                        for (final key in _localConfig.keys) {
                          if (key != 'showInMinutes') { // Skip showInMinutes for text controllers
                            _controllers[key]?.text = _convertToDisplay(_localConfig[key]!).toString();
                          }
                        }
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildNumberField(
                'Work Duration',
                'workDuration',
                'Duration of work sessions',
              ),
              _buildNumberField(
                'Short Break',
                'shortBreak',
                'Duration of short breaks',
              ),
              _buildNumberField(
                'Long Break',
                'longBreak',
                'Duration of long breaks',
              ),
              _buildNumberField(
                'Sessions until Long Break',
                'sessionsUntilLongBreak',
                'Number of work sessions before a long break',
              ),
              _buildNumberField(
                'Min Blink Interval',
                'minBlinkInterval',
                'Minimum time between blink reminders',
              ),
              _buildNumberField(
                'Max Blink Interval',
                'maxBlinkInterval',
                'Maximum time between blink reminders',
              ),
              _buildNumberField(
                'Blink Duration',
                'blinkDuration',
                'Duration of blink reminder',
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _resetToDefaults,
          child: const Text('Reset to Defaults'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _saveConfig,
          child: const Text('Save'),
        ),
      ],
    );
  }

  Widget _buildNumberField(
    String label,
    String key,
    String hint,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _controllers[key],
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          suffixText: _showInMinutes ? 'minutes' : 'seconds',
        ),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a value';
          }
          final number = int.tryParse(value);
          if (number == null || number <= 0) {
            return 'Please enter a positive number';
          }
          return null;
        },
        onChanged: (value) {
          final number = int.tryParse(value);
          if (number != null) {
            setState(() {
              _localConfig[key] = _convertToSeconds(number);
            });
          }
        },
      ),
    );
  }
} 