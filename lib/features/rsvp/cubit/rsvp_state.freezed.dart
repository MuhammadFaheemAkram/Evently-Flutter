// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rsvp_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RsvpState {

 RsvpStatus get status; EventCardItem? get event; TicketType? get type; String get note;/// Field errors show after the first Confirm, not while typing.
 bool get showErrors;/// Why the last Confirm failed.
 String? get error;/// Set once, when the server confirmed: the one-time effect that opens
/// the new ticket.
 String? get ticketId;/// What "can I book it" is judged against.
 DateTime? get now;
/// Create a copy of RsvpState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RsvpStateCopyWith<RsvpState> get copyWith => _$RsvpStateCopyWithImpl<RsvpState>(this as RsvpState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RsvpState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RsvpState&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.event, _this.event) || other.event == _this.event)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.showErrors, _this.showErrors) || other.showErrors == _this.showErrors)&&(identical(other.error, _this.error) || other.error == _this.error)&&(identical(other.ticketId, _this.ticketId) || other.ticketId == _this.ticketId)&&(identical(other.now, _this.now) || other.now == _this.now));
}


@override
int get hashCode {
  final _this = this as RsvpState;
  return Object.hash(runtimeType,_this.status,_this.event,_this.type,_this.note,_this.showErrors,_this.error,_this.ticketId,_this.now);
}

@override
String toString() {
  final _this = this as RsvpState;
  return 'RsvpState(status: ${_this.status}, event: ${_this.event}, type: ${_this.type}, note: ${_this.note}, showErrors: ${_this.showErrors}, error: ${_this.error}, ticketId: ${_this.ticketId}, now: ${_this.now})';
}


}

/// @nodoc
abstract mixin class $RsvpStateCopyWith<$Res>  {
  factory $RsvpStateCopyWith(RsvpState value, $Res Function(RsvpState) _then) = _$RsvpStateCopyWithImpl;
@useResult
$Res call({
 RsvpStatus status, EventCardItem? event, TicketType? type, String note, bool showErrors, String? error, String? ticketId, DateTime? now
});


$EventCardItemCopyWith<$Res>? get event;

}
/// @nodoc
class _$RsvpStateCopyWithImpl<$Res>
    implements $RsvpStateCopyWith<$Res> {
  _$RsvpStateCopyWithImpl(this._self, this._then);

  final RsvpState _self;
  final $Res Function(RsvpState) _then;

/// Create a copy of RsvpState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? event = freezed,Object? type = freezed,Object? note = null,Object? showErrors = null,Object? error = freezed,Object? ticketId = freezed,Object? now = freezed,}) {
  return _then(RsvpState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RsvpStatus,event: freezed == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as EventCardItem?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TicketType?,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,showErrors: null == showErrors ? _self.showErrors : showErrors // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,ticketId: freezed == ticketId ? _self.ticketId : ticketId // ignore: cast_nullable_to_non_nullable
as String?,now: freezed == now ? _self.now : now // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of RsvpState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventCardItemCopyWith<$Res>? get event {
    if (_self.event == null) {
    return null;
  }

  return $EventCardItemCopyWith<$Res>(_self.event!, (value) {
    return _then(_self.copyWith(event: value));
  });
}
}


/// Adds pattern-matching-related methods to [RsvpState].
extension RsvpStatePatterns on RsvpState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RsvpState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RsvpState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RsvpState value)  $default,){
final _that = this;
switch (_that) {
case _RsvpState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RsvpState value)?  $default,){
final _that = this;
switch (_that) {
case _RsvpState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RsvpStatus status,  EventCardItem? event,  TicketType? type,  String note,  bool showErrors,  String? error,  String? ticketId,  DateTime? now)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RsvpState() when $default != null:
return $default(_that.status,_that.event,_that.type,_that.note,_that.showErrors,_that.error,_that.ticketId,_that.now);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RsvpStatus status,  EventCardItem? event,  TicketType? type,  String note,  bool showErrors,  String? error,  String? ticketId,  DateTime? now)  $default,) {final _that = this;
switch (_that) {
case _RsvpState():
return $default(_that.status,_that.event,_that.type,_that.note,_that.showErrors,_that.error,_that.ticketId,_that.now);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RsvpStatus status,  EventCardItem? event,  TicketType? type,  String note,  bool showErrors,  String? error,  String? ticketId,  DateTime? now)?  $default,) {final _that = this;
switch (_that) {
case _RsvpState() when $default != null:
return $default(_that.status,_that.event,_that.type,_that.note,_that.showErrors,_that.error,_that.ticketId,_that.now);case _:
  return null;

}
}

}

/// @nodoc


class _RsvpState extends RsvpState {
  const _RsvpState({this.status = RsvpStatus.loading, this.event, this.type, this.note = '', this.showErrors = false, this.error, this.ticketId, this.now}): super._();
  

@override@JsonKey() final  RsvpStatus status;
@override final  EventCardItem? event;
@override final  TicketType? type;
@override@JsonKey() final  String note;
/// Field errors show after the first Confirm, not while typing.
@override@JsonKey() final  bool showErrors;
/// Why the last Confirm failed.
@override final  String? error;
/// Set once, when the server confirmed: the one-time effect that opens
/// the new ticket.
@override final  String? ticketId;
/// What "can I book it" is judged against.
@override final  DateTime? now;

/// Create a copy of RsvpState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RsvpStateCopyWith<_RsvpState> get copyWith => __$RsvpStateCopyWithImpl<_RsvpState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RsvpState&&(identical(other.status, status) || other.status == status)&&(identical(other.event, event) || other.event == event)&&(identical(other.type, type) || other.type == type)&&(identical(other.note, note) || other.note == note)&&(identical(other.showErrors, showErrors) || other.showErrors == showErrors)&&(identical(other.error, error) || other.error == error)&&(identical(other.ticketId, ticketId) || other.ticketId == ticketId)&&(identical(other.now, now) || other.now == now));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,event,type,note,showErrors,error,ticketId,now);
}

@override
String toString() {
    return 'RsvpState(status: $status, event: $event, type: $type, note: $note, showErrors: $showErrors, error: $error, ticketId: $ticketId, now: $now)';
}


}

/// @nodoc
abstract mixin class _$RsvpStateCopyWith<$Res> implements $RsvpStateCopyWith<$Res> {
  factory _$RsvpStateCopyWith(_RsvpState value, $Res Function(_RsvpState) _then) = __$RsvpStateCopyWithImpl;
@override @useResult
$Res call({
 RsvpStatus status, EventCardItem? event, TicketType? type, String note, bool showErrors, String? error, String? ticketId, DateTime? now
});


@override $EventCardItemCopyWith<$Res>? get event;

}
/// @nodoc
class __$RsvpStateCopyWithImpl<$Res>
    implements _$RsvpStateCopyWith<$Res> {
  __$RsvpStateCopyWithImpl(this._self, this._then);

  final _RsvpState _self;
  final $Res Function(_RsvpState) _then;

/// Create a copy of RsvpState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? event = freezed,Object? type = freezed,Object? note = null,Object? showErrors = null,Object? error = freezed,Object? ticketId = freezed,Object? now = freezed,}) {
  return _then(_RsvpState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RsvpStatus,event: freezed == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as EventCardItem?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TicketType?,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,showErrors: null == showErrors ? _self.showErrors : showErrors // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,ticketId: freezed == ticketId ? _self.ticketId : ticketId // ignore: cast_nullable_to_non_nullable
as String?,now: freezed == now ? _self.now : now // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of RsvpState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventCardItemCopyWith<$Res>? get event {
    if (_self.event == null) {
    return null;
  }

  return $EventCardItemCopyWith<$Res>(_self.event!, (value) {
    return _then(_self.copyWith(event: value));
  });
}
}

// dart format on
