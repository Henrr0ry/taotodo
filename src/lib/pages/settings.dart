import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/settings_services.dart';

class SettingsPage extends StatefulWidget {
  final bool initialDarkMode;
  final Color initialPrimaryColor;
  final void Function(bool) onThemeChanged;
  final void Function(Color) onColorChanged;

  const SettingsPage({
    super.key,
    required this.initialDarkMode,
    required this.initialPrimaryColor,
    required this.onThemeChanged,
    required this.onColorChanged,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late SettingsService _settingsService;
  late bool _darkMode;
  String _language = 'en';
  late String _primaryColorString;

  @override
  void initState() {
    super.initState();
    _darkMode = widget.initialDarkMode;
    _primaryColorString = widget.initialPrimaryColor.toString();
    _loadSettings();
  }

  @override
  void didUpdateWidget(covariant SettingsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialDarkMode != widget.initialDarkMode) {
      setState(() {
        _darkMode = widget.initialDarkMode;
      });
    }
    if (oldWidget.initialPrimaryColor != widget.initialPrimaryColor) {
      setState(() {
        _primaryColorString = widget.initialPrimaryColor.toString();
      });
    }
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _settingsService = SettingsService(prefs);

    setState(() {
      _language = _settingsService.getLanguage() ?? 'en';
    });
  }

  Widget _buildColorButton(Color color) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          _primaryColorString = color.toString();
        });
        await _settingsService.savePrimaryColor(_primaryColorString);
        widget.onColorChanged(color);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: _primaryColorString == color.toString()
              ? Border.all(color: Colors.black, width: 3)
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: _darkMode,
            onChanged: (value) async {
              setState(() {
                _darkMode = value;
              });
              await _settingsService.saveDarkMode(value);
              widget.onThemeChanged(value);
            },
          ),
          ListTile(
            title: const Text('Language'),
            trailing: DropdownButton<String>(
              value: _language,
              items: const [
                DropdownMenuItem(value: 'cs', child: Text('Čeština')),
                DropdownMenuItem(value: 'en', child: Text('English')),
              ],
              onChanged: (value) async {
                if (value != null) {
                  setState(() {
                    _language = value;
                  });
                  await _settingsService.saveLanguage(value);
                }
              },
            ),
          ),
          ListTile(
            title: const Text('Primary Color'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildColorButton(Colors.blue),
                _buildColorButton(Colors.red),
                _buildColorButton(Colors.green),
                _buildColorButton(Colors.purple),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
