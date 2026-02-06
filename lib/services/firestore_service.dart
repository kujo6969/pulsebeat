import 'package:cloud_firestore/cloud_firestore.dart';

class BpmService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final List<int> _bpmBuffer = [];
  DateTime? _lastSavedRaw;
  DateTime? _lastSavedAvg;

  Future<void> addBpmReading(String deviceId, int bpm) async {
    if (bpm <= 0) return;
    _bpmBuffer.add(bpm);

    print("BPM received: $bpm");

    final now = DateTime.now();

    // Save raw BPM every 5-10 seconds
    if (_lastSavedRaw == null ||
        now.difference(_lastSavedRaw!) > const Duration(seconds: 10)) {
      await _saveRawBpm(deviceId, bpm);
      _lastSavedRaw = now;
    }

    // Save daily average every minute
    if (_lastSavedAvg == null ||
        now.difference(_lastSavedAvg!) > const Duration(minutes: 1)) {
      await _saveDailyAverage(deviceId);
      _lastSavedAvg = now;
    }

    // Keep buffer reasonable (avoid memory growth)
    if (_bpmBuffer.length > 1000) {
      _bpmBuffer.removeRange(0, _bpmBuffer.length - 1000);
    }
  }

  Future<void> _saveRawBpm(String deviceId, int bpm) async {
    try {
      final docRef = await _db
          .collection('devices')
          .doc(deviceId)
          .collection('bpm')
          .add({'bpm': bpm, 'timestamp': FieldValue.serverTimestamp()});
      print("Raw BPM saved: ${docRef.id}");
    } catch (e) {
      print("Error saving raw BPM: $e");
    }
  }

  /// Save daily average (local time)
  Future<void> _saveDailyAverage(String deviceId) async {
    if (_bpmBuffer.isEmpty) return;

    final avg = (_bpmBuffer.reduce((a, b) => a + b) / _bpmBuffer.length)
        .round();
    final minBpm = _bpmBuffer.reduce((a, b) => a < b ? a : b);
    final maxBpm = _bpmBuffer.reduce((a, b) => a > b ? a : b);

    final now = DateTime.now();
    final dateId =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    try {
      await _db
          .collection('devices')
          .doc(deviceId)
          .collection('daily_avg')
          .doc(dateId)
          .set({
            'date': dateId,
            'avg_bpm': avg,
            'min_bpm': minBpm,
            'max_bpm': maxBpm,
            'timestamp':
                FieldValue.serverTimestamp(), // server timestamp for reference
          });
      print("Daily average saved for $dateId: avg $avg");
    } catch (e) {
      print("Error saving daily average: $e");
    }
  }
}
