// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfileCounts {

/// Active tickets for events not over yet.
 int get upcomingTickets; int get savedEvents; int get organizersFollowed; int get sessionsBookmarked;
/// Create a copy of ProfileCounts
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileCountsCopyWith<ProfileCounts> get copyWith => _$ProfileCountsCopyWithImpl<ProfileCounts>(this as ProfileCounts, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ProfileCounts;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileCounts&&(identical(other.upcomingTickets, _this.upcomingTickets) || other.upcomingTickets == _this.upcomingTickets)&&(identical(other.savedEvents, _this.savedEvents) || other.savedEvents == _this.savedEvents)&&(identical(other.organizersFollowed, _this.organizersFollowed) || other.organizersFollowed == _this.organizersFollowed)&&(identical(other.sessionsBookmarked, _this.sessionsBookmarked) || other.sessionsBookmarked == _this.sessionsBookmarked));
}


@override
int get hashCode {
  final _this = this as ProfileCounts;
  return Object.hash(runtimeType,_this.upcomingTickets,_this.savedEvents,_this.organizersFollowed,_this.sessionsBookmarked);
}

@override
String toString() {
  final _this = this as ProfileCounts;
  return 'ProfileCounts(upcomingTickets: ${_this.upcomingTickets}, savedEvents: ${_this.savedEvents}, organizersFollowed: ${_this.organizersFollowed}, sessionsBookmarked: ${_this.sessionsBookmarked})';
}


}

/// @nodoc
abstract mixin class $ProfileCountsCopyWith<$Res>  {
  factory $ProfileCountsCopyWith(ProfileCounts value, $Res Function(ProfileCounts) _then) = _$ProfileCountsCopyWithImpl;
@useResult
$Res call({
 int upcomingTickets, int savedEvents, int organizersFollowed, int sessionsBookmarked
});




}
/// @nodoc
class _$ProfileCountsCopyWithImpl<$Res>
    implements $ProfileCountsCopyWith<$Res> {
  _$ProfileCountsCopyWithImpl(this._self, this._then);

  final ProfileCounts _self;
  final $Res Function(ProfileCounts) _then;

/// Create a copy of ProfileCounts
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? upcomingTickets = null,Object? savedEvents = null,Object? organizersFollowed = null,Object? sessionsBookmarked = null,}) {
  return _then(ProfileCounts(
upcomingTickets: null == upcomingTickets ? _self.upcomingTickets : upcomingTickets // ignore: cast_nullable_to_non_nullable
as int,savedEvents: null == savedEvents ? _self.savedEvents : savedEvents // ignore: cast_nullable_to_non_nullable
as int,organizersFollowed: null == organizersFollowed ? _self.organizersFollowed : organizersFollowed // ignore: cast_nullable_to_non_nullable
as int,sessionsBookmarked: null == sessionsBookmarked ? _self.sessionsBookmarked : sessionsBookmarked // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileCounts].
extension ProfileCountsPatterns on ProfileCounts {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileCounts value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileCounts() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileCounts value)  $default,){
final _that = this;
switch (_that) {
case _ProfileCounts():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileCounts value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileCounts() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int upcomingTickets,  int savedEvents,  int organizersFollowed,  int sessionsBookmarked)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileCounts() when $default != null:
return $default(_that.upcomingTickets,_that.savedEvents,_that.organizersFollowed,_that.sessionsBookmarked);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int upcomingTickets,  int savedEvents,  int organizersFollowed,  int sessionsBookmarked)  $default,) {final _that = this;
switch (_that) {
case _ProfileCounts():
return $default(_that.upcomingTickets,_that.savedEvents,_that.organizersFollowed,_that.sessionsBookmarked);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int upcomingTickets,  int savedEvents,  int organizersFollowed,  int sessionsBookmarked)?  $default,) {final _that = this;
switch (_that) {
case _ProfileCounts() when $default != null:
return $default(_that.upcomingTickets,_that.savedEvents,_that.organizersFollowed,_that.sessionsBookmarked);case _:
  return null;

}
}

}

/// @nodoc


class _ProfileCounts implements ProfileCounts {
  const _ProfileCounts({this.upcomingTickets = 0, this.savedEvents = 0, this.organizersFollowed = 0, this.sessionsBookmarked = 0});
  

/// Active tickets for events not over yet.
@override@JsonKey() final  int upcomingTickets;
@override@JsonKey() final  int savedEvents;
@override@JsonKey() final  int organizersFollowed;
@override@JsonKey() final  int sessionsBookmarked;

/// Create a copy of ProfileCounts
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileCountsCopyWith<_ProfileCounts> get copyWith => __$ProfileCountsCopyWithImpl<_ProfileCounts>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileCounts&&(identical(other.upcomingTickets, upcomingTickets) || other.upcomingTickets == upcomingTickets)&&(identical(other.savedEvents, savedEvents) || other.savedEvents == savedEvents)&&(identical(other.organizersFollowed, organizersFollowed) || other.organizersFollowed == organizersFollowed)&&(identical(other.sessionsBookmarked, sessionsBookmarked) || other.sessionsBookmarked == sessionsBookmarked));
}


@override
int get hashCode {
    return Object.hash(runtimeType,upcomingTickets,savedEvents,organizersFollowed,sessionsBookmarked);
}

@override
String toString() {
    return 'ProfileCounts(upcomingTickets: $upcomingTickets, savedEvents: $savedEvents, organizersFollowed: $organizersFollowed, sessionsBookmarked: $sessionsBookmarked)';
}


}

/// @nodoc
abstract mixin class _$ProfileCountsCopyWith<$Res> implements $ProfileCountsCopyWith<$Res> {
  factory _$ProfileCountsCopyWith(_ProfileCounts value, $Res Function(_ProfileCounts) _then) = __$ProfileCountsCopyWithImpl;
@override @useResult
$Res call({
 int upcomingTickets, int savedEvents, int organizersFollowed, int sessionsBookmarked
});




}
/// @nodoc
class __$ProfileCountsCopyWithImpl<$Res>
    implements _$ProfileCountsCopyWith<$Res> {
  __$ProfileCountsCopyWithImpl(this._self, this._then);

  final _ProfileCounts _self;
  final $Res Function(_ProfileCounts) _then;

/// Create a copy of ProfileCounts
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? upcomingTickets = null,Object? savedEvents = null,Object? organizersFollowed = null,Object? sessionsBookmarked = null,}) {
  return _then(_ProfileCounts(
upcomingTickets: null == upcomingTickets ? _self.upcomingTickets : upcomingTickets // ignore: cast_nullable_to_non_nullable
as int,savedEvents: null == savedEvents ? _self.savedEvents : savedEvents // ignore: cast_nullable_to_non_nullable
as int,organizersFollowed: null == organizersFollowed ? _self.organizersFollowed : organizersFollowed // ignore: cast_nullable_to_non_nullable
as int,sessionsBookmarked: null == sessionsBookmarked ? _self.sessionsBookmarked : sessionsBookmarked // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$OrganizerDetails {

 Organizer get organizer; bool get isFollowing; List<EventCardItem> get events;
/// Create a copy of OrganizerDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrganizerDetailsCopyWith<OrganizerDetails> get copyWith => _$OrganizerDetailsCopyWithImpl<OrganizerDetails>(this as OrganizerDetails, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OrganizerDetails;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrganizerDetails&&(identical(other.organizer, _this.organizer) || other.organizer == _this.organizer)&&(identical(other.isFollowing, _this.isFollowing) || other.isFollowing == _this.isFollowing)&&const DeepCollectionEquality().equals(other.events, _this.events));
}


@override
int get hashCode {
  final _this = this as OrganizerDetails;
  return Object.hash(runtimeType,_this.organizer,_this.isFollowing,const DeepCollectionEquality().hash(_this.events));
}

@override
String toString() {
  final _this = this as OrganizerDetails;
  return 'OrganizerDetails(organizer: ${_this.organizer}, isFollowing: ${_this.isFollowing}, events: ${_this.events})';
}


}

/// @nodoc
abstract mixin class $OrganizerDetailsCopyWith<$Res>  {
  factory $OrganizerDetailsCopyWith(OrganizerDetails value, $Res Function(OrganizerDetails) _then) = _$OrganizerDetailsCopyWithImpl;
@useResult
$Res call({
 Organizer organizer, bool isFollowing, List<EventCardItem> events
});


$OrganizerCopyWith<$Res> get organizer;

}
/// @nodoc
class _$OrganizerDetailsCopyWithImpl<$Res>
    implements $OrganizerDetailsCopyWith<$Res> {
  _$OrganizerDetailsCopyWithImpl(this._self, this._then);

  final OrganizerDetails _self;
  final $Res Function(OrganizerDetails) _then;

/// Create a copy of OrganizerDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? organizer = null,Object? isFollowing = null,Object? events = null,}) {
  return _then(OrganizerDetails(
organizer: null == organizer ? _self.organizer : organizer // ignore: cast_nullable_to_non_nullable
as Organizer,isFollowing: null == isFollowing ? _self.isFollowing : isFollowing // ignore: cast_nullable_to_non_nullable
as bool,events: null == events ? _self.events : events // ignore: cast_nullable_to_non_nullable
as List<EventCardItem>,
  ));
}
/// Create a copy of OrganizerDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrganizerCopyWith<$Res> get organizer {
  
  return $OrganizerCopyWith<$Res>(_self.organizer, (value) {
    return _then(_self.copyWith(organizer: value));
  });
}
}


/// Adds pattern-matching-related methods to [OrganizerDetails].
extension OrganizerDetailsPatterns on OrganizerDetails {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrganizerDetails value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrganizerDetails() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrganizerDetails value)  $default,){
final _that = this;
switch (_that) {
case _OrganizerDetails():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrganizerDetails value)?  $default,){
final _that = this;
switch (_that) {
case _OrganizerDetails() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Organizer organizer,  bool isFollowing,  List<EventCardItem> events)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrganizerDetails() when $default != null:
return $default(_that.organizer,_that.isFollowing,_that.events);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Organizer organizer,  bool isFollowing,  List<EventCardItem> events)  $default,) {final _that = this;
switch (_that) {
case _OrganizerDetails():
return $default(_that.organizer,_that.isFollowing,_that.events);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Organizer organizer,  bool isFollowing,  List<EventCardItem> events)?  $default,) {final _that = this;
switch (_that) {
case _OrganizerDetails() when $default != null:
return $default(_that.organizer,_that.isFollowing,_that.events);case _:
  return null;

}
}

}

/// @nodoc


class _OrganizerDetails implements OrganizerDetails {
  const _OrganizerDetails({required this.organizer, this.isFollowing = false,  List<EventCardItem> events = const <EventCardItem>[]}): _events = events;
  

@override final  Organizer organizer;
@override@JsonKey() final  bool isFollowing;
 final  List<EventCardItem> _events;
@override@JsonKey() List<EventCardItem> get events {
  if (_events is EqualUnmodifiableListView) return _events;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_events);
}


/// Create a copy of OrganizerDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrganizerDetailsCopyWith<_OrganizerDetails> get copyWith => __$OrganizerDetailsCopyWithImpl<_OrganizerDetails>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrganizerDetails&&(identical(other.organizer, organizer) || other.organizer == organizer)&&(identical(other.isFollowing, isFollowing) || other.isFollowing == isFollowing)&&const DeepCollectionEquality().equals(other.events, _events));
}


@override
int get hashCode {
    return Object.hash(runtimeType,organizer,isFollowing,const DeepCollectionEquality().hash(_events));
}

@override
String toString() {
    return 'OrganizerDetails(organizer: $organizer, isFollowing: $isFollowing, events: $events)';
}


}

/// @nodoc
abstract mixin class _$OrganizerDetailsCopyWith<$Res> implements $OrganizerDetailsCopyWith<$Res> {
  factory _$OrganizerDetailsCopyWith(_OrganizerDetails value, $Res Function(_OrganizerDetails) _then) = __$OrganizerDetailsCopyWithImpl;
@override @useResult
$Res call({
 Organizer organizer, bool isFollowing, List<EventCardItem> events
});


@override $OrganizerCopyWith<$Res> get organizer;

}
/// @nodoc
class __$OrganizerDetailsCopyWithImpl<$Res>
    implements _$OrganizerDetailsCopyWith<$Res> {
  __$OrganizerDetailsCopyWithImpl(this._self, this._then);

  final _OrganizerDetails _self;
  final $Res Function(_OrganizerDetails) _then;

/// Create a copy of OrganizerDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? organizer = null,Object? isFollowing = null,Object? events = null,}) {
  return _then(_OrganizerDetails(
organizer: null == organizer ? _self.organizer : organizer // ignore: cast_nullable_to_non_nullable
as Organizer,isFollowing: null == isFollowing ? _self.isFollowing : isFollowing // ignore: cast_nullable_to_non_nullable
as bool,events: null == events ? _self._events : events // ignore: cast_nullable_to_non_nullable
as List<EventCardItem>,
  ));
}

/// Create a copy of OrganizerDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrganizerCopyWith<$Res> get organizer {
  
  return $OrganizerCopyWith<$Res>(_self.organizer, (value) {
    return _then(_self.copyWith(organizer: value));
  });
}
}

/// @nodoc
mixin _$FollowedOrganizer {

 Organizer get organizer;/// Their soonest event that isn't over, if any.
 EventCardItem? get nextEvent;
/// Create a copy of FollowedOrganizer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FollowedOrganizerCopyWith<FollowedOrganizer> get copyWith => _$FollowedOrganizerCopyWithImpl<FollowedOrganizer>(this as FollowedOrganizer, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FollowedOrganizer;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FollowedOrganizer&&(identical(other.organizer, _this.organizer) || other.organizer == _this.organizer)&&(identical(other.nextEvent, _this.nextEvent) || other.nextEvent == _this.nextEvent));
}


@override
int get hashCode {
  final _this = this as FollowedOrganizer;
  return Object.hash(runtimeType,_this.organizer,_this.nextEvent);
}

@override
String toString() {
  final _this = this as FollowedOrganizer;
  return 'FollowedOrganizer(organizer: ${_this.organizer}, nextEvent: ${_this.nextEvent})';
}


}

/// @nodoc
abstract mixin class $FollowedOrganizerCopyWith<$Res>  {
  factory $FollowedOrganizerCopyWith(FollowedOrganizer value, $Res Function(FollowedOrganizer) _then) = _$FollowedOrganizerCopyWithImpl;
@useResult
$Res call({
 Organizer organizer, EventCardItem? nextEvent
});


$OrganizerCopyWith<$Res> get organizer;$EventCardItemCopyWith<$Res>? get nextEvent;

}
/// @nodoc
class _$FollowedOrganizerCopyWithImpl<$Res>
    implements $FollowedOrganizerCopyWith<$Res> {
  _$FollowedOrganizerCopyWithImpl(this._self, this._then);

  final FollowedOrganizer _self;
  final $Res Function(FollowedOrganizer) _then;

/// Create a copy of FollowedOrganizer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? organizer = null,Object? nextEvent = freezed,}) {
  return _then(FollowedOrganizer(
organizer: null == organizer ? _self.organizer : organizer // ignore: cast_nullable_to_non_nullable
as Organizer,nextEvent: freezed == nextEvent ? _self.nextEvent : nextEvent // ignore: cast_nullable_to_non_nullable
as EventCardItem?,
  ));
}
/// Create a copy of FollowedOrganizer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrganizerCopyWith<$Res> get organizer {
  
  return $OrganizerCopyWith<$Res>(_self.organizer, (value) {
    return _then(_self.copyWith(organizer: value));
  });
}/// Create a copy of FollowedOrganizer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventCardItemCopyWith<$Res>? get nextEvent {
    if (_self.nextEvent == null) {
    return null;
  }

  return $EventCardItemCopyWith<$Res>(_self.nextEvent!, (value) {
    return _then(_self.copyWith(nextEvent: value));
  });
}
}


/// Adds pattern-matching-related methods to [FollowedOrganizer].
extension FollowedOrganizerPatterns on FollowedOrganizer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FollowedOrganizer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FollowedOrganizer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FollowedOrganizer value)  $default,){
final _that = this;
switch (_that) {
case _FollowedOrganizer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FollowedOrganizer value)?  $default,){
final _that = this;
switch (_that) {
case _FollowedOrganizer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Organizer organizer,  EventCardItem? nextEvent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FollowedOrganizer() when $default != null:
return $default(_that.organizer,_that.nextEvent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Organizer organizer,  EventCardItem? nextEvent)  $default,) {final _that = this;
switch (_that) {
case _FollowedOrganizer():
return $default(_that.organizer,_that.nextEvent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Organizer organizer,  EventCardItem? nextEvent)?  $default,) {final _that = this;
switch (_that) {
case _FollowedOrganizer() when $default != null:
return $default(_that.organizer,_that.nextEvent);case _:
  return null;

}
}

}

/// @nodoc


class _FollowedOrganizer implements FollowedOrganizer {
  const _FollowedOrganizer({required this.organizer, this.nextEvent});
  

@override final  Organizer organizer;
/// Their soonest event that isn't over, if any.
@override final  EventCardItem? nextEvent;

/// Create a copy of FollowedOrganizer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FollowedOrganizerCopyWith<_FollowedOrganizer> get copyWith => __$FollowedOrganizerCopyWithImpl<_FollowedOrganizer>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FollowedOrganizer&&(identical(other.organizer, organizer) || other.organizer == organizer)&&(identical(other.nextEvent, nextEvent) || other.nextEvent == nextEvent));
}


@override
int get hashCode {
    return Object.hash(runtimeType,organizer,nextEvent);
}

@override
String toString() {
    return 'FollowedOrganizer(organizer: $organizer, nextEvent: $nextEvent)';
}


}

/// @nodoc
abstract mixin class _$FollowedOrganizerCopyWith<$Res> implements $FollowedOrganizerCopyWith<$Res> {
  factory _$FollowedOrganizerCopyWith(_FollowedOrganizer value, $Res Function(_FollowedOrganizer) _then) = __$FollowedOrganizerCopyWithImpl;
@override @useResult
$Res call({
 Organizer organizer, EventCardItem? nextEvent
});


@override $OrganizerCopyWith<$Res> get organizer;@override $EventCardItemCopyWith<$Res>? get nextEvent;

}
/// @nodoc
class __$FollowedOrganizerCopyWithImpl<$Res>
    implements _$FollowedOrganizerCopyWith<$Res> {
  __$FollowedOrganizerCopyWithImpl(this._self, this._then);

  final _FollowedOrganizer _self;
  final $Res Function(_FollowedOrganizer) _then;

/// Create a copy of FollowedOrganizer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? organizer = null,Object? nextEvent = freezed,}) {
  return _then(_FollowedOrganizer(
organizer: null == organizer ? _self.organizer : organizer // ignore: cast_nullable_to_non_nullable
as Organizer,nextEvent: freezed == nextEvent ? _self.nextEvent : nextEvent // ignore: cast_nullable_to_non_nullable
as EventCardItem?,
  ));
}

/// Create a copy of FollowedOrganizer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OrganizerCopyWith<$Res> get organizer {
  
  return $OrganizerCopyWith<$Res>(_self.organizer, (value) {
    return _then(_self.copyWith(organizer: value));
  });
}/// Create a copy of FollowedOrganizer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventCardItemCopyWith<$Res>? get nextEvent {
    if (_self.nextEvent == null) {
    return null;
  }

  return $EventCardItemCopyWith<$Res>(_self.nextEvent!, (value) {
    return _then(_self.copyWith(nextEvent: value));
  });
}
}

// dart format on
