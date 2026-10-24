// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalog_diff.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CatalogDiff {

/// Its start changed, and it's still on.
 List<String> get moved;/// It was on, and now it's off.
 List<String> get cancelled;/// It wasn't there before.
 List<String> get added;
/// Create a copy of CatalogDiff
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatalogDiffCopyWith<CatalogDiff> get copyWith => _$CatalogDiffCopyWithImpl<CatalogDiff>(this as CatalogDiff, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as CatalogDiff;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatalogDiff&&const DeepCollectionEquality().equals(other.moved, _this.moved)&&const DeepCollectionEquality().equals(other.cancelled, _this.cancelled)&&const DeepCollectionEquality().equals(other.added, _this.added));
}


@override
int get hashCode {
  final _this = this as CatalogDiff;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.moved),const DeepCollectionEquality().hash(_this.cancelled),const DeepCollectionEquality().hash(_this.added));
}

@override
String toString() {
  final _this = this as CatalogDiff;
  return 'CatalogDiff(moved: ${_this.moved}, cancelled: ${_this.cancelled}, added: ${_this.added})';
}


}

/// @nodoc
abstract mixin class $CatalogDiffCopyWith<$Res>  {
  factory $CatalogDiffCopyWith(CatalogDiff value, $Res Function(CatalogDiff) _then) = _$CatalogDiffCopyWithImpl;
@useResult
$Res call({
 List<String> moved, List<String> cancelled, List<String> added
});




}
/// @nodoc
class _$CatalogDiffCopyWithImpl<$Res>
    implements $CatalogDiffCopyWith<$Res> {
  _$CatalogDiffCopyWithImpl(this._self, this._then);

  final CatalogDiff _self;
  final $Res Function(CatalogDiff) _then;

/// Create a copy of CatalogDiff
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? moved = null,Object? cancelled = null,Object? added = null,}) {
  return _then(CatalogDiff(
moved: null == moved ? _self.moved : moved // ignore: cast_nullable_to_non_nullable
as List<String>,cancelled: null == cancelled ? _self.cancelled : cancelled // ignore: cast_nullable_to_non_nullable
as List<String>,added: null == added ? _self.added : added // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [CatalogDiff].
extension CatalogDiffPatterns on CatalogDiff {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CatalogDiff value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CatalogDiff() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CatalogDiff value)  $default,){
final _that = this;
switch (_that) {
case _CatalogDiff():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CatalogDiff value)?  $default,){
final _that = this;
switch (_that) {
case _CatalogDiff() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> moved,  List<String> cancelled,  List<String> added)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CatalogDiff() when $default != null:
return $default(_that.moved,_that.cancelled,_that.added);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> moved,  List<String> cancelled,  List<String> added)  $default,) {final _that = this;
switch (_that) {
case _CatalogDiff():
return $default(_that.moved,_that.cancelled,_that.added);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> moved,  List<String> cancelled,  List<String> added)?  $default,) {final _that = this;
switch (_that) {
case _CatalogDiff() when $default != null:
return $default(_that.moved,_that.cancelled,_that.added);case _:
  return null;

}
}

}

/// @nodoc


class _CatalogDiff extends CatalogDiff {
  const _CatalogDiff({ List<String> moved = const <String>[],  List<String> cancelled = const <String>[],  List<String> added = const <String>[]}): _moved = moved,_cancelled = cancelled,_added = added,super._();
  

/// Its start changed, and it's still on.
 final  List<String> _moved;
/// Its start changed, and it's still on.
@override@JsonKey() List<String> get moved {
  if (_moved is EqualUnmodifiableListView) return _moved;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_moved);
}

/// It was on, and now it's off.
 final  List<String> _cancelled;
/// It was on, and now it's off.
@override@JsonKey() List<String> get cancelled {
  if (_cancelled is EqualUnmodifiableListView) return _cancelled;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cancelled);
}

/// It wasn't there before.
 final  List<String> _added;
/// It wasn't there before.
@override@JsonKey() List<String> get added {
  if (_added is EqualUnmodifiableListView) return _added;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_added);
}


/// Create a copy of CatalogDiff
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CatalogDiffCopyWith<_CatalogDiff> get copyWith => __$CatalogDiffCopyWithImpl<_CatalogDiff>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CatalogDiff&&const DeepCollectionEquality().equals(other.moved, _moved)&&const DeepCollectionEquality().equals(other.cancelled, _cancelled)&&const DeepCollectionEquality().equals(other.added, _added));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_moved),const DeepCollectionEquality().hash(_cancelled),const DeepCollectionEquality().hash(_added));
}

@override
String toString() {
    return 'CatalogDiff(moved: $moved, cancelled: $cancelled, added: $added)';
}


}

/// @nodoc
abstract mixin class _$CatalogDiffCopyWith<$Res> implements $CatalogDiffCopyWith<$Res> {
  factory _$CatalogDiffCopyWith(_CatalogDiff value, $Res Function(_CatalogDiff) _then) = __$CatalogDiffCopyWithImpl;
@override @useResult
$Res call({
 List<String> moved, List<String> cancelled, List<String> added
});




}
/// @nodoc
class __$CatalogDiffCopyWithImpl<$Res>
    implements _$CatalogDiffCopyWith<$Res> {
  __$CatalogDiffCopyWithImpl(this._self, this._then);

  final _CatalogDiff _self;
  final $Res Function(_CatalogDiff) _then;

/// Create a copy of CatalogDiff
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? moved = null,Object? cancelled = null,Object? added = null,}) {
  return _then(_CatalogDiff(
moved: null == moved ? _self._moved : moved // ignore: cast_nullable_to_non_nullable
as List<String>,cancelled: null == cancelled ? _self._cancelled : cancelled // ignore: cast_nullable_to_non_nullable
as List<String>,added: null == added ? _self._added : added // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
