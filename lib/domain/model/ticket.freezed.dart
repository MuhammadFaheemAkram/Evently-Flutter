// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ticket.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Ticket {

 String get id; String get eventId;/// What the QR code encodes, and the door checks ("EVT-7KQ2-M9XA").
 String get code; TicketType get type; String get note; DateTime get bookedAt;/// When you cancelled it. An event the organizer cancels says so on its
/// own (`EventStatus.cancelled`); the ticket stays as it was.
 DateTime? get cancelledAt;
/// Create a copy of Ticket
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TicketCopyWith<Ticket> get copyWith => _$TicketCopyWithImpl<Ticket>(this as Ticket, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Ticket;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Ticket&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.eventId, _this.eventId) || other.eventId == _this.eventId)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.bookedAt, _this.bookedAt) || other.bookedAt == _this.bookedAt)&&(identical(other.cancelledAt, _this.cancelledAt) || other.cancelledAt == _this.cancelledAt));
}


@override
int get hashCode {
  final _this = this as Ticket;
  return Object.hash(runtimeType,_this.id,_this.eventId,_this.code,_this.type,_this.note,_this.bookedAt,_this.cancelledAt);
}

@override
String toString() {
  final _this = this as Ticket;
  return 'Ticket(id: ${_this.id}, eventId: ${_this.eventId}, code: ${_this.code}, type: ${_this.type}, note: ${_this.note}, bookedAt: ${_this.bookedAt}, cancelledAt: ${_this.cancelledAt})';
}


}

/// @nodoc
abstract mixin class $TicketCopyWith<$Res>  {
  factory $TicketCopyWith(Ticket value, $Res Function(Ticket) _then) = _$TicketCopyWithImpl;
@useResult
$Res call({
 String id, String eventId, String code, TicketType type, String note, DateTime bookedAt, DateTime? cancelledAt
});




}
/// @nodoc
class _$TicketCopyWithImpl<$Res>
    implements $TicketCopyWith<$Res> {
  _$TicketCopyWithImpl(this._self, this._then);

  final Ticket _self;
  final $Res Function(Ticket) _then;

/// Create a copy of Ticket
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? eventId = null,Object? code = null,Object? type = null,Object? note = null,Object? bookedAt = null,Object? cancelledAt = freezed,}) {
  return _then(Ticket(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TicketType,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,bookedAt: null == bookedAt ? _self.bookedAt : bookedAt // ignore: cast_nullable_to_non_nullable
as DateTime,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Ticket].
extension TicketPatterns on Ticket {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Ticket value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Ticket() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Ticket value)  $default,){
final _that = this;
switch (_that) {
case _Ticket():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Ticket value)?  $default,){
final _that = this;
switch (_that) {
case _Ticket() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String eventId,  String code,  TicketType type,  String note,  DateTime bookedAt,  DateTime? cancelledAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Ticket() when $default != null:
return $default(_that.id,_that.eventId,_that.code,_that.type,_that.note,_that.bookedAt,_that.cancelledAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String eventId,  String code,  TicketType type,  String note,  DateTime bookedAt,  DateTime? cancelledAt)  $default,) {final _that = this;
switch (_that) {
case _Ticket():
return $default(_that.id,_that.eventId,_that.code,_that.type,_that.note,_that.bookedAt,_that.cancelledAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String eventId,  String code,  TicketType type,  String note,  DateTime bookedAt,  DateTime? cancelledAt)?  $default,) {final _that = this;
switch (_that) {
case _Ticket() when $default != null:
return $default(_that.id,_that.eventId,_that.code,_that.type,_that.note,_that.bookedAt,_that.cancelledAt);case _:
  return null;

}
}

}

/// @nodoc


class _Ticket extends Ticket {
  const _Ticket({required this.id, required this.eventId, required this.code, required this.type, this.note = '', required this.bookedAt, this.cancelledAt}): super._();
  

@override final  String id;
@override final  String eventId;
/// What the QR code encodes, and the door checks ("EVT-7KQ2-M9XA").
@override final  String code;
@override final  TicketType type;
@override@JsonKey() final  String note;
@override final  DateTime bookedAt;
/// When you cancelled it. An event the organizer cancels says so on its
/// own (`EventStatus.cancelled`); the ticket stays as it was.
@override final  DateTime? cancelledAt;

/// Create a copy of Ticket
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TicketCopyWith<_Ticket> get copyWith => __$TicketCopyWithImpl<_Ticket>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Ticket&&(identical(other.id, id) || other.id == id)&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.code, code) || other.code == code)&&(identical(other.type, type) || other.type == type)&&(identical(other.note, note) || other.note == note)&&(identical(other.bookedAt, bookedAt) || other.bookedAt == bookedAt)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,eventId,code,type,note,bookedAt,cancelledAt);
}

@override
String toString() {
    return 'Ticket(id: $id, eventId: $eventId, code: $code, type: $type, note: $note, bookedAt: $bookedAt, cancelledAt: $cancelledAt)';
}


}

/// @nodoc
abstract mixin class _$TicketCopyWith<$Res> implements $TicketCopyWith<$Res> {
  factory _$TicketCopyWith(_Ticket value, $Res Function(_Ticket) _then) = __$TicketCopyWithImpl;
@override @useResult
$Res call({
 String id, String eventId, String code, TicketType type, String note, DateTime bookedAt, DateTime? cancelledAt
});




}
/// @nodoc
class __$TicketCopyWithImpl<$Res>
    implements _$TicketCopyWith<$Res> {
  __$TicketCopyWithImpl(this._self, this._then);

  final _Ticket _self;
  final $Res Function(_Ticket) _then;

/// Create a copy of Ticket
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? eventId = null,Object? code = null,Object? type = null,Object? note = null,Object? bookedAt = null,Object? cancelledAt = freezed,}) {
  return _then(_Ticket(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TicketType,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,bookedAt: null == bookedAt ? _self.bookedAt : bookedAt // ignore: cast_nullable_to_non_nullable
as DateTime,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
