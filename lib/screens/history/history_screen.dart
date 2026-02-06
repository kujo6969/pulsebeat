import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TextEditingController _deviceIdController = TextEditingController();
  List<PulseHistory> _historyData = [];
  bool _loading = false;

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Fetch daily averages for the given device
  Future<void> _fetchHistory(String deviceId) async {
    setState(() {
      _loading = true;
      _historyData = [];
    });

    try {
      final snapshot = await _db
          .collection('devices')
          .doc(deviceId)
          .collection('daily_avg')
          .orderBy('date', descending: true)
          .get();

      final history = snapshot.docs.map((doc) {
        final avgBpm = doc['avg_bpm'] as int;
        return PulseHistory(
          date: DateTime.parse(doc['date']),
          avgBpm: avgBpm,
          isElevated: avgBpm > 100,
        );
      }).toList();

      setState(() {
        _historyData = history;
      });
    } catch (e) {
      print("Error fetching history: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to fetch history: $e")));
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _deviceIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("BPM History")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _deviceIdController,
                    decoration: InputDecoration(
                      labelText: "Enter Device ID",
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(4), // optional
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
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () {
                      final deviceId = _deviceIdController.text.trim();
                      if (deviceId.isNotEmpty) {
                        _fetchHistory(deviceId);
                      }
                    },
                    child: const Icon(
                      Icons.download,
                    ), 
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _historyData.isEmpty
                ? const Center(child: Text("Enter a Device ID and press Load"))
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _historyData.length,
                    itemBuilder: (context, index) {
                      final item = _historyData[index];
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Icon(
                            item.isElevated
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: item.isElevated ? Colors.red : Colors.green,
                            size: 30,
                          ),
                          title: Text(
                            _formatDate(item.date),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "${item.avgBpm} BPM - ${item.isElevated ? "Elevated Pulse" : "Normal"}",
                            style: TextStyle(
                              color: item.isElevated
                                  ? Colors.red
                                  : Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          trailing: Icon(
                            Icons.circle,
                            color: item.isElevated ? Colors.red : Colors.green,
                            size: 14,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.month}/${date.day}/${date.year}";
  }
}

class PulseHistory {
  final DateTime date;
  final int avgBpm;
  final bool isElevated;

  PulseHistory({
    required this.date,
    required this.avgBpm,
    required this.isElevated,
  });
}
