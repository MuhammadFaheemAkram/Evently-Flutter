// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_criteria.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SearchCriteria {

/// Trimmed; empty matches everything.
 String get text; Set<EventCategory> get categories;/// The window an event must overlap, start included, end excluded.
 DateTime? get from; DateTime? get until; PriceFilter get price; FormatFilter get format; RsvpFilter get rsvp;/// Events that have ended by now are left out.
 DateTime get now;
/// Create a copy of SearchCriteria
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchCriteriaCopyWith<SearchCriteria> get copyWith => _$SearchCriteriaCopyWithImpl<SearchCriteria>(this as SearchCriteria, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SearchCriteria;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchCriteria&&(identical(other.text, _this.text) || other.text == _this.text)&&const DeepCollectionEquality().equals(other.categories, _this.categories)&&(identical(other.from, _this.from) || other.from == _this.from)&&(identical(other.until, _this.until) || other.until == _this.until)&&(identical(other.price, _this.price) || other.price == _this.price)&&(identical(other.format, _this.format) || other.format == _this.format)&&(identical(other.rsvp, _this.rsvp) || other.rsvp == _this.rsvp)&&(identical(other.now, _this.now) || other.now == _this.now));
}


@override
int get hashCode {
  final _this = this as SearchCriteria;
  return Object.hash(runtimeType,_this.text,const DeepCollectionEquality().hash(_this.categories),_this.from,_this.until,_this.price,_this.format,_this.rsvp,_this.now);
}

@override
String toString() {
  final _this = this as SearchCriteria;
  return 'SearchCriteria(text: ${_this.text}, categories: ${_this.categories}, from: ${_this.from}, until: ${_this.until}, price: ${_this.price}, format: ${_this.format}, rsvp: ${_this.rsvp}, now: ${_this.now})';
}


}

/// @nodoc
abstract mixin class $SearchCriteriaCopyWith<$Res>  {
  factory $SearchCriteriaCopyWith(SearchCriteria value, $Res Function(SearchCriteria) _then) = _$SearchCriteriaCopyWithImpl;
@useResult
$Res call({
 String text, Set<EventCategory> categories, DateTime? from, DateTime? until, PriceFilter price, FormatFilter format, RsvpFilter rsvp, DateTime now
});




}
/// @nodoc
class _$SearchCriteriaCopyWithImpl<$Res>
    implements $SearchCriteriaCopyWith<$Res> {
  _$SearchCriteriaCopyWithImpl(this._self, this._then);

  final SearchCriteria _self;
  final $Res Function(SearchCriteria) _then;

/// Create a copy of SearchCriteria
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? categories = null,Object? from = freezed,Object? until = freezed,Object? price = null,Object? format = null,Object? rsvp = null,Object? now = null,}) {
  return _then(SearchCriteria(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as Set<EventCategory>,from: freezed == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DateTime?,until: freezed == until ? _self.until : until // ignore: cast_nullable_to_non_nullable
as DateTime?,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as PriceFilter,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as FormatFilter,rsvp: null == rsvp ? _self.rsvp : rsvp // ignore: cast_nullable_to_non_nullable
as RsvpFilter,now: null == now ? _self.now : now // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchCriteria].
extension SearchCriteriaPatterns on SearchCriteria {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchCriteria value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchCriteria() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchCriteria value)  $default,){
final _that = this;
switch (_that) {
case _SearchCriteria():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchCriteria value)?  $default,){
final _that = this;
switch (_that) {
case _SearchCriteria() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text,  Set<EventCategory> categories,  DateTime? from,  DateTime? until,  PriceFilter price,  FormatFilter format,  RsvpFilter rsvp,  DateTime now)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchCriteria() when $default != null:
return $default(_that.text,_that.categories,_that.from,_that.until,_that.price,_that.format,_that.rsvp,_that.now);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text,  Set<EventCategory> categories,  DateTime? from,  DateTime? until,  PriceFilter price,  FormatFilter format,  RsvpFilter rsvp,  DateTime now)  $default,) {final _that = this;
switch (_that) {
case _SearchCriteria():
return $default(_that.text,_that.categories,_that.from,_that.until,_that.price,_that.format,_that.rsvp,_that.now);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text,  Set<EventCategory> categories,  DateTime? from,  DateTime? until,  PriceFilter price,  FormatFilter format,  RsvpFilter rsvp,  DateTime now)?  $default,) {final _that = this;
switch (_that) {
case _SearchCriteria() when $default != null:
return $default(_that.text,_that.categories,_that.from,_that.until,_that.price,_that.format,_that.rsvp,_that.now);case _:
  return null;

}
}

}

/// @nodoc


class _SearchCriteria implements SearchCriteria {
  const _SearchCriteria({this.text = '',  Set<EventCategory> categories = const <EventCategory>{}, this.from, this.until, this.price = PriceFilter.any, this.format = FormatFilter.any, this.rsvp = RsvpFilter.any, required this.now}): _categories = categories;
  

/// Trimmed; empty matches everything.
@override@JsonKey() final  String text;
 final  Set<EventCategory> _categories;
@override@JsonKey() Set<EventCategory> get categories {
  if (_categories is EqualUnmodifiableSetView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_categories);
}

/// The window an event must overlap, start included, end excluded.
@override final  DateTime? from;
@override final  DateTime? until;
@override@JsonKey() final  PriceFilter price;
@override@JsonKey() final  FormatFilter format;
@override@JsonKey() final  RsvpFilter rsvp;
/// Events that have ended by now are left out.
@override final  DateTime now;

/// Create a copy of SearchCriteria
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchCriteriaCopyWith<_SearchCriteria> get copyWith => __$SearchCriteriaCopyWithImpl<_SearchCriteria>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchCriteria&&(identical(other.text, text) || other.text == text)&&const DeepCollectionEquality().equals(other.categories, _categories)&&(identical(other.from, from) || other.from == from)&&(identical(other.until, until) || other.until == until)&&(identical(other.price, price) || other.price == price)&&(identical(other.format, format) || other.format == format)&&(identical(other.rsvp, rsvp) || other.rsvp == rsvp)&&(identical(other.now, now) || other.now == now));
}


@override
int get hashCode {
    return Object.hash(runtimeType,text,const DeepCollectionEquality().hash(_categories),from,until,price,format,rsvp,now);
}

@override
String toString() {
    return 'SearchCriteria(text: $text, categories: $categories, from: $from, until: $until, price: $price, format: $format, rsvp: $rsvp, now: $now)';
}


}

/// @nodoc
abstract mixin class _$SearchCriteriaCopyWith<$Res> implements $SearchCriteriaCopyWith<$Res> {
  factory _$SearchCriteriaCopyWith(_SearchCriteria value, $Res Function(_SearchCriteria) _then) = __$SearchCriteriaCopyWithImpl;
@override @useResult
$Res call({
 String text, Set<EventCategory> categories, DateTime? from, DateTime? until, PriceFilter price, FormatFilter format, RsvpFilter rsvp, DateTime now
});




}
/// @nodoc
class __$SearchCriteriaCopyWithImpl<$Res>
    implements _$SearchCriteriaCopyWith<$Res> {
  __$SearchCriteriaCopyWithImpl(this._self, this._then);

  final _SearchCriteria _self;
  final $Res Function(_SearchCriteria) _then;

/// Create a copy of SearchCriteria
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? categories = null,Object? from = freezed,Object? until = freezed,Object? price = null,Object? format = null,Object? rsvp = null,Object? now = null,}) {
  return _then(_SearchCriteria(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as Set<EventCategory>,from: freezed == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DateTime?,until: freezed == until ? _self.until : until // ignore: cast_nullable_to_non_nullable
as DateTime?,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as PriceFilter,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as FormatFilter,rsvp: null == rsvp ? _self.rsvp : rsvp // ignore: cast_nullable_to_non_nullable
as RsvpFilter,now: null == now ? _self.now : now // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
