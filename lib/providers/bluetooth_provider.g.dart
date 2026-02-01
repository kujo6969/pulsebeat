// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bluetooth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BluetoothNotifier)
final bluetoothProvider = BluetoothNotifierProvider._();

final class BluetoothNotifierProvider
    extends $NotifierProvider<BluetoothNotifier, BleState> {
  BluetoothNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bluetoothProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bluetoothNotifierHash();

  @$internal
  @override
  BluetoothNotifier create() => BluetoothNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BleState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BleState>(value),
    );
  }
}

String _$bluetoothNotifierHash() => r'97b9c9d39ce5b397fe59218661dd7f84e4c19452';

abstract class _$BluetoothNotifier extends $Notifier<BleState> {
  BleState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<BleState, BleState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<BleState, BleState>,
              BleState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
