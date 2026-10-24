// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discover_sections.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DiscoverSections {

 List<EventCardItem> get featured; List<EventCardItem> get inYourCity; List<DayGroup<EventCardItem>> get upcoming;
/// Create a copy of DiscoverSections
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiscoverSectionsCopyWith<DiscoverSections> get copyWith => _$DiscoverSectionsCopyWithImpl<DiscoverSections>(this as DiscoverSections, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DiscoverSections;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscoverSections&&const DeepCollectionEquality().equals(other.featured, _this.featured)&&const DeepCollectionEquality().equals(other.inYourCity, _this.inYourCity)&&const DeepCollectionEquality().equals(other.upcoming, _this.upcoming));
}


@override
int get hashCode {
  final _this = this as DiscoverSections;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.featured),const DeepCollectionEquality().hash(_this.inYourCity),const DeepCollectionEquality().hash(_this.upcoming));
}

@override
String toString() {
  final _this = this as DiscoverSections;
  return 'DiscoverSections(featured: ${_this.featured}, inYourCity: ${_this.inYourCity}, upcoming: ${_this.upcoming})';
}


}

/// @nodoc
abstract mixin class $DiscoverSectionsCopyWith<$Res>  {
  factory $DiscoverSectionsCopyWith(DiscoverSections value, $Res Function(DiscoverSections) _then) = _$DiscoverSectionsCopyWithImpl;
@useResult
$Res call({
 List<EventCardItem> featured, List<EventCardItem> inYourCity, List<DayGroup<EventCardItem>> upcoming
});




}
/// @nodoc
class _$DiscoverSectionsCopyWithImpl<$Res>
    implements $DiscoverSectionsCopyWith<$Res> {
  _$DiscoverSectionsCopyWithImpl(this._self, this._then);

  final DiscoverSections _self;
  final $Res Function(DiscoverSections) _then;

/// Create a copy of DiscoverSections
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? featured = null,Object? inYourCity = null,Object? upcoming = null,}) {
  return _then(DiscoverSections(
featured: null == featured ? _self.featured : featured // ignore: cast_nullable_to_non_nullable
as List<EventCardItem>,inYourCity: null == inYourCity ? _self.inYourCity : inYourCity // ignore: cast_nullable_to_non_nullable
as List<EventCardItem>,upcoming: null == upcoming ? _self.upcoming : upcoming // ignore: cast_nullable_to_non_nullable
as List<DayGroup<EventCardItem>>,
  ));
}

}


/// Adds pattern-matching-related methods to [DiscoverSections].
extension DiscoverSectionsPatterns on DiscoverSections {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiscoverSections value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiscoverSections() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiscoverSections value)  $default,){
final _that = this;
switch (_that) {
case _DiscoverSections():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiscoverSections value)?  $default,){
final _that = this;
switch (_that) {
case _DiscoverSections() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<EventCardItem> featured,  List<EventCardItem> inYourCity,  List<DayGroup<EventCardItem>> upcoming)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiscoverSections() when $default != null:
return $default(_that.featured,_that.inYourCity,_that.upcoming);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<EventCardItem> featured,  List<EventCardItem> inYourCity,  List<DayGroup<EventCardItem>> upcoming)  $default,) {final _that = this;
switch (_that) {
case _DiscoverSections():
return $default(_that.featured,_that.inYourCity,_that.upcoming);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<EventCardItem> featured,  List<EventCardItem> inYourCity,  List<DayGroup<EventCardItem>> upcoming)?  $default,) {final _that = this;
switch (_that) {
case _DiscoverSections() when $default != null:
return $default(_that.featured,_that.inYourCity,_that.upcoming);case _:
  return null;

}
}

}

/// @nodoc


class _DiscoverSections implements DiscoverSections {
  const _DiscoverSections({ List<EventCardItem> featured = const <EventCardItem>[],  List<EventCardItem> inYourCity = const <EventCardItem>[],  List<DayGroup<EventCardItem>> upcoming = const <DayGroup<EventCardItem>>[]}): _featured = featured,_inYourCity = inYourCity,_upcoming = upcoming;
  

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


/// Create a copy of DiscoverSections
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiscoverSectionsCopyWith<_DiscoverSections> get copyWith => __$DiscoverSectionsCopyWithImpl<_DiscoverSections>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiscoverSections&&const DeepCollectionEquality().equals(other.featured, _featured)&&const DeepCollectionEquality().equals(other.inYourCity, _inYourCity)&&const DeepCollectionEquality().equals(other.upcoming, _upcoming));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_featured),const DeepCollectionEquality().hash(_inYourCity),const DeepCollectionEquality().hash(_upcoming));
}

@override
String toString() {
    return 'DiscoverSections(featured: $featured, inYourCity: $inYourCity, upcoming: $upcoming)';
}


}

/// @nodoc
abstract mixin class _$DiscoverSectionsCopyWith<$Res> implements $DiscoverSectionsCopyWith<$Res> {
  factory _$DiscoverSectionsCopyWith(_DiscoverSections value, $Res Function(_DiscoverSections) _then) = __$DiscoverSectionsCopyWithImpl;
@override @useResult
$Res call({
 List<EventCardItem> featured, List<EventCardItem> inYourCity, List<DayGroup<EventCardItem>> upcoming
});




}
/// @nodoc
class __$DiscoverSectionsCopyWithImpl<$Res>
    implements _$DiscoverSectionsCopyWith<$Res> {
  __$DiscoverSectionsCopyWithImpl(this._self, this._then);

  final _DiscoverSections _self;
  final $Res Function(_DiscoverSections) _then;

/// Create a copy of DiscoverSections
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? featured = null,Object? inYourCity = null,Object? upcoming = null,}) {
  return _then(_DiscoverSections(
featured: null == featured ? _self._featured : featured // ignore: cast_nullable_to_non_nullable
as List<EventCardItem>,inYourCity: null == inYourCity ? _self._inYourCity : inYourCity // ignore: cast_nullable_to_non_nullable
as List<EventCardItem>,upcoming: null == upcoming ? _self._upcoming : upcoming // ignore: cast_nullable_to_non_nullable
as List<DayGroup<EventCardItem>>,
  ));
}


}

// dart format on
