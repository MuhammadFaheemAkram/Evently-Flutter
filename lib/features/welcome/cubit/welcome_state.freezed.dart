// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'welcome_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WelcomeState {

/// The catalog is fetched first: its cities are the choices, and both
/// starts need its events.
 CatalogStatus get catalog;/// The cities to choose from, A to Z (once [catalog] is ready).
 List<String> get cities;/// The chosen city; `null` is "Anywhere".
 String? get city;/// The start in progress, if any: every control waits for it.
 StartChoice? get starting;/// Why the catalog or the demo couldn't be loaded. The matching button
/// then reads "Try again".
 String? get errorMessage;
/// Create a copy of WelcomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WelcomeStateCopyWith<WelcomeState> get copyWith => _$WelcomeStateCopyWithImpl<WelcomeState>(this as WelcomeState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as WelcomeState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WelcomeState&&(identical(other.catalog, _this.catalog) || other.catalog == _this.catalog)&&const DeepCollectionEquality().equals(other.cities, _this.cities)&&(identical(other.city, _this.city) || other.city == _this.city)&&(identical(other.starting, _this.starting) || other.starting == _this.starting)&&(identical(other.errorMessage, _this.errorMessage) || other.errorMessage == _this.errorMessage));
}


@override
int get hashCode {
  final _this = this as WelcomeState;
  return Object.hash(runtimeType,_this.catalog,const DeepCollectionEquality().hash(_this.cities),_this.city,_this.starting,_this.errorMessage);
}

@override
String toString() {
  final _this = this as WelcomeState;
  return 'WelcomeState(catalog: ${_this.catalog}, cities: ${_this.cities}, city: ${_this.city}, starting: ${_this.starting}, errorMessage: ${_this.errorMessage})';
}


}

/// @nodoc
abstract mixin class $WelcomeStateCopyWith<$Res>  {
  factory $WelcomeStateCopyWith(WelcomeState value, $Res Function(WelcomeState) _then) = _$WelcomeStateCopyWithImpl;
@useResult
$Res call({
 CatalogStatus catalog, List<String> cities, String? city, StartChoice? starting, String? errorMessage
});




}
/// @nodoc
class _$WelcomeStateCopyWithImpl<$Res>
    implements $WelcomeStateCopyWith<$Res> {
  _$WelcomeStateCopyWithImpl(this._self, this._then);

  final WelcomeState _self;
  final $Res Function(WelcomeState) _then;

/// Create a copy of WelcomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? catalog = null,Object? cities = null,Object? city = freezed,Object? starting = freezed,Object? errorMessage = freezed,}) {
  return _then(WelcomeState(
catalog: null == catalog ? _self.catalog : catalog // ignore: cast_nullable_to_non_nullable
as CatalogStatus,cities: null == cities ? _self.cities : cities // ignore: cast_nullable_to_non_nullable
as List<String>,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,starting: freezed == starting ? _self.starting : starting // ignore: cast_nullable_to_non_nullable
as StartChoice?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WelcomeState].
extension WelcomeStatePatterns on WelcomeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WelcomeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WelcomeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WelcomeState value)  $default,){
final _that = this;
switch (_that) {
case _WelcomeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WelcomeState value)?  $default,){
final _that = this;
switch (_that) {
case _WelcomeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CatalogStatus catalog,  List<String> cities,  String? city,  StartChoice? starting,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WelcomeState() when $default != null:
return $default(_that.catalog,_that.cities,_that.city,_that.starting,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CatalogStatus catalog,  List<String> cities,  String? city,  StartChoice? starting,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _WelcomeState():
return $default(_that.catalog,_that.cities,_that.city,_that.starting,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CatalogStatus catalog,  List<String> cities,  String? city,  StartChoice? starting,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _WelcomeState() when $default != null:
return $default(_that.catalog,_that.cities,_that.city,_that.starting,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _WelcomeState extends WelcomeState {
  const _WelcomeState({this.catalog = CatalogStatus.loading,  List<String> cities = const <String>[], this.city, this.starting, this.errorMessage}): _cities = cities,super._();
  

/// The catalog is fetched first: its cities are the choices, and both
/// starts need its events.
@override@JsonKey() final  CatalogStatus catalog;
/// The cities to choose from, A to Z (once [catalog] is ready).
 final  List<String> _cities;
/// The cities to choose from, A to Z (once [catalog] is ready).
@override@JsonKey() List<String> get cities {
  if (_cities is EqualUnmodifiableListView) return _cities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cities);
}

/// The chosen city; `null` is "Anywhere".
@override final  String? city;
/// The start in progress, if any: every control waits for it.
@override final  StartChoice? starting;
/// Why the catalog or the demo couldn't be loaded. The matching button
/// then reads "Try again".
@override final  String? errorMessage;

/// Create a copy of WelcomeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WelcomeStateCopyWith<_WelcomeState> get copyWith => __$WelcomeStateCopyWithImpl<_WelcomeState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WelcomeState&&(identical(other.catalog, catalog) || other.catalog == catalog)&&const DeepCollectionEquality().equals(other.cities, _cities)&&(identical(other.city, city) || other.city == city)&&(identical(other.starting, starting) || other.starting == starting)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode {
    return Object.hash(runtimeType,catalog,const DeepCollectionEquality().hash(_cities),city,starting,errorMessage);
}

@override
String toString() {
    return 'WelcomeState(catalog: $catalog, cities: $cities, city: $city, starting: $starting, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$WelcomeStateCopyWith<$Res> implements $WelcomeStateCopyWith<$Res> {
  factory _$WelcomeStateCopyWith(_WelcomeState value, $Res Function(_WelcomeState) _then) = __$WelcomeStateCopyWithImpl;
@override @useResult
$Res call({
 CatalogStatus catalog, List<String> cities, String? city, StartChoice? starting, String? errorMessage
});




}
/// @nodoc
class __$WelcomeStateCopyWithImpl<$Res>
    implements _$WelcomeStateCopyWith<$Res> {
  __$WelcomeStateCopyWithImpl(this._self, this._then);

  final _WelcomeState _self;
  final $Res Function(_WelcomeState) _then;

/// Create a copy of WelcomeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? catalog = null,Object? cities = null,Object? city = freezed,Object? starting = freezed,Object? errorMessage = freezed,}) {
  return _then(_WelcomeState(
catalog: null == catalog ? _self.catalog : catalog // ignore: cast_nullable_to_non_nullable
as CatalogStatus,cities: null == cities ? _self._cities : cities // ignore: cast_nullable_to_non_nullable
as List<String>,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,starting: freezed == starting ? _self.starting : starting // ignore: cast_nullable_to_non_nullable
as StartChoice?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
