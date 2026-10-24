// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'saved_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SavedState {

 SavedStatus get status;/// Saved events still to come, soonest first.
 List<EventCardItem> get upcoming;/// Saved events that are over, most recent first.
 List<EventCardItem> get past; DateTime? get now;/// The event just removed, for the SnackBar's Undo; [removedSerial]
/// makes each removal distinct.
 EventCardItem? get removed; int get removedSerial;/// A one-time SnackBar (a failed write); [messageSerial] makes each one
/// distinct.
 String? get message; int get messageSerial;
/// Create a copy of SavedState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavedStateCopyWith<SavedState> get copyWith => _$SavedStateCopyWithImpl<SavedState>(this as SavedState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SavedState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavedState&&(identical(other.status, _this.status) || other.status == _this.status)&&const DeepCollectionEquality().equals(other.upcoming, _this.upcoming)&&const DeepCollectionEquality().equals(other.past, _this.past)&&(identical(other.now, _this.now) || other.now == _this.now)&&(identical(other.removed, _this.removed) || other.removed == _this.removed)&&(identical(other.removedSerial, _this.removedSerial) || other.removedSerial == _this.removedSerial)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.messageSerial, _this.messageSerial) || other.messageSerial == _this.messageSerial));
}


@override
int get hashCode {
  final _this = this as SavedState;
  return Object.hash(runtimeType,_this.status,const DeepCollectionEquality().hash(_this.upcoming),const DeepCollectionEquality().hash(_this.past),_this.now,_this.removed,_this.removedSerial,_this.message,_this.messageSerial);
}

@override
String toString() {
  final _this = this as SavedState;
  return 'SavedState(status: ${_this.status}, upcoming: ${_this.upcoming}, past: ${_this.past}, now: ${_this.now}, removed: ${_this.removed}, removedSerial: ${_this.removedSerial}, message: ${_this.message}, messageSerial: ${_this.messageSerial})';
}


}

/// @nodoc
abstract mixin class $SavedStateCopyWith<$Res>  {
  factory $SavedStateCopyWith(SavedState value, $Res Function(SavedState) _then) = _$SavedStateCopyWithImpl;
@useResult
$Res call({
 SavedStatus status, List<EventCardItem> upcoming, List<EventCardItem> past, DateTime? now, EventCardItem? removed, int removedSerial, String? message, int messageSerial
});


$EventCardItemCopyWith<$Res>? get removed;

}
/// @nodoc
class _$SavedStateCopyWithImpl<$Res>
    implements $SavedStateCopyWith<$Res> {
  _$SavedStateCopyWithImpl(this._self, this._then);

  final SavedState _self;
  final $Res Function(SavedState) _then;

/// Create a copy of SavedState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? upcoming = null,Object? past = null,Object? now = freezed,Object? removed = freezed,Object? removedSerial = null,Object? message = freezed,Object? messageSerial = null,}) {
  return _then(SavedState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SavedStatus,upcoming: null == upcoming ? _self.upcoming : upcoming // ignore: cast_nullable_to_non_nullable
as List<EventCardItem>,past: null == past ? _self.past : past // ignore: cast_nullable_to_non_nullable
as List<EventCardItem>,now: freezed == now ? _self.now : now // ignore: cast_nullable_to_non_nullable
as DateTime?,removed: freezed == removed ? _self.removed : removed // ignore: cast_nullable_to_non_nullable
as EventCardItem?,removedSerial: null == removedSerial ? _self.removedSerial : removedSerial // ignore: cast_nullable_to_non_nullable
as int,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,messageSerial: null == messageSerial ? _self.messageSerial : messageSerial // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of SavedState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventCardItemCopyWith<$Res>? get removed {
    if (_self.removed == null) {
    return null;
  }

  return $EventCardItemCopyWith<$Res>(_self.removed!, (value) {
    return _then(_self.copyWith(removed: value));
  });
}
}


/// Adds pattern-matching-related methods to [SavedState].
extension SavedStatePatterns on SavedState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SavedState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SavedState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SavedState value)  $default,){
final _that = this;
switch (_that) {
case _SavedState():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SavedState value)?  $default,){
final _that = this;
switch (_that) {
case _SavedState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SavedStatus status,  List<EventCardItem> upcoming,  List<EventCardItem> past,  DateTime? now,  EventCardItem? removed,  int removedSerial,  String? message,  int messageSerial)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SavedState() when $default != null:
return $default(_that.status,_that.upcoming,_that.past,_that.now,_that.removed,_that.removedSerial,_that.message,_that.messageSerial);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SavedStatus status,  List<EventCardItem> upcoming,  List<EventCardItem> past,  DateTime? now,  EventCardItem? removed,  int removedSerial,  String? message,  int messageSerial)  $default,) {final _that = this;
switch (_that) {
case _SavedState():
return $default(_that.status,_that.upcoming,_that.past,_that.now,_that.removed,_that.removedSerial,_that.message,_that.messageSerial);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SavedStatus status,  List<EventCardItem> upcoming,  List<EventCardItem> past,  DateTime? now,  EventCardItem? removed,  int removedSerial,  String? message,  int messageSerial)?  $default,) {final _that = this;
switch (_that) {
case _SavedState() when $default != null:
return $default(_that.status,_that.upcoming,_that.past,_that.now,_that.removed,_that.removedSerial,_that.message,_that.messageSerial);case _:
  return null;

}
}

}

/// @nodoc


class _SavedState extends SavedState {
  const _SavedState({this.status = SavedStatus.loading,  List<EventCardItem> upcoming = const <EventCardItem>[],  List<EventCardItem> past = const <EventCardItem>[], this.now, this.removed, this.removedSerial = 0, this.message, this.messageSerial = 0}): _upcoming = upcoming,_past = past,super._();
  

@override@JsonKey() final  SavedStatus status;
/// Saved events still to come, soonest first.
 final  List<EventCardItem> _upcoming;
/// Saved events still to come, soonest first.
@override@JsonKey() List<EventCardItem> get upcoming {
  if (_upcoming is EqualUnmodifiableListView) return _upcoming;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_upcoming);
}

/// Saved events that are over, most recent first.
 final  List<EventCardItem> _past;
/// Saved events that are over, most recent first.
@override@JsonKey() List<EventCardItem> get past {
  if (_past is EqualUnmodifiableListView) return _past;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_past);
}

@override final  DateTime? now;
/// The event just removed, for the SnackBar's Undo; [removedSerial]
/// makes each removal distinct.
@override final  EventCardItem? removed;
@override@JsonKey() final  int removedSerial;
/// A one-time SnackBar (a failed write); [messageSerial] makes each one
/// distinct.
@override final  String? message;
@override@JsonKey() final  int messageSerial;

/// Create a copy of SavedState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SavedStateCopyWith<_SavedState> get copyWith => __$SavedStateCopyWithImpl<_SavedState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SavedState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.upcoming, _upcoming)&&const DeepCollectionEquality().equals(other.past, _past)&&(identical(other.now, now) || other.now == now)&&(identical(other.removed, removed) || other.removed == removed)&&(identical(other.removedSerial, removedSerial) || other.removedSerial == removedSerial)&&(identical(other.message, message) || other.message == message)&&(identical(other.messageSerial, messageSerial) || other.messageSerial == messageSerial));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_upcoming),const DeepCollectionEquality().hash(_past),now,removed,removedSerial,message,messageSerial);
}

@override
String toString() {
    return 'SavedState(status: $status, upcoming: $upcoming, past: $past, now: $now, removed: $removed, removedSerial: $removedSerial, message: $message, messageSerial: $messageSerial)';
}


}

/// @nodoc
abstract mixin class _$SavedStateCopyWith<$Res> implements $SavedStateCopyWith<$Res> {
  factory _$SavedStateCopyWith(_SavedState value, $Res Function(_SavedState) _then) = __$SavedStateCopyWithImpl;
@override @useResult
$Res call({
 SavedStatus status, List<EventCardItem> upcoming, List<EventCardItem> past, DateTime? now, EventCardItem? removed, int removedSerial, String? message, int messageSerial
});


@override $EventCardItemCopyWith<$Res>? get removed;

}
/// @nodoc
class __$SavedStateCopyWithImpl<$Res>
    implements _$SavedStateCopyWith<$Res> {
  __$SavedStateCopyWithImpl(this._self, this._then);

  final _SavedState _self;
  final $Res Function(_SavedState) _then;

/// Create a copy of SavedState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? upcoming = null,Object? past = null,Object? now = freezed,Object? removed = freezed,Object? removedSerial = null,Object? message = freezed,Object? messageSerial = null,}) {
  return _then(_SavedState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SavedStatus,upcoming: null == upcoming ? _self._upcoming : upcoming // ignore: cast_nullable_to_non_nullable
as List<EventCardItem>,past: null == past ? _self._past : past // ignore: cast_nullable_to_non_nullable
as List<EventCardItem>,now: freezed == now ? _self.now : now // ignore: cast_nullable_to_non_nullable
as DateTime?,removed: freezed == removed ? _self.removed : removed // ignore: cast_nullable_to_non_nullable
as EventCardItem?,removedSerial: null == removedSerial ? _self.removedSerial : removedSerial // ignore: cast_nullable_to_non_nullable
as int,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,messageSerial: null == messageSerial ? _self.messageSerial : messageSerial // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of SavedState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventCardItemCopyWith<$Res>? get removed {
    if (_self.removed == null) {
    return null;
  }

  return $EventCardItemCopyWith<$Res>(_self.removed!, (value) {
    return _then(_self.copyWith(removed: value));
  });
}
}

// dart format on
