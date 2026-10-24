// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_time.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EventTime {

/// UTC.
 DateTime get start;/// UTC, after [start].
 DateTime get end;/// The venue's IANA zone (an online event's organizer's).
 String get zone;
/// Create a copy of EventTime
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventTimeCopyWith<EventTime> get copyWith => _$EventTimeCopyWithImpl<EventTime>(this as EventTime, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as EventTime;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventTime&&(identical(other.start, _this.start) || other.start == _this.start)&&(identical(other.end, _this.end) || other.end == _this.end)&&(identical(other.zone, _this.zone) || other.zone == _this.zone));
}


@override
int get hashCode {
  final _this = this as EventTime;
  return Object.hash(runtimeType,_this.start,_this.end,_this.zone);
}

@override
String toString() {
  final _this = this as EventTime;
  return 'EventTime(start: ${_this.start}, end: ${_this.end}, zone: ${_this.zone})';
}


}

/// @nodoc
abstract mixin class $EventTimeCopyWith<$Res>  {
  factory $EventTimeCopyWith(EventTime value, $Res Function(EventTime) _then) = _$EventTimeCopyWithImpl;
@useResult
$Res call({
 DateTime start, DateTime end, String zone
});




}
/// @nodoc
class _$EventTimeCopyWithImpl<$Res>
    implements $EventTimeCopyWith<$Res> {
  _$EventTimeCopyWithImpl(this._self, this._then);

  final EventTime _self;
  final $Res Function(EventTime) _then;

/// Create a copy of EventTime
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? start = null,Object? end = null,Object? zone = null,}) {
  return _then(EventTime(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,zone: null == zone ? _self.zone : zone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [EventTime].
extension EventTimePatterns on EventTime {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventTime value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventTime() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventTime value)  $default,){
final _that = this;
switch (_that) {
case _EventTime():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventTime value)?  $default,){
final _that = this;
switch (_that) {
case _EventTime() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime start,  DateTime end,  String zone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventTime() when $default != null:
return $default(_that.start,_that.end,_that.zone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime start,  DateTime end,  String zone)  $default,) {final _that = this;
switch (_that) {
case _EventTime():
return $default(_that.start,_that.end,_that.zone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime start,  DateTime end,  String zone)?  $default,) {final _that = this;
switch (_that) {
case _EventTime() when $default != null:
return $default(_that.start,_that.end,_that.zone);case _:
  return null;

}
}

}

/// @nodoc


class _EventTime extends EventTime {
  const _EventTime({required this.start, required this.end, required this.zone}): super._();
  

/// UTC.
@override final  DateTime start;
/// UTC, after [start].
@override final  DateTime end;
/// The venue's IANA zone (an online event's organizer's).
@override final  String zone;

/// Create a copy of EventTime
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventTimeCopyWith<_EventTime> get copyWith => __$EventTimeCopyWithImpl<_EventTime>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventTime&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.zone, zone) || other.zone == zone));
}


@override
int get hashCode {
    return Object.hash(runtimeType,start,end,zone);
}

@override
String toString() {
    return 'EventTime(start: $start, end: $end, zone: $zone)';
}


}

/// @nodoc
abstract mixin class _$EventTimeCopyWith<$Res> implements $EventTimeCopyWith<$Res> {
  factory _$EventTimeCopyWith(_EventTime value, $Res Function(_EventTime) _then) = __$EventTimeCopyWithImpl;
@override @useResult
$Res call({
 DateTime start, DateTime end, String zone
});




}
/// @nodoc
class __$EventTimeCopyWithImpl<$Res>
    implements _$EventTimeCopyWith<$Res> {
  __$EventTimeCopyWithImpl(this._self, this._then);

  final _EventTime _self;
  final $Res Function(_EventTime) _then;

/// Create a copy of EventTime
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? start = null,Object? end = null,Object? zone = null,}) {
  return _then(_EventTime(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,zone: null == zone ? _self.zone : zone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
