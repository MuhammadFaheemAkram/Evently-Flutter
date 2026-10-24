// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discover_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DiscoverState {

 DiscoverStatus get status; List<EventCardItem> get featured; List<EventCardItem> get inYourCity; List<DayGroup<EventCardItem>> get upcoming;/// The category the upcoming list is filtered to; `null` is "All".
 EventCategory? get category;/// The preferred city; `null` is "Anywhere" (no "In your city").
 String? get city;/// When the lists were last worked out: what "upcoming" and "can I book
/// it" were judged against.
 DateTime? get now;/// The user's day at [now]: the upcoming list's "Today".
 CalendarDate? get today;/// Why the cache couldn't be filled ([DiscoverStatus.failed]).
 String? get errorMessage;/// A one-time SnackBar (offline on refresh, a failed save);
/// [messageSerial] makes each one distinct.
 String? get message; int get messageSerial;
/// Create a copy of DiscoverState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiscoverStateCopyWith<DiscoverState> get copyWith => _$DiscoverStateCopyWithImpl<DiscoverState>(this as DiscoverState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DiscoverState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscoverState&&(identical(other.status, _this.status) || other.status == _this.status)&&const DeepCollectionEquality().equals(other.featured, _this.featured)&&const DeepCollectionEquality().equals(other.inYourCity, _this.inYourCity)&&const DeepCollectionEquality().equals(other.upcoming, _this.upcoming)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.city, _this.city) || other.city == _this.city)&&(identical(other.now, _this.now) || other.now == _this.now)&&(identical(other.today, _this.today) || other.today == _this.today)&&(identical(other.errorMessage, _this.errorMessage) || other.errorMessage == _this.errorMessage)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.messageSerial, _this.messageSerial) || other.messageSerial == _this.messageSerial));
}


@override
int get hashCode {
  final _this = this as DiscoverState;
  return Object.hash(runtimeType,_this.status,const DeepCollectionEquality().hash(_this.featured),const DeepCollectionEquality().hash(_this.inYourCity),const DeepCollectionEquality().hash(_this.upcoming),_this.category,_this.city,_this.now,_this.today,_this.errorMessage,_this.message,_this.messageSerial);
}

@override
String toString() {
  final _this = this as DiscoverState;
  return 'DiscoverState(status: ${_this.status}, featured: ${_this.featured}, inYourCity: ${_this.inYourCity}, upcoming: ${_this.upcoming}, category: ${_this.category}, city: ${_this.city}, now: ${_this.now}, today: ${_this.today}, errorMessage: ${_this.errorMessage}, message: ${_this.message}, messageSerial: ${_this.messageSerial})';
}


}

/// @nodoc
abstract mixin class $DiscoverStateCopyWith<$Res>  {
  factory $DiscoverStateCopyWith(DiscoverState value, $Res Function(DiscoverState) _then) = _$DiscoverStateCopyWithImpl;
@useResult
$Res call({
 DiscoverStatus status, List<EventCardItem> featured, List<EventCardItem> inYourCity, List<DayGroup<EventCardItem>> upcoming, EventCategory? category, String? city, DateTime? now, CalendarDate? today, String? errorMessage, String? message, int messageSerial
});




}
/// @nodoc
class _$DiscoverStateCopyWithImpl<$Res>
    implements $DiscoverStateCopyWith<$Res> {
  _$DiscoverStateCopyWithImpl(this._self, this._then);

  final DiscoverState _self;
  final $Res Function(DiscoverState) _then;

/// Create a copy of DiscoverState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? featured = null,Object? inYourCity = null,Object? upcoming = null,Object? category = freezed,Object? city = freezed,Object? now = freezed,Object? today = freezed,Object? errorMessage = freezed,Object? message = freezed,Object? messageSerial = null,}) {
  return _then(DiscoverState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DiscoverStatus,featured: null == featured ? _self.featured : featured // ignore: cast_nullable_to_non_nullable
as List<EventCardItem>,inYourCity: null == inYourCity ? _self.inYourCity : inYourCity // ignore: cast_nullable_to_non_nullable
as List<EventCardItem>,upcoming: null == upcoming ? _self.upcoming : upcoming // ignore: cast_nullable_to_non_nullable
as List<DayGroup<EventCardItem>>,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as EventCategory?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,now: freezed == now ? _self.now : now // ignore: cast_nullable_to_non_nullable
as DateTime?,today: freezed == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as CalendarDate?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,messageSerial: null == messageSerial ? _self.messageSerial : messageSerial // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DiscoverState].
extension DiscoverStatePatterns on DiscoverState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiscoverState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiscoverState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiscoverState value)  $default,){
final _that = this;
switch (_that) {
case _DiscoverState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiscoverState value)?  $default,){
final _that = this;
switch (_that) {
case _DiscoverState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DiscoverStatus status,  List<EventCardItem> featured,  List<EventCardItem> inYourCity,  List<DayGroup<EventCardItem>> upcoming,  EventCategory? category,  String? city,  DateTime? now,  CalendarDate? today,  String? errorMessage,  String? message,  int messageSerial)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiscoverState() when $default != null:
return $default(_that.status,_that.featured,_that.inYourCity,_that.upcoming,_that.category,_that.city,_that.now,_that.today,_that.errorMessage,_that.message,_that.messageSerial);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DiscoverStatus status,  List<EventCardItem> featured,  List<EventCardItem> inYourCity,  List<DayGroup<EventCardItem>> upcoming,  EventCategory? category,  String? city,  DateTime? now,  CalendarDate? today,  String? errorMessage,  String? message,  int messageSerial)  $default,) {final _that = this;
switch (_that) {
case _DiscoverState():
return $default(_that.status,_that.featured,_that.inYourCity,_that.upcoming,_that.category,_that.city,_that.now,_that.today,_that.errorMessage,_that.message,_that.messageSerial);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DiscoverStatus status,  List<EventCardItem> featured,  List<EventCardItem> inYourCity,  List<DayGroup<EventCardItem>> upcoming,  EventCategory? category,  String? city,  DateTime? now,  CalendarDate? today,  String? errorMessage,  String? message,  int messageSerial)?  $default,) {final _that = this;
switch (_that) {
case _DiscoverState() when $default != null:
return $default(_that.status,_that.featured,_that.inYourCity,_that.upcoming,_that.category,_that.city,_that.now,_that.today,_that.errorMessage,_that.message,_that.messageSerial);case _:
  return null;

}
}

}

/// @nodoc


class _DiscoverState extends DiscoverState {
  const _DiscoverState({this.status = DiscoverStatus.loading,  List<EventCardItem> featured = const <EventCardItem>[],  List<EventCardItem> inYourCity = const <EventCardItem>[],  List<DayGroup<EventCardItem>> upcoming = const <DayGroup<EventCardItem>>[], this.category, this.city, this.now, this.today, this.errorMessage, this.message, this.messageSerial = 0}): _featured = featured,_inYourCity = inYourCity,_upcoming = upcoming,super._();
  

@override@JsonKey() final  DiscoverStatus status;
 final  List<EventCardItem> _featured;
@override@JsonKey() List<EventCardItem> get featured {
  if (_featured is EqualUnmodifiableListView) return _featured;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_featured);
}

 final  List<EventCardItem> _inYourCity;
@override@JsonKey() List<EventCardItem> get inYourCity {
  if (_inYourCity is EqualUnmodifiableListView) return _inYourCity;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_inYourCity);
}

 final  List<DayGroup<EventCardItem>> _upcoming;
@override@JsonKey() List<DayGroup<EventCardItem>> get upcoming {
  if (_upcoming is EqualUnmodifiableListView) return _upcoming;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_upcoming);
}

/// The category the upcoming list is filtered to; `null` is "All".
@override final  EventCategory? category;
/// The preferred city; `null` is "Anywhere" (no "In your city").
@override final  String? city;
/// When the lists were last worked out: what "upcoming" and "can I book
/// it" were judged against.
@override final  DateTime? now;
/// The user's day at [now]: the upcoming list's "Today".
@override final  CalendarDate? today;
/// Why the cache couldn't be filled ([DiscoverStatus.failed]).
@override final  String? errorMessage;
/// A one-time SnackBar (offline on refresh, a failed save);
/// [messageSerial] makes each one distinct.
@override final  String? message;
@override@JsonKey() final  int messageSerial;

/// Create a copy of DiscoverState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiscoverStateCopyWith<_DiscoverState> get copyWith => __$DiscoverStateCopyWithImpl<_DiscoverState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiscoverState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.featured, _featured)&&const DeepCollectionEquality().equals(other.inYourCity, _inYourCity)&&const DeepCollectionEquality().equals(other.upcoming, _upcoming)&&(identical(other.category, category) || other.category == category)&&(identical(other.city, city) || other.city == city)&&(identical(other.now, now) || other.now == now)&&(identical(other.today, today) || other.today == today)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.message, message) || other.message == message)&&(identical(other.messageSerial, messageSerial) || other.messageSerial == messageSerial));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_featured),const DeepCollectionEquality().hash(_inYourCity),const DeepCollectionEquality().hash(_upcoming),category,city,now,today,errorMessage,message,messageSerial);
}

@override
String toString() {
    return 'DiscoverState(status: $status, featured: $featured, inYourCity: $inYourCity, upcoming: $upcoming, category: $category, city: $city, now: $now, today: $today, errorMessage: $errorMessage, message: $message, messageSerial: $messageSerial)';
}


}

/// @nodoc
abstract mixin class _$DiscoverStateCopyWith<$Res> implements $DiscoverStateCopyWith<$Res> {
  factory _$DiscoverStateCopyWith(_DiscoverState value, $Res Function(_DiscoverState) _then) = __$DiscoverStateCopyWithImpl;
@override @useResult
$Res call({
 DiscoverStatus status, List<EventCardItem> featured, List<EventCardItem> inYourCity, List<DayGroup<EventCardItem>> upcoming, EventCategory? category, String? city, DateTime? now, CalendarDate? today, String? errorMessage, String? message, int messageSerial
});




}
/// @nodoc
class __$DiscoverStateCopyWithImpl<$Res>
    implements _$DiscoverStateCopyWith<$Res> {
  __$DiscoverStateCopyWithImpl(this._self, this._then);

  final _DiscoverState _self;
  final $Res Function(_DiscoverState) _then;

/// Create a copy of DiscoverState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? featured = null,Object? inYourCity = null,Object? upcoming = null,Object? category = freezed,Object? city = freezed,Object? now = freezed,Object? today = freezed,Object? errorMessage = freezed,Object? message = freezed,Object? messageSerial = null,}) {
  return _then(_DiscoverState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DiscoverStatus,featured: null == featured ? _self._featured : featured // ignore: cast_nullable_to_non_nullable
as List<EventCardItem>,inYourCity: null == inYourCity ? _self._inYourCity : inYourCity // ignore: cast_nullable_to_non_nullable
as List<EventCardItem>,upcoming: null == upcoming ? _self._upcoming : upcoming // ignore: cast_nullable_to_non_nullable
as List<DayGroup<EventCardItem>>,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as EventCategory?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,now: freezed == now ? _self.now : now // ignore: cast_nullable_to_non_nullable
as DateTime?,today: freezed == today ? _self.today : today // ignore: cast_nullable_to_non_nullable
as CalendarDate?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,messageSerial: null == messageSerial ? _self.messageSerial : messageSerial // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
