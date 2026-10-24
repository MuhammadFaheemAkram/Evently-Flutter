// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'agenda_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AgendaState {

 AgendaStatus get status; Agenda? get agenda;/// The day shown; `null` is the first.
 CalendarDate? get selectedDay;/// Only bookmarked sessions ("My sessions").
 bool get myOnly;/// A one-time SnackBar (a failed bookmark); [messageSerial] makes each
/// one distinct.
 String? get message; int get messageSerial;
/// Create a copy of AgendaState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AgendaStateCopyWith<AgendaState> get copyWith => _$AgendaStateCopyWithImpl<AgendaState>(this as AgendaState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AgendaState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AgendaState&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.agenda, _this.agenda) || other.agenda == _this.agenda)&&(identical(other.selectedDay, _this.selectedDay) || other.selectedDay == _this.selectedDay)&&(identical(other.myOnly, _this.myOnly) || other.myOnly == _this.myOnly)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.messageSerial, _this.messageSerial) || other.messageSerial == _this.messageSerial));
}


@override
int get hashCode {
  final _this = this as AgendaState;
  return Object.hash(runtimeType,_this.status,_this.agenda,_this.selectedDay,_this.myOnly,_this.message,_this.messageSerial);
}

@override
String toString() {
  final _this = this as AgendaState;
  return 'AgendaState(status: ${_this.status}, agenda: ${_this.agenda}, selectedDay: ${_this.selectedDay}, myOnly: ${_this.myOnly}, message: ${_this.message}, messageSerial: ${_this.messageSerial})';
}


}

/// @nodoc
abstract mixin class $AgendaStateCopyWith<$Res>  {
  factory $AgendaStateCopyWith(AgendaState value, $Res Function(AgendaState) _then) = _$AgendaStateCopyWithImpl;
@useResult
$Res call({
 AgendaStatus status, Agenda? agenda, CalendarDate? selectedDay, bool myOnly, String? message, int messageSerial
});


$AgendaCopyWith<$Res>? get agenda;

}
/// @nodoc
class _$AgendaStateCopyWithImpl<$Res>
    implements $AgendaStateCopyWith<$Res> {
  _$AgendaStateCopyWithImpl(this._self, this._then);

  final AgendaState _self;
  final $Res Function(AgendaState) _then;

/// Create a copy of AgendaState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? agenda = freezed,Object? selectedDay = freezed,Object? myOnly = null,Object? message = freezed,Object? messageSerial = null,}) {
  return _then(AgendaState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AgendaStatus,agenda: freezed == agenda ? _self.agenda : agenda // ignore: cast_nullable_to_non_nullable
as Agenda?,selectedDay: freezed == selectedDay ? _self.selectedDay : selectedDay // ignore: cast_nullable_to_non_nullable
as CalendarDate?,myOnly: null == myOnly ? _self.myOnly : myOnly // ignore: cast_nullable_to_non_nullable
as bool,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,messageSerial: null == messageSerial ? _self.messageSerial : messageSerial // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of AgendaState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AgendaCopyWith<$Res>? get agenda {
    if (_self.agenda == null) {
    return null;
  }

  return $AgendaCopyWith<$Res>(_self.agenda!, (value) {
    return _then(_self.copyWith(agenda: value));
  });
}
}


/// Adds pattern-matching-related methods to [AgendaState].
extension AgendaStatePatterns on AgendaState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AgendaState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AgendaState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AgendaState value)  $default,){
final _that = this;
switch (_that) {
case _AgendaState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AgendaState value)?  $default,){
final _that = this;
switch (_that) {
case _AgendaState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AgendaStatus status,  Agenda? agenda,  CalendarDate? selectedDay,  bool myOnly,  String? message,  int messageSerial)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AgendaState() when $default != null:
return $default(_that.status,_that.agenda,_that.selectedDay,_that.myOnly,_that.message,_that.messageSerial);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AgendaStatus status,  Agenda? agenda,  CalendarDate? selectedDay,  bool myOnly,  String? message,  int messageSerial)  $default,) {final _that = this;
switch (_that) {
case _AgendaState():
return $default(_that.status,_that.agenda,_that.selectedDay,_that.myOnly,_that.message,_that.messageSerial);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AgendaStatus status,  Agenda? agenda,  CalendarDate? selectedDay,  bool myOnly,  String? message,  int messageSerial)?  $default,) {final _that = this;
switch (_that) {
case _AgendaState() when $default != null:
return $default(_that.status,_that.agenda,_that.selectedDay,_that.myOnly,_that.message,_that.messageSerial);case _:
  return null;

}
}

}

/// @nodoc


class _AgendaState extends AgendaState {
  const _AgendaState({this.status = AgendaStatus.loading, this.agenda, this.selectedDay, this.myOnly = false, this.message, this.messageSerial = 0}): super._();
  

@override@JsonKey() final  AgendaStatus status;
@override final  Agenda? agenda;
/// The day shown; `null` is the first.
@override final  CalendarDate? selectedDay;
/// Only bookmarked sessions ("My sessions").
@override@JsonKey() final  bool myOnly;
/// A one-time SnackBar (a failed bookmark); [messageSerial] makes each
/// one distinct.
@override final  String? message;
@override@JsonKey() final  int messageSerial;

/// Create a copy of AgendaState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AgendaStateCopyWith<_AgendaState> get copyWith => __$AgendaStateCopyWithImpl<_AgendaState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AgendaState&&(identical(other.status, status) || other.status == status)&&(identical(other.agenda, agenda) || other.agenda == agenda)&&(identical(other.selectedDay, selectedDay) || other.selectedDay == selectedDay)&&(identical(other.myOnly, myOnly) || other.myOnly == myOnly)&&(identical(other.message, message) || other.message == message)&&(identical(other.messageSerial, messageSerial) || other.messageSerial == messageSerial));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,agenda,selectedDay,myOnly,message,messageSerial);
}

@override
String toString() {
    return 'AgendaState(status: $status, agenda: $agenda, selectedDay: $selectedDay, myOnly: $myOnly, message: $message, messageSerial: $messageSerial)';
}


}

/// @nodoc
abstract mixin class _$AgendaStateCopyWith<$Res> implements $AgendaStateCopyWith<$Res> {
  factory _$AgendaStateCopyWith(_AgendaState value, $Res Function(_AgendaState) _then) = __$AgendaStateCopyWithImpl;
@override @useResult
$Res call({
 AgendaStatus status, Agenda? agenda, CalendarDate? selectedDay, bool myOnly, String? message, int messageSerial
});


@override $AgendaCopyWith<$Res>? get agenda;

}
/// @nodoc
class __$AgendaStateCopyWithImpl<$Res>
    implements _$AgendaStateCopyWith<$Res> {
  __$AgendaStateCopyWithImpl(this._self, this._then);

  final _AgendaState _self;
  final $Res Function(_AgendaState) _then;

/// Create a copy of AgendaState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? agenda = freezed,Object? selectedDay = freezed,Object? myOnly = null,Object? message = freezed,Object? messageSerial = null,}) {
  return _then(_AgendaState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AgendaStatus,agenda: freezed == agenda ? _self.agenda : agenda // ignore: cast_nullable_to_non_nullable
as Agenda?,selectedDay: freezed == selectedDay ? _self.selectedDay : selectedDay // ignore: cast_nullable_to_non_nullable
as CalendarDate?,myOnly: null == myOnly ? _self.myOnly : myOnly // ignore: cast_nullable_to_non_nullable
as bool,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,messageSerial: null == messageSerial ? _self.messageSerial : messageSerial // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of AgendaState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AgendaCopyWith<$Res>? get agenda {
    if (_self.agenda == null) {
    return null;
  }

  return $AgendaCopyWith<$Res>(_self.agenda!, (value) {
    return _then(_self.copyWith(agenda: value));
  });
}
}

// dart format on
