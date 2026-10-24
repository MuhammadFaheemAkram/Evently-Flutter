// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_card_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EventCardItem {

 Event get event; String get organizerName; bool get isSaved;/// You hold an active ticket.
 bool get isGoing;
/// Create a copy of EventCardItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventCardItemCopyWith<EventCardItem> get copyWith => _$EventCardItemCopyWithImpl<EventCardItem>(this as EventCardItem, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as EventCardItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventCardItem&&(identical(other.event, _this.event) || other.event == _this.event)&&(identical(other.organizerName, _this.organizerName) || other.organizerName == _this.organizerName)&&(identical(other.isSaved, _this.isSaved) || other.isSaved == _this.isSaved)&&(identical(other.isGoing, _this.isGoing) || other.isGoing == _this.isGoing));
}


@override
int get hashCode {
  final _this = this as EventCardItem;
  return Object.hash(runtimeType,_this.event,_this.organizerName,_this.isSaved,_this.isGoing);
}

@override
String toString() {
  final _this = this as EventCardItem;
  return 'EventCardItem(event: ${_this.event}, organizerName: ${_this.organizerName}, isSaved: ${_this.isSaved}, isGoing: ${_this.isGoing})';
}


}

/// @nodoc
abstract mixin class $EventCardItemCopyWith<$Res>  {
  factory $EventCardItemCopyWith(EventCardItem value, $Res Function(EventCardItem) _then) = _$EventCardItemCopyWithImpl;
@useResult
$Res call({
 Event event, String organizerName, bool isSaved, bool isGoing
});


$EventCopyWith<$Res> get event;

}
/// @nodoc
class _$EventCardItemCopyWithImpl<$Res>
    implements $EventCardItemCopyWith<$Res> {
  _$EventCardItemCopyWithImpl(this._self, this._then);

  final EventCardItem _self;
  final $Res Function(EventCardItem) _then;

/// Create a copy of EventCardItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? event = null,Object? organizerName = null,Object? isSaved = null,Object? isGoing = null,}) {
  return _then(EventCardItem(
event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as Event,organizerName: null == organizerName ? _self.organizerName : organizerName // ignore: cast_nullable_to_non_nullable
as String,isSaved: null == isSaved ? _self.isSaved : isSaved // ignore: cast_nullable_to_non_nullable
as bool,isGoing: null == isGoing ? _self.isGoing : isGoing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of EventCardItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventCopyWith<$Res> get event {
  
  return $EventCopyWith<$Res>(_self.event, (value) {
    return _then(_self.copyWith(event: value));
  });
}
}


/// Adds pattern-matching-related methods to [EventCardItem].
extension EventCardItemPatterns on EventCardItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventCardItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventCardItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventCardItem value)  $default,){
final _that = this;
switch (_that) {
case _EventCardItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventCardItem value)?  $default,){
final _that = this;
switch (_that) {
case _EventCardItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Event event,  String organizerName,  bool isSaved,  bool isGoing)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventCardItem() when $default != null:
return $default(_that.event,_that.organizerName,_that.isSaved,_that.isGoing);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Event event,  String organizerName,  bool isSaved,  bool isGoing)  $default,) {final _that = this;
switch (_that) {
case _EventCardItem():
return $default(_that.event,_that.organizerName,_that.isSaved,_that.isGoing);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Event event,  String organizerName,  bool isSaved,  bool isGoing)?  $default,) {final _that = this;
switch (_that) {
case _EventCardItem() when $default != null:
return $default(_that.event,_that.organizerName,_that.isSaved,_that.isGoing);case _:
  return null;

}
}

}

/// @nodoc


class _EventCardItem implements EventCardItem {
  const _EventCardItem({required this.event, required this.organizerName, this.isSaved = false, this.isGoing = false});
  

@override final  Event event;
@override final  String organizerName;
@override@JsonKey() final  bool isSaved;
/// You hold an active ticket.
@override@JsonKey() final  bool isGoing;

/// Create a copy of EventCardItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventCardItemCopyWith<_EventCardItem> get copyWith => __$EventCardItemCopyWithImpl<_EventCardItem>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventCardItem&&(identical(other.event, event) || other.event == event)&&(identical(other.organizerName, organizerName) || other.organizerName == organizerName)&&(identical(other.isSaved, isSaved) || other.isSaved == isSaved)&&(identical(other.isGoing, isGoing) || other.isGoing == isGoing));
}


@override
int get hashCode {
    return Object.hash(runtimeType,event,organizerName,isSaved,isGoing);
}

@override
String toString() {
    return 'EventCardItem(event: $event, organizerName: $organizerName, isSaved: $isSaved, isGoing: $isGoing)';
}


}

/// @nodoc
abstract mixin class _$EventCardItemCopyWith<$Res> implements $EventCardItemCopyWith<$Res> {
  factory _$EventCardItemCopyWith(_EventCardItem value, $Res Function(_EventCardItem) _then) = __$EventCardItemCopyWithImpl;
@override @useResult
$Res call({
 Event event, String organizerName, bool isSaved, bool isGoing
});


@override $EventCopyWith<$Res> get event;

}
/// @nodoc
class __$EventCardItemCopyWithImpl<$Res>
    implements _$EventCardItemCopyWith<$Res> {
  __$EventCardItemCopyWithImpl(this._self, this._then);

  final _EventCardItem _self;
  final $Res Function(_EventCardItem) _then;

/// Create a copy of EventCardItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? event = null,Object? organizerName = null,Object? isSaved = null,Object? isGoing = null,}) {
  return _then(_EventCardItem(
event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as Event,organizerName: null == organizerName ? _self.organizerName : organizerName // ignore: cast_nullable_to_non_nullable
as String,isSaved: null == isSaved ? _self.isSaved : isSaved // ignore: cast_nullable_to_non_nullable
as bool,isGoing: null == isGoing ? _self.isGoing : isGoing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of EventCardItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EventCopyWith<$Res> get event {
  
  return $EventCopyWith<$Res>(_self.event, (value) {
    return _then(_self.copyWith(event: value));
  });
}
}

// dart format on
