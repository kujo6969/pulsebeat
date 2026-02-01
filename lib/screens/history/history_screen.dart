import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({super.key});

  final List<PulseHistory> historyData = [
    PulseHistory(date: DateTime(2026, 1, 15), isElevated: false),
    PulseHistory(date: DateTime(2026, 1, 14), isElevated: true),
    PulseHistory(date: DateTime(2026, 1, 13), isElevated: false),
    PulseHistory(date: DateTime(2026, 1, 12), isElevated: true),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: historyData.length,
      itemBuilder: (context, index) {
        final item = historyData[index];

        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Icon(
              item.isElevated ? Icons.favorite : Icons.favorite_border,
              color: item.isElevated ? Colors.red : Colors.green,
              size: 30,
            ),
            title: Text(
              _formatDate(item.date),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              item.isElevated ? "Elevated Pulse" : "Normal",
              style: TextStyle(
                color: item.isElevated ? Colors.red : Colors.green,
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
    );
  }

  String _formatDate(DateTime date) {
    return "${date.month}/${date.day}/${date.year}";
  }
}

class PulseHistory {
  final DateTime date;
  final bool isElevated;

  PulseHistory({required this.date, required this.isElevated});
}
