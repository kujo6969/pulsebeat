import 'package:flutter_riverpod/legacy.dart';

final isConnected = StateProvider<bool>((ref) => false);

final isBluetoothOn = StateProvider<bool>((ref) => false);
