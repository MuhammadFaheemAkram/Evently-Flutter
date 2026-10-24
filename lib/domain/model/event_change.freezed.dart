// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_change.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EventChange {

/// The record's id: one alert per record.
 int get id; EventChangeKind get kind; Event get event;/// Your active ticket for it, where the alert's tap leads (`null` once
/// you cancelled it: the tap opens the event).
 String? get ticketId;
/// Create a copy of EventChange
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventChangeCopyWith<EventChange> get copyWith => _$EventChangeCopyWithImpl<EventChange>(this as EventChange, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as EventChange;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventChange&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.event, _this.event) || other.event == _this.event)&&(identical(other.ticketId, _this.ticketId) || other.ticketId == _this.ticketId));
}


@override
int get hashCode {
  final _this = this as EventChange;
  return Object.hash(runtimeType,_this.id,_this.kind,_this.event,_this.ticketId);
}

@override
String toString() {
  final _this = this as EventChange;
  return 'EventChange(id: ${_this.id}, kind: ${_this.kind}, event: ${_this.event}, ticketId: ${_this.ticketId})';
}


}

/// @nodoc
abstract mixin class $EventChangeCopyWith<$Res>  {
  factory $EventChangeCopyWith(EventChange value, $Res Function(EventChange) _then) = _$EventChangeCopyWithImpl;
@useResult
$Res call({
 int id, EventChangeKind kind, Event event, String? ticketId
});


$EventCopyWith<$Res> get event;

}
/// @nodoc
class _$EventChangeCopyWithImpl<$Res>
    implements $EventChangeCopyWith<$Res> {
  _$EventChangeCopyWithImpl(this._self, this._then);

  final EventChange _self;
  final $Res Function(EventChange) _then;

/// Create a copy of EventChange
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kind = null,Object? event = null,Object? ticketId = freezed,}) {
  return _then(EventChange(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as EventChangeKind,event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as Event,ticketId: freezed == ticketId ? _self.ticketId : ticketId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of EventChange
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventCopyWith<$Res> get event {
  
  return $EventCopyWith<$Res>(_self.event, (value) {
    return _then(_self.copyWith(event: value));
  });
}
}


/// Adds pattern-matching-related methods to [EventChange].
extension EventChangePatterns on EventChange {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventChange value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventChange() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventChange value)  $default,){
final _that = this;
switch (_that) {
case _EventChange():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventChange value)?  $default,){
final _that = this;
switch (_that) {
case _EventChange() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  EventChangeKind kind,  Event event,  String? ticketId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventChange() when $default != null:
return $default(_that.id,_that.kind,_that.event,_that.ticketId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  EventChangeKind kind,  Event event,  String? ticketId)  $default,) {final _that = this;
switch (_that) {
case _EventChange():
return $default(_that.id,_that.kind,_that.event,_that.ticketId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  EventChangeKind kind,  Event event,  String? ticketId)?  $default,) {final _that = this;
switch (_that) {
case _EventChange() when $default != null:
return $default(_that.id,_that.kind,_that.event,_that.ticketId);case _:
  return null;

}
}

}

/// @nodoc


class _EventChange implements EventChange {
  const _EventChange({required this.id, required this.kind, required this.event, this.ticketId});
  

/// The record's id: one alert per record.
@override final  int id;
@override final  EventChangeKind kind;
@override final  Event event;
/// Your active ticket for it, where the alert's tap leads (`null` once
/// you cancelled it: the tap opens the event).
@override final  String? ticketId;

/// Create a copy of EventChange
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventChangeCopyWith<_EventChange> get copyWith => __$EventChangeCopyWithImpl<_EventChange>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventChange&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.event, event) || other.event == event)&&(identical(other.ticketId, ticketId) || other.ticketId == ticketId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,kind,event,ticketId);
}

@override
String toString() {
    return 'EventChange(id: $id, kind: $kind, event: $event, ticketId: $ticketId)';
}


}

/// @nodoc
abstract mixin class _$EventChangeCopyWith<$Res> implements $EventChangeCopyWith<$Res> {
  factory _$EventChangeCopyWith(_EventChange value, $Res Function(_EventChange) _then) = __$EventChangeCopyWithImpl;
@override @useResult
$Res call({
 int id, EventChangeKind kind, Event event, String? ticketId
});


@override $EventCopyWith<$Res> get event;

}
/// @nodoc
class __$EventChangeCopyWithImpl<$Res>
    implements _$EventChangeCopyWith<$Res> {
  __$EventChangeCopyWithImpl(this._self, this._then);

  final _EventChange _self;
  final $Res Function(_EventChange) _then;

/// Create a copy of EventChange
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kind = null,Object? event = null,Object? ticketId = freezed,}) {
  return _then(_EventChange(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as EventChangeKind,event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as Event,ticketId: freezed == ticketId ? _self.ticketId : ticketId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of EventChange
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventCopyWith<$Res> get event {
  
  return $EventCopyWith<$Res>(_self.event, (value) {
    return _then(_self.copyWith(event: value));
  });
}
}

// dart format on
