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

  @override
  void initState() {
    super.initState();
    _showInMinutes = true;
    _localConfig = Map.from(widget.config);
    // Initialize controllers
    for (final key in _localConfig.keys) {
      _controllers[key] = TextEditingController(
        text: _convertToDisplay(_localConfig[key]!).toString(),
      );
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
              SwitchListTile(
                title: const Text('Show in Minutes'),
                value: _showInMinutes,
                onChanged: (value) {
                  setState(() {
                    _showInMinutes = value;
                    // Update all form fields to reflect the new unit
                    for (final key in _localConfig.keys) {
                      _controllers[key]?.text = _convertToDisplay(_localConfig[key]!).toString();
                    }
                  });
                },
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