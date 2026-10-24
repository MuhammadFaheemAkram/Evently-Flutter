// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EventDetails {

 EventCardItem get item; Organizer get organizer;/// The first sessions of the agenda, in order.
 List<ScheduleSession> get agendaPreview;/// How many sessions the whole agenda has.
 int get sessionCount;/// Your active ticket's id, when you're going.
 String? get ticketId;
/// Create a copy of EventDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventDetailsCopyWith<EventDetails> get copyWith => _$EventDetailsCopyWithImpl<EventDetails>(this as EventDetails, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as EventDetails;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventDetails&&(identical(other.item, _this.item) || other.item == _this.item)&&(identical(other.organizer, _this.organizer) || other.organizer == _this.organizer)&&const DeepCollectionEquality().equals(other.agendaPreview, _this.agendaPreview)&&(identical(other.sessionCount, _this.sessionCount) || other.sessionCount == _this.sessionCount)&&(identical(other.ticketId, _this.ticketId) || other.ticketId == _this.ticketId));
}


@override
int get hashCode {
  final _this = this as EventDetails;
  return Object.hash(runtimeType,_this.item,_this.organizer,const DeepCollectionEquality().hash(_this.agendaPreview),_this.sessionCount,_this.ticketId);
}

@override
String toString() {
  final _this = this as EventDetails;
  return 'EventDetails(item: ${_this.item}, organizer: ${_this.organizer}, agendaPreview: ${_this.agendaPreview}, sessionCount: ${_this.sessionCount}, ticketId: ${_this.ticketId})';
}


}

/// @nodoc
abstract mixin class $EventDetailsCopyWith<$Res>  {
  factory $EventDetailsCopyWith(EventDetails value, $Res Function(EventDetails) _then) = _$EventDetailsCopyWithImpl;
@useResult
$Res call({
 EventCardItem item, Organizer organizer, List<ScheduleSession> agendaPreview, int sessionCount, String? ticketId
});


$EventCardItemCopyWith<$Res> get item;$OrganizerCopyWith<$Res> get organizer;

}
/// @nodoc
class _$EventDetailsCopyWithImpl<$Res>
    implements $EventDetailsCopyWith<$Res> {
  _$EventDetailsCopyWithImpl(this._self, this._then);

  final EventDetails _self;
  final $Res Function(EventDetails) _then;

/// Create a copy of EventDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? item = null,Object? organizer = null,Object? agendaPreview = null,Object? sessionCount = null,Object? ticketId = freezed,}) {
  return _then(EventDetails(
item: null == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as EventCardItem,organizer: null == organizer ? _self.organizer : organizer // ignore: cast_nullable_to_non_nullable
as Organizer,agendaPreview: null == agendaPreview ? _self.agendaPreview : agendaPreview // ignore: cast_nullable_to_non_nullable
as List<ScheduleSession>,sessionCount: null == sessionCount ? _self.sessionCount : sessionCount // ignore: cast_nullable_to_non_nullable
as int,ticketId: freezed == ticketId ? _self.ticketId : ticketId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of EventDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventCardItemCopyWith<$Res> get item {
  
  return $EventCardItemCopyWith<$Res>(_self.item, (value) {
    return _then(_self.copyWith(item: value));
  });
}/// Create a copy of EventDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrganizerCopyWith<$Res> get organizer {
  
  return $OrganizerCopyWith<$Res>(_self.organizer, (value) {
    return _then(_self.copyWith(organizer: value));
  });
}
}


/// Adds pattern-matching-related methods to [EventDetails].
extension EventDetailsPatterns on EventDetails {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventDetails value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventDetails() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventDetails value)  $default,){
final _that = this;
switch (_that) {
case _EventDetails():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventDetails value)?  $default,){
final _that = this;
switch (_that) {
case _EventDetails() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( EventCardItem item,  Organizer organizer,  List<ScheduleSession> agendaPreview,  int sessionCount,  String? ticketId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventDetails() when $default != null:
return $default(_that.item,_that.organizer,_that.agendaPreview,_that.sessionCount,_that.ticketId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( EventCardItem item,  Organizer organizer,  List<ScheduleSession> agendaPreview,  int sessionCount,  String? ticketId)  $default,) {final _that = this;
switch (_that) {
case _EventDetails():
return $default(_that.item,_that.organizer,_that.agendaPreview,_that.sessionCount,_that.ticketId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( EventCardItem item,  Organizer organizer,  List<ScheduleSession> agendaPreview,  int sessionCount,  String? ticketId)?  $default,) {final _that = this;
switch (_that) {
case _EventDetails() when $default != null:
return $default(_that.item,_that.organizer,_that.agendaPreview,_that.sessionCount,_that.ticketId);case _:
  return null;

}
}

}

/// @nodoc


class _EventDetails implements EventDetails {
  const _EventDetails({required this.item, required this.organizer,  List<ScheduleSession> agendaPreview = const <ScheduleSession>[], this.sessionCount = 0, this.ticketId}): _agendaPreview = agendaPreview;
  

@override final  EventCardItem item;
@override final  Organizer organizer;
/// The first sessions of the agenda, in order.
 final  List<ScheduleSession> _agendaPreview;
/// The first sessions of the agenda, in order.
@override@JsonKey() List<ScheduleSession> get agendaPreview {
  if (_agendaPreview is EqualUnmodifiableListView) return _agendaPreview;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_agendaPreview);
}

/// How many sessions the whole agenda has.
@override@JsonKey() final  int sessionCount;
/// Your active ticket's id, when you're going.
@override final  String? ticketId;

/// Create a copy of EventDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventDetailsCopyWith<_EventDetails> get copyWith => __$EventDetailsCopyWithImpl<_EventDetails>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventDetails&&(identical(other.item, item) || other.item == item)&&(identical(other.organizer, organizer) || other.organizer == organizer)&&const DeepCollectionEquality().equals(other.agendaPreview, _agendaPreview)&&(identical(other.sessionCount, sessionCount) || other.sessionCount == sessionCount)&&(identical(other.ticketId, ticketId) || other.ticketId == ticketId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,item,organizer,const DeepCollectionEquality().hash(_agendaPreview),sessionCount,ticketId);
}

@override
String toString() {
    return 'EventDetails(item: $item, organizer: $organizer, agendaPreview: $agendaPreview, sessionCount: $sessionCount, ticketId: $ticketId)';
}


}

/// @nodoc
abstract mixin class _$EventDetailsCopyWith<$Res> implements $EventDetailsCopyWith<$Res> {
  factory _$EventDetailsCopyWith(_EventDetails value, $Res Function(_EventDetails) _then) = __$EventDetailsCopyWithImpl;
@override @useResult
$Res call({
 EventCardItem item, Organizer organizer, List<ScheduleSession> agendaPreview, int sessionCount, String? ticketId
});


@override $EventCardItemCopyWith<$Res> get item;@override $OrganizerCopyWith<$Res> get organizer;

}
/// @nodoc
class __$EventDetailsCopyWithImpl<$Res>
    implements _$EventDetailsCopyWith<$Res> {
  __$EventDetailsCopyWithImpl(this._self, this._then);

  final _EventDetails _self;
  final $Res Function(_EventDetails) _then;

/// Create a copy of EventDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? item = null,Object? organizer = null,Object? agendaPreview = null,Object? sessionCount = null,Object? ticketId = freezed,}) {
  return _then(_EventDetails(
item: null == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as EventCardItem,organizer: null == organizer ? _self.organizer : organizer // ignore: cast_nullable_to_non_nullable
as Organizer,agendaPreview: null == agendaPreview ? _self._agendaPreview : agendaPreview // ignore: cast_nullable_to_non_nullable
as List<ScheduleSession>,sessionCount: null == sessionCount ? _self.sessionCount : sessionCount // ignore: cast_nullable_to_non_nullable
as int,ticketId: freezed == ticketId ? _self.ticketId : ticketId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of EventDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventCardItemCopyWith<$Res> get item {
  
  return $EventCardItemCopyWith<$Res>(_self.item, (value) {
    return _then(_self.copyWith(item: value));
  });
}/// Create a copy of EventDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrganizerCopyWith<$Res> get organizer {
  
  return $OrganizerCopyWith<$Res>(_self.organizer, (value) {
    return _then(_self.copyWith(organizer: value));
  });
}
}

// dart format on
