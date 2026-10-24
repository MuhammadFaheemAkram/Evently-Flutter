// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EventFilter {

/// Matched against the title, the organizer, the venue and the city.
 String get query; Set<EventCategory> get categories; DatePreset get dates;/// The custom range's first and last day ([DatePreset.custom] only).
 CalendarDate? get from; CalendarDate? get to; PriceFilter get price; FormatFilter get format; RsvpFilter get rsvp;
/// Create a copy of EventFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventFilterCopyWith<EventFilter> get copyWith => _$EventFilterCopyWithImpl<EventFilter>(this as EventFilter, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as EventFilter;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventFilter&&(identical(other.query, _this.query) || other.query == _this.query)&&const DeepCollectionEquality().equals(other.categories, _this.categories)&&(identical(other.dates, _this.dates) || other.dates == _this.dates)&&(identical(other.from, _this.from) || other.from == _this.from)&&(identical(other.to, _this.to) || other.to == _this.to)&&(identical(other.price, _this.price) || other.price == _this.price)&&(identical(other.format, _this.format) || other.format == _this.format)&&(identical(other.rsvp, _this.rsvp) || other.rsvp == _this.rsvp));
}


@override
int get hashCode {
  final _this = this as EventFilter;
  return Object.hash(runtimeType,_this.query,const DeepCollectionEquality().hash(_this.categories),_this.dates,_this.from,_this.to,_this.price,_this.format,_this.rsvp);
}

@override
String toString() {
  final _this = this as EventFilter;
  return 'EventFilter(query: ${_this.query}, categories: ${_this.categories}, dates: ${_this.dates}, from: ${_this.from}, to: ${_this.to}, price: ${_this.price}, format: ${_this.format}, rsvp: ${_this.rsvp})';
}


}

/// @nodoc
abstract mixin class $EventFilterCopyWith<$Res>  {
  factory $EventFilterCopyWith(EventFilter value, $Res Function(EventFilter) _then) = _$EventFilterCopyWithImpl;
@useResult
$Res call({
 String query, Set<EventCategory> categories, DatePreset dates, CalendarDate? from, CalendarDate? to, PriceFilter price, FormatFilter format, RsvpFilter rsvp
});




}
/// @nodoc
class _$EventFilterCopyWithImpl<$Res>
    implements $EventFilterCopyWith<$Res> {
  _$EventFilterCopyWithImpl(this._self, this._then);

  final EventFilter _self;
  final $Res Function(EventFilter) _then;

/// Create a copy of EventFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? query = null,Object? categories = null,Object? dates = null,Object? from = freezed,Object? to = freezed,Object? price = null,Object? format = null,Object? rsvp = null,}) {
  return _then(EventFilter(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as Set<EventCategory>,dates: null == dates ? _self.dates : dates // ignore: cast_nullable_to_non_nullable
as DatePreset,from: freezed == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as CalendarDate?,to: freezed == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as CalendarDate?,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as PriceFilter,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as FormatFilter,rsvp: null == rsvp ? _self.rsvp : rsvp // ignore: cast_nullable_to_non_nullable
as RsvpFilter,
  ));
}

}


/// Adds pattern-matching-related methods to [EventFilter].
extension EventFilterPatterns on EventFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventFilter value)  $default,){
final _that = this;
switch (_that) {
case _EventFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventFilter value)?  $default,){
final _that = this;
switch (_that) {
case _EventFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String query,  Set<EventCategory> categories,  DatePreset dates,  CalendarDate? from,  CalendarDate? to,  PriceFilter price,  FormatFilter format,  RsvpFilter rsvp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventFilter() when $default != null:
return $default(_that.query,_that.categories,_that.dates,_that.from,_that.to,_that.price,_that.format,_that.rsvp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String query,  Set<EventCategory> categories,  DatePreset dates,  CalendarDate? from,  CalendarDate? to,  PriceFilter price,  FormatFilter format,  RsvpFilter rsvp)  $default,) {final _that = this;
switch (_that) {
case _EventFilter():
return $default(_that.query,_that.categories,_that.dates,_that.from,_that.to,_that.price,_that.format,_that.rsvp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String query,  Set<EventCategory> categories,  DatePreset dates,  CalendarDate? from,  CalendarDate? to,  PriceFilter price,  FormatFilter format,  RsvpFilter rsvp)?  $default,) {final _that = this;
switch (_that) {
case _EventFilter() when $default != null:
return $default(_that.query,_that.categories,_that.dates,_that.from,_that.to,_that.price,_that.format,_that.rsvp);case _:
  return null;

}
}

}

/// @nodoc


class _EventFilter extends EventFilter {
  const _EventFilter({this.query = '',  Set<EventCategory> categories = const <EventCategory>{}, this.dates = DatePreset.any, this.from, this.to, this.price = PriceFilter.any, this.format = FormatFilter.any, this.rsvp = RsvpFilter.any}): _categories = categories,super._();
  

/// Matched against the title, the organizer, the venue and the city.
@override@JsonKey() final  String query;
 final  Set<EventCategory> _categories;
@override@JsonKey() Set<EventCategory> get categories {
  if (_categories is EqualUnmodifiableSetView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_categories);
}

@override@JsonKey() final  DatePreset dates;
/// The custom range's first and last day ([DatePreset.custom] only).
@override final  CalendarDate? from;
@override final  CalendarDate? to;
@override@JsonKey() final  PriceFilter price;
@override@JsonKey() final  FormatFilter format;
@override@JsonKey() final  RsvpFilter rsvp;

/// Create a copy of EventFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventFilterCopyWith<_EventFilter> get copyWith => __$EventFilterCopyWithImpl<_EventFilter>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventFilter&&(identical(other.query, query) || other.query == query)&&const DeepCollectionEquality().equals(other.categories, _categories)&&(identical(other.dates, dates) || other.dates == dates)&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.price, price) || other.price == price)&&(identical(other.format, format) || other.format == format)&&(identical(other.rsvp, rsvp) || other.rsvp == rsvp));
}


@override
int get hashCode {
    return Object.hash(runtimeType,query,const DeepCollectionEquality().hash(_categories),dates,from,to,price,format,rsvp);
}

@override
String toString() {
    return 'EventFilter(query: $query, categories: $categories, dates: $dates, from: $from, to: $to, price: $price, format: $format, rsvp: $rsvp)';
}


}

/// @nodoc
abstract mixin class _$EventFilterCopyWith<$Res> implements $EventFilterCopyWith<$Res> {
  factory _$EventFilterCopyWith(_EventFilter value, $Res Function(_EventFilter) _then) = __$EventFilterCopyWithImpl;
@override @useResult
$Res call({
 String query, Set<EventCategory> categories, DatePreset dates, CalendarDate? from, CalendarDate? to, PriceFilter price, FormatFilter format, RsvpFilter rsvp
});




}
/// @nodoc
class __$EventFilterCopyWithImpl<$Res>
    implements _$EventFilterCopyWith<$Res> {
  __$EventFilterCopyWithImpl(this._self, this._then);

  final _EventFilter _self;
  final $Res Function(_EventFilter) _then;

/// Create a copy of EventFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? query = null,Object? categories = null,Object? dates = null,Object? from = freezed,Object? to = freezed,Object? price = null,Object? format = null,Object? rsvp = null,}) {
  return _then(_EventFilter(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as Set<EventCategory>,dates: null == dates ? _self.dates : dates // ignore: cast_nullable_to_non_nullable
as DatePreset,from: freezed == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as CalendarDate?,to: freezed == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as CalendarDate?,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as PriceFilter,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as FormatFilter,rsvp: null == rsvp ? _self.rsvp : rsvp // ignore: cast_nullable_to_non_nullable
as RsvpFilter,
  ));
}


}

// dart format on
