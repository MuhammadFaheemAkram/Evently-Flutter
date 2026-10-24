// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tickets_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TicketsState {

 TicketsStatus get status;/// Tickets whose event hasn't ended, soonest first.
 List<TicketItem> get upcoming;/// Tickets whose event is over, most recent first.
 List<TicketItem> get past;
/// Create a copy of TicketsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketsStateCopyWith<TicketsState> get copyWith => _$TicketsStateCopyWithImpl<TicketsState>(this as TicketsState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TicketsState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketsState&&(identical(other.status, _this.status) || other.status == _this.status)&&const DeepCollectionEquality().equals(other.upcoming, _this.upcoming)&&const DeepCollectionEquality().equals(other.past, _this.past));
}


@override
int get hashCode {
  final _this = this as TicketsState;
  return Object.hash(runtimeType,_this.status,const DeepCollectionEquality().hash(_this.upcoming),const DeepCollectionEquality().hash(_this.past));
}

@override
String toString() {
  final _this = this as TicketsState;
  return 'TicketsState(status: ${_this.status}, upcoming: ${_this.upcoming}, past: ${_this.past})';
}


}

/// @nodoc
abstract mixin class $TicketsStateCopyWith<$Res>  {
  factory $TicketsStateCopyWith(TicketsState value, $Res Function(TicketsState) _then) = _$TicketsStateCopyWithImpl;
@useResult
$Res call({
 TicketsStatus status, List<TicketItem> upcoming, List<TicketItem> past
});




}
/// @nodoc
class _$TicketsStateCopyWithImpl<$Res>
    implements $TicketsStateCopyWith<$Res> {
  _$TicketsStateCopyWithImpl(this._self, this._then);

  final TicketsState _self;
  final $Res Function(TicketsState) _then;

/// Create a copy of TicketsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? upcoming = null,Object? past = null,}) {
  return _then(TicketsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TicketsStatus,upcoming: null == upcoming ? _self.upcoming : upcoming // ignore: cast_nullable_to_non_nullable
as List<TicketItem>,past: null == past ? _self.past : past // ignore: cast_nullable_to_non_nullable
as List<TicketItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [TicketsState].
extension TicketsStatePatterns on TicketsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TicketsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TicketsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TicketsState value)  $default,){
final _that = this;
switch (_that) {
case _TicketsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TicketsState value)?  $default,){
final _that = this;
switch (_that) {
case _TicketsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TicketsStatus status,  List<TicketItem> upcoming,  List<TicketItem> past)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TicketsState() when $default != null:
return $default(_that.status,_that.upcoming,_that.past);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TicketsStatus status,  List<TicketItem> upcoming,  List<TicketItem> past)  $default,) {final _that = this;
switch (_that) {
case _TicketsState():
return $default(_that.status,_that.upcoming,_that.past);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TicketsStatus status,  List<TicketItem> upcoming,  List<TicketItem> past)?  $default,) {final _that = this;
switch (_that) {
case _TicketsState() when $default != null:
return $default(_that.status,_that.upcoming,_that.past);case _:
  return null;

}
}

}

/// @nodoc


class _TicketsState implements TicketsState {
  const _TicketsState({this.status = TicketsStatus.loading,  List<TicketItem> upcoming = const <TicketItem>[],  List<TicketItem> past = const <TicketItem>[]}): _upcoming = upcoming,_past = past;
  

@override@JsonKey() final  TicketsStatus status;
/// Tickets whose event hasn't ended, soonest first.
 final  List<TicketItem> _upcoming;
/// Tickets whose event hasn't ended, soonest first.
@override@JsonKey() List<TicketItem> get upcoming {
  if (_upcoming is EqualUnmodifiableListView) return _upcoming;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_upcoming);
}

/// Tickets whose event is over, most recent first.
 final  List<TicketItem> _past;
/// Tickets whose event is over, most recent first.
@override@JsonKey() List<TicketItem> get past {
  if (_past is EqualUnmodifiableListView) return _past;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_past);
}


/// Create a copy of TicketsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TicketsStateCopyWith<_TicketsState> get copyWith => __$TicketsStateCopyWithImpl<_TicketsState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TicketsState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.upcoming, _upcoming)&&const DeepCollectionEquality().equals(other.past, _past));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_upcoming),const DeepCollectionEquality().hash(_past));
}

@override
String toString() {
    return 'TicketsState(status: $status, upcoming: $upcoming, past: $past)';
}


}

/// @nodoc
abstract mixin class _$TicketsStateCopyWith<$Res> implements $TicketsStateCopyWith<$Res> {
  factory _$TicketsStateCopyWith(_TicketsState value, $Res Function(_TicketsState) _then) = __$TicketsStateCopyWithImpl;
@override @useResult
$Res call({
 TicketsStatus status, List<TicketItem> upcoming, List<TicketItem> past
});




}
/// @nodoc
class __$TicketsStateCopyWithImpl<$Res>
    implements _$TicketsStateCopyWith<$Res> {
  __$TicketsStateCopyWithImpl(this._self, this._then);

  final _TicketsState _self;
  final $Res Function(_TicketsState) _then;

/// Create a copy of TicketsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? upcoming = null,Object? past = null,}) {
  return _then(_TicketsState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TicketsStatus,upcoming: null == upcoming ? _self._upcoming : upcoming // ignore: cast_nullable_to_non_nullable
as List<TicketItem>,past: null == past ? _self._past : past // ignore: cast_nullable_to_non_nullable
as List<TicketItem>,
  ));
}


}

// dart format on
