// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'planned_notification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NotificationTarget {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationTarget);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'NotificationTarget()';
}


}

/// @nodoc
class $NotificationTargetCopyWith<$Res>  {
$NotificationTargetCopyWith(NotificationTarget _, $Res Function(NotificationTarget) __);
}


/// Adds pattern-matching-related methods to [NotificationTarget].
extension NotificationTargetPatterns on NotificationTarget {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( OpenEvent value)?  event,TResult Function( OpenTicket value)?  ticket,TResult Function( OpenTickets value)?  tickets,required TResult orElse(),}){
final _that = this;
switch (_that) {
case OpenEvent() when event != null:
return event(_that);case OpenTicket() when ticket != null:
return ticket(_that);case OpenTickets() when tickets != null:
return tickets(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( OpenEvent value)  event,required TResult Function( OpenTicket value)  ticket,required TResult Function( OpenTickets value)  tickets,}){
final _that = this;
switch (_that) {
case OpenEvent():
return event(_that);case OpenTicket():
return ticket(_that);case OpenTickets():
return tickets(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( OpenEvent value)?  event,TResult? Function( OpenTicket value)?  ticket,TResult? Function( OpenTickets value)?  tickets,}){
final _that = this;
switch (_that) {
case OpenEvent() when event != null:
return event(_that);case OpenTicket() when ticket != null:
return ticket(_that);case OpenTickets() when tickets != null:
return tickets(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String eventId)?  event,TResult Function( String ticketId)?  ticket,TResult Function()?  tickets,required TResult orElse(),}) {final _that = this;
switch (_that) {
case OpenEvent() when event != null:
return event(_that.eventId);case OpenTicket() when ticket != null:
return ticket(_that.ticketId);case OpenTickets() when tickets != null:
return tickets();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String eventId)  event,required TResult Function( String ticketId)  ticket,required TResult Function()  tickets,}) {final _that = this;
switch (_that) {
case OpenEvent():
return event(_that.eventId);case OpenTicket():
return ticket(_that.ticketId);case OpenTickets():
return tickets();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String eventId)?  event,TResult? Function( String ticketId)?  ticket,TResult? Function()?  tickets,}) {final _that = this;
switch (_that) {
case OpenEvent() when event != null:
return event(_that.eventId);case OpenTicket() when ticket != null:
return ticket(_that.ticketId);case OpenTickets() when tickets != null:
return tickets();case _:
  return null;

}
}

}

/// @nodoc


class OpenEvent extends NotificationTarget {
  const OpenEvent(this.eventId): super._();
  

 final  String eventId;

/// Create a copy of NotificationTarget
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OpenEventCopyWith<OpenEvent> get copyWith => _$OpenEventCopyWithImpl<OpenEvent>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is OpenEvent&&(identical(other.eventId, eventId) || other.eventId == eventId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,eventId);
}

@override
String toString() {
    return 'NotificationTarget.event(eventId: $eventId)';
}


}

/// @nodoc
abstract mixin class $OpenEventCopyWith<$Res> implements $NotificationTargetCopyWith<$Res> {
  factory $OpenEventCopyWith(OpenEvent value, $Res Function(OpenEvent) _then) = _$OpenEventCopyWithImpl;
@useResult
$Res call({
 String eventId
});




}
/// @nodoc
class _$OpenEventCopyWithImpl<$Res>
    implements $OpenEventCopyWith<$Res> {
  _$OpenEventCopyWithImpl(this._self, this._then);

  final OpenEvent _self;
  final $Res Function(OpenEvent) _then;

/// Create a copy of NotificationTarget
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? eventId = null,}) {
  return _then(OpenEvent(
null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class OpenTicket extends NotificationTarget {
  const OpenTicket(this.ticketId): super._();
  

 final  String ticketId;

/// Create a copy of NotificationTarget
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OpenTicketCopyWith<OpenTicket> get copyWith => _$OpenTicketCopyWithImpl<OpenTicket>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is OpenTicket&&(identical(other.ticketId, ticketId) || other.ticketId == ticketId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,ticketId);
}

@override
String toString() {
    return 'NotificationTarget.ticket(ticketId: $ticketId)';
}


}

/// @nodoc
abstract mixin class $OpenTicketCopyWith<$Res> implements $NotificationTargetCopyWith<$Res> {
  factory $OpenTicketCopyWith(OpenTicket value, $Res Function(OpenTicket) _then) = _$OpenTicketCopyWithImpl;
@useResult
$Res call({
 String ticketId
});




}
/// @nodoc
class _$OpenTicketCopyWithImpl<$Res>
    implements $OpenTicketCopyWith<$Res> {
  _$OpenTicketCopyWithImpl(this._self, this._then);

  final OpenTicket _self;
  final $Res Function(OpenTicket) _then;

/// Create a copy of NotificationTarget
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? ticketId = null,}) {
  return _then(OpenTicket(
null == ticketId ? _self.ticketId : ticketId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class OpenTickets extends NotificationTarget {
  const OpenTickets(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is OpenTickets);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'NotificationTarget.tickets()';
}


}




/// @nodoc
mixin _$PlannedNotification {

/// Stable from one plan to the next for the same kind and event (or
/// day), so the scheduler can tell what changed (`notificationId`).
 int get id; NotificationKind get kind;/// When it rings: an instant (UTC). An event's reminder is a lead time
/// before an instant; the summary's wall-clock time was turned into one
/// with the user's zone when it was planned, and is planned again if
/// the zone changes.
 DateTime get at; String get title; String get body; NotificationTarget get target;
/// Create a copy of PlannedNotification
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlannedNotificationCopyWith<PlannedNotification> get copyWith => _$PlannedNotificationCopyWithImpl<PlannedNotification>(this as PlannedNotification, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PlannedNotification;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlannedNotification&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.at, _this.at) || other.at == _this.at)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.body, _this.body) || other.body == _this.body)&&(identical(other.target, _this.target) || other.target == _this.target));
}


@override
int get hashCode {
  final _this = this as PlannedNotification;
  return Object.hash(runtimeType,_this.id,_this.kind,_this.at,_this.title,_this.body,_this.target);
}

@override
String toString() {
  final _this = this as PlannedNotification;
  return 'PlannedNotification(id: ${_this.id}, kind: ${_this.kind}, at: ${_this.at}, title: ${_this.title}, body: ${_this.body}, target: ${_this.target})';
}


}

/// @nodoc
abstract mixin class $PlannedNotificationCopyWith<$Res>  {
  factory $PlannedNotificationCopyWith(PlannedNotification value, $Res Function(PlannedNotification) _then) = _$PlannedNotificationCopyWithImpl;
@useResult
$Res call({
 int id, NotificationKind kind, DateTime at, String title, String body, NotificationTarget target
});


$NotificationTargetCopyWith<$Res> get target;

}
/// @nodoc
class _$PlannedNotificationCopyWithImpl<$Res>
    implements $PlannedNotificationCopyWith<$Res> {
  _$PlannedNotificationCopyWithImpl(this._self, this._then);

  final PlannedNotification _self;
  final $Res Function(PlannedNotification) _then;

/// Create a copy of PlannedNotification
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kind = null,Object? at = null,Object? title = null,Object? body = null,Object? target = null,}) {
  return _then(PlannedNotification(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as NotificationKind,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as NotificationTarget,
  ));
}
/// Create a copy of PlannedNotification
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationTargetCopyWith<$Res> get target {
  
  return $NotificationTargetCopyWith<$Res>(_self.target, (value) {
    return _then(_self.copyWith(target: value));
  });
}
}


/// Adds pattern-matching-related methods to [PlannedNotification].
extension PlannedNotificationPatterns on PlannedNotification {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlannedNotification value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlannedNotification() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlannedNotification value)  $default,){
final _that = this;
switch (_that) {
case _PlannedNotification():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlannedNotification value)?  $default,){
final _that = this;
switch (_that) {
case _PlannedNotification() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  NotificationKind kind,  DateTime at,  String title,  String body,  NotificationTarget target)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlannedNotification() when $default != null:
return $default(_that.id,_that.kind,_that.at,_that.title,_that.body,_that.target);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  NotificationKind kind,  DateTime at,  String title,  String body,  NotificationTarget target)  $default,) {final _that = this;
switch (_that) {
case _PlannedNotification():
return $default(_that.id,_that.kind,_that.at,_that.title,_that.body,_that.target);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  NotificationKind kind,  DateTime at,  String title,  String body,  NotificationTarget target)?  $default,) {final _that = this;
switch (_that) {
case _PlannedNotification() when $default != null:
return $default(_that.id,_that.kind,_that.at,_that.title,_that.body,_that.target);case _:
  return null;

}
}

}

/// @nodoc


class _PlannedNotification extends PlannedNotification {
  const _PlannedNotification({required this.id, required this.kind, required this.at, required this.title, required this.body, required this.target}): super._();
  

/// Stable from one plan to the next for the same kind and event (or
/// day), so the scheduler can tell what changed (`notificationId`).
@override final  int id;
@override final  NotificationKind kind;
/// When it rings: an instant (UTC). An event's reminder is a lead time
/// before an instant; the summary's wall-clock time was turned into one
/// with the user's zone when it was planned, and is planned again if
/// the zone changes.
@override final  DateTime at;
@override final  String title;
@override final  String body;
@override final  NotificationTarget target;

/// Create a copy of PlannedNotification
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlannedNotificationCopyWith<_PlannedNotification> get copyWith => __$PlannedNotificationCopyWithImpl<_PlannedNotification>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlannedNotification&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.at, at) || other.at == at)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.target, target) || other.target == target));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,kind,at,title,body,target);
}

@override
String toString() {
    return 'PlannedNotification(id: $id, kind: $kind, at: $at, title: $title, body: $body, target: $target)';
}


}

/// @nodoc
abstract mixin class _$PlannedNotificationCopyWith<$Res> implements $PlannedNotificationCopyWith<$Res> {
  factory _$PlannedNotificationCopyWith(_PlannedNotification value, $Res Function(_PlannedNotification) _then) = __$PlannedNotificationCopyWithImpl;
@override @useResult
$Res call({
 int id, NotificationKind kind, DateTime at, String title, String body, NotificationTarget target
});


@override $NotificationTargetCopyWith<$Res> get target;

}
/// @nodoc
class __$PlannedNotificationCopyWithImpl<$Res>
    implements _$PlannedNotificationCopyWith<$Res> {
  __$PlannedNotificationCopyWithImpl(this._self, this._then);

  final _PlannedNotification _self;
  final $Res Function(_PlannedNotification) _then;

/// Create a copy of PlannedNotification
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kind = null,Object? at = null,Object? title = null,Object? body = null,Object? target = null,}) {
  return _then(_PlannedNotification(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as NotificationKind,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as NotificationTarget,
  ));
}

/// Create a copy of PlannedNotification
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationTargetCopyWith<$Res> get target {
  
  return $NotificationTargetCopyWith<$Res>(_self.target, (value) {
    return _then(_self.copyWith(target: value));
  });
}
}

/// @nodoc
mixin _$InstantNotification {

 int get id; NotificationKind get kind; String get title; String get body; NotificationTarget get target;
/// Create a copy of InstantNotification
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InstantNotificationCopyWith<InstantNotification> get copyWith => _$InstantNotificationCopyWithImpl<InstantNotification>(this as InstantNotification, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as InstantNotification;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InstantNotification&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.body, _this.body) || other.body == _this.body)&&(identical(other.target, _this.target) || other.target == _this.target));
}


@override
int get hashCode {
  final _this = this as InstantNotification;
  return Object.hash(runtimeType,_this.id,_this.kind,_this.title,_this.body,_this.target);
}

@override
String toString() {
  final _this = this as InstantNotification;
  return 'InstantNotification(id: ${_this.id}, kind: ${_this.kind}, title: ${_this.title}, body: ${_this.body}, target: ${_this.target})';
}


}

/// @nodoc
abstract mixin class $InstantNotificationCopyWith<$Res>  {
  factory $InstantNotificationCopyWith(InstantNotification value, $Res Function(InstantNotification) _then) = _$InstantNotificationCopyWithImpl;
@useResult
$Res call({
 int id, NotificationKind kind, String title, String body, NotificationTarget target
});


$NotificationTargetCopyWith<$Res> get target;

}
/// @nodoc
class _$InstantNotificationCopyWithImpl<$Res>
    implements $InstantNotificationCopyWith<$Res> {
  _$InstantNotificationCopyWithImpl(this._self, this._then);

  final InstantNotification _self;
  final $Res Function(InstantNotification) _then;

/// Create a copy of InstantNotification
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kind = null,Object? title = null,Object? body = null,Object? target = null,}) {
  return _then(InstantNotification(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as NotificationKind,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as NotificationTarget,
  ));
}
/// Create a copy of InstantNotification
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationTargetCopyWith<$Res> get target {
  
  return $NotificationTargetCopyWith<$Res>(_self.target, (value) {
    return _then(_self.copyWith(target: value));
  });
}
}


/// Adds pattern-matching-related methods to [InstantNotification].
extension InstantNotificationPatterns on InstantNotification {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InstantNotification value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InstantNotification() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InstantNotification value)  $default,){
final _that = this;
switch (_that) {
case _InstantNotification():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InstantNotification value)?  $default,){
final _that = this;
switch (_that) {
case _InstantNotification() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  NotificationKind kind,  String title,  String body,  NotificationTarget target)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InstantNotification() when $default != null:
return $default(_that.id,_that.kind,_that.title,_that.body,_that.target);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  NotificationKind kind,  String title,  String body,  NotificationTarget target)  $default,) {final _that = this;
switch (_that) {
case _InstantNotification():
return $default(_that.id,_that.kind,_that.title,_that.body,_that.target);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  NotificationKind kind,  String title,  String body,  NotificationTarget target)?  $default,) {final _that = this;
switch (_that) {
case _InstantNotification() when $default != null:
return $default(_that.id,_that.kind,_that.title,_that.body,_that.target);case _:
  return null;

}
}

}

/// @nodoc


class _InstantNotification extends InstantNotification {
  const _InstantNotification({required this.id, required this.kind, required this.title, required this.body, required this.target}): super._();
  

@override final  int id;
@override final  NotificationKind kind;
@override final  String title;
@override final  String body;
@override final  NotificationTarget target;

/// Create a copy of InstantNotification
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InstantNotificationCopyWith<_InstantNotification> get copyWith => __$InstantNotificationCopyWithImpl<_InstantNotification>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _InstantNotification&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.target, target) || other.target == target));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,kind,title,body,target);
}

@override
String toString() {
    return 'InstantNotification(id: $id, kind: $kind, title: $title, body: $body, target: $target)';
}


}

/// @nodoc
abstract mixin class _$InstantNotificationCopyWith<$Res> implements $InstantNotificationCopyWith<$Res> {
  factory _$InstantNotificationCopyWith(_InstantNotification value, $Res Function(_InstantNotification) _then) = __$InstantNotificationCopyWithImpl;
@override @useResult
$Res call({
 int id, NotificationKind kind, String title, String body, NotificationTarget target
});


@override $NotificationTargetCopyWith<$Res> get target;

}
/// @nodoc
class __$InstantNotificationCopyWithImpl<$Res>
    implements _$InstantNotificationCopyWith<$Res> {
  __$InstantNotificationCopyWithImpl(this._self, this._then);

  final _InstantNotification _self;
  final $Res Function(_InstantNotification) _then;

/// Create a copy of InstantNotification
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kind = null,Object? title = null,Object? body = null,Object? target = null,}) {
  return _then(_InstantNotification(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as NotificationKind,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,target: null == target ? _self.target : target // ignore: cast_nullable_to_non_nullable
as NotificationTarget,
  ));
}

/// Create a copy of InstantNotification
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NotificationTargetCopyWith<$Res> get target {
  
  return $NotificationTargetCopyWith<$Res>(_self.target, (value) {
    return _then(_self.copyWith(target: value));
  });
}
}

/// @nodoc
mixin _$PendingNotification {

 int get id; String? get title; String? get body; String? get payload;
/// Create a copy of PendingNotification
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PendingNotificationCopyWith<PendingNotification> get copyWith => _$PendingNotificationCopyWithImpl<PendingNotification>(this as PendingNotification, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PendingNotification;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PendingNotification&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.body, _this.body) || other.body == _this.body)&&(identical(other.payload, _this.payload) || other.payload == _this.payload));
}


@override
int get hashCode {
  final _this = this as PendingNotification;
  return Object.hash(runtimeType,_this.id,_this.title,_this.body,_this.payload);
}

@override
String toString() {
  final _this = this as PendingNotification;
  return 'PendingNotification(id: ${_this.id}, title: ${_this.title}, body: ${_this.body}, payload: ${_this.payload})';
}


}

/// @nodoc
abstract mixin class $PendingNotificationCopyWith<$Res>  {
  factory $PendingNotificationCopyWith(PendingNotification value, $Res Function(PendingNotification) _then) = _$PendingNotificationCopyWithImpl;
@useResult
$Res call({
 int id, String? title, String? body, String? payload
});




}
/// @nodoc
class _$PendingNotificationCopyWithImpl<$Res>
    implements $PendingNotificationCopyWith<$Res> {
  _$PendingNotificationCopyWithImpl(this._self, this._then);

  final PendingNotification _self;
  final $Res Function(PendingNotification) _then;

/// Create a copy of PendingNotification
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = freezed,Object? body = freezed,Object? payload = freezed,}) {
  return _then(PendingNotification(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,payload: freezed == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PendingNotification].
extension PendingNotificationPatterns on PendingNotification {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PendingNotification value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PendingNotification() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PendingNotification value)  $default,){
final _that = this;
switch (_that) {
case _PendingNotification():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PendingNotification value)?  $default,){
final _that = this;
switch (_that) {
case _PendingNotification() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String? title,  String? body,  String? payload)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PendingNotification() when $default != null:
return $default(_that.id,_that.title,_that.body,_that.payload);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String? title,  String? body,  String? payload)  $default,) {final _that = this;
switch (_that) {
case _PendingNotification():
return $default(_that.id,_that.title,_that.body,_that.payload);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String? title,  String? body,  String? payload)?  $default,) {final _that = this;
switch (_that) {
case _PendingNotification() when $default != null:
return $default(_that.id,_that.title,_that.body,_that.payload);case _:
  return null;

}
}

}

/// @nodoc


class _PendingNotification implements PendingNotification {
  const _PendingNotification({required this.id, this.title, this.body, this.payload});
  

@override final  int id;
@override final  String? title;
@override final  String? body;
@override final  String? payload;

/// Create a copy of PendingNotification
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PendingNotificationCopyWith<_PendingNotification> get copyWith => __$PendingNotificationCopyWithImpl<_PendingNotification>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PendingNotification&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&(identical(other.payload, payload) || other.payload == payload));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,title,body,payload);
}

@override
String toString() {
    return 'PendingNotification(id: $id, title: $title, body: $body, payload: $payload)';
}


}

/// @nodoc
abstract mixin class _$PendingNotificationCopyWith<$Res> implements $PendingNotificationCopyWith<$Res> {
  factory _$PendingNotificationCopyWith(_PendingNotification value, $Res Function(_PendingNotification) _then) = __$PendingNotificationCopyWithImpl;
@override @useResult
$Res call({
 int id, String? title, String? body, String? payload
});




}
/// @nodoc
class __$PendingNotificationCopyWithImpl<$Res>
    implements _$PendingNotificationCopyWith<$Res> {
  __$PendingNotificationCopyWithImpl(this._self, this._then);

  final _PendingNotification _self;
  final $Res Function(_PendingNotification) _then;

/// Create a copy of PendingNotification
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = freezed,Object? body = freezed,Object? payload = freezed,}) {
  return _then(_PendingNotification(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,payload: freezed == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$NotificationSyncReport {

/// Whether notifications are on (and allowed).
 bool get enabled;/// The plan's size.
 int get planned; int get scheduled; int get cancelled;/// Already on the device, unchanged: left alone.
 int get kept;/// The system no longer allows notifications: the switch turned off.
 bool get permissionRevoked;
/// Create a copy of NotificationSyncReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationSyncReportCopyWith<NotificationSyncReport> get copyWith => _$NotificationSyncReportCopyWithImpl<NotificationSyncReport>(this as NotificationSyncReport, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as NotificationSyncReport;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationSyncReport&&(identical(other.enabled, _this.enabled) || other.enabled == _this.enabled)&&(identical(other.planned, _this.planned) || other.planned == _this.planned)&&(identical(other.scheduled, _this.scheduled) || other.scheduled == _this.scheduled)&&(identical(other.cancelled, _this.cancelled) || other.cancelled == _this.cancelled)&&(identical(other.kept, _this.kept) || other.kept == _this.kept)&&(identical(other.permissionRevoked, _this.permissionRevoked) || other.permissionRevoked == _this.permissionRevoked));
}


@override
int get hashCode {
  final _this = this as NotificationSyncReport;
  return Object.hash(runtimeType,_this.enabled,_this.planned,_this.scheduled,_this.cancelled,_this.kept,_this.permissionRevoked);
}

@override
String toString() {
  final _this = this as NotificationSyncReport;
  return 'NotificationSyncReport(enabled: ${_this.enabled}, planned: ${_this.planned}, scheduled: ${_this.scheduled}, cancelled: ${_this.cancelled}, kept: ${_this.kept}, permissionRevoked: ${_this.permissionRevoked})';
}


}

/// @nodoc
abstract mixin class $NotificationSyncReportCopyWith<$Res>  {
  factory $NotificationSyncReportCopyWith(NotificationSyncReport value, $Res Function(NotificationSyncReport) _then) = _$NotificationSyncReportCopyWithImpl;
@useResult
$Res call({
 bool enabled, int planned, int scheduled, int cancelled, int kept, bool permissionRevoked
});




}
/// @nodoc
class _$NotificationSyncReportCopyWithImpl<$Res>
    implements $NotificationSyncReportCopyWith<$Res> {
  _$NotificationSyncReportCopyWithImpl(this._self, this._then);

  final NotificationSyncReport _self;
  final $Res Function(NotificationSyncReport) _then;

/// Create a copy of NotificationSyncReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? enabled = null,Object? planned = null,Object? scheduled = null,Object? cancelled = null,Object? kept = null,Object? permissionRevoked = null,}) {
  return _then(NotificationSyncReport(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,planned: null == planned ? _self.planned : planned // ignore: cast_nullable_to_non_nullable
as int,scheduled: null == scheduled ? _self.scheduled : scheduled // ignore: cast_nullable_to_non_nullable
as int,cancelled: null == cancelled ? _self.cancelled : cancelled // ignore: cast_nullable_to_non_nullable
as int,kept: null == kept ? _self.kept : kept // ignore: cast_nullable_to_non_nullable
as int,permissionRevoked: null == permissionRevoked ? _self.permissionRevoked : permissionRevoked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationSyncReport].
extension NotificationSyncReportPatterns on NotificationSyncReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationSyncReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationSyncReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationSyncReport value)  $default,){
final _that = this;
switch (_that) {
case _NotificationSyncReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationSyncReport value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationSyncReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool enabled,  int planned,  int scheduled,  int cancelled,  int kept,  bool permissionRevoked)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationSyncReport() when $default != null:
return $default(_that.enabled,_that.planned,_that.scheduled,_that.cancelled,_that.kept,_that.permissionRevoked);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool enabled,  int planned,  int scheduled,  int cancelled,  int kept,  bool permissionRevoked)  $default,) {final _that = this;
switch (_that) {
case _NotificationSyncReport():
return $default(_that.enabled,_that.planned,_that.scheduled,_that.cancelled,_that.kept,_that.permissionRevoked);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool enabled,  int planned,  int scheduled,  int cancelled,  int kept,  bool permissionRevoked)?  $default,) {final _that = this;
switch (_that) {
case _NotificationSyncReport() when $default != null:
return $default(_that.enabled,_that.planned,_that.scheduled,_that.cancelled,_that.kept,_that.permissionRevoked);case _:
  return null;

}
}

}

/// @nodoc


class _NotificationSyncReport implements NotificationSyncReport {
  const _NotificationSyncReport({required this.enabled, this.planned = 0, this.scheduled = 0, this.cancelled = 0, this.kept = 0, this.permissionRevoked = false});
  

/// Whether notifications are on (and allowed).
@override final  bool enabled;
/// The plan's size.
@override@JsonKey() final  int planned;
@override@JsonKey() final  int scheduled;
@override@JsonKey() final  int cancelled;
/// Already on the device, unchanged: left alone.
@override@JsonKey() final  int kept;
/// The system no longer allows notifications: the switch turned off.
@override@JsonKey() final  bool permissionRevoked;

/// Create a copy of NotificationSyncReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationSyncReportCopyWith<_NotificationSyncReport> get copyWith => __$NotificationSyncReportCopyWithImpl<_NotificationSyncReport>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationSyncReport&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.planned, planned) || other.planned == planned)&&(identical(other.scheduled, scheduled) || other.scheduled == scheduled)&&(identical(other.cancelled, cancelled) || other.cancelled == cancelled)&&(identical(other.kept, kept) || other.kept == kept)&&(identical(other.permissionRevoked, permissionRevoked) || other.permissionRevoked == permissionRevoked));
}


@override
int get hashCode {
    return Object.hash(runtimeType,enabled,planned,scheduled,cancelled,kept,permissionRevoked);
}

@override
String toString() {
    return 'NotificationSyncReport(enabled: $enabled, planned: $planned, scheduled: $scheduled, cancelled: $cancelled, kept: $kept, permissionRevoked: $permissionRevoked)';
}


}

/// @nodoc
abstract mixin class _$NotificationSyncReportCopyWith<$Res> implements $NotificationSyncReportCopyWith<$Res> {
  factory _$NotificationSyncReportCopyWith(_NotificationSyncReport value, $Res Function(_NotificationSyncReport) _then) = __$NotificationSyncReportCopyWithImpl;
@override @useResult
$Res call({
 bool enabled, int planned, int scheduled, int cancelled, int kept, bool permissionRevoked
});




}
/// @nodoc
class __$NotificationSyncReportCopyWithImpl<$Res>
    implements _$NotificationSyncReportCopyWith<$Res> {
  __$NotificationSyncReportCopyWithImpl(this._self, this._then);

  final _NotificationSyncReport _self;
  final $Res Function(_NotificationSyncReport) _then;

/// Create a copy of NotificationSyncReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? enabled = null,Object? planned = null,Object? scheduled = null,Object? cancelled = null,Object? kept = null,Object? permissionRevoked = null,}) {
  return _then(_NotificationSyncReport(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,planned: null == planned ? _self.planned : planned // ignore: cast_nullable_to_non_nullable
as int,scheduled: null == scheduled ? _self.scheduled : scheduled // ignore: cast_nullable_to_non_nullable
as int,cancelled: null == cancelled ? _self.cancelled : cancelled // ignore: cast_nullable_to_non_nullable
as int,kept: null == kept ? _self.kept : kept // ignore: cast_nullable_to_non_nullable
as int,permissionRevoked: null == permissionRevoked ? _self.permissionRevoked : permissionRevoked // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$NotificationPlanPreview {

/// What the planner wants now (planned even while notifications are
/// off, so it can be inspected).
 List<PlannedNotification> get plan;/// How many are pending on the device.
 int get pending; bool get enabled;
/// Create a copy of NotificationPlanPreview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationPlanPreviewCopyWith<NotificationPlanPreview> get copyWith => _$NotificationPlanPreviewCopyWithImpl<NotificationPlanPreview>(this as NotificationPlanPreview, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as NotificationPlanPreview;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationPlanPreview&&const DeepCollectionEquality().equals(other.plan, _this.plan)&&(identical(other.pending, _this.pending) || other.pending == _this.pending)&&(identical(other.enabled, _this.enabled) || other.enabled == _this.enabled));
}


@override
int get hashCode {
  final _this = this as NotificationPlanPreview;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.plan),_this.pending,_this.enabled);
}

@override
String toString() {
  final _this = this as NotificationPlanPreview;
  return 'NotificationPlanPreview(plan: ${_this.plan}, pending: ${_this.pending}, enabled: ${_this.enabled})';
}


}

/// @nodoc
abstract mixin class $NotificationPlanPreviewCopyWith<$Res>  {
  factory $NotificationPlanPreviewCopyWith(NotificationPlanPreview value, $Res Function(NotificationPlanPreview) _then) = _$NotificationPlanPreviewCopyWithImpl;
@useResult
$Res call({
 List<PlannedNotification> plan, int pending, bool enabled
});




}
/// @nodoc
class _$NotificationPlanPreviewCopyWithImpl<$Res>
    implements $NotificationPlanPreviewCopyWith<$Res> {
  _$NotificationPlanPreviewCopyWithImpl(this._self, this._then);

  final NotificationPlanPreview _self;
  final $Res Function(NotificationPlanPreview) _then;

/// Create a copy of NotificationPlanPreview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? plan = null,Object? pending = null,Object? enabled = null,}) {
  return _then(NotificationPlanPreview(
plan: null == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as List<PlannedNotification>,pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as int,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationPlanPreview].
extension NotificationPlanPreviewPatterns on NotificationPlanPreview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationPlanPreview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationPlanPreview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationPlanPreview value)  $default,){
final _that = this;
switch (_that) {
case _NotificationPlanPreview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationPlanPreview value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationPlanPreview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<PlannedNotification> plan,  int pending,  bool enabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationPlanPreview() when $default != null:
return $default(_that.plan,_that.pending,_that.enabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<PlannedNotification> plan,  int pending,  bool enabled)  $default,) {final _that = this;
switch (_that) {
case _NotificationPlanPreview():
return $default(_that.plan,_that.pending,_that.enabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<PlannedNotification> plan,  int pending,  bool enabled)?  $default,) {final _that = this;
switch (_that) {
case _NotificationPlanPreview() when $default != null:
return $default(_that.plan,_that.pending,_that.enabled);case _:
  return null;

}
}

}

/// @nodoc


class _NotificationPlanPreview implements NotificationPlanPreview {
  const _NotificationPlanPreview({required  List<PlannedNotification> plan, required this.pending, required this.enabled}): _plan = plan;
  

/// What the planner wants now (planned even while notifications are
/// off, so it can be inspected).
 final  List<PlannedNotification> _plan;
/// What the planner wants now (planned even while notifications are
/// off, so it can be inspected).
@override List<PlannedNotification> get plan {
  if (_plan is EqualUnmodifiableListView) return _plan;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_plan);
}

/// How many are pending on the device.
@override final  int pending;
@override final  bool enabled;

/// Create a copy of NotificationPlanPreview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationPlanPreviewCopyWith<_NotificationPlanPreview> get copyWith => __$NotificationPlanPreviewCopyWithImpl<_NotificationPlanPreview>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationPlanPreview&&const DeepCollectionEquality().equals(other.plan, _plan)&&(identical(other.pending, pending) || other.pending == pending)&&(identical(other.enabled, enabled) || other.enabled == enabled));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_plan),pending,enabled);
}

@override
String toString() {
    return 'NotificationPlanPreview(plan: $plan, pending: $pending, enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class _$NotificationPlanPreviewCopyWith<$Res> implements $NotificationPlanPreviewCopyWith<$Res> {
  factory _$NotificationPlanPreviewCopyWith(_NotificationPlanPreview value, $Res Function(_NotificationPlanPreview) _then) = __$NotificationPlanPreviewCopyWithImpl;
@override @useResult
$Res call({
 List<PlannedNotification> plan, int pending, bool enabled
});




}
/// @nodoc
class __$NotificationPlanPreviewCopyWithImpl<$Res>
    implements _$NotificationPlanPreviewCopyWith<$Res> {
  __$NotificationPlanPreviewCopyWithImpl(this._self, this._then);

  final _NotificationPlanPreview _self;
  final $Res Function(_NotificationPlanPreview) _then;

/// Create a copy of NotificationPlanPreview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? plan = null,Object? pending = null,Object? enabled = null,}) {
  return _then(_NotificationPlanPreview(
plan: null == plan ? _self._plan : plan // ignore: cast_nullable_to_non_nullable
as List<PlannedNotification>,pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as int,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
