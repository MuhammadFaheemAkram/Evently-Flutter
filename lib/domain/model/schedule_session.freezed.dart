// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScheduleSession {

 String get id; String get eventId; String get title; String get speaker; String get room; DateTime get start; DateTime get end;
/// Create a copy of ScheduleSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleSessionCopyWith<ScheduleSession> get copyWith => _$ScheduleSessionCopyWithImpl<ScheduleSession>(this as ScheduleSession, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ScheduleSession;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleSession&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.eventId, _this.eventId) || other.eventId == _this.eventId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.speaker, _this.speaker) || other.speaker == _this.speaker)&&(identical(other.room, _this.room) || other.room == _this.room)&&(identical(other.start, _this.start) || other.start == _this.start)&&(identical(other.end, _this.end) || other.end == _this.end));
}


@override
int get hashCode {
  final _this = this as ScheduleSession;
  return Object.hash(runtimeType,_this.id,_this.eventId,_this.title,_this.speaker,_this.room,_this.start,_this.end);
}

@override
String toString() {
  final _this = this as ScheduleSession;
  return 'ScheduleSession(id: ${_this.id}, eventId: ${_this.eventId}, title: ${_this.title}, speaker: ${_this.speaker}, room: ${_this.room}, start: ${_this.start}, end: ${_this.end})';
}


}

/// @nodoc
abstract mixin class $ScheduleSessionCopyWith<$Res>  {
  factory $ScheduleSessionCopyWith(ScheduleSession value, $Res Function(ScheduleSession) _then) = _$ScheduleSessionCopyWithImpl;
@useResult
$Res call({
 String id, String eventId, String title, String speaker, String room, DateTime start, DateTime end
});




}
/// @nodoc
class _$ScheduleSessionCopyWithImpl<$Res>
    implements $ScheduleSessionCopyWith<$Res> {
  _$ScheduleSessionCopyWithImpl(this._self, this._then);

  final ScheduleSession _self;
  final $Res Function(ScheduleSession) _then;

/// Create a copy of ScheduleSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? eventId = null,Object? title = null,Object? speaker = null,Object? room = null,Object? start = null,Object? end = null,}) {
  return _then(ScheduleSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,speaker: null == speaker ? _self.speaker : speaker // ignore: cast_nullable_to_non_nullable
as String,room: null == room ? _self.room : room // ignore: cast_nullable_to_non_nullable
as String,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduleSession].
extension ScheduleSessionPatterns on ScheduleSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleSession value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleSession value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String eventId,  String title,  String speaker,  String room,  DateTime start,  DateTime end)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleSession() when $default != null:
return $default(_that.id,_that.eventId,_that.title,_that.speaker,_that.room,_that.start,_that.end);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String eventId,  String title,  String speaker,  String room,  DateTime start,  DateTime end)  $default,) {final _that = this;
switch (_that) {
case _ScheduleSession():
return $default(_that.id,_that.eventId,_that.title,_that.speaker,_that.room,_that.start,_that.end);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String eventId,  String title,  String speaker,  String room,  DateTime start,  DateTime end)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleSession() when $default != null:
return $default(_that.id,_that.eventId,_that.title,_that.speaker,_that.room,_that.start,_that.end);case _:
  return null;

}
}

}

/// @nodoc


class _ScheduleSession implements ScheduleSession {
  const _ScheduleSession({required this.id, required this.eventId, required this.title, required this.speaker, required this.room, required this.start, required this.end});
  

@override final  String id;
@override final  String eventId;
@override final  String title;
@override final  String speaker;
@override final  String room;
@override final  DateTime start;
@override final  DateTime end;

/// Create a copy of ScheduleSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleSessionCopyWith<_ScheduleSession> get copyWith => __$ScheduleSessionCopyWithImpl<_ScheduleSession>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleSession&&(identical(other.id, id) || other.id == id)&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.title, title) || other.title == title)&&(identical(other.speaker, speaker) || other.speaker == speaker)&&(identical(other.room, room) || other.room == room)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,eventId,title,speaker,room,start,end);
}

@override
String toString() {
    return 'ScheduleSession(id: $id, eventId: $eventId, title: $title, speaker: $speaker, room: $room, start: $start, end: $end)';
}


}

/// @nodoc
abstract mixin class _$ScheduleSessionCopyWith<$Res> implements $ScheduleSessionCopyWith<$Res> {
  factory _$ScheduleSessionCopyWith(_ScheduleSession value, $Res Function(_ScheduleSession) _then) = __$ScheduleSessionCopyWithImpl;
@override @useResult
$Res call({
 String id, String eventId, String title, String speaker, String room, DateTime start, DateTime end
});




}
/// @nodoc
class __$ScheduleSessionCopyWithImpl<$Res>
    implements _$ScheduleSessionCopyWith<$Res> {
  __$ScheduleSessionCopyWithImpl(this._self, this._then);

  final _ScheduleSession _self;
  final $Res Function(_ScheduleSession) _then;

/// Create a copy of ScheduleSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? eventId = null,Object? title = null,Object? speaker = null,Object? room = null,Object? start = null,Object? end = null,}) {
  return _then(_ScheduleSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,speaker: null == speaker ? _self.speaker : speaker // ignore: cast_nullable_to_non_nullable
as String,room: null == room ? _self.room : room // ignore: cast_nullable_to_non_nullable
as String,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
