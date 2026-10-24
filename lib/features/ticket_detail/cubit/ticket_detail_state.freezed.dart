// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ticket_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TicketDetailState {

 TicketDetailStatus get status; TicketItem? get item;/// What "can I still cancel" is judged against.
 DateTime? get now;/// Waiting for the server to cancel.
 bool get cancelling;/// A one-time SnackBar; [messageSerial] makes each one distinct.
 String? get message; int get messageSerial;
/// Create a copy of TicketDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketDetailStateCopyWith<TicketDetailState> get copyWith => _$TicketDetailStateCopyWithImpl<TicketDetailState>(this as TicketDetailState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TicketDetailState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TicketDetailState&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.item, _this.item) || other.item == _this.item)&&(identical(other.now, _this.now) || other.now == _this.now)&&(identical(other.cancelling, _this.cancelling) || other.cancelling == _this.cancelling)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.messageSerial, _this.messageSerial) || other.messageSerial == _this.messageSerial));
}


@override
int get hashCode {
  final _this = this as TicketDetailState;
  return Object.hash(runtimeType,_this.status,_this.item,_this.now,_this.cancelling,_this.message,_this.messageSerial);
}

@override
String toString() {
  final _this = this as TicketDetailState;
  return 'TicketDetailState(status: ${_this.status}, item: ${_this.item}, now: ${_this.now}, cancelling: ${_this.cancelling}, message: ${_this.message}, messageSerial: ${_this.messageSerial})';
}


}

/// @nodoc
abstract mixin class $TicketDetailStateCopyWith<$Res>  {
  factory $TicketDetailStateCopyWith(TicketDetailState value, $Res Function(TicketDetailState) _then) = _$TicketDetailStateCopyWithImpl;
@useResult
$Res call({
 TicketDetailStatus status, TicketItem? item, DateTime? now, bool cancelling, String? message, int messageSerial
});


$TicketItemCopyWith<$Res>? get item;

}
/// @nodoc
class _$TicketDetailStateCopyWithImpl<$Res>
    implements $TicketDetailStateCopyWith<$Res> {
  _$TicketDetailStateCopyWithImpl(this._self, this._then);

  final TicketDetailState _self;
  final $Res Function(TicketDetailState) _then;

/// Create a copy of TicketDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? item = freezed,Object? now = freezed,Object? cancelling = null,Object? message = freezed,Object? messageSerial = null,}) {
  return _then(TicketDetailState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TicketDetailStatus,item: freezed == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as TicketItem?,now: freezed == now ? _self.now : now // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelling: null == cancelling ? _self.cancelling : cancelling // ignore: cast_nullable_to_non_nullable
as bool,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,messageSerial: null == messageSerial ? _self.messageSerial : messageSerial // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of TicketDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TicketItemCopyWith<$Res>? get item {
    if (_self.item == null) {
    return null;
  }

  return $TicketItemCopyWith<$Res>(_self.item!, (value) {
    return _then(_self.copyWith(item: value));
  });
}
}


/// Adds pattern-matching-related methods to [TicketDetailState].
extension TicketDetailStatePatterns on TicketDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TicketDetailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TicketDetailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TicketDetailState value)  $default,){
final _that = this;
switch (_that) {
case _TicketDetailState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TicketDetailState value)?  $default,){
final _that = this;
switch (_that) {
case _TicketDetailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TicketDetailStatus status,  TicketItem? item,  DateTime? now,  bool cancelling,  String? message,  int messageSerial)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TicketDetailState() when $default != null:
return $default(_that.status,_that.item,_that.now,_that.cancelling,_that.message,_that.messageSerial);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TicketDetailStatus status,  TicketItem? item,  DateTime? now,  bool cancelling,  String? message,  int messageSerial)  $default,) {final _that = this;
switch (_that) {
case _TicketDetailState():
return $default(_that.status,_that.item,_that.now,_that.cancelling,_that.message,_that.messageSerial);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TicketDetailStatus status,  TicketItem? item,  DateTime? now,  bool cancelling,  String? message,  int messageSerial)?  $default,) {final _that = this;
switch (_that) {
case _TicketDetailState() when $default != null:
return $default(_that.status,_that.item,_that.now,_that.cancelling,_that.message,_that.messageSerial);case _:
  return null;

}
}

}

/// @nodoc


class _TicketDetailState extends TicketDetailState {
  const _TicketDetailState({this.status = TicketDetailStatus.loading, this.item, this.now, this.cancelling = false, this.message, this.messageSerial = 0}): super._();
  

@override@JsonKey() final  TicketDetailStatus status;
@override final  TicketItem? item;
/// What "can I still cancel" is judged against.
@override final  DateTime? now;
/// Waiting for the server to cancel.
@override@JsonKey() final  bool cancelling;
/// A one-time SnackBar; [messageSerial] makes each one distinct.
@override final  String? message;
@override@JsonKey() final  int messageSerial;

/// Create a copy of TicketDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TicketDetailStateCopyWith<_TicketDetailState> get copyWith => __$TicketDetailStateCopyWithImpl<_TicketDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TicketDetailState&&(identical(other.status, status) || other.status == status)&&(identical(other.item, item) || other.item == item)&&(identical(other.now, now) || other.now == now)&&(identical(other.cancelling, cancelling) || other.cancelling == cancelling)&&(identical(other.message, message) || other.message == message)&&(identical(other.messageSerial, messageSerial) || other.messageSerial == messageSerial));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,item,now,cancelling,message,messageSerial);
}

@override
String toString() {
    return 'TicketDetailState(status: $status, item: $item, now: $now, cancelling: $cancelling, message: $message, messageSerial: $messageSerial)';
}


}

/// @nodoc
abstract mixin class _$TicketDetailStateCopyWith<$Res> implements $TicketDetailStateCopyWith<$Res> {
  factory _$TicketDetailStateCopyWith(_TicketDetailState value, $Res Function(_TicketDetailState) _then) = __$TicketDetailStateCopyWithImpl;
@override @useResult
$Res call({
 TicketDetailStatus status, TicketItem? item, DateTime? now, bool cancelling, String? message, int messageSerial
});


@override $TicketItemCopyWith<$Res>? get item;

}
/// @nodoc
class __$TicketDetailStateCopyWithImpl<$Res>
    implements _$TicketDetailStateCopyWith<$Res> {
  __$TicketDetailStateCopyWithImpl(this._self, this._then);

  final _TicketDetailState _self;
  final $Res Function(_TicketDetailState) _then;

/// Create a copy of TicketDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? item = freezed,Object? now = freezed,Object? cancelling = null,Object? message = freezed,Object? messageSerial = null,}) {
  return _then(_TicketDetailState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TicketDetailStatus,item: freezed == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as TicketItem?,now: freezed == now ? _self.now : now // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelling: null == cancelling ? _self.cancelling : cancelling // ignore: cast_nullable_to_non_nullable
as bool,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,messageSerial: null == messageSerial ? _self.messageSerial : messageSerial // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of TicketDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TicketItemCopyWith<$Res>? get item {
    if (_self.item == null) {
    return null;
  }

  return $TicketItemCopyWith<$Res>(_self.item!, (value) {
    return _then(_self.copyWith(item: value));
  });
}
}

// dart format on
