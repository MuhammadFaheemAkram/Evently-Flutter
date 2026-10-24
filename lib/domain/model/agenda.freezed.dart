// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'agenda.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AgendaSession {

 ScheduleSession get session; bool get isBookmarked;/// Other bookmarked sessions overlapping this one (only when this one
/// is bookmarked too): you can't be in both.
 List<ScheduleSession> get clashesWith;
/// Create a copy of AgendaSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AgendaSessionCopyWith<AgendaSession> get copyWith => _$AgendaSessionCopyWithImpl<AgendaSession>(this as AgendaSession, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AgendaSession;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AgendaSession&&(identical(other.session, _this.session) || other.session == _this.session)&&(identical(other.isBookmarked, _this.isBookmarked) || other.isBookmarked == _this.isBookmarked)&&const DeepCollectionEquality().equals(other.clashesWith, _this.clashesWith));
}


@override
int get hashCode {
  final _this = this as AgendaSession;
  return Object.hash(runtimeType,_this.session,_this.isBookmarked,const DeepCollectionEquality().hash(_this.clashesWith));
}

@override
String toString() {
  final _this = this as AgendaSession;
  return 'AgendaSession(session: ${_this.session}, isBookmarked: ${_this.isBookmarked}, clashesWith: ${_this.clashesWith})';
}


}

/// @nodoc
abstract mixin class $AgendaSessionCopyWith<$Res>  {
  factory $AgendaSessionCopyWith(AgendaSession value, $Res Function(AgendaSession) _then) = _$AgendaSessionCopyWithImpl;
@useResult
$Res call({
 ScheduleSession session, bool isBookmarked, List<ScheduleSession> clashesWith
});


$ScheduleSessionCopyWith<$Res> get session;

}
/// @nodoc
class _$AgendaSessionCopyWithImpl<$Res>
    implements $AgendaSessionCopyWith<$Res> {
  _$AgendaSessionCopyWithImpl(this._self, this._then);

  final AgendaSession _self;
  final $Res Function(AgendaSession) _then;

/// Create a copy of AgendaSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? session = null,Object? isBookmarked = null,Object? clashesWith = null,}) {
  return _then(AgendaSession(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as ScheduleSession,isBookmarked: null == isBookmarked ? _self.isBookmarked : isBookmarked // ignore: cast_nullable_to_non_nullable
as bool,clashesWith: null == clashesWith ? _self.clashesWith : clashesWith // ignore: cast_nullable_to_non_nullable
as List<ScheduleSession>,
  ));
}
/// Create a copy of AgendaSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScheduleSessionCopyWith<$Res> get session {
  
  return $ScheduleSessionCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}
}


/// Adds pattern-matching-related methods to [AgendaSession].
extension AgendaSessionPatterns on AgendaSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AgendaSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AgendaSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AgendaSession value)  $default,){
final _that = this;
switch (_that) {
case _AgendaSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AgendaSession value)?  $default,){
final _that = this;
switch (_that) {
case _AgendaSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ScheduleSession session,  bool isBookmarked,  List<ScheduleSession> clashesWith)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AgendaSession() when $default != null:
return $default(_that.session,_that.isBookmarked,_that.clashesWith);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ScheduleSession session,  bool isBookmarked,  List<ScheduleSession> clashesWith)  $default,) {final _that = this;
switch (_that) {
case _AgendaSession():
return $default(_that.session,_that.isBookmarked,_that.clashesWith);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ScheduleSession session,  bool isBookmarked,  List<ScheduleSession> clashesWith)?  $default,) {final _that = this;
switch (_that) {
case _AgendaSession() when $default != null:
return $default(_that.session,_that.isBookmarked,_that.clashesWith);case _:
  return null;

}
}

}

/// @nodoc


class _AgendaSession implements AgendaSession {
  const _AgendaSession({required this.session, this.isBookmarked = false,  List<ScheduleSession> clashesWith = const <ScheduleSession>[]}): _clashesWith = clashesWith;
  

@override final  ScheduleSession session;
@override@JsonKey() final  bool isBookmarked;
/// Other bookmarked sessions overlapping this one (only when this one
/// is bookmarked too): you can't be in both.
 final  List<ScheduleSession> _clashesWith;
/// Other bookmarked sessions overlapping this one (only when this one
/// is bookmarked too): you can't be in both.
@override@JsonKey() List<ScheduleSession> get clashesWith {
  if (_clashesWith is EqualUnmodifiableListView) return _clashesWith;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_clashesWith);
}


/// Create a copy of AgendaSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AgendaSessionCopyWith<_AgendaSession> get copyWith => __$AgendaSessionCopyWithImpl<_AgendaSession>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AgendaSession&&(identical(other.session, session) || other.session == session)&&(identical(other.isBookmarked, isBookmarked) || other.isBookmarked == isBookmarked)&&const DeepCollectionEquality().equals(other.clashesWith, _clashesWith));
}


@override
int get hashCode {
    return Object.hash(runtimeType,session,isBookmarked,const DeepCollectionEquality().hash(_clashesWith));
}

@override
String toString() {
    return 'AgendaSession(session: $session, isBookmarked: $isBookmarked, clashesWith: $clashesWith)';
}


}

/// @nodoc
abstract mixin class _$AgendaSessionCopyWith<$Res> implements $AgendaSessionCopyWith<$Res> {
  factory _$AgendaSessionCopyWith(_AgendaSession value, $Res Function(_AgendaSession) _then) = __$AgendaSessionCopyWithImpl;
@override @useResult
$Res call({
 ScheduleSession session, bool isBookmarked, List<ScheduleSession> clashesWith
});


@override $ScheduleSessionCopyWith<$Res> get session;

}
/// @nodoc
class __$AgendaSessionCopyWithImpl<$Res>
    implements _$AgendaSessionCopyWith<$Res> {
  __$AgendaSessionCopyWithImpl(this._self, this._then);

  final _AgendaSession _self;
  final $Res Function(_AgendaSession) _then;

/// Create a copy of AgendaSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? session = null,Object? isBookmarked = null,Object? clashesWith = null,}) {
  return _then(_AgendaSession(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as ScheduleSession,isBookmarked: null == isBookmarked ? _self.isBookmarked : isBookmarked // ignore: cast_nullable_to_non_nullable
as bool,clashesWith: null == clashesWith ? _self._clashesWith : clashesWith // ignore: cast_nullable_to_non_nullable
as List<ScheduleSession>,
  ));
}

/// Create a copy of AgendaSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScheduleSessionCopyWith<$Res> get session {
  
  return $ScheduleSessionCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}
}

/// @nodoc
mixin _$AgendaDay {

 CalendarDate get day; List<AgendaSession> get sessions;
/// Create a copy of AgendaDay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AgendaDayCopyWith<AgendaDay> get copyWith => _$AgendaDayCopyWithImpl<AgendaDay>(this as AgendaDay, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AgendaDay;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AgendaDay&&(identical(other.day, _this.day) || other.day == _this.day)&&const DeepCollectionEquality().equals(other.sessions, _this.sessions));
}


@override
int get hashCode {
  final _this = this as AgendaDay;
  return Object.hash(runtimeType,_this.day,const DeepCollectionEquality().hash(_this.sessions));
}

@override
String toString() {
  final _this = this as AgendaDay;
  return 'AgendaDay(day: ${_this.day}, sessions: ${_this.sessions})';
}


}

/// @nodoc
abstract mixin class $AgendaDayCopyWith<$Res>  {
  factory $AgendaDayCopyWith(AgendaDay value, $Res Function(AgendaDay) _then) = _$AgendaDayCopyWithImpl;
@useResult
$Res call({
 CalendarDate day, List<AgendaSession> sessions
});




}
/// @nodoc
class _$AgendaDayCopyWithImpl<$Res>
    implements $AgendaDayCopyWith<$Res> {
  _$AgendaDayCopyWithImpl(this._self, this._then);

  final AgendaDay _self;
  final $Res Function(AgendaDay) _then;

/// Create a copy of AgendaDay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? day = null,Object? sessions = null,}) {
  return _then(AgendaDay(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as CalendarDate,sessions: null == sessions ? _self.sessions : sessions // ignore: cast_nullable_to_non_nullable
as List<AgendaSession>,
  ));
}

}


/// Adds pattern-matching-related methods to [AgendaDay].
extension AgendaDayPatterns on AgendaDay {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AgendaDay value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AgendaDay() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AgendaDay value)  $default,){
final _that = this;
switch (_that) {
case _AgendaDay():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AgendaDay value)?  $default,){
final _that = this;
switch (_that) {
case _AgendaDay() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CalendarDate day,  List<AgendaSession> sessions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AgendaDay() when $default != null:
return $default(_that.day,_that.sessions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CalendarDate day,  List<AgendaSession> sessions)  $default,) {final _that = this;
switch (_that) {
case _AgendaDay():
return $default(_that.day,_that.sessions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CalendarDate day,  List<AgendaSession> sessions)?  $default,) {final _that = this;
switch (_that) {
case _AgendaDay() when $default != null:
return $default(_that.day,_that.sessions);case _:
  return null;

}
}

}

/// @nodoc


class _AgendaDay implements AgendaDay {
  const _AgendaDay({required this.day, required  List<AgendaSession> sessions}): _sessions = sessions;
  

@override final  CalendarDate day;
 final  List<AgendaSession> _sessions;
@override List<AgendaSession> get sessions {
  if (_sessions is EqualUnmodifiableListView) return _sessions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sessions);
}


/// Create a copy of AgendaDay
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AgendaDayCopyWith<_AgendaDay> get copyWith => __$AgendaDayCopyWithImpl<_AgendaDay>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AgendaDay&&(identical(other.day, day) || other.day == day)&&const DeepCollectionEquality().equals(other.sessions, _sessions));
}


@override
int get hashCode {
    return Object.hash(runtimeType,day,const DeepCollectionEquality().hash(_sessions));
}

@override
String toString() {
    return 'AgendaDay(day: $day, sessions: $sessions)';
}


}

/// @nodoc
abstract mixin class _$AgendaDayCopyWith<$Res> implements $AgendaDayCopyWith<$Res> {
  factory _$AgendaDayCopyWith(_AgendaDay value, $Res Function(_AgendaDay) _then) = __$AgendaDayCopyWithImpl;
@override @useResult
$Res call({
 CalendarDate day, List<AgendaSession> sessions
});




}
/// @nodoc
class __$AgendaDayCopyWithImpl<$Res>
    implements _$AgendaDayCopyWith<$Res> {
  __$AgendaDayCopyWithImpl(this._self, this._then);

  final _AgendaDay _self;
  final $Res Function(_AgendaDay) _then;

/// Create a copy of AgendaDay
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? day = null,Object? sessions = null,}) {
  return _then(_AgendaDay(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as CalendarDate,sessions: null == sessions ? _self._sessions : sessions // ignore: cast_nullable_to_non_nullable
as List<AgendaSession>,
  ));
}


}

/// @nodoc
mixin _$Agenda {

 String get eventId; String get eventTitle;/// The event's IANA zone: its days and times are the venue's.
 String get zone; List<AgendaDay> get days;
/// Create a copy of Agenda
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AgendaCopyWith<Agenda> get copyWith => _$AgendaCopyWithImpl<Agenda>(this as Agenda, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Agenda;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Agenda&&(identical(other.eventId, _this.eventId) || other.eventId == _this.eventId)&&(identical(other.eventTitle, _this.eventTitle) || other.eventTitle == _this.eventTitle)&&(identical(other.zone, _this.zone) || other.zone == _this.zone)&&const DeepCollectionEquality().equals(other.days, _this.days));
}


@override
int get hashCode {
  final _this = this as Agenda;
  return Object.hash(runtimeType,_this.eventId,_this.eventTitle,_this.zone,const DeepCollectionEquality().hash(_this.days));
}

@override
String toString() {
  final _this = this as Agenda;
  return 'Agenda(eventId: ${_this.eventId}, eventTitle: ${_this.eventTitle}, zone: ${_this.zone}, days: ${_this.days})';
}


}

/// @nodoc
abstract mixin class $AgendaCopyWith<$Res>  {
  factory $AgendaCopyWith(Agenda value, $Res Function(Agenda) _then) = _$AgendaCopyWithImpl;
@useResult
$Res call({
 String eventId, String eventTitle, String zone, List<AgendaDay> days
});




}
/// @nodoc
class _$AgendaCopyWithImpl<$Res>
    implements $AgendaCopyWith<$Res> {
  _$AgendaCopyWithImpl(this._self, this._then);

  final Agenda _self;
  final $Res Function(Agenda) _then;

/// Create a copy of Agenda
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? eventId = null,Object? eventTitle = null,Object? zone = null,Object? days = null,}) {
  return _then(Agenda(
eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,eventTitle: null == eventTitle ? _self.eventTitle : eventTitle // ignore: cast_nullable_to_non_nullable
as String,zone: null == zone ? _self.zone : zone // ignore: cast_nullable_to_non_nullable
as String,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as List<AgendaDay>,
  ));
}

}


/// Adds pattern-matching-related methods to [Agenda].
extension AgendaPatterns on Agenda {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Agenda value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Agenda() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Agenda value)  $default,){
final _that = this;
switch (_that) {
case _Agenda():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Agenda value)?  $default,){
final _that = this;
switch (_that) {
case _Agenda() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String eventId,  String eventTitle,  String zone,  List<AgendaDay> days)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Agenda() when $default != null:
return $default(_that.eventId,_that.eventTitle,_that.zone,_that.days);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String eventId,  String eventTitle,  String zone,  List<AgendaDay> days)  $default,) {final _that = this;
switch (_that) {
case _Agenda():
return $default(_that.eventId,_that.eventTitle,_that.zone,_that.days);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String eventId,  String eventTitle,  String zone,  List<AgendaDay> days)?  $default,) {final _that = this;
switch (_that) {
case _Agenda() when $default != null:
return $default(_that.eventId,_that.eventTitle,_that.zone,_that.days);case _:
  return null;

}
}

}

/// @nodoc


class _Agenda implements Agenda {
  const _Agenda({required this.eventId, required this.eventTitle, required this.zone,  List<AgendaDay> days = const <AgendaDay>[]}): _days = days;
  

@override final  String eventId;
@override final  String eventTitle;
/// The event's IANA zone: its days and times are the venue's.
@override final  String zone;
 final  List<AgendaDay> _days;
@override@JsonKey() List<AgendaDay> get days {
  if (_days is EqualUnmodifiableListView) return _days;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_days);
}


/// Create a copy of Agenda
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AgendaCopyWith<_Agenda> get copyWith => __$AgendaCopyWithImpl<_Agenda>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Agenda&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.eventTitle, eventTitle) || other.eventTitle == eventTitle)&&(identical(other.zone, zone) || other.zone == zone)&&const DeepCollectionEquality().equals(other.days, _days));
}


@override
int get hashCode {
    return Object.hash(runtimeType,eventId,eventTitle,zone,const DeepCollectionEquality().hash(_days));
}

@override
String toString() {
    return 'Agenda(eventId: $eventId, eventTitle: $eventTitle, zone: $zone, days: $days)';
}


}

/// @nodoc
abstract mixin class _$AgendaCopyWith<$Res> implements $AgendaCopyWith<$Res> {
  factory _$AgendaCopyWith(_Agenda value, $Res Function(_Agenda) _then) = __$AgendaCopyWithImpl;
@override @useResult
$Res call({
 String eventId, String eventTitle, String zone, List<AgendaDay> days
});




}
/// @nodoc
class __$AgendaCopyWithImpl<$Res>
    implements _$AgendaCopyWith<$Res> {
  __$AgendaCopyWithImpl(this._self, this._then);

  final _Agenda _self;
  final $Res Function(_Agenda) _then;

/// Create a copy of Agenda
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? eventId = null,Object? eventTitle = null,Object? zone = null,Object? days = null,}) {
  return _then(_Agenda(
eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,eventTitle: null == eventTitle ? _self.eventTitle : eventTitle // ignore: cast_nullable_to_non_nullable
as String,zone: null == zone ? _self.zone : zone // ignore: cast_nullable_to_non_nullable
as String,days: null == days ? _self._days : days // ignore: cast_nullable_to_non_nullable
as List<AgendaDay>,
  ));
}


}

// dart format on
