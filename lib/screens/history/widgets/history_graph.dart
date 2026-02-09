import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HistoryGraph extends StatefulWidget {
  const HistoryGraph({super.key});

  @override
  State<HistoryGraph> createState() => _HistoryGraphState();
}

class _HistoryGraphState extends State<HistoryGraph> {
  final TextEditingController _deviceIdController = TextEditingController();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  List<PulseHistory> _historyData = [];
  bool _loading = false;

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
          .orderBy('date')
          .get();

      final history = snapshot.docs.map((doc) {
        final avgBpm = doc['avg_bpm'] as int;
        final maxBpm = doc['max_bpm'] as int;
        final minBpm = doc['min_bpm'] as int;

        return PulseHistory(
          date: DateTime.parse(doc['date']),
          avgBpm: avgBpm,
          maxBpm: maxBpm,
          minBpm: minBpm,
          isElevated: avgBpm > 100,
        );
      }).toList();
      setState(() {
        _historyData = history;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error loading graph: $e")));
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("BPM Graph")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _deviceIdController,
                    decoration: const InputDecoration(
                      labelText: "Enter Device ID",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final deviceId = _deviceIdController.text.trim();
                    if (deviceId.isNotEmpty) {
                      _fetchHistory(deviceId);
                    }
                  },
                  child: const Icon(Icons.show_chart),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Chip(
                avatar: CircleAvatar(backgroundColor: Colors.red),
                label: const Text('Avg. BPM'),
                side: BorderSide.none,
              ),
              Chip(
                avatar: CircleAvatar(backgroundColor: Colors.green),
                label: const Text('Min. BPM'),
                side: BorderSide.none,
              ),
              Chip(
                avatar: CircleAvatar(backgroundColor: Colors.blue),
                label: const Text('Max. BPM'),
                side: BorderSide.none,
              ),
            ],
          ),

          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _historyData.isEmpty
                ? const Center(
                    child: Text("No data available to display graph"),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: LineChart(_buildChart()),
                  ),
          ),
        ],
      ),
    );
  }

  LineChartData _buildChart() {
    return LineChartData(
      minY: 40,
      gridData: FlGridData(show: true),
      borderData: FlBorderData(show: true),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index < 0 || index >= _historyData.length) {
                return const SizedBox.shrink();
              }
              final date = _historyData[index].date;
              return Text("${date.month}/${date.day}");
            },
          ),
        ),
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true,reservedSize: 40)),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: List.generate(
            _historyData.length,
            (i) => FlSpot(i.toDouble(), _historyData[i].avgBpm.toDouble()),
          ),
          isCurved: true,
          barWidth: 3,
          color: Colors.red,
          dotData: FlDotData(show: true),
        ),

        LineChartBarData(
          spots: List.generate(
            _historyData.length,
            (i) => FlSpot(i.toDouble(), _historyData[i].maxBpm.toDouble()),
          ),
          isCurved: true,
          barWidth: 2,
          color: Colors.blue,
          dotData: FlDotData(show: false),
        ),

        LineChartBarData(
          spots: List.generate(
            _historyData.length,
            (i) => FlSpot(i.toDouble(), _historyData[i].minBpm.toDouble()),
          ),
          isCurved: true,
          barWidth: 2,
          color: Colors.green,
          dotData: FlDotData(show: false),
        ),
      ],
    );
  }
}

class PulseHistory {
  final DateTime date;
  final int avgBpm;
  final int maxBpm;
  final int minBpm;
  final bool isElevated;

  PulseHistory({
    required this.date,
    required this.avgBpm,
    required this.maxBpm,
    required this.minBpm,
    required this.isElevated,
  });
}
