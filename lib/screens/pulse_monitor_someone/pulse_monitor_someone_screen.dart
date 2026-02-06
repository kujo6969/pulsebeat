import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PulseMonitorSomeoneScreen extends StatefulWidget {
  const PulseMonitorSomeoneScreen({super.key});

  @override
  State<PulseMonitorSomeoneScreen> createState() =>
      _PulseMonitorSomeoneScreenState();
}

class _PulseMonitorSomeoneScreenState extends State<PulseMonitorSomeoneScreen>
    with SingleTickerProviderStateMixin {
  final int frameWidth = 300;
  final double midY = 75;
  late List<double> points;

  List<double> currentPattern = [];
  int patternIndex = 0;
  int bpm = 60;

  String deviceId = "";
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    points = List.filled(frameWidth, midY);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Stream<QuerySnapshot>? _buildStream() {
    if (deviceId.isEmpty) return null;

    return FirebaseFirestore.instance
        .collection('devices')
        .doc(deviceId)
        .collection('bpm')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final stream = _buildStream();

    return Scaffold(
      appBar: AppBar(title: const Text('Monitor Someone')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: "Enter Device ID",
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 60,
                  width: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
                    onPressed: () {
                      setState(() {
                        deviceId = _controller.text.trim();
                      });
                    },
                    child: const Icon(Icons.download),
                  ),
                ),
              ],
            ),
          ),

          if (stream == null)
            Expanded(
              child: Center(
                child: const Text("Enter a Device ID and press Load"),
              ),
            )
          else
            StreamBuilder<QuerySnapshot>(
              stream: stream,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  final data = snapshot.data!.docs.first;
                  bpm = data['bpm'] as int;
                }

                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        "$bpm BPM",
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: bpm > 100 ? Colors.red : Colors.green,
                        ),
                      ),
                      Text(
                        bpm > 100 ? "⚠️ Elevated Pulse" : "Normal",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: bpm > 100 ? Colors.red : Colors.green,
                        ),
                      ),
                      Text(
                        "Data refresh every 5 seconds if the wearer is active.",
                        style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
