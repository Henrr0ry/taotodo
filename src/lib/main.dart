import 'package:flutter/material.dart';
import 'pages/settings.dart';
import 'services/settings_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  ThemeMode _themeMode = ThemeMode.light;
  Color _primaryColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settings = SettingsService(prefs);
    setState(() {
      _themeMode = (settings.getDarkMode() ?? false)
          ? ThemeMode.dark
          : ThemeMode.light;
      final colorString = settings.getPrimaryColor();
      _primaryColor = colorString != null
          ? _parseColor(colorString)
          : Colors.blue;
    });
  }

  Color _parseColor(String colorString) {
    final reg = RegExp(r'Color\(0x([0-9a-f]+)\)');
    final match = reg.firstMatch(colorString);
    if (match != null) {
      final value = int.parse(match.group(1)!, radix: 16);
      return Color(value);
    }
    return Colors.blue;
  }

  void _onThemeChanged(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _onColorChanged(Color color) {
    setState(() {
      _primaryColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(
        currentDarkMode: _themeMode == ThemeMode.dark,
        currentPrimaryColor: _primaryColor,
        onThemeChanged: _onThemeChanged,
        onColorChanged: _onColorChanged,
      ),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _primaryColor,
          brightness: Brightness.light,
          onSurface: Colors.black,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _primaryColor,
          brightness: Brightness.dark,
          surface: Colors.black,
        ),
      ),
      themeMode: _themeMode,
    );
  }
}

class HomePage extends StatefulWidget {
  final bool currentDarkMode;
  final Color currentPrimaryColor;
  final void Function(bool) onThemeChanged;
  final void Function(Color) onColorChanged;

  const HomePage({
    super.key,
    required this.currentDarkMode,
    required this.currentPrimaryColor,
    required this.onThemeChanged,
    required this.onColorChanged,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _pages = [
      const Center(child: Text("Calendar Page")),
      const Center(child: Text("Tools")),
      const Center(child: Text("Tao")),
      const Center(child: Text("Stats")),
      SettingsPage(
        initialDarkMode: widget.currentDarkMode,
        initialPrimaryColor: widget.currentPrimaryColor,
        onThemeChanged: widget.onThemeChanged,
        onColorChanged: widget.onColorChanged,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Taotodo',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 8,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface,
        selectedIconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.primary,
        ),
        unselectedIconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onSurface,
        ),
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Calendar",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.toys), label: "Tools"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Tao"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Stats"),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
