// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'organizer_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OrganizerState {

 OrganizerStatus get status; Organizer? get organizer; bool get isFollowing;/// Their events still to come, soonest first.
 List<EventCardItem> get upcoming;/// Their events that are over, most recent first.
 List<EventCardItem> get past; DateTime? get now;/// A one-time SnackBar; [messageSerial] makes each one distinct.
 String? get message; int get messageSerial;
/// Create a copy of OrganizerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrganizerStateCopyWith<OrganizerState> get copyWith => _$OrganizerStateCopyWithImpl<OrganizerState>(this as OrganizerState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OrganizerState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrganizerState&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.organizer, _this.organizer) || other.organizer == _this.organizer)&&(identical(other.isFollowing, _this.isFollowing) || other.isFollowing == _this.isFollowing)&&const DeepCollectionEquality().equals(other.upcoming, _this.upcoming)&&const DeepCollectionEquality().equals(other.past, _this.past)&&(identical(other.now, _this.now) || other.now == _this.now)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.messageSerial, _this.messageSerial) || other.messageSerial == _this.messageSerial));
}


@override
int get hashCode {
  final _this = this as OrganizerState;
  return Object.hash(runtimeType,_this.status,_this.organizer,_this.isFollowing,const DeepCollectionEquality().hash(_this.upcoming),const DeepCollectionEquality().hash(_this.past),_this.now,_this.message,_this.messageSerial);
}

@override
String toString() {
  final _this = this as OrganizerState;
  return 'OrganizerState(status: ${_this.status}, organizer: ${_this.organizer}, isFollowing: ${_this.isFollowing}, upcoming: ${_this.upcoming}, past: ${_this.past}, now: ${_this.now}, message: ${_this.message}, messageSerial: ${_this.messageSerial})';
}


}

/// @nodoc
abstract mixin class $OrganizerStateCopyWith<$Res>  {
  factory $OrganizerStateCopyWith(OrganizerState value, $Res Function(OrganizerState) _then) = _$OrganizerStateCopyWithImpl;
@useResult
$Res call({
 OrganizerStatus status, Organizer? organizer, bool isFollowing, List<EventCardItem> upcoming, List<EventCardItem> past, DateTime? now, String? message, int messageSerial
});


$OrganizerCopyWith<$Res>? get organizer;

}
/// @nodoc
class _$OrganizerStateCopyWithImpl<$Res>
    implements $OrganizerStateCopyWith<$Res> {
  _$OrganizerStateCopyWithImpl(this._self, this._then);

  final OrganizerState _self;
  final $Res Function(OrganizerState) _then;

/// Create a copy of OrganizerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? organizer = freezed,Object? isFollowing = null,Object? upcoming = null,Object? past = null,Object? now = freezed,Object? message = freezed,Object? messageSerial = null,}) {
  return _then(OrganizerState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrganizerStatus,organizer: freezed == organizer ? _self.organizer : organizer // ignore: cast_nullable_to_non_nullable
as Organizer?,isFollowing: null == isFollowing ? _self.isFollowing : isFollowing // ignore: cast_nullable_to_non_nullable
as bool,upcoming: null == upcoming ? _self.upcoming : upcoming // ignore: cast_nullable_to_non_nullable
as List<EventCardItem>,past: null == past ? _self.past : past // ignore: cast_nullable_to_non_nullable
as List<EventCardItem>,now: freezed == now ? _self.now : now // ignore: cast_nullable_to_non_nullable
as DateTime?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,messageSerial: null == messageSerial ? _self.messageSerial : messageSerial // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of OrganizerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrganizerCopyWith<$Res>? get organizer {
    if (_self.organizer == null) {
    return null;
  }

  return $OrganizerCopyWith<$Res>(_self.organizer!, (value) {
    return _then(_self.copyWith(organizer: value));
  });
}
}


/// Adds pattern-matching-related methods to [OrganizerState].
extension OrganizerStatePatterns on OrganizerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrganizerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrganizerState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrganizerState value)  $default,){
final _that = this;
switch (_that) {
case _OrganizerState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrganizerState value)?  $default,){
final _that = this;
switch (_that) {
case _OrganizerState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( OrganizerStatus status,  Organizer? organizer,  bool isFollowing,  List<EventCardItem> upcoming,  List<EventCardItem> past,  DateTime? now,  String? message,  int messageSerial)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrganizerState() when $default != null:
return $default(_that.status,_that.organizer,_that.isFollowing,_that.upcoming,_that.past,_that.now,_that.message,_that.messageSerial);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( OrganizerStatus status,  Organizer? organizer,  bool isFollowing,  List<EventCardItem> upcoming,  List<EventCardItem> past,  DateTime? now,  String? message,  int messageSerial)  $default,) {final _that = this;
switch (_that) {
case _OrganizerState():
return $default(_that.status,_that.organizer,_that.isFollowing,_that.upcoming,_that.past,_that.now,_that.message,_that.messageSerial);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( OrganizerStatus status,  Organizer? organizer,  bool isFollowing,  List<EventCardItem> upcoming,  List<EventCardItem> past,  DateTime? now,  String? message,  int messageSerial)?  $default,) {final _that = this;
switch (_that) {
case _OrganizerState() when $default != null:
return $default(_that.status,_that.organizer,_that.isFollowing,_that.upcoming,_that.past,_that.now,_that.message,_that.messageSerial);case _:
  return null;

}
}

}

/// @nodoc


class _OrganizerState extends OrganizerState {
  const _OrganizerState({this.status = OrganizerStatus.loading, this.organizer, this.isFollowing = false,  List<EventCardItem> upcoming = const <EventCardItem>[],  List<EventCardItem> past = const <EventCardItem>[], this.now, this.message, this.messageSerial = 0}): _upcoming = upcoming,_past = past,super._();
  

@override@JsonKey() final  OrganizerStatus status;
@override final  Organizer? organizer;
@override@JsonKey() final  bool isFollowing;
/// Their events still to come, soonest first.
 final  List<EventCardItem> _upcoming;
/// Their events still to come, soonest first.
@override@JsonKey() List<EventCardItem> get upcoming {
  if (_upcoming is EqualUnmodifiableListView) return _upcoming;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_upcoming);
}

/// Their events that are over, most recent first.
 final  List<EventCardItem> _past;
/// Their events that are over, most recent first.
@override@JsonKey() List<EventCardItem> get past {
  if (_past is EqualUnmodifiableListView) return _past;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_past);
}

@override final  DateTime? now;
/// A one-time SnackBar; [messageSerial] makes each one distinct.
@override final  String? message;
@override@JsonKey() final  int messageSerial;

/// Create a copy of OrganizerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrganizerStateCopyWith<_OrganizerState> get copyWith => __$OrganizerStateCopyWithImpl<_OrganizerState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrganizerState&&(identical(other.status, status) || other.status == status)&&(identical(other.organizer, organizer) || other.organizer == organizer)&&(identical(other.isFollowing, isFollowing) || other.isFollowing == isFollowing)&&const DeepCollectionEquality().equals(other.upcoming, _upcoming)&&const DeepCollectionEquality().equals(other.past, _past)&&(identical(other.now, now) || other.now == now)&&(identical(other.message, message) || other.message == message)&&(identical(other.messageSerial, messageSerial) || other.messageSerial == messageSerial));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,organizer,isFollowing,const DeepCollectionEquality().hash(_upcoming),const DeepCollectionEquality().hash(_past),now,message,messageSerial);
}

@override
String toString() {
    return 'OrganizerState(status: $status, organizer: $organizer, isFollowing: $isFollowing, upcoming: $upcoming, past: $past, now: $now, message: $message, messageSerial: $messageSerial)';
}


}

/// @nodoc
abstract mixin class _$OrganizerStateCopyWith<$Res> implements $OrganizerStateCopyWith<$Res> {
  factory _$OrganizerStateCopyWith(_OrganizerState value, $Res Function(_OrganizerState) _then) = __$OrganizerStateCopyWithImpl;
@override @useResult
$Res call({
 OrganizerStatus status, Organizer? organizer, bool isFollowing, List<EventCardItem> upcoming, List<EventCardItem> past, DateTime? now, String? message, int messageSerial
});


@override $OrganizerCopyWith<$Res>? get organizer;

}
/// @nodoc
class __$OrganizerStateCopyWithImpl<$Res>
    implements _$OrganizerStateCopyWith<$Res> {
  __$OrganizerStateCopyWithImpl(this._self, this._then);

  final _OrganizerState _self;
  final $Res Function(_OrganizerState) _then;

/// Create a copy of OrganizerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? organizer = freezed,Object? isFollowing = null,Object? upcoming = null,Object? past = null,Object? now = freezed,Object? message = freezed,Object? messageSerial = null,}) {
  return _then(_OrganizerState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OrganizerStatus,organizer: freezed == organizer ? _self.organizer : organizer // ignore: cast_nullable_to_non_nullable
as Organizer?,isFollowing: null == isFollowing ? _self.isFollowing : isFollowing // ignore: cast_nullable_to_non_nullable
as bool,upcoming: null == upcoming ? _self._upcoming : upcoming // ignore: cast_nullable_to_non_nullable
as List<EventCardItem>,past: null == past ? _self._past : past // ignore: cast_nullable_to_non_nullable
as List<EventCardItem>,now: freezed == now ? _self.now : now // ignore: cast_nullable_to_non_nullable
as DateTime?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,messageSerial: null == messageSerial ? _self.messageSerial : messageSerial // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of OrganizerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrganizerCopyWith<$Res>? get organizer {
    if (_self.organizer == null) {
    return null;
  }

  return $OrganizerCopyWith<$Res>(_self.organizer!, (value) {
    return _then(_self.copyWith(organizer: value));
  });
}
}

// dart format on
