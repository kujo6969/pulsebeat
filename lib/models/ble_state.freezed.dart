// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ble_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BleState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BleState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BleState()';
}


}

/// @nodoc
class $BleStateCopyWith<$Res>  {
$BleStateCopyWith(BleState _, $Res Function(BleState) __);
}


/// Adds pattern-matching-related methods to [BleState].
extension BleStatePatterns on BleState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Disconnected value)?  disconnected,TResult Function( _Scanning value)?  scanning,TResult Function( _Connecting value)?  connecting,TResult Function( _Connected value)?  connected,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Disconnected() when disconnected != null:
return disconnected(_that);case _Scanning() when scanning != null:
return scanning(_that);case _Connecting() when connecting != null:
return connecting(_that);case _Connected() when connected != null:
return connected(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Disconnected value)  disconnected,required TResult Function( _Scanning value)  scanning,required TResult Function( _Connecting value)  connecting,required TResult Function( _Connected value)  connected,}){
final _that = this;
switch (_that) {
case _Disconnected():
return disconnected(_that);case _Scanning():
return scanning(_that);case _Connecting():
return connecting(_that);case _Connected():
return connected(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Disconnected value)?  disconnected,TResult? Function( _Scanning value)?  scanning,TResult? Function( _Connecting value)?  connecting,TResult? Function( _Connected value)?  connected,}){
final _that = this;
switch (_that) {
case _Disconnected() when disconnected != null:
return disconnected(_that);case _Scanning() when scanning != null:
return scanning(_that);case _Connecting() when connecting != null:
return connecting(_that);case _Connected() when connected != null:
return connected(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  disconnected,TResult Function()?  scanning,TResult Function()?  connecting,TResult Function( String deviceId,  String deviceName,  String data)?  connected,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Disconnected() when disconnected != null:
return disconnected();case _Scanning() when scanning != null:
return scanning();case _Connecting() when connecting != null:
return connecting();case _Connected() when connected != null:
return connected(_that.deviceId,_that.deviceName,_that.data);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  disconnected,required TResult Function()  scanning,required TResult Function()  connecting,required TResult Function( String deviceId,  String deviceName,  String data)  connected,}) {final _that = this;
switch (_that) {
case _Disconnected():
return disconnected();case _Scanning():
return scanning();case _Connecting():
return connecting();case _Connected():
return connected(_that.deviceId,_that.deviceName,_that.data);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  disconnected,TResult? Function()?  scanning,TResult? Function()?  connecting,TResult? Function( String deviceId,  String deviceName,  String data)?  connected,}) {final _that = this;
switch (_that) {
case _Disconnected() when disconnected != null:
return disconnected();case _Scanning() when scanning != null:
return scanning();case _Connecting() when connecting != null:
return connecting();case _Connected() when connected != null:
return connected(_that.deviceId,_that.deviceName,_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _Disconnected implements BleState {
  const _Disconnected();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Disconnected);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BleState.disconnected()';
}


}




/// @nodoc


class _Scanning implements BleState {
  const _Scanning();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Scanning);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BleState.scanning()';
}


}




/// @nodoc


class _Connecting implements BleState {
  const _Connecting();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Connecting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BleState.connecting()';
}


}




/// @nodoc


class _Connected implements BleState {
  const _Connected({required this.deviceId, required this.deviceName, required this.data});
  

 final  String deviceId;
 final  String deviceName;
 final  String data;

/// Create a copy of BleState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConnectedCopyWith<_Connected> get copyWith => __$ConnectedCopyWithImpl<_Connected>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Connected&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.deviceName, deviceName) || other.deviceName == deviceName)&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,deviceId,deviceName,data);

@override
String toString() {
  return 'BleState.connected(deviceId: $deviceId, deviceName: $deviceName, data: $data)';
}


}

/// @nodoc
abstract mixin class _$ConnectedCopyWith<$Res> implements $BleStateCopyWith<$Res> {
  factory _$ConnectedCopyWith(_Connected value, $Res Function(_Connected) _then) = __$ConnectedCopyWithImpl;
@useResult
$Res call({
 String deviceId, String deviceName, String data
});




}
/// @nodoc
class __$ConnectedCopyWithImpl<$Res>
    implements _$ConnectedCopyWith<$Res> {
  __$ConnectedCopyWithImpl(this._self, this._then);

  final _Connected _self;
  final $Res Function(_Connected) _then;

/// Create a copy of BleState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? deviceId = null,Object? deviceName = null,Object? data = null,}) {
  return _then(_Connected(
deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,deviceName: null == deviceName ? _self.deviceName : deviceName // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
