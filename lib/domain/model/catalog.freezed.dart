// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalog.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Catalog {

 List<Organizer> get organizers; List<Event> get events; List<ScheduleSession> get sessions;
/// Create a copy of Catalog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatalogCopyWith<Catalog> get copyWith => _$CatalogCopyWithImpl<Catalog>(this as Catalog, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Catalog;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Catalog&&const DeepCollectionEquality().equals(other.organizers, _this.organizers)&&const DeepCollectionEquality().equals(other.events, _this.events)&&const DeepCollectionEquality().equals(other.sessions, _this.sessions));
}


@override
int get hashCode {
  final _this = this as Catalog;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.organizers),const DeepCollectionEquality().hash(_this.events),const DeepCollectionEquality().hash(_this.sessions));
}

@override
String toString() {
  final _this = this as Catalog;
  return 'Catalog(organizers: ${_this.organizers}, events: ${_this.events}, sessions: ${_this.sessions})';
}


}

/// @nodoc
abstract mixin class $CatalogCopyWith<$Res>  {
  factory $CatalogCopyWith(Catalog value, $Res Function(Catalog) _then) = _$CatalogCopyWithImpl;
@useResult
$Res call({
 List<Organizer> organizers, List<Event> events, List<ScheduleSession> sessions
});




}
/// @nodoc
class _$CatalogCopyWithImpl<$Res>
    implements $CatalogCopyWith<$Res> {
  _$CatalogCopyWithImpl(this._self, this._then);

  final Catalog _self;
  final $Res Function(Catalog) _then;

/// Create a copy of Catalog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? organizers = null,Object? events = null,Object? sessions = null,}) {
  return _then(Catalog(
organizers: null == organizers ? _self.organizers : organizers // ignore: cast_nullable_to_non_nullable
as List<Organizer>,events: null == events ? _self.events : events // ignore: cast_nullable_to_non_nullable
as List<Event>,sessions: null == sessions ? _self.sessions : sessions // ignore: cast_nullable_to_non_nullable
as List<ScheduleSession>,
  ));
}

}


/// Adds pattern-matching-related methods to [Catalog].
extension CatalogPatterns on Catalog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Catalog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Catalog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Catalog value)  $default,){
final _that = this;
switch (_that) {
case _Catalog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Catalog value)?  $default,){
final _that = this;
switch (_that) {
case _Catalog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Organizer> organizers,  List<Event> events,  List<ScheduleSession> sessions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Catalog() when $default != null:
return $default(_that.organizers,_that.events,_that.sessions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Organizer> organizers,  List<Event> events,  List<ScheduleSession> sessions)  $default,) {final _that = this;
switch (_that) {
case _Catalog():
return $default(_that.organizers,_that.events,_that.sessions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Organizer> organizers,  List<Event> events,  List<ScheduleSession> sessions)?  $default,) {final _that = this;
switch (_that) {
case _Catalog() when $default != null:
return $default(_that.organizers,_that.events,_that.sessions);case _:
  return null;

}
}

}

/// @nodoc


class _Catalog implements Catalog {
  const _Catalog({ List<Organizer> organizers = const <Organizer>[],  List<Event> events = const <Event>[],  List<ScheduleSession> sessions = const <ScheduleSession>[]}): _organizers = organizers,_events = events,_sessions = sessions;
  

 final  List<Organizer> _organizers;
@override@JsonKey() List<Organizer> get organizers {
  if (_organizers is EqualUnmodifiableListView) return _organizers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_organizers);
}

 final  List<Event> _events;
@override@JsonKey() List<Event> get events {
  if (_events is EqualUnmodifiableListView) return _events;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_events);
}

 final  List<ScheduleSession> _sessions;
@override@JsonKey() List<ScheduleSession> get sessions {
  if (_sessions is EqualUnmodifiableListView) return _sessions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sessions);
}


/// Create a copy of Catalog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CatalogCopyWith<_Catalog> get copyWith => __$CatalogCopyWithImpl<_Catalog>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Catalog&&const DeepCollectionEquality().equals(other.organizers, _organizers)&&const DeepCollectionEquality().equals(other.events, _events)&&const DeepCollectionEquality().equals(other.sessions, _sessions));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_organizers),const DeepCollectionEquality().hash(_events),const DeepCollectionEquality().hash(_sessions));
}

@override
String toString() {
    return 'Catalog(organizers: $organizers, events: $events, sessions: $sessions)';
}


}

/// @nodoc
abstract mixin class _$CatalogCopyWith<$Res> implements $CatalogCopyWith<$Res> {
  factory _$CatalogCopyWith(_Catalog value, $Res Function(_Catalog) _then) = __$CatalogCopyWithImpl;
@override @useResult
$Res call({
 List<Organizer> organizers, List<Event> events, List<ScheduleSession> sessions
});




}
/// @nodoc
class __$CatalogCopyWithImpl<$Res>
    implements _$CatalogCopyWith<$Res> {
  __$CatalogCopyWithImpl(this._self, this._then);

  final _Catalog _self;
  final $Res Function(_Catalog) _then;

/// Create a copy of Catalog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? organizers = null,Object? events = null,Object? sessions = null,}) {
  return _then(_Catalog(
organizers: null == organizers ? _self._organizers : organizers // ignore: cast_nullable_to_non_nullable
as List<Organizer>,events: null == events ? _self._events : events // ignore: cast_nullable_to_non_nullable
as List<Event>,sessions: null == sessions ? _self._sessions : sessions // ignore: cast_nullable_to_non_nullable
as List<ScheduleSession>,
  ));
}


}

// dart format on
