// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SavedEvent {

 String get eventId; DateTime get savedAt;
/// Create a copy of SavedEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavedEventCopyWith<SavedEvent> get copyWith => _$SavedEventCopyWithImpl<SavedEvent>(this as SavedEvent, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SavedEvent;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavedEvent&&(identical(other.eventId, _this.eventId) || other.eventId == _this.eventId)&&(identical(other.savedAt, _this.savedAt) || other.savedAt == _this.savedAt));
}


@override
int get hashCode {
  final _this = this as SavedEvent;
  return Object.hash(runtimeType,_this.eventId,_this.savedAt);
}

@override
String toString() {
  final _this = this as SavedEvent;
  return 'SavedEvent(eventId: ${_this.eventId}, savedAt: ${_this.savedAt})';
}


}

/// @nodoc
abstract mixin class $SavedEventCopyWith<$Res>  {
  factory $SavedEventCopyWith(SavedEvent value, $Res Function(SavedEvent) _then) = _$SavedEventCopyWithImpl;
@useResult
$Res call({
 String eventId, DateTime savedAt
});




}
/// @nodoc
class _$SavedEventCopyWithImpl<$Res>
    implements $SavedEventCopyWith<$Res> {
  _$SavedEventCopyWithImpl(this._self, this._then);

  final SavedEvent _self;
  final $Res Function(SavedEvent) _then;

/// Create a copy of SavedEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? eventId = null,Object? savedAt = null,}) {
  return _then(SavedEvent(
eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,savedAt: null == savedAt ? _self.savedAt : savedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SavedEvent].
extension SavedEventPatterns on SavedEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SavedEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SavedEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SavedEvent value)  $default,){
final _that = this;
switch (_that) {
case _SavedEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SavedEvent value)?  $default,){
final _that = this;
switch (_that) {
case _SavedEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String eventId,  DateTime savedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SavedEvent() when $default != null:
return $default(_that.eventId,_that.savedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String eventId,  DateTime savedAt)  $default,) {final _that = this;
switch (_that) {
case _SavedEvent():
return $default(_that.eventId,_that.savedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String eventId,  DateTime savedAt)?  $default,) {final _that = this;
switch (_that) {
case _SavedEvent() when $default != null:
return $default(_that.eventId,_that.savedAt);case _:
  return null;

}
}

}

/// @nodoc


class _SavedEvent implements SavedEvent {
  const _SavedEvent({required this.eventId, required this.savedAt});
  

@override final  String eventId;
@override final  DateTime savedAt;

/// Create a copy of SavedEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SavedEventCopyWith<_SavedEvent> get copyWith => __$SavedEventCopyWithImpl<_SavedEvent>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SavedEvent&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.savedAt, savedAt) || other.savedAt == savedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,eventId,savedAt);
}

@override
String toString() {
    return 'SavedEvent(eventId: $eventId, savedAt: $savedAt)';
}


}

/// @nodoc
abstract mixin class _$SavedEventCopyWith<$Res> implements $SavedEventCopyWith<$Res> {
  factory _$SavedEventCopyWith(_SavedEvent value, $Res Function(_SavedEvent) _then) = __$SavedEventCopyWithImpl;
@override @useResult
$Res call({
 String eventId, DateTime savedAt
});




}
/// @nodoc
class __$SavedEventCopyWithImpl<$Res>
    implements _$SavedEventCopyWith<$Res> {
  __$SavedEventCopyWithImpl(this._self, this._then);

  final _SavedEvent _self;
  final $Res Function(_SavedEvent) _then;

/// Create a copy of SavedEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? eventId = null,Object? savedAt = null,}) {
  return _then(_SavedEvent(
eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,savedAt: null == savedAt ? _self.savedAt : savedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
mixin _$SessionBookmark {

 String get sessionId; DateTime get createdAt;
/// Create a copy of SessionBookmark
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionBookmarkCopyWith<SessionBookmark> get copyWith => _$SessionBookmarkCopyWithImpl<SessionBookmark>(this as SessionBookmark, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SessionBookmark;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionBookmark&&(identical(other.sessionId, _this.sessionId) || other.sessionId == _this.sessionId)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}


@override
int get hashCode {
  final _this = this as SessionBookmark;
  return Object.hash(runtimeType,_this.sessionId,_this.createdAt);
}

@override
String toString() {
  final _this = this as SessionBookmark;
  return 'SessionBookmark(sessionId: ${_this.sessionId}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $SessionBookmarkCopyWith<$Res>  {
  factory $SessionBookmarkCopyWith(SessionBookmark value, $Res Function(SessionBookmark) _then) = _$SessionBookmarkCopyWithImpl;
@useResult
$Res call({
 String sessionId, DateTime createdAt
});




}
/// @nodoc
class _$SessionBookmarkCopyWithImpl<$Res>
    implements $SessionBookmarkCopyWith<$Res> {
  _$SessionBookmarkCopyWithImpl(this._self, this._then);

  final SessionBookmark _self;
  final $Res Function(SessionBookmark) _then;

/// Create a copy of SessionBookmark
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? createdAt = null,}) {
  return _then(SessionBookmark(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionBookmark].
extension SessionBookmarkPatterns on SessionBookmark {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionBookmark value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionBookmark() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionBookmark value)  $default,){
final _that = this;
switch (_that) {
case _SessionBookmark():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionBookmark value)?  $default,){
final _that = this;
switch (_that) {
case _SessionBookmark() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sessionId,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionBookmark() when $default != null:
return $default(_that.sessionId,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sessionId,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _SessionBookmark():
return $default(_that.sessionId,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sessionId,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _SessionBookmark() when $default != null:
return $default(_that.sessionId,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _SessionBookmark implements SessionBookmark {
  const _SessionBookmark({required this.sessionId, required this.createdAt});
  

@override final  String sessionId;
@override final  DateTime createdAt;

/// Create a copy of SessionBookmark
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionBookmarkCopyWith<_SessionBookmark> get copyWith => __$SessionBookmarkCopyWithImpl<_SessionBookmark>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionBookmark&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,sessionId,createdAt);
}

@override
String toString() {
    return 'SessionBookmark(sessionId: $sessionId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$SessionBookmarkCopyWith<$Res> implements $SessionBookmarkCopyWith<$Res> {
  factory _$SessionBookmarkCopyWith(_SessionBookmark value, $Res Function(_SessionBookmark) _then) = __$SessionBookmarkCopyWithImpl;
@override @useResult
$Res call({
 String sessionId, DateTime createdAt
});




}
/// @nodoc
class __$SessionBookmarkCopyWithImpl<$Res>
    implements _$SessionBookmarkCopyWith<$Res> {
  __$SessionBookmarkCopyWithImpl(this._self, this._then);

  final _SessionBookmark _self;
  final $Res Function(_SessionBookmark) _then;

/// Create a copy of SessionBookmark
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? createdAt = null,}) {
  return _then(_SessionBookmark(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
mixin _$Follow {

 String get organizerId; DateTime get followedAt;
/// Create a copy of Follow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FollowCopyWith<Follow> get copyWith => _$FollowCopyWithImpl<Follow>(this as Follow, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Follow;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Follow&&(identical(other.organizerId, _this.organizerId) || other.organizerId == _this.organizerId)&&(identical(other.followedAt, _this.followedAt) || other.followedAt == _this.followedAt));
}


@override
int get hashCode {
  final _this = this as Follow;
  return Object.hash(runtimeType,_this.organizerId,_this.followedAt);
}

@override
String toString() {
  final _this = this as Follow;
  return 'Follow(organizerId: ${_this.organizerId}, followedAt: ${_this.followedAt})';
}


}

/// @nodoc
abstract mixin class $FollowCopyWith<$Res>  {
  factory $FollowCopyWith(Follow value, $Res Function(Follow) _then) = _$FollowCopyWithImpl;
@useResult
$Res call({
 String organizerId, DateTime followedAt
});




}
/// @nodoc
class _$FollowCopyWithImpl<$Res>
    implements $FollowCopyWith<$Res> {
  _$FollowCopyWithImpl(this._self, this._then);

  final Follow _self;
  final $Res Function(Follow) _then;

/// Create a copy of Follow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? organizerId = null,Object? followedAt = null,}) {
  return _then(Follow(
organizerId: null == organizerId ? _self.organizerId : organizerId // ignore: cast_nullable_to_non_nullable
as String,followedAt: null == followedAt ? _self.followedAt : followedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Follow].
extension FollowPatterns on Follow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Follow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Follow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Follow value)  $default,){
final _that = this;
switch (_that) {
case _Follow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Follow value)?  $default,){
final _that = this;
switch (_that) {
case _Follow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String organizerId,  DateTime followedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Follow() when $default != null:
return $default(_that.organizerId,_that.followedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String organizerId,  DateTime followedAt)  $default,) {final _that = this;
switch (_that) {
case _Follow():
return $default(_that.organizerId,_that.followedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String organizerId,  DateTime followedAt)?  $default,) {final _that = this;
switch (_that) {
case _Follow() when $default != null:
return $default(_that.organizerId,_that.followedAt);case _:
  return null;

}
}

}

/// @nodoc


class _Follow implements Follow {
  const _Follow({required this.organizerId, required this.followedAt});
  

@override final  String organizerId;
@override final  DateTime followedAt;

/// Create a copy of Follow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FollowCopyWith<_Follow> get copyWith => __$FollowCopyWithImpl<_Follow>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Follow&&(identical(other.organizerId, organizerId) || other.organizerId == organizerId)&&(identical(other.followedAt, followedAt) || other.followedAt == followedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,organizerId,followedAt);
}

@override
String toString() {
    return 'Follow(organizerId: $organizerId, followedAt: $followedAt)';
}


}

/// @nodoc
abstract mixin class _$FollowCopyWith<$Res> implements $FollowCopyWith<$Res> {
  factory _$FollowCopyWith(_Follow value, $Res Function(_Follow) _then) = __$FollowCopyWithImpl;
@override @useResult
$Res call({
 String organizerId, DateTime followedAt
});




}
/// @nodoc
class __$FollowCopyWithImpl<$Res>
    implements _$FollowCopyWith<$Res> {
  __$FollowCopyWithImpl(this._self, this._then);

  final _Follow _self;
  final $Res Function(_Follow) _then;

/// Create a copy of Follow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? organizerId = null,Object? followedAt = null,}) {
  return _then(_Follow(
organizerId: null == organizerId ? _self.organizerId : organizerId // ignore: cast_nullable_to_non_nullable
as String,followedAt: null == followedAt ? _self.followedAt : followedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
mixin _$UserData {

 UserProfile? get profile; List<SavedEvent> get saved; List<Ticket> get tickets; List<SessionBookmark> get bookmarks; List<Follow> get follows;
/// Create a copy of UserData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserDataCopyWith<UserData> get copyWith => _$UserDataCopyWithImpl<UserData>(this as UserData, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as UserData;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserData&&(identical(other.profile, _this.profile) || other.profile == _this.profile)&&const DeepCollectionEquality().equals(other.saved, _this.saved)&&const DeepCollectionEquality().equals(other.tickets, _this.tickets)&&const DeepCollectionEquality().equals(other.bookmarks, _this.bookmarks)&&const DeepCollectionEquality().equals(other.follows, _this.follows));
}


@override
int get hashCode {
  final _this = this as UserData;
  return Object.hash(runtimeType,_this.profile,const DeepCollectionEquality().hash(_this.saved),const DeepCollectionEquality().hash(_this.tickets),const DeepCollectionEquality().hash(_this.bookmarks),const DeepCollectionEquality().hash(_this.follows));
}

@override
String toString() {
  final _this = this as UserData;
  return 'UserData(profile: ${_this.profile}, saved: ${_this.saved}, tickets: ${_this.tickets}, bookmarks: ${_this.bookmarks}, follows: ${_this.follows})';
}


}

/// @nodoc
abstract mixin class $UserDataCopyWith<$Res>  {
  factory $UserDataCopyWith(UserData value, $Res Function(UserData) _then) = _$UserDataCopyWithImpl;
@useResult
$Res call({
 UserProfile? profile, List<SavedEvent> saved, List<Ticket> tickets, List<SessionBookmark> bookmarks, List<Follow> follows
});


$UserProfileCopyWith<$Res>? get profile;

}
/// @nodoc
class _$UserDataCopyWithImpl<$Res>
    implements $UserDataCopyWith<$Res> {
  _$UserDataCopyWithImpl(this._self, this._then);

  final UserData _self;
  final $Res Function(UserData) _then;

/// Create a copy of UserData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? profile = freezed,Object? saved = null,Object? tickets = null,Object? bookmarks = null,Object? follows = null,}) {
  return _then(UserData(
profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as UserProfile?,saved: null == saved ? _self.saved : saved // ignore: cast_nullable_to_non_nullable
as List<SavedEvent>,tickets: null == tickets ? _self.tickets : tickets // ignore: cast_nullable_to_non_nullable
as List<Ticket>,bookmarks: null == bookmarks ? _self.bookmarks : bookmarks // ignore: cast_nullable_to_non_nullable
as List<SessionBookmark>,follows: null == follows ? _self.follows : follows // ignore: cast_nullable_to_non_nullable
as List<Follow>,
  ));
}
/// Create a copy of UserData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserProfileCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $UserProfileCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}


/// Adds pattern-matching-related methods to [UserData].
extension UserDataPatterns on UserData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserData value)  $default,){
final _that = this;
switch (_that) {
case _UserData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserData value)?  $default,){
final _that = this;
switch (_that) {
case _UserData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UserProfile? profile,  List<SavedEvent> saved,  List<Ticket> tickets,  List<SessionBookmark> bookmarks,  List<Follow> follows)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserData() when $default != null:
return $default(_that.profile,_that.saved,_that.tickets,_that.bookmarks,_that.follows);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UserProfile? profile,  List<SavedEvent> saved,  List<Ticket> tickets,  List<SessionBookmark> bookmarks,  List<Follow> follows)  $default,) {final _that = this;
switch (_that) {
case _UserData():
return $default(_that.profile,_that.saved,_that.tickets,_that.bookmarks,_that.follows);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UserProfile? profile,  List<SavedEvent> saved,  List<Ticket> tickets,  List<SessionBookmark> bookmarks,  List<Follow> follows)?  $default,) {final _that = this;
switch (_that) {
case _UserData() when $default != null:
return $default(_that.profile,_that.saved,_that.tickets,_that.bookmarks,_that.follows);case _:
  return null;

}
}

}

/// @nodoc


class _UserData implements UserData {
  const _UserData({this.profile,  List<SavedEvent> saved = const <SavedEvent>[],  List<Ticket> tickets = const <Ticket>[],  List<SessionBookmark> bookmarks = const <SessionBookmark>[],  List<Follow> follows = const <Follow>[]}): _saved = saved,_tickets = tickets,_bookmarks = bookmarks,_follows = follows;
  

@override final  UserProfile? profile;
 final  List<SavedEvent> _saved;
@override@JsonKey() List<SavedEvent> get saved {
  if (_saved is EqualUnmodifiableListView) return _saved;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_saved);
}

 final  List<Ticket> _tickets;
@override@JsonKey() List<Ticket> get tickets {
  if (_tickets is EqualUnmodifiableListView) return _tickets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tickets);
}

 final  List<SessionBookmark> _bookmarks;
@override@JsonKey() List<SessionBookmark> get bookmarks {
  if (_bookmarks is EqualUnmodifiableListView) return _bookmarks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bookmarks);
}

 final  List<Follow> _follows;
@override@JsonKey() List<Follow> get follows {
  if (_follows is EqualUnmodifiableListView) return _follows;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_follows);
}


/// Create a copy of UserData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserDataCopyWith<_UserData> get copyWith => __$UserDataCopyWithImpl<_UserData>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserData&&(identical(other.profile, profile) || other.profile == profile)&&const DeepCollectionEquality().equals(other.saved, _saved)&&const DeepCollectionEquality().equals(other.tickets, _tickets)&&const DeepCollectionEquality().equals(other.bookmarks, _bookmarks)&&const DeepCollectionEquality().equals(other.follows, _follows));
}


@override
int get hashCode {
    return Object.hash(runtimeType,profile,const DeepCollectionEquality().hash(_saved),const DeepCollectionEquality().hash(_tickets),const DeepCollectionEquality().hash(_bookmarks),const DeepCollectionEquality().hash(_follows));
}

@override
String toString() {
    return 'UserData(profile: $profile, saved: $saved, tickets: $tickets, bookmarks: $bookmarks, follows: $follows)';
}


}

/// @nodoc
abstract mixin class _$UserDataCopyWith<$Res> implements $UserDataCopyWith<$Res> {
  factory _$UserDataCopyWith(_UserData value, $Res Function(_UserData) _then) = __$UserDataCopyWithImpl;
@override @useResult
$Res call({
 UserProfile? profile, List<SavedEvent> saved, List<Ticket> tickets, List<SessionBookmark> bookmarks, List<Follow> follows
});


@override $UserProfileCopyWith<$Res>? get profile;

}
/// @nodoc
class __$UserDataCopyWithImpl<$Res>
    implements _$UserDataCopyWith<$Res> {
  __$UserDataCopyWithImpl(this._self, this._then);

  final _UserData _self;
  final $Res Function(_UserData) _then;

/// Create a copy of UserData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? profile = freezed,Object? saved = null,Object? tickets = null,Object? bookmarks = null,Object? follows = null,}) {
  return _then(_UserData(
profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as UserProfile?,saved: null == saved ? _self._saved : saved // ignore: cast_nullable_to_non_nullable
as List<SavedEvent>,tickets: null == tickets ? _self._tickets : tickets // ignore: cast_nullable_to_non_nullable
as List<Ticket>,bookmarks: null == bookmarks ? _self._bookmarks : bookmarks // ignore: cast_nullable_to_non_nullable
as List<SessionBookmark>,follows: null == follows ? _self._follows : follows // ignore: cast_nullable_to_non_nullable
as List<Follow>,
  ));
}

/// Create a copy of UserData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserProfileCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $UserProfileCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}

// dart format on
