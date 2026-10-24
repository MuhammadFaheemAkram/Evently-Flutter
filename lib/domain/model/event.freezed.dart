// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EventLocation {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is EventLocation);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'EventLocation()';
}


}

/// @nodoc
class $EventLocationCopyWith<$Res>  {
$EventLocationCopyWith(EventLocation _, $Res Function(EventLocation) __);
}


/// Adds pattern-matching-related methods to [EventLocation].
extension EventLocationPatterns on EventLocation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( Venue value)?  venue,TResult Function( Online value)?  online,required TResult orElse(),}){
final _that = this;
switch (_that) {
case Venue() when venue != null:
return venue(_that);case Online() when online != null:
return online(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( Venue value)  venue,required TResult Function( Online value)  online,}){
final _that = this;
switch (_that) {
case Venue():
return venue(_that);case Online():
return online(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( Venue value)?  venue,TResult? Function( Online value)?  online,}){
final _that = this;
switch (_that) {
case Venue() when venue != null:
return venue(_that);case Online() when online != null:
return online(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String name,  String address,  String city)?  venue,TResult Function( Uri joinUrl)?  online,required TResult orElse(),}) {final _that = this;
switch (_that) {
case Venue() when venue != null:
return venue(_that.name,_that.address,_that.city);case Online() when online != null:
return online(_that.joinUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String name,  String address,  String city)  venue,required TResult Function( Uri joinUrl)  online,}) {final _that = this;
switch (_that) {
case Venue():
return venue(_that.name,_that.address,_that.city);case Online():
return online(_that.joinUrl);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String name,  String address,  String city)?  venue,TResult? Function( Uri joinUrl)?  online,}) {final _that = this;
switch (_that) {
case Venue() when venue != null:
return venue(_that.name,_that.address,_that.city);case Online() when online != null:
return online(_that.joinUrl);case _:
  return null;

}
}

}

/// @nodoc


class Venue implements EventLocation {
  const Venue({required this.name, required this.address, required this.city});
  

 final  String name;
 final  String address;
 final  String city;

/// Create a copy of EventLocation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VenueCopyWith<Venue> get copyWith => _$VenueCopyWithImpl<Venue>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is Venue&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.city, city) || other.city == city));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name,address,city);
}

@override
String toString() {
    return 'EventLocation.venue(name: $name, address: $address, city: $city)';
}


}

/// @nodoc
abstract mixin class $VenueCopyWith<$Res> implements $EventLocationCopyWith<$Res> {
  factory $VenueCopyWith(Venue value, $Res Function(Venue) _then) = _$VenueCopyWithImpl;
@useResult
$Res call({
 String name, String address, String city
});




}
/// @nodoc
class _$VenueCopyWithImpl<$Res>
    implements $VenueCopyWith<$Res> {
  _$VenueCopyWithImpl(this._self, this._then);

  final Venue _self;
  final $Res Function(Venue) _then;

/// Create a copy of EventLocation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? name = null,Object? address = null,Object? city = null,}) {
  return _then(Venue(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class Online implements EventLocation {
  const Online({required this.joinUrl});
  

 final  Uri joinUrl;

/// Create a copy of EventLocation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnlineCopyWith<Online> get copyWith => _$OnlineCopyWithImpl<Online>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is Online&&(identical(other.joinUrl, joinUrl) || other.joinUrl == joinUrl));
}


@override
int get hashCode {
    return Object.hash(runtimeType,joinUrl);
}

@override
String toString() {
    return 'EventLocation.online(joinUrl: $joinUrl)';
}


}

/// @nodoc
abstract mixin class $OnlineCopyWith<$Res> implements $EventLocationCopyWith<$Res> {
  factory $OnlineCopyWith(Online value, $Res Function(Online) _then) = _$OnlineCopyWithImpl;
@useResult
$Res call({
 Uri joinUrl
});




}
/// @nodoc
class _$OnlineCopyWithImpl<$Res>
    implements $OnlineCopyWith<$Res> {
  _$OnlineCopyWithImpl(this._self, this._then);

  final Online _self;
  final $Res Function(Online) _then;

/// Create a copy of EventLocation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? joinUrl = null,}) {
  return _then(Online(
joinUrl: null == joinUrl ? _self.joinUrl : joinUrl // ignore: cast_nullable_to_non_nullable
as Uri,
  ));
}


}

/// @nodoc
mixin _$TicketOffer {

 TicketType get type;/// In the currency's minor unit (pence, cents, paisa): money is never a
/// `double`.
 int get priceMinor;/// ISO 4217 ("GBP").
 String get currency; int get capacity;/// Places left, as the server last said.
 int get remaining;
/// Create a copy of TicketOffer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketOfferCopyWith<TicketOffer> get copyWith => _$TicketOfferCopyWithImpl<TicketOffer>(this as TicketOffer, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TicketOffer;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketOffer&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.priceMinor, _this.priceMinor) || other.priceMinor == _this.priceMinor)&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.capacity, _this.capacity) || other.capacity == _this.capacity)&&(identical(other.remaining, _this.remaining) || other.remaining == _this.remaining));
}


@override
int get hashCode {
  final _this = this as TicketOffer;
  return Object.hash(runtimeType,_this.type,_this.priceMinor,_this.currency,_this.capacity,_this.remaining);
}

@override
String toString() {
  final _this = this as TicketOffer;
  return 'TicketOffer(type: ${_this.type}, priceMinor: ${_this.priceMinor}, currency: ${_this.currency}, capacity: ${_this.capacity}, remaining: ${_this.remaining})';
}


}

/// @nodoc
abstract mixin class $TicketOfferCopyWith<$Res>  {
  factory $TicketOfferCopyWith(TicketOffer value, $Res Function(TicketOffer) _then) = _$TicketOfferCopyWithImpl;
@useResult
$Res call({
 TicketType type, int priceMinor, String currency, int capacity, int remaining
});




}
/// @nodoc
class _$TicketOfferCopyWithImpl<$Res>
    implements $TicketOfferCopyWith<$Res> {
  _$TicketOfferCopyWithImpl(this._self, this._then);

  final TicketOffer _self;
  final $Res Function(TicketOffer) _then;

/// Create a copy of TicketOffer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? priceMinor = null,Object? currency = null,Object? capacity = null,Object? remaining = null,}) {
  return _then(TicketOffer(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TicketType,priceMinor: null == priceMinor ? _self.priceMinor : priceMinor // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,capacity: null == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int,remaining: null == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TicketOffer].
extension TicketOfferPatterns on TicketOffer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TicketOffer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TicketOffer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TicketOffer value)  $default,){
final _that = this;
switch (_that) {
case _TicketOffer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TicketOffer value)?  $default,){
final _that = this;
switch (_that) {
case _TicketOffer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TicketType type,  int priceMinor,  String currency,  int capacity,  int remaining)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TicketOffer() when $default != null:
return $default(_that.type,_that.priceMinor,_that.currency,_that.capacity,_that.remaining);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TicketType type,  int priceMinor,  String currency,  int capacity,  int remaining)  $default,) {final _that = this;
switch (_that) {
case _TicketOffer():
return $default(_that.type,_that.priceMinor,_that.currency,_that.capacity,_that.remaining);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TicketType type,  int priceMinor,  String currency,  int capacity,  int remaining)?  $default,) {final _that = this;
switch (_that) {
case _TicketOffer() when $default != null:
return $default(_that.type,_that.priceMinor,_that.currency,_that.capacity,_that.remaining);case _:
  return null;

}
}

}

/// @nodoc


class _TicketOffer extends TicketOffer {
  const _TicketOffer({required this.type, required this.priceMinor, required this.currency, required this.capacity, required this.remaining}): super._();
  

@override final  TicketType type;
/// In the currency's minor unit (pence, cents, paisa): money is never a
/// `double`.
@override final  int priceMinor;
/// ISO 4217 ("GBP").
@override final  String currency;
@override final  int capacity;
/// Places left, as the server last said.
@override final  int remaining;

/// Create a copy of TicketOffer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TicketOfferCopyWith<_TicketOffer> get copyWith => __$TicketOfferCopyWithImpl<_TicketOffer>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TicketOffer&&(identical(other.type, type) || other.type == type)&&(identical(other.priceMinor, priceMinor) || other.priceMinor == priceMinor)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.remaining, remaining) || other.remaining == remaining));
}


@override
int get hashCode {
    return Object.hash(runtimeType,type,priceMinor,currency,capacity,remaining);
}

@override
String toString() {
    return 'TicketOffer(type: $type, priceMinor: $priceMinor, currency: $currency, capacity: $capacity, remaining: $remaining)';
}


}

/// @nodoc
abstract mixin class _$TicketOfferCopyWith<$Res> implements $TicketOfferCopyWith<$Res> {
  factory _$TicketOfferCopyWith(_TicketOffer value, $Res Function(_TicketOffer) _then) = __$TicketOfferCopyWithImpl;
@override @useResult
$Res call({
 TicketType type, int priceMinor, String currency, int capacity, int remaining
});




}
/// @nodoc
class __$TicketOfferCopyWithImpl<$Res>
    implements _$TicketOfferCopyWith<$Res> {
  __$TicketOfferCopyWithImpl(this._self, this._then);

  final _TicketOffer _self;
  final $Res Function(_TicketOffer) _then;

/// Create a copy of TicketOffer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? priceMinor = null,Object? currency = null,Object? capacity = null,Object? remaining = null,}) {
  return _then(_TicketOffer(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TicketType,priceMinor: null == priceMinor ? _self.priceMinor : priceMinor // ignore: cast_nullable_to_non_nullable
as int,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,capacity: null == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int,remaining: null == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$Event {

 String get id; String get title; String get description; EventCategory get category; String get organizerId; EventTime get time; EventLocation get location; bool get featured;/// People going, and the places in all, as the server counts them.
 int get attendeeCount; int get capacity; EventStatus get status;/// When a moved event used to start (UTC).
 DateTime? get previousStart;/// Its ticket types, in the order the server lists them.
 List<TicketOffer> get offers;
/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventCopyWith<Event> get copyWith => _$EventCopyWithImpl<Event>(this as Event, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Event;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Event&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.organizerId, _this.organizerId) || other.organizerId == _this.organizerId)&&(identical(other.time, _this.time) || other.time == _this.time)&&(identical(other.location, _this.location) || other.location == _this.location)&&(identical(other.featured, _this.featured) || other.featured == _this.featured)&&(identical(other.attendeeCount, _this.attendeeCount) || other.attendeeCount == _this.attendeeCount)&&(identical(other.capacity, _this.capacity) || other.capacity == _this.capacity)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.previousStart, _this.previousStart) || other.previousStart == _this.previousStart)&&const DeepCollectionEquality().equals(other.offers, _this.offers));
}


@override
int get hashCode {
  final _this = this as Event;
  return Object.hash(runtimeType,_this.id,_this.title,_this.description,_this.category,_this.organizerId,_this.time,_this.location,_this.featured,_this.attendeeCount,_this.capacity,_this.status,_this.previousStart,const DeepCollectionEquality().hash(_this.offers));
}

@override
String toString() {
  final _this = this as Event;
  return 'Event(id: ${_this.id}, title: ${_this.title}, description: ${_this.description}, category: ${_this.category}, organizerId: ${_this.organizerId}, time: ${_this.time}, location: ${_this.location}, featured: ${_this.featured}, attendeeCount: ${_this.attendeeCount}, capacity: ${_this.capacity}, status: ${_this.status}, previousStart: ${_this.previousStart}, offers: ${_this.offers})';
}


}

/// @nodoc
abstract mixin class $EventCopyWith<$Res>  {
  factory $EventCopyWith(Event value, $Res Function(Event) _then) = _$EventCopyWithImpl;
@useResult
$Res call({
 String id, String title, String description, EventCategory category, String organizerId, EventTime time, EventLocation location, bool featured, int attendeeCount, int capacity, EventStatus status, DateTime? previousStart, List<TicketOffer> offers
});


$EventTimeCopyWith<$Res> get time;$EventLocationCopyWith<$Res> get location;

}
/// @nodoc
class _$EventCopyWithImpl<$Res>
    implements $EventCopyWith<$Res> {
  _$EventCopyWithImpl(this._self, this._then);

  final Event _self;
  final $Res Function(Event) _then;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? category = null,Object? organizerId = null,Object? time = null,Object? location = null,Object? featured = null,Object? attendeeCount = null,Object? capacity = null,Object? status = null,Object? previousStart = freezed,Object? offers = null,}) {
  return _then(Event(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as EventCategory,organizerId: null == organizerId ? _self.organizerId : organizerId // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as EventTime,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as EventLocation,featured: null == featured ? _self.featured : featured // ignore: cast_nullable_to_non_nullable
as bool,attendeeCount: null == attendeeCount ? _self.attendeeCount : attendeeCount // ignore: cast_nullable_to_non_nullable
as int,capacity: null == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EventStatus,previousStart: freezed == previousStart ? _self.previousStart : previousStart // ignore: cast_nullable_to_non_nullable
as DateTime?,offers: null == offers ? _self.offers : offers // ignore: cast_nullable_to_non_nullable
as List<TicketOffer>,
  ));
}
/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventTimeCopyWith<$Res> get time {
  
  return $EventTimeCopyWith<$Res>(_self.time, (value) {
    return _then(_self.copyWith(time: value));
  });
}/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventLocationCopyWith<$Res> get location {
  
  return $EventLocationCopyWith<$Res>(_self.location, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}


/// Adds pattern-matching-related methods to [Event].
extension EventPatterns on Event {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Event value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Event() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Event value)  $default,){
final _that = this;
switch (_that) {
case _Event():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Event value)?  $default,){
final _that = this;
switch (_that) {
case _Event() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String description,  EventCategory category,  String organizerId,  EventTime time,  EventLocation location,  bool featured,  int attendeeCount,  int capacity,  EventStatus status,  DateTime? previousStart,  List<TicketOffer> offers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Event() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.category,_that.organizerId,_that.time,_that.location,_that.featured,_that.attendeeCount,_that.capacity,_that.status,_that.previousStart,_that.offers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String description,  EventCategory category,  String organizerId,  EventTime time,  EventLocation location,  bool featured,  int attendeeCount,  int capacity,  EventStatus status,  DateTime? previousStart,  List<TicketOffer> offers)  $default,) {final _that = this;
switch (_that) {
case _Event():
return $default(_that.id,_that.title,_that.description,_that.category,_that.organizerId,_that.time,_that.location,_that.featured,_that.attendeeCount,_that.capacity,_that.status,_that.previousStart,_that.offers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String description,  EventCategory category,  String organizerId,  EventTime time,  EventLocation location,  bool featured,  int attendeeCount,  int capacity,  EventStatus status,  DateTime? previousStart,  List<TicketOffer> offers)?  $default,) {final _that = this;
switch (_that) {
case _Event() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.category,_that.organizerId,_that.time,_that.location,_that.featured,_that.attendeeCount,_that.capacity,_that.status,_that.previousStart,_that.offers);case _:
  return null;

}
}

}

/// @nodoc


class _Event extends Event {
  const _Event({required this.id, required this.title, required this.description, required this.category, required this.organizerId, required this.time, required this.location, this.featured = false, required this.attendeeCount, required this.capacity, this.status = EventStatus.scheduled, this.previousStart, required  List<TicketOffer> offers}): _offers = offers,super._();
  

@override final  String id;
@override final  String title;
@override final  String description;
@override final  EventCategory category;
@override final  String organizerId;
@override final  EventTime time;
@override final  EventLocation location;
@override@JsonKey() final  bool featured;
/// People going, and the places in all, as the server counts them.
@override final  int attendeeCount;
@override final  int capacity;
@override@JsonKey() final  EventStatus status;
/// When a moved event used to start (UTC).
@override final  DateTime? previousStart;
/// Its ticket types, in the order the server lists them.
 final  List<TicketOffer> _offers;
/// Its ticket types, in the order the server lists them.
@override List<TicketOffer> get offers {
  if (_offers is EqualUnmodifiableListView) return _offers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_offers);
}


/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventCopyWith<_Event> get copyWith => __$EventCopyWithImpl<_Event>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Event&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.organizerId, organizerId) || other.organizerId == organizerId)&&(identical(other.time, time) || other.time == time)&&(identical(other.location, location) || other.location == location)&&(identical(other.featured, featured) || other.featured == featured)&&(identical(other.attendeeCount, attendeeCount) || other.attendeeCount == attendeeCount)&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.status, status) || other.status == status)&&(identical(other.previousStart, previousStart) || other.previousStart == previousStart)&&const DeepCollectionEquality().equals(other.offers, _offers));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,title,description,category,organizerId,time,location,featured,attendeeCount,capacity,status,previousStart,const DeepCollectionEquality().hash(_offers));
}

@override
String toString() {
    return 'Event(id: $id, title: $title, description: $description, category: $category, organizerId: $organizerId, time: $time, location: $location, featured: $featured, attendeeCount: $attendeeCount, capacity: $capacity, status: $status, previousStart: $previousStart, offers: $offers)';
}


}

/// @nodoc
abstract mixin class _$EventCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory _$EventCopyWith(_Event value, $Res Function(_Event) _then) = __$EventCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String description, EventCategory category, String organizerId, EventTime time, EventLocation location, bool featured, int attendeeCount, int capacity, EventStatus status, DateTime? previousStart, List<TicketOffer> offers
});


@override $EventTimeCopyWith<$Res> get time;@override $EventLocationCopyWith<$Res> get location;

}
/// @nodoc
class __$EventCopyWithImpl<$Res>
    implements _$EventCopyWith<$Res> {
  __$EventCopyWithImpl(this._self, this._then);

  final _Event _self;
  final $Res Function(_Event) _then;

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? category = null,Object? organizerId = null,Object? time = null,Object? location = null,Object? featured = null,Object? attendeeCount = null,Object? capacity = null,Object? status = null,Object? previousStart = freezed,Object? offers = null,}) {
  return _then(_Event(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as EventCategory,organizerId: null == organizerId ? _self.organizerId : organizerId // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as EventTime,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as EventLocation,featured: null == featured ? _self.featured : featured // ignore: cast_nullable_to_non_nullable
as bool,attendeeCount: null == attendeeCount ? _self.attendeeCount : attendeeCount // ignore: cast_nullable_to_non_nullable
as int,capacity: null == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EventStatus,previousStart: freezed == previousStart ? _self.previousStart : previousStart // ignore: cast_nullable_to_non_nullable
as DateTime?,offers: null == offers ? _self._offers : offers // ignore: cast_nullable_to_non_nullable
as List<TicketOffer>,
  ));
}

/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventTimeCopyWith<$Res> get time {
  
  return $EventTimeCopyWith<$Res>(_self.time, (value) {
    return _then(_self.copyWith(time: value));
  });
}/// Create a copy of Event
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventLocationCopyWith<$Res> get location {
  
  return $EventLocationCopyWith<$Res>(_self.location, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}

// dart format on
