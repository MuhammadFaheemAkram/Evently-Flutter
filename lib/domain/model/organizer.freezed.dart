// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'organizer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Organizer {

 String get id; String get name; String get bio; int get followers;/// Their events in the catalog, as the server counts them.
 int get eventsCount;
/// Create a copy of Organizer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrganizerCopyWith<Organizer> get copyWith => _$OrganizerCopyWithImpl<Organizer>(this as Organizer, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Organizer;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Organizer&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.bio, _this.bio) || other.bio == _this.bio)&&(identical(other.followers, _this.followers) || other.followers == _this.followers)&&(identical(other.eventsCount, _this.eventsCount) || other.eventsCount == _this.eventsCount));
}


@override
int get hashCode {
  final _this = this as Organizer;
  return Object.hash(runtimeType,_this.id,_this.name,_this.bio,_this.followers,_this.eventsCount);
}

@override
String toString() {
  final _this = this as Organizer;
  return 'Organizer(id: ${_this.id}, name: ${_this.name}, bio: ${_this.bio}, followers: ${_this.followers}, eventsCount: ${_this.eventsCount})';
}


}

/// @nodoc
abstract mixin class $OrganizerCopyWith<$Res>  {
  factory $OrganizerCopyWith(Organizer value, $Res Function(Organizer) _then) = _$OrganizerCopyWithImpl;
@useResult
$Res call({
 String id, String name, String bio, int followers, int eventsCount
});




}
/// @nodoc
class _$OrganizerCopyWithImpl<$Res>
    implements $OrganizerCopyWith<$Res> {
  _$OrganizerCopyWithImpl(this._self, this._then);

  final Organizer _self;
  final $Res Function(Organizer) _then;

/// Create a copy of Organizer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? bio = null,Object? followers = null,Object? eventsCount = null,}) {
  return _then(Organizer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,followers: null == followers ? _self.followers : followers // ignore: cast_nullable_to_non_nullable
as int,eventsCount: null == eventsCount ? _self.eventsCount : eventsCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Organizer].
extension OrganizerPatterns on Organizer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Organizer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Organizer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Organizer value)  $default,){
final _that = this;
switch (_that) {
case _Organizer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Organizer value)?  $default,){
final _that = this;
switch (_that) {
case _Organizer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String bio,  int followers,  int eventsCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Organizer() when $default != null:
return $default(_that.id,_that.name,_that.bio,_that.followers,_that.eventsCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String bio,  int followers,  int eventsCount)  $default,) {final _that = this;
switch (_that) {
case _Organizer():
return $default(_that.id,_that.name,_that.bio,_that.followers,_that.eventsCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String bio,  int followers,  int eventsCount)?  $default,) {final _that = this;
switch (_that) {
case _Organizer() when $default != null:
return $default(_that.id,_that.name,_that.bio,_that.followers,_that.eventsCount);case _:
  return null;

}
}

}

/// @nodoc


class _Organizer implements Organizer {
  const _Organizer({required this.id, required this.name, required this.bio, required this.followers, required this.eventsCount});
  

@override final  String id;
@override final  String name;
@override final  String bio;
@override final  int followers;
/// Their events in the catalog, as the server counts them.
@override final  int eventsCount;

/// Create a copy of Organizer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrganizerCopyWith<_Organizer> get copyWith => __$OrganizerCopyWithImpl<_Organizer>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Organizer&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.followers, followers) || other.followers == followers)&&(identical(other.eventsCount, eventsCount) || other.eventsCount == eventsCount));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,bio,followers,eventsCount);
}

@override
String toString() {
    return 'Organizer(id: $id, name: $name, bio: $bio, followers: $followers, eventsCount: $eventsCount)';
}


}

/// @nodoc
abstract mixin class _$OrganizerCopyWith<$Res> implements $OrganizerCopyWith<$Res> {
  factory _$OrganizerCopyWith(_Organizer value, $Res Function(_Organizer) _then) = __$OrganizerCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String bio, int followers, int eventsCount
});




}
/// @nodoc
class __$OrganizerCopyWithImpl<$Res>
    implements _$OrganizerCopyWith<$Res> {
  __$OrganizerCopyWithImpl(this._self, this._then);

  final _Organizer _self;
  final $Res Function(_Organizer) _then;

/// Create a copy of Organizer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? bio = null,Object? followers = null,Object? eventsCount = null,}) {
  return _then(_Organizer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,followers: null == followers ? _self.followers : followers // ignore: cast_nullable_to_non_nullable
as int,eventsCount: null == eventsCount ? _self.eventsCount : eventsCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
