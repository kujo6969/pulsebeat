import 'package:flutter/material.dart';
import 'package:testing3/screens/bluetooth/bluetooth_screen.dart';
import 'package:testing3/screens/history/history_screen.dart';
import 'package:testing3/screens/pulse_monitor_someone/pulse_monitor_someone_screen.dart';
import 'package:testing3/screens/pulse_monitoring/pulse_monitoring_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    BluetoothScreen(),
    PulseMonitoringScreen(),
    HistoryScreen(),
    PulseMonitorSomeoneScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PulseBeat", style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
      ),

      body: IndexedStack(index: _currentIndex, children: _pages),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Theme.of(context).colorScheme.tertiary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.bluetooth),
            label: 'Bluetooth',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Pulse'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(
            icon: Icon(Icons.monitor_heart),
            label: 'Monitor',
          ),
        ],
      ),
    );
  }
}
